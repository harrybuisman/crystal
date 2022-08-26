import { GraphQLError } from "graphql";

/**
 * Internally we wrap errors that occur in a CrystalError; this allows us to do
 * simple `instanceof` checks to see if a value is an actual value or an error.
 * Users should never use this class; it's for internal usage only.
 *
 * @internal
 */
export interface CrystalError extends Error {
  originalError: Error;
}

// IMPORTANT: this WILL NOT WORK when compiled down to ES5. It requires ES6+
// native class support.
/**
 * When an error occurs during plan execution we wrap it in a CrystalError so
 * that we can pass it around as a value.  It gets unwrapped and thrown in the
 * crystal resolver.
 *
 * @internal
 */
class _CrystalError extends Error implements CrystalError {
  public readonly originalError: Error;
  extensions: Record<string, any>;
  constructor(originalError: Error, planId: number | null) {
    if (originalError instanceof _CrystalError) {
      throw new Error(
        "GraphileInternalError<62505509-8b21-4ef7-80f5-d0f99873174b>: attempted to wrap a CrystalError with a CrystalError.",
      );
    }
    const message = originalError?.message;
    // TODO: remove `CrystalError:` prefix
    super(message ? `CrystalError: ${message}` : `CrystalError`);
    this.originalError = originalError;
    this.extensions = { dataplanner: { planId } };
  }
}

/**
 * DO NOT ALLOW CONSTRUCTION OF ERRORS OUTSIDE OF THIS MODULE!
 *
 * @internal
 */
export function newCrystalError(error: Error, planId: number | null) {
  return new _CrystalError(error, planId);
}

// TODO: delete this?
/**
 * DO NOT ALLOW CONSTRUCTION OF ERRORS OUTSIDE OF THIS MODULE!
 *
 * @internal
 */
export function newNonNullError(planId: number | null) {
  const message = "";
  const nodes = null;
  const source = null;
  const positions = null;
  const path = null;
  const originalError = null;
  const extensions = null;
  const error = new GraphQLError(
    message,
    nodes,
    source,
    positions,
    path,
    originalError,
    extensions,
  );
  return new _CrystalError(error, planId);
}

/**
 * Is the given value a CrystalError? This is the only public API that people
 * should use for looking at CrystalErrors.
 */
export function isCrystalError(value: any): value is CrystalError {
  return value != null && value.constructor === _CrystalError;
}

class FieldError {
  constructor(
    public readonly originalError: CrystalError,
    public readonly path: ReadonlyArray<string | number>,
  ) {}
}

export function newFieldError(
  originalError: CrystalError,
  path: ReadonlyArray<string | number>,
) {
  return new FieldError(originalError, path);
}

export function isFieldError(thing: any): thing is FieldError {
  return thing instanceof FieldError;
}
