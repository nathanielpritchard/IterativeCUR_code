#include <stdio.h>
#include <math.h>
#include <string.h>
#include <pthread.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include "mex.h"


void givens(double x, double y, double *c, double *s)
{
    // Given two numbers x and y it will produce the sine and cosine values
    // in a given rotation
    double alp, r;
    if(y != 0){
        if(fabs(y) > fabs(x)){
            alp = -x/y;
            r = sqrt(1.0 + alp * alp);
            *s = 1.0 / r;
            *c = *s * alp;
        } else {
            alp = -y/x;
            r = sqrt(1.0 + alp * alp);
            *c = 1.0 / r; 
            *s = *c * alp;
        } 
    } else {
        *c = 1;
        *s = 0;
    }

}

void reset_vec(double* x, int n)
{
    // This function will zero up to n entries and set the last entry to be 1
    memset(x,0, n*sizeof(double));
    x[n] = 1.0;
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *Q, *R, *U, *LC, *QO, *RO, s, c;
    double R_o;
    double Q_o;
    int n_q, m_q, n_u, m_u, n_r, m_r, m_q_o, spR, spQ;
    // Get the pointers to all the arrays
    Q = mxGetPr(prhs[0]);
    R = mxGetPr(prhs[1]);
    U = mxGetPr(prhs[2]);
    // Get sizes of matrices M is rows N is columns
    n_q = mxGetN(prhs[0]); 
    m_q = mxGetM(prhs[0]); 
    n_r = mxGetN(prhs[1]); 
    m_r = mxGetM(prhs[1]);
    n_u = mxGetN(prhs[2]); 
    m_u = mxGetM(prhs[2]); 
    // Allocate extra column for Q update
    LC = (double *)calloc(m_q, sizeof(double));
    // Take care of the output arrays by copying the inputs
    plhs[0] = mxDuplicateArray(prhs[0]);  
    plhs[1] = mxDuplicateArray(prhs[1]);  
    QO = mxGetPr(plhs[0]);
    RO = mxGetPr(plhs[1]);
    // Assume that n_q is the rows of Q+newly allocated space = n_u so first 1.0 should 
    // occur at n_q - n_r because of zero indexing
    m_q_o = m_q - m_u;
    for(int i=0; i<m_u; i++){
       reset_vec(LC, m_q_o+i);
        for(int j=0; j<n_u; j++){
            // Get the sine and cosine value
            givens(RO[j+m_r*j], U[i+m_u*j], &c, &s);
            for(int k=j; k<n_r; k++){
                // Use givens rotations to update R and U
                // Always update the ith row of U and jth row of R
                // need to store original R for correct multiplication
                // Since R is overwritten before U only R needs to be stored
                R_o = RO[j+m_r*k];
                RO[j+m_r*k] = c * R_o - s * U[i+m_u*k];
                U[i+m_u*k] = c * U[i+m_u*k] + s * R_o;
            }
        
            for(int l=0; l<m_q; l++){
                // Update the Q matrix and the last column matrix that will be dropped
                // as at end of a row of givens rotations is technically multiplied by a 
                // zero vector 
                Q_o = QO[l+j*m_q];
                QO[l+j*m_q] = c * Q_o - s * LC[l];
                LC[l] = s * Q_o + c * LC[l];
            }
        } 
    }
    //plhs[2] = mxCreateDoubleScalar((double)n_thread); 
    free(LC);
}
