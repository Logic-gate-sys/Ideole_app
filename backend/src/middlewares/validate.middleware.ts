import { Request, Response, NextFunction } from 'express';
import { ZodObject, ZodError } from 'zod';

export const validateBody = (schema: ZodObject) => {
  return (req: Request, res: Response, next: NextFunction) => {
    try {
      const result = schema.safeParse(req.body);

      if (!result.success) {
        return res.status(400).json({
          error: 'Invalid body',
          details: result.error.issues.map((iss) => ({
            path: iss.path.join('.'),
            message: iss.message
          }))
        });
      }

      // Attach the cleaned data back to req.body
      req.body = result.data;
      next();
    } catch (error: any) {
      return res.status(500).json({
        error: 'Body validation error',
        details: error.message
      });
    }
  };
};

  
 export const validateQuery = (schema: ZodObject) => 
    (req: Request, res: Response, next: NextFunction) => {
      try {
        const result = schema.safeParse(req.query); 

        // incase it fails
        if (!result.success) {
          return res.status(400).json({
            error: 'Invalid query',
            details: result.error.issues.map((issue) => ({
              path: issue.path.join('.'),
              message: issue.message
            }))
          })
        }

        // Store validated query data in a custom property (req.query is read-only)
        (req as any).validatedQuery = result.data; 

        next()
      } catch (error: any) {
        return res.status(500).json({
          error: 'Query validation error',
          details: error.message
        });
      }
   };
     
  
  export const validateParams = (schema: ZodObject) => 
      (req: Request, res: Response, next: NextFunction) => {
        try {
          const result = schema.safeParse(req.params); 
          
          if (!result.success) {
            return res.status(400).json({
              error: 'Invalid parameters',
              details: result.error.issues.map((issue) => ({
                path: issue.path.join('.'),
                message: issue.message
              }))
            })
          }

          // Assign to req.params (it's writable)
          req.params = result.data; 

          next();
        } catch (error: any) {
          return res.status(500).json({
            error: 'Parameter validation error',
            details: error.message
          });
        }
  };