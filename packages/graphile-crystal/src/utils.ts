import { inspect } from "util";
import * as assert from "assert";
import { isDev } from "./dev";
import {
  GraphQLInputType,
  ValueNode,
  GraphQLNonNull,
  GraphQLList,
  GraphQLInputObjectType,
  ObjectFieldNode,
  GraphQLInt,
  GraphQLString,
  GraphQLFloat,
  GraphQLID,
  GraphQLBoolean,
  GraphQLEnumType,
  GraphQLScalarType,
} from "graphql";

export function assertNullPrototype(object: {}, description: string): void {
  if (isDev) {
    assert.equal(
      Object.getPrototypeOf(object),
      null,
      `Expected ${description} to have a null prototype`,
    );
  }
}

function dangerousRawValueToValueNode(value: JSON): ValueNode {
  if (value == null) {
    return { kind: "NullValue" };
  }
  if (typeof value === "boolean") {
    return { kind: "BooleanValue", value };
  }
  if (typeof value === "number") {
    if (value === Math.round(value)) {
      return { kind: "IntValue", value: String(value) };
    } else {
      return { kind: "FloatValue", value: String(value) };
    }
  }
  if (typeof value === "string") {
    return { kind: "StringValue", value };
  }
  if (Array.isArray(value)) {
    return {
      kind: "ListValue",
      values: value.map(dangerousRawValueToValueNode),
    };
  }
  if (typeof value === "object" && value) {
    return {
      kind: "ObjectValue",
      fields: Object.keys(value).map((key) => ({
        kind: "ObjectField",
        name: { kind: "Name", value: key },
        value: dangerousRawValueToValueNode(value[key]),
      })),
    };
  }
  const never: never = value;
  console.error(
    `Unhandled type when converting custom scalar to ValueNode: ${inspect(
      never,
    )}`,
  );
  throw new Error(`Unhandled type when converting custom scalar to ValueNode`);
}

function rawValueToValueNode(
  type: GraphQLInputType,
  value: any,
): ValueNode | undefined {
  // TODO: move this to input object section
  if (type instanceof GraphQLNonNull) {
    if (value == null) {
      throw new Error(
        "defaultValue contained null/undefined at a position that is marked as non-null",
      );
    }
    return rawValueToValueNode(type.ofType, value);
  }
  // Below here null/undefined are allowed.
  if (value === undefined) {
    return undefined;
  }
  if (value === null) {
    return { kind: "NullValue" };
  }
  if (type === GraphQLBoolean) {
    if (typeof value !== "boolean") {
      throw new Error(
        "defaultValue contained invalid value at a position expecting boolean",
      );
    }
    return { kind: "BooleanValue", value };
  }
  if (type === GraphQLInt) {
    if (typeof value !== "number") {
      throw new Error(
        "defaultValue contained invalid value at a position expecting int",
      );
    }
    return { kind: "IntValue", value: String(parseInt(String(value), 10)) };
  }
  if (type === GraphQLFloat) {
    if (typeof value !== "number") {
      throw new Error(
        "defaultValue contained invalid value at a position expecting int",
      );
    }
    return { kind: "FloatValue", value: String(value) };
  }
  if (type === GraphQLString || type === GraphQLID) {
    if (typeof value !== "string") {
      throw new Error(
        "defaultValue contained invalid value at a position expecting string",
      );
    }
    return { kind: "StringValue", value };
  }
  if (type instanceof GraphQLEnumType) {
    const enumValues = type.getValues();
    const enumValue = enumValues.find((v) => v.value === value);
    if (!enumValue) {
      console.error(
        `Default contained invalid value for enum ${type.name}: ${inspect(
          value,
        )}`,
      );
      throw new Error(`Default contained invalid value for enum ${type.name}`);
    }
    return { kind: "EnumValue", value: enumValue.name };
  }
  if (type instanceof GraphQLScalarType) {
    return dangerousRawValueToValueNode(value);
  }
  if (type instanceof GraphQLList) {
    if (!Array.isArray(value)) {
      throw new Error(
        "defaultValue contained invalid value at location expecting a list",
      );
    }
    return {
      kind: "ListValue",
      values: value.map((entry: any) => {
        const entryValueNode = rawValueToValueNode(type.ofType, entry);
        if (entryValueNode === undefined) {
          throw new Error(
            "defaultValue contained invalid list (contained `undefined`)",
          );
        }
        return entryValueNode;
      }),
    };
  }
  if (type instanceof GraphQLInputObjectType) {
    if (typeof value !== "object" || !value) {
      throw new Error(
        "defaultValue contained invalid value at location expecting an object",
      );
    }
    const fieldDefs = type.getFields();
    const fields: ObjectFieldNode[] = [];
    for (const fieldName in fieldDefs) {
      const fieldDef = fieldDefs[fieldName];
      const fieldType = fieldDef.type;
      const rawValue =
        value[fieldName] !== undefined
          ? value[fieldName]
          : fieldDef.defaultValue;
      const fieldValueNode = rawValueToValueNode(fieldType, rawValue);
      if (fieldValueNode !== undefined) {
        fields.push({
          kind: "ObjectField",
          name: { kind: "Name", value: fieldName },
          value: fieldValueNode,
        });
      }
    }
    return {
      kind: "ObjectValue",
      fields,
    };
  }
  const never: never = type;
  console.error(
    `Encountered unexpected type when processing defaultValue ${inspect(
      never,
    )}`,
  );
  throw new Error(`Encountered unexpected type when processing defaultValue`);
}

export function defaultValueToValueNode(
  type: GraphQLInputType,
  defaultValue: JSON | undefined,
): ValueNode | undefined {
  // NOTE: even if `type` is non-null it's okay for `defaultValue` to be
  // undefined. However it is not okay for defaultValue to be null if type is
  // non-null.
  if (defaultValue === undefined) {
    return undefined;
  }
  return rawValueToValueNode(type, defaultValue);
}

// We might change this to number in future for optimisation reasons.
export type UniqueId = symbol;

/**
 * The internal `fastCounter` is safe up to Number.MAX_SAFE_INTEGER; if we were
 * to generate 100 million unique ids per second every second (a significant
 * over-estimate), it would take us 1042 days to exhaust the safe range for
 * this.
 *
 * Even calling this in the hottest of loops only generates about half a
 * billion per second, which is safe for ~200 days:
 *
 * `let i=0;console.time('loop');for(;i<500_000_000;i++);console.timeEnd('loop');`
 *
 * Nonetheless, out of an abundance of caution, I've decided to let this loop
 * tick over by using a prefix once we hit this max limit. This now means that
 * this is safe over roughly 360,000 times the age of the universe.
 *
 * (I considered starting at `-Number.MAX_SAFE_INTEGER` rather than zero in
 * order to quadruple the range, but decided against it on aesthetic grounds.)
 */
const developmentUid = ((): (() => UniqueId) => {
  // Hide counter in this scope so it can't be fiddled with.
  let prefix = "";
  let prefixCounter = 0;
  let fastCounter = 0;
  return function developmentUid(): UniqueId {
    if (++fastCounter === Number.MAX_SAFE_INTEGER) {
      prefix = `${++prefixCounter}|`;
      fastCounter = 0;
    }
    return Symbol(`${prefix}${fastCounter}`);
  };
})();

const productionUid = (): UniqueId => Symbol();

export const uid = isDev ? developmentUid : productionUid;

export function isPromise<T>(t: T | Promise<T>): t is Promise<T> {
  return (
    typeof t === "object" &&
    t !== null &&
    typeof (t as any).then === "function" &&
    typeof (t as any).catch === "function"
  );
}
