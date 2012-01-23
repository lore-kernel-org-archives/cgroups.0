From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [RFC 1/4] move /proc/filesystems inside /proc/self
Date: Mon, 23 Jan 2012 20:56:09 +0400
Message-ID: <1327337772-1972-2-git-send-email-glommer@parallels.com>
References: <1327337772-1972-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1327337772-1972-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, daniel.lezcano-GANU6spQydw@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org, xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

This simple patch is a preparation for what is to come. It moves
the list of available filesystems inside /proc/self/, linking /proc/filesystems
to it.

It effectively means that each process may have a different view of which
filesystems are available in the system, depending on the namespace it
lives.

Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
---
 fs/filesystems.c   |   21 +--------------------
 fs/proc/base.c     |   15 +++++++++++++++
 fs/proc/root.c     |    1 +
 include/linux/fs.h |    2 ++
 4 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/fs/filesystems.c b/fs/filesystems.c
index 0845f84..458d120 100644
--- a/fs/filesystems.c
+++ b/fs/filesystems.c
@@ -219,7 +219,7 @@ int __init get_filesystem_list(char *buf)
 }
 
 #ifdef CONFIG_PROC_FS
-static int filesystems_proc_show(struct seq_file *m, void *v)
+int filesystems_proc_show(struct seq_file *m, void *v)
 {
 	struct file_system_type * tmp;
 
@@ -234,25 +234,6 @@ static int filesystems_proc_show(struct seq_file *m, void *v)
 	read_unlock(&file_systems_lock);
 	return 0;
 }
-
-static int filesystems_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, filesystems_proc_show, NULL);
-}
-
-static const struct file_operations filesystems_proc_fops = {
-	.open		= filesystems_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static int __init proc_filesystems_init(void)
-{
-	proc_create("filesystems", 0, NULL, &filesystems_proc_fops);
-	return 0;
-}
-module_init(proc_filesystems_init);
 #endif
 
 static struct file_system_type *__get_fs_type(const char *name, int len)
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 851ba3d..2a6e2c7 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2768,6 +2768,7 @@ static int proc_pid_personality(struct seq_file *m, struct pid_namespace *ns,
  */
 static const struct file_operations proc_task_operations;
 static const struct inode_operations proc_task_inode_operations;
+static const struct file_operations filesystems_proc_fops;
 
 static const struct pid_entry tgid_base_stuff[] = {
 	DIR("task",       S_IRUGO|S_IXUGO, proc_task_inode_operations, proc_task_operations),
@@ -2851,6 +2852,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_HARDWALL
 	INF("hardwall",   S_IRUGO, proc_pid_hardwall),
 #endif
+	REG("filesystems", S_IRUGO, filesystems_proc_fops),
 };
 
 static int proc_tgid_base_readdir(struct file * filp,
@@ -2871,6 +2873,18 @@ static struct dentry *proc_tgid_base_lookup(struct inode *dir, struct dentry *de
 				  tgid_base_stuff, ARRAY_SIZE(tgid_base_stuff));
 }
 
+static int filesystems_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, filesystems_proc_show, NULL);
+}
+
+static const struct file_operations filesystems_proc_fops = {
+	.open		= filesystems_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static const struct inode_operations proc_tgid_base_inode_operations = {
 	.lookup		= proc_tgid_base_lookup,
 	.getattr	= pid_getattr,
@@ -3193,6 +3207,7 @@ static const struct pid_entry tid_base_stuff[] = {
 #ifdef CONFIG_HARDWALL
 	INF("hardwall",   S_IRUGO, proc_pid_hardwall),
 #endif
+	REG("filesystems", S_IRUGO, filesystems_proc_fops),
 };
 
 static int proc_tid_base_readdir(struct file * filp,
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 03102d9..87bf2e3 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -104,6 +104,7 @@ void __init proc_root_init(void)
 	}
 
 	proc_symlink("mounts", NULL, "self/mounts");
+	proc_symlink("filesystems", NULL, "self/filesystems");
 
 	proc_net_init();
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e0bc4ff..3286d74 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2529,6 +2529,8 @@ extern int generic_block_fiemap(struct inode *inode,
 extern void get_filesystem(struct file_system_type *fs);
 extern void put_filesystem(struct file_system_type *fs);
 extern struct file_system_type *get_fs_type(const char *name);
+extern int filesystems_proc_show(struct seq_file *m, void *v);
+
 extern struct super_block *get_super(struct block_device *);
 extern struct super_block *get_active_super(struct block_device *bdev);
 extern struct super_block *user_get_super(dev_t);
-- 
1.7.7.4
