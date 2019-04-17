/*
 * Rust BareBones OS
 * - By John Hodge (Mutabah/thePowersGang) 
 *
 * main.rs
 * - Top-level file for kernel
 *
 * This code has been put into the public domain, there are no restrictions on
 * its use, and the author takes no liability.
 */
#![feature(panic_info_message)]    //< Panic handling
#![feature(asm)]    //< As a kernel, we need inline assembly
#![no_std]    //< Kernels can't use std
#![crate_name = "kernel"]

/// Macros, need to be loaded before everything else due to how rust parses
#[macro_use]
mod macros;

#[cfg(target_arch = "x86_64")]
#[path = "arch/amd64/mod.rs"]
pub mod arch;
#[cfg(target_arch = "x86")]
#[path = "arch/x86/mod.rs"]
pub mod arch;

/// Exception handling (panic)
pub mod unwind;

/// Logging code
mod logging;

//static HELLO: &[u8] = b"Hello World!";

// Kernel entrypoint (called by arch/<foo>/start.S)
#[no_mangle]
pub fn kmain()
{
    log!("Hello world! 1={}", 1);

//    let vga_buffer = 0xb8000 as *mut u8;
//
//    for (i, &byte) in HELLO.iter().enumerate() {
//        unsafe {
//            *vga_buffer.offset(i as isize * 2) = byte;
//            *vga_buffer.offset(i as isize * 2 + 1) = 0xb;
//        }
//    }

    loop {}
}

