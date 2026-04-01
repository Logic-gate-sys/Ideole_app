import type{ Request, Response, NextFunction } from "express";
import { ZodType } from "zod";

export const Validator = {
    validateBody(body: ZodType){
       return  async (req:Request, res:Response, next:NextFunction) =>{
            const result = body.safeParse(req.body);
            if(!result.success){
                return res.status(400).json({
                    message:'error',
                    details: result.error.issues.map((iss)=>({
                        path:iss.path.join("."),
                        message:iss.message
                    }))
                })
            }
            // other than that
            req.body = result.data ; // attach valid body
        
            next(); 
        }
    },

    validateParam(params: ZodType){
       return  async (req:Request, res:Response, next:NextFunction) =>{
            const result = params.safeParse(req.body);
            if(!result.success){
                return res.status(400).json({
                    message:'error',
                    details: result.error.issues.map((iss)=>({
                        path:iss.path.join("."),
                        message:iss.message
                    }))
                })
            }
            //
        
            next(); 
        }
    },

    validateQuey(query: ZodType){
       return  async (req:Request, res:Response, next:NextFunction) =>{
            const result = query.safeParse(req.body);
            if(!result.success){
                return res.status(400).json({
                    message:'error',
                    details: result.error.issues.map((iss)=>({
                        path:iss.path.join("."),
                        message:iss.message
                    }))
                })
            }
            // other than that
        
            next(); 
        }
    }
}