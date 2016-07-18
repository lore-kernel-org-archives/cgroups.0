From: Aleksa Sarai <asarai@suse.de>
Subject: [PATCH v1 1/3] kernfs: add support for custom per-sb permission hooks
Date: Tue, 19 Jul 2016 02:18:14 +1000
Message-ID: <20160718161816.13040-2-asarai@suse.de>
References: <20160718161816.13040-1-asarai@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160718161816.13040-1-asarai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Aditya Kali <adityakali@google.com>, Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Christian Brauner <cbrauner@suse.de>, Aleksa Sarai <asarai@suse.de>, dev@opencontainers.org

This allows for users of kernfs to create custom (and possibly less
restrictive) permission checks for kernfs_nodes. The default is
unchanged. This patch is part of the cgroupns unprivileged subtree
management patchset.

Cc: dev@opencontainers.org
Signed-off-by: Aleksa Sarai <asarai@suse.de>
---
 fs/kernfs/inode.c      | 13 ++++++++++++-
 include/linux/kernfs.h |  3 +++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
index 63b925d5ba1e..e82b8e5aa643 100644
--- a/fs/kernfs/inode.c
+++ b/fs/kernfs/inode.c
@@ -364,15 +364,26 @@ void kernfs_evict_inode(struct inode *inode)
 int kernfs_iop_permission(struct inode *inode, int mask)
 {
 	struct kernfs_node *kn;
+	struct kernfs_syscall_ops *scops;
+	int ret;
 
 	if (mask & MAY_NOT_BLOCK)
 		return -ECHILD;
 
 	kn = inode->i_private;
+	if (!kernfs_get_active(kn))
+		return -ENODEV;
 
 	mutex_lock(&kernfs_mutex);
 	kernfs_refresh_inode(kn, inode);
 	mutex_unlock(&kernfs_mutex);
 
-	return generic_permission(inode, mask);
+	scops = kernfs_root(kn)->syscall_ops;
+	if (unlikely(scops && scops->permission))
+		ret = scops->permission(inode, kn, mask);
+	else
+		ret = generic_permission(inode, mask);
+
+	kernfs_put_active(kn);
+	return ret;
 }
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 96356ef012de..373b5a888a81 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -16,6 +16,7 @@
 #include <linux/rbtree.h>
 #include <linux/atomic.h>
 #include <linux/wait.h>
+#include <linux/fs.h>
 
 struct file;
 struct dentry;
@@ -154,6 +155,8 @@ struct kernfs_syscall_ops {
 		      const char *new_name);
 	int (*show_path)(struct seq_file *sf, struct kernfs_node *kn,
 			 struct kernfs_root *root);
+	int (*permission)(struct inode *inode, struct kernfs_node *kn,
+			  int mask);
 };
 
 struct kernfs_root {
-- 
2.9.0

