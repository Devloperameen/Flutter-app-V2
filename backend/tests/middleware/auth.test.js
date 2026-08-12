const { authenticate } = require('../../src/middleware/auth');
const jwt = require('jsonwebtoken');
const User = require('../../src/models/User');

// Mock dependencies
jest.mock('jsonwebtoken');
jest.mock('../../src/models/User');

describe('Auth Middleware', () => {
  let req;
  let res;
  let next;

  beforeEach(() => {
    req = {
      headers: {},
    };
    res = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn(),
    };
    next = jest.fn();
    
    // Clear all mocks
    jest.clearAllMocks();
    
    // Setup environment variable for test
    process.env.JWT_SECRET = 'test-secret';
  });

  describe('authenticate', () => {
    it('should return 401 if no authorization header is provided', async () => {
      await authenticate(req, res, next);

      expect(res.status).toHaveBeenCalledWith(401);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
        success: false,
        message: 'No authorization token provided'
      }));
      expect(next).not.toHaveBeenCalled();
    });

    it('should return 401 if token structure is invalid (no Bearer)', async () => {
      req.headers.authorization = 'InvalidFormatToken123';
      
      await authenticate(req, res, next);

      expect(res.status).toHaveBeenCalledWith(401);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
        success: false,
        message: 'No authorization token provided'
      }));
    });

    it('should return 401 if token verification fails', async () => {
      req.headers.authorization = 'Bearer invalid-token';
      const jwtError = new Error('Invalid token');
      jwtError.name = 'JsonWebTokenError';
      jwt.verify.mockImplementation(() => { throw jwtError; });

      await authenticate(req, res, next);

      expect(res.status).toHaveBeenCalledWith(401);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
        success: false,
        message: 'Invalid token'
      }));
    });

    it('should return 401 if user is not found in database', async () => {
      req.headers.authorization = 'Bearer valid-token';
      jwt.verify.mockReturnValue({ userId: 'valid-id' });
      User.findById.mockReturnValue({
        select: jest.fn().mockResolvedValue(null) // User not found
      });

      await authenticate(req, res, next);

      expect(res.status).toHaveBeenCalledWith(401);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
        success: false,
        message: 'User not found'
      }));
    });

    it('should call next() and attach user to req if authentication succeeds', async () => {
      req.headers.authorization = 'Bearer valid-token';
      jwt.verify.mockReturnValue({ userId: 'valid-id' });
      
      const mockUser = {
        _id: 'valid-id',
        email: 'test@test.com',
        fullName: 'Test User',
        isActive: true,
      };
      
      User.findById.mockReturnValue({
        select: jest.fn().mockResolvedValue(mockUser)
      });

      await authenticate(req, res, next);

      expect(req.user).toBeDefined();
      expect(req.user.id).toBe('valid-id');
      expect(req.user.email).toBe('test@test.com');
      expect(next).toHaveBeenCalledTimes(1);
    });
  });
});
