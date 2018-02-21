const SwytchToken = artifacts.require('../contracts/SwytchToken.sol');
const utils = require('./helpers/Utils');

contract('SwytchToken', (accounts) => {
  let token;
  let owner = accounts[0];

  beforeEach(async () => {
    token = await SwytchToken.new();
    // token = await SwytchToken.new(accounts[0], 100)
  });

  describe('construction', async () => {
    it('should be ownable', async () => {
      assert.equal(await token.owner(), owner);
    });

    it('should return correct name after construction', async () => {
      assert.equal(await token.name(), "Swytch Energy Token");
    });

    it('should return correct symbol after construction', async () => {
      assert.equal(await token.symbol(), 'SET');
    });

    it('should return correct decimal points after construction', async () => {
      assert.equal(await token.decimals(), 18);
    });

    it('should be initialized as not transferable', async () => {
      assert.equal(await token.transfersEnabled(), false);
    });

    it('should throw when attempting to transfer by default', async () => {
      let token = await SwytchToken.new();
      await token.disableTransfers(true)
      assert.equal(await token.transfersEnabled(), false);

      await token.issue(accounts[0], 1000);
      let balance = await token.balanceOf(accounts[0]);
      // console.log(balance)
      assert.equal(balance, 2000);

      try {
        await token.transfer(accounts[1], 100);
        // let balance = await token.balanceOf(accounts[1]);
        // console.log(balance)
        // assert.equal(balance, 2000);
        assert(false, "didn't throw");
      } catch (error) {
        return utils.ensureException(error);
      }
    });
  });
});