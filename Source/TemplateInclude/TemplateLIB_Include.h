/***************************************************************************//*!
* \file TemplateLIB_Include.h
* \author 
* \copyright . All Rights Reserved.
* \date 10/15/2025 11:37:28 AM
* \brief A fixed name include is required in order for some components of the template
* 	components to work.  That's the purpose of this file.  Do not copy or include
* 	this file in more than the base project.
*******************************************************************************/

#ifndef __TemplateLIB_Include_H__
#define __TemplateLIB_Include_H__

#ifdef __cplusplus
    extern "C" {
#endif

//==============================================================================
// Include files

//==============================================================================
// Constants

#define LIBCHECK int TestLib_CheckVersionCompatibility (IN int ExpectedVersionMajor, IN int ExpectedVersionMinor, int *VersionMajor, int *VersionMinor)

//==============================================================================
// Types

//==============================================================================
// External variables

//==============================================================================
// Global functions

#ifdef __cplusplus
    }
#endif

#endif  /* ndef __TemplateLIB_Include_H__ */
