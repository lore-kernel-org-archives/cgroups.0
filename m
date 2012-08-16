From: aris@redhat.com
Subject: [PATCH v6 0/4] cgroup: add xattr support
Date: Thu, 16 Aug 2012 13:44:53 -0400
Message-ID: <20120816174453.154143248@napanee.usersys.redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>, Hillf Danton <dhillf@gmail.com>, Lennart Poettering <lpoetter@redhat.com>

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

v6:
- only allow trusted and security
- replace subsys_bits by something more meaningful
v5:
- check for permissions for user xattr namespace
v4:
- implemented requested changes by Tejun Heo in patch #2

Cc: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Lennart Poettering <lpoetter@redhat.com>
Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>

-- 
Aristeu
