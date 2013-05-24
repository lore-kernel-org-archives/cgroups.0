From: Jeff Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: enabled xattr on root hierarchy if required
Date: Sat, 25 May 2013 00:03:12 +0800
Message-ID: <519F8F40.3040601@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexey Kodanev <alexey.kodanev-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

From: Jie Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

If the root cgroup is alive without xattr, set extended
attributes on a new cgroup with xattr enabled will failed
with ENOTSUPP. e.g.

# mount -t cgroup -o cpu none /cgroup1
# mount -t cgroup -o cpu,xattr none /cgroup2
# mkdir /cgroup2/test
# setfattr -n trusted.name -v test /cgroup2/test
setfattr: /cgroup2/test: Operation not supported

This patch fix it by checking ROOT_XATTR against the new
mount and turn it up on the existing root hierarchy if needed.

With this fix:
# mount | grep cgroup
none on /cgroup1 type cgroup (rw,cpu)
none on /cgroup2 type cgroup (rw,xattr,cpu)

# mkdir /cgroup2/test
# setfattr -n trusted.name -v test /cgroup2/test
# getfattr -d -m - /cgroup2/test
getfattr: Removing leading '/' from absolute path names
trusted.name="test"

Signed-off-by: Jie Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reported-by: Alexey Kodanev <alexey.kodanev-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a32f943..46e8cbb 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1687,6 +1687,13 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		cgroup_drop_root(opts.new_root);
 		/* no subsys rebinding, so refcounts don't change */
 		drop_parsed_module_refcounts(opts.subsys_mask);
+
+		/*
+		 * Enable xattr on the existing root hierarchy if it is
+		 * specified on new mount.
+		 */
+		if (test_bit(ROOT_XATTR, &opts.flags))
+			test_and_set_bit(ROOT_XATTR, &root->flags);
 	}
 
 	kfree(opts.release_agent);
-- 
1.7.9.5
