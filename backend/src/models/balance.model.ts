/// Module to make sure `/api/account/setCurrentBalance` has valid post body.


/**
 * Checks that a balance is valid. Refer to tests to see what is currently
 * considered valid.
 */
export const validBalance = (balance: string): boolean => {

  const regex = /^-?\d+(\.\d{0,2})?$/;

  return regex.test(balance);
}
