From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Subject: cgroups commit 61d1d219c4 breaks systemd
Date: Thu, 29 Mar 2012 00:01:26 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1203282354440.25526@pobox.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>

Hi,

I am not able to boot current Linus' tree on system which is using 
systemd. In the early boot phase I get

	Failed to create root cgroup hierarchy: No such process
	Failed to allocate manager object: No such process

and that's it, the system is completely unusable afterwards (not having 
any console spawned, no networking, etc).

Bisection pointed to

	commit 61d1d219c4c0761059236a46867bc49943c4d29d
	Author: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
	Date:   Mon Jan 30 12:51:56 2012 -0800

	    cgroup: remove extra calls to find_existing_css_set

and I have verified that reverting this single commit on top of current 
Linus' tree makes the problem go away and the system boots properly.

strace output shows that with 61d1d219c applied, systemd is failing while 
trying to add itself to the systemd cgroup:

mkdir("/sys", 0755)                     = -1 EEXIST (File exists)
mkdir("/sys/fs", 0755)                  = -1 EEXIST (File exists)
mkdir("/sys/fs/cgroup", 0755)           = -1 EEXIST (File exists)
mkdir("/sys/fs/cgroup/systemd", 0755)   = -1 EEXIST (File exists)
mkdir("/sys/fs/cgroup/systemd/system", 0755) = 0
open("/sys/fs/cgroup/systemd/system/tasks", O_WRONLY|O_CREAT|O_TRUNC|O_CLOEXEC, 0666) = 6
fstat(6, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f60c4ecb000
write(6, "357\n", 4)                    = -1 ESRCH (No such process)
close(6)                                = 0
munmap(0x7f60c4ecb000, 4096)            = 0
writev(3, [{"<27>", 4}, {"systemd", 7}, {"[357]: ", 7}, {"Failed to create root cgroup hierarchy: No such process", 55}, {"\n", 1}], 5) = 74
open("/sys/fs/cgroup/systemd/system/tasks", O_RDONLY|O_CLOEXEC) = 6
fstat(6, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f60c4ecb000
read(6, "357\n", 4096)                  = 4
open("/sys/fs/cgroup/systemd/tasks", O_WRONLY|O_CREAT|O_TRUNC|O_CLOEXEC, 0666) = 7
fstat(7, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f60c4eca000
write(7, "357\n", 4)                    = -1 ESRCH (No such process)
close(7)                                = 0
munmap(0x7f60c4eca000, 4096)            = 0
read(6, "", 4096)                       = 0
close(6)                                = 0
munmap(0x7f60c4ecb000, 4096)            = 0
open("/sys/fs/cgroup/systemd/system/tasks", O_RDONLY|O_CLOEXEC) = 6
fstat(6, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f60c4ecb000
read(6, "", 4096)                       = 0
close(6)                                = 0
munmap(0x7f60c4ecb000, 4096)            = 0
open("/sys/fs/cgroup/systemd/system", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 6
getdents(6, /* 7 entries */, 32768)     = 240
getdents(6, /* 0 entries */, 32768)     = 0
lstat("/sys/fs/cgroup/systemd/system/tasks", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
rmdir("/sys/fs/cgroup/systemd/system")  = 0
close(6)                                = 0
close(4)                                = 0
close(5)                                = 0
close(0)                                = 0
writev(3, [{"<27>", 4}, {"systemd", 7}, {"[357]: ", 7}, {"Failed to allocate manager object: No such process", 50}, {"\n", 1}], 5) = 69

-- 
Jiri Kosina
SUSE Labs
