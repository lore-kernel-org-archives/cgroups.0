From: Glauber Costa <glommer@parallels.com>
Subject: [RFC 3/4] show only allowed filesystems in /proc/filesystems
Date: Mon, 23 Jan 2012 20:56:11 +0400
Message-ID: <1327337772-1972-4-git-send-email-glommer@parallels.com>
References: <1327337772-1972-1-git-send-email-glommer@parallels.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1327337772-1972-1-git-send-email-glommer@parallels.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, ebiederm@xmission.com, serge@hallyn.com, daniel.lezcano@free.fr, pjt@google.com, mzxreary@0pointer.de, xemul@parallels.com, James.Bottomley@HansenPartnership.com, tj@kernel.org, eric.dumazet@gmail.com, Glauber Costa <glommer@parallels.com>

Now that a namespace can have a different than default list of
filesystems, only show the allowed ones in /proc/filesystems.

Signed-off-by: Glauber Costa <glommer@parallels.com>
---
 fs/filesystems.c |    4 +++-
 fs/proc/base.c   |   51 +++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 44 insertions(+), 11 deletions(-)

diff --git a/fs/filesystems.c b/fs/filesystems.c
index 118d0d6..b797cda 100644
--- a/fs/filesystems.c
+++ b/fs/filesystems.c
@@ -243,11 +243,13 @@ out:
 int filesystems_proc_show(struct seq_file *m, void *v)
 {
 	struct file_system_type * tmp;
+	struct mnt_namespace *ns = m->private;
 
 	read_lock(&file_systems_lock);
 	tmp = file_systems;
 	while (tmp) {
-		seq_printf(m, "%s\t%s\n",
+		if (fs_allowed(tmp, ns))
+			seq_printf(m, "%s\t%s\n",
 			(tmp->fs_flags & FS_REQUIRES_DEV) ? "" : "nodev",
 			tmp->name);
 		tmp = tmp->next;
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 2a6e2c7..2a88a47 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -627,6 +627,44 @@ int proc_setattr(struct dentry *dentry, struct iattr *attr)
 	return 0;
 }
 
+struct mnt_namespace *mnt_ns_from_task(struct task_struct *task)
+{
+	struct nsproxy *nsp;
+	struct mnt_namespace *ns = NULL;
+
+
+	rcu_read_lock();
+	nsp = task_nsproxy(task);
+	if (nsp) {
+		ns = nsp->mnt_ns;
+		if (ns)
+			get_mnt_ns(ns);
+	}
+	rcu_read_unlock();
+	return ns;
+}
+
+struct mnt_namespace *mnt_ns_from_inode(struct inode *inode)
+{
+	struct task_struct *task = get_proc_task(inode);
+	struct path root;
+	struct mnt_namespace *ns = NULL;
+
+	if (!task)
+		return NULL;
+
+	ns = mnt_ns_from_task(task);
+
+	if (ns && get_task_root(task, &root) != 0) {
+		put_mnt_ns(ns);
+		ns = NULL;
+	}
+
+	path_put(&root);
+	put_task_struct(task);
+	return ns;
+}
+
 static const struct inode_operations proc_def_inode_operations = {
 	.setattr	= proc_setattr,
 };
@@ -635,21 +673,13 @@ static int mounts_open_common(struct inode *inode, struct file *file,
 			      const struct seq_operations *op)
 {
 	struct task_struct *task = get_proc_task(inode);
-	struct nsproxy *nsp;
 	struct mnt_namespace *ns = NULL;
 	struct path root;
 	struct proc_mounts *p;
 	int ret = -EINVAL;
 
 	if (task) {
-		rcu_read_lock();
-		nsp = task_nsproxy(task);
-		if (nsp) {
-			ns = nsp->mnt_ns;
-			if (ns)
-				get_mnt_ns(ns);
-		}
-		rcu_read_unlock();
+		ns = mnt_ns_from_task(task);
 		if (ns && get_task_root(task, &root) == 0)
 			ret = 0;
 		put_task_struct(task);
@@ -2875,7 +2905,8 @@ static struct dentry *proc_tgid_base_lookup(struct inode *dir, struct dentry *de
 
 static int filesystems_proc_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, filesystems_proc_show, NULL);
+	struct mnt_namespace *ns = mnt_ns_from_inode(inode);
+	return single_open(file, filesystems_proc_show, ns);
 }
 
 static const struct file_operations filesystems_proc_fops = {
-- 
1.7.7.4

