From: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Subject: [PATCH v7 0/4] cgroup: add xattr support
Date: Thu, 23 Aug 2012 16:53:27 -0400
Message-ID: <20120823205327.237533518@napanee.usersys.redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Lennart Poettering <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

This series are a refreshed version of a patchset submitted by Li Zefan back
in march:
	https://lkml.org/lkml/2012/3/1/13

With Li's permission, I refreshed the patches to apply over the latest upstream
and added the modifications suggested by others in the thread:
- using a mount option instead of config option to enable the xattr support
- reinitialize the list in kmem_xattrs_free()
- renamed functions to simple_xattr_*()

There're two users for this patchset:
- SELinux: to be able to control access to cgroupfs inside containers
- systemd: to store meta information such as main PID in a service cgroup,
  set specific services special options in the cgroup.

While the xattrs will use kernel memory like tmpfs, they're restricted to
'security' (which controls the format of the value) and 'trusted' (which
requires CAP_SYS_ADMIN). If kernel memory usage is still a concern, we're
not far from having memcg account for kernel memory.

v7:
- fix checkpatch.pl warnings
- Implement the changes requested by Hugh Dickins:
        - make simple_xattrs_init and simple_xattrs_free inline
        - get rid of locking and list reinitialization in simple_xattrs_free,
          they're not needed
v6:
- only allow trusted and security
- replace subsys_bits by something more meaningful
v5:
- check for permissions for user xattr namespace
v4:
- implemented requested changes by Tejun Heo in patch #2

Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Lennart Poettering <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

-- 
Aristeu
