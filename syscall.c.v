module syscall

import os

// read reads data from the file descriptor *fd* into the *buf* buffer.
// If *count* is not set the *buf.len* bytes will read.
// See also [read(2)](https://www.man7.org/linux/man-pages/man2/read.2.html).
pub fn read(fd int, mut buf []u8, count ?usize) !int {
	mut count_ := usize(buf.len)
	if count != none {
		count_ = count
	}
	res := C.read(fd, buf.data, count_)
	if res == -1 {
		return os.last_error()
	}
	return res
}

// pread reads up to count bytes from file descriptor fd at offset offset (from the
// start of the file) into the buffer buf. The file offset is not changed.
// See also [pread(2)](https://www.man7.org/linux/man-pages/man2/pread.2.html).
pub fn pread(fd int, mut buf []u8, count usize, offset isize) !int {
	res := C.pread(fd, buf.data, count, offset)
	if res == -1 {
		return os.last_error()
	}
	return res
}

// write writes data from *buf* into the file descriptor *fd*.
// If *count* is not set the *buf.len* bytes will written.
// See also [write(2)](https://www.man7.org/linux/man-pages/man2/write.2.html).
pub fn write(fd int, buf []u8, count ?usize) !int {
	mut count_ := usize(buf.len)
	if count != none {
		count_ = count
	}
	res := C.write(fd, buf.data, count_)
	if res == -1 {
		return os.last_error()
	}
	return res
}

// pwrite writes up to count bytes from the buffer buf to the file descriptor fd at
// offset offset. The file offset is not changed.
// See also [pwrite(2)](https://www.man7.org/linux/man-pages/man2/pwrite.2.html).
pub fn pwrite(fd int, buf []u8, count usize, offset isize) !int {
	res := C.pwrite(fd, buf.data, count, offset)
	if res == -1 {
		return os.last_error()
	}
	return res
}

// open opens and possibly creates a file.
// See [open(2)](https://www.man7.org/linux/man-pages/man2/open.2.html) for details.
pub fn open(path string, flags i32, mode i32) !int {
	res := C.open(&char(path.str), flags, mode)
	if res == -1 {
		return os.last_error()
	}
	return res
}

// close closes the file descriptor.
// See also [close(2)](https://www.man7.org/linux/man-pages/man2/close.2.html).
pub fn close(fd int) ! {
	if C.close(fd) == -1 {
		return os.last_error()
	}
}

// lseek repositions read/write file offset.
// See also [lseek(2)](https://www.man7.org/linux/man-pages/man2/lseek.2.html).
pub fn lseek(fd int, offset isize, whence i32) !isize {
	res := C.lseek(fd, offset, whence)
	if res == -1 {
		return os.last_error()
	}
	return res
}

// unlink deletes a name and possibly the file it refers to.
// See also [unlink(2)](https://www.man7.org/linux/man-pages/man2/unlink.2.html).
pub fn unlink(path string) ! {
	if C.unlink(&char(path.str)) == -1 {
		return os.last_error()
	}
}

// mount mounts the filesystem.
//
// Linux: See [mount(2)](https://man7.org/linux/man-pages/man2/mount.2.html).
//
// FreeBSD: The *source* argument is ignored. See [mount(2)](https://man.freebsd.org/cgi/man.cgi?query=mount&apropos=0&sektion=2).
pub fn mount(source string, target string, filesystemtype string, mountflags u64, data voidptr) ! {
	$if linux {
		if C.mount(&char(source.str), &char(target.str), &char(filesystemtype.str), mountflags,
			data) == -1 {
			return os.last_error()
		}
	} $else $if freebsd {
		if C.mount(&char(filesystemtype.str), &char(target.str), mountflags, data) == -1 {
			return os.last_error()
		}
	}
}

// unmount unmounts the filesystem mounted to *target*.
//
// Linux: See [umount(2)](https://man7.org/linux/man-pages/man2/umount.2.html).
// If `flags` is non-zero `umount2` is called instead of `umount`.
//
// FreeBSD: See [unmount(2)](https://man.freebsd.org/cgi/man.cgi?query=unmount&sektion=2).
pub fn unmount(target string, flags i32) ! {
	$if linux {
		if flags == 0 {
			if C.umount(&char(target.str)) == -1 {
				return os.last_error()
			}
		} else {
			if C.umount2(&char(target.str), flags) == -1 {
				return os.last_error()
			}
		}
	} $else $if freebsd {
		if C.unmount(&char(target.str), flags) == -1 {
			return os.last_error()
		}
	}
}

// chroot changes the root directory of the calling process.
// See [chroot(2)](https://www.man7.org/linux/man-pages/man2/chroot.2.html) for details.
// Note: Only privileged process may call chroot(). On Linux CAP_SYS_CHROOT capability is required.
pub fn chroot(path string) ! {
	if C.chroot(&char(path.str)) == -1 {
		return os.last_error()
	}
}

// kill sends signal *sig* to process identified by *pid*.
// See also [kill(2)](https://www.man7.org/linux/man-pages/man2/kill.2.html).
pub fn kill(pid i32, sig i32) ! {
	if C.kill(pid, sig) == -1 {
		return os.last_error()
	}
}

// fork creates a new process and returns it's PID.
// See also [fork(2)](https://www.man7.org/linux/man-pages/man2/fork.2.html).
pub fn fork() !int {
	res := C.fork()
	if res == -1 {
		return os.last_error()
	}
	return res
}

// pipe creates pipe. See also [pipe(2)](https://www.man7.org/linux/man-pages/man2/pipe.2.html).
pub fn pipe() !(int, int) {
	mut fds := [2]int{}
	if C.pipe(&fds[0]) == -1 {
		return os.last_error()
	}
	return fds[0], fds[1]
}

// pipe2 creates pipe. See also [pipe(2)](https://www.man7.org/linux/man-pages/man2/pipe.2.html).
pub fn pipe2(flags i32) !(int, int) {
	mut fds := [2]int{}
	if C.pipe2(&fds[0], flags) == -1 {
		return os.last_error()
	}
	return fds[0], fds[1]
}
