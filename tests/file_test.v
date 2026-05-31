import syscall
import os

fn test_file() {
	path := os.join_path_single(os.temp_dir(), 'syscall_file_test')

	fd := syscall.open(path, syscall.o_creat | syscall.o_rdwr | syscall.o_trunc,
		syscall.s_irusr | syscall.s_iwusr | syscall.s_irgrp | syscall.s_iroth)!

	hello := 'hello'.bytes()
	assert syscall.write(fd, hello)! == hello.len

	assert syscall.lseek(fd, 0, syscall.seek_set)! == 0

	mut hello_buf := []u8{len: 5}
	assert syscall.read(fd, mut hello_buf)! == hello.len

	assert hello_buf == hello

	world := ' world'.bytes()
	assert syscall.pwrite(fd, world, usize(world.len), isize(hello.len))! == world.len

	mut world_buf := []u8{len: 6}
	assert syscall.pread(fd, mut world_buf, usize(world.len), isize(hello.len))! == world.len

	assert world_buf == world

	syscall.close(fd)!

	syscall.unlink(path)!
}
