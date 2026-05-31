module syscall

#include <unistd.h>
#include <sys/mount.h>
#include <signal.h>

// C.syscall calls syscall indirectly.
//
// Example:
// ```v
// import syscall
//
// pid := C.syscall(syscall.sys_getpid)
// println(pid)
// ```
pub fn C.syscall(i32, ...voidptr) i32

fn C.open(&char, i32, ...int) i32
fn C.close(i32) i32
fn C.read(i32, voidptr, usize) i32
fn C.pread(i32, voidptr, usize, isize) i32
fn C.write(i32, voidptr, usize) i32
fn C.pwrite(i32, voidptr, usize, isize) i32
fn C.lseek(i32, usize, i32) usize
fn C.unlink(&char) i32
fn C.chroot(&char) i32
fn C.kill(i32, i32) i32
fn C.fork() i32
fn C.pipe(&int) i32
fn C.pipe2(&int, i32) i32

$if linux {
	fn C.mount(&char, &char, &char, u64, voidptr) i32
	fn C.umount(&char) i32
	fn C.umount2(&char, i32) i32
}

$if freebsd {
	fn C.mount(&char, &char, i32, voidptr) i32
	fn C.unmount(&char, i32) i32
}
