From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH for-6.1-fixes] memcg: Fix possible use-after-free in
 memcg_write_event_control()
Date: Wed, 7 Dec 2022 16:53:15 -1000
Message-ID: <Y5FRm/cfcKPGzWwl@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=Tg8aD+lDH6Tv1G5iqzFowxNp9DpUbCk5WdkpP14KUyw=;
        b=bwaVRySVfZUnRb2bEPwJ5xCOaAbW2JOL2VzvtwPsxsOLsgpqhXcMxtBMO4VtjWsH7V
         MDQdVhBlbBUjWAU33uNkOOvxe6VkCUIQpal1m6VcrraOtDor8fGL9ie8cC1x1k9jxDpj
         czQSokKN+AFxHVJpY8Th5uLXRaS/kzWqoEfgdtR/nJOjRFicdSnYdhZ4WHoINWQqfB/R
         k05tFcdSkGfjgd0dvF+scgm7a1+iUyuh/FVGqvRGA392bZFPehNVJTITg5BaWJBBlLvm
         tIEKV5suDt1M2Sc9G4ukFt5sH7wc7eq/2lUB3Z18JNCWI+My330fDciGZKoERtGwNA5C
         HQVw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

memcg_write_event_control() accesses the dentry->d_name of the specified
control fd to route the write call. As a cgroup interface file can't be
renamed, it's safe to access d_name as long as the specified file is a
regular cgroup file. Also, as these cgroup interface files can't be removed
before the directory, it's safe to access the parent too.

Prior to 347c4a874710 ("memcg: remove cgroup_event->cft"), there was a call
to __file_cft() which verified that the specified file is a regular cgroupfs
file before further accesses. The cftype pointer returned from __file_cft()
was no longer necessary and the commit inadvertently dropped the file type
check with it allowing any file to slip through. With the invarients broken,
the d_name and parent accesses can now race against renames and removals of
arbitrary files and cause use-after-free's.

Fix the bug by resurrecting the file type check in __file_cft(). Now that
cgroupfs is implemented through kernfs, checking the file operations needs
to go through a layer of indirection. Instead, let's check the superblock
and dentry type.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Fixes: 347c4a874710 ("memcg: remove cgroup_event->cft")
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # v3.14+
Reported-by: Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
---
 include/linux/cgroup.h          |    1 +
 kernel/cgroup/cgroup-internal.h |    1 -
 mm/memcontrol.c                 |   15 +++++++++++++--
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 528bd44b59e2..2b7d077de7ef 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -68,6 +68,7 @@ struct css_task_iter {
 	struct list_head		iters_node;	/* css_set->task_iters */
 };
 
+extern struct file_system_type cgroup_fs_type;
 extern struct cgroup_root cgrp_dfl_root;
 extern struct css_set init_css_set;
 
diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index fd4020835ec6..367b0a42ada9 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -167,7 +167,6 @@ struct cgroup_mgctx {
 extern spinlock_t css_set_lock;
 extern struct cgroup_subsys *cgroup_subsys[];
 extern struct list_head cgroup_roots;
-extern struct file_system_type cgroup_fs_type;
 
 /* iterate across the hierarchies */
 #define for_each_root(root)						\
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a1a35c12635e..266a1ab05434 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4832,6 +4832,7 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 	unsigned int efd, cfd;
 	struct fd efile;
 	struct fd cfile;
+	struct dentry *cdentry;
 	const char *name;
 	char *endp;
 	int ret;
@@ -4885,6 +4886,16 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 	if (ret < 0)
 		goto out_put_cfile;
 
+	/*
+	 * The control file must be a regular cgroup1 file. As a regular cgroup
+	 * file can't be renamed, it's safe to access its name afterwards.
+	 */
+	cdentry = cfile.file->f_path.dentry;
+	if (cdentry->d_sb->s_type != &cgroup_fs_type || !d_is_reg(cdentry)) {
+		ret = -EINVAL;
+		goto out_put_cfile;
+	}
+
 	/*
 	 * Determine the event callbacks and set them in @event.  This used
 	 * to be done via struct cftype but cgroup core no longer knows
@@ -4893,7 +4904,7 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 	 *
 	 * DO NOT ADD NEW FILES.
 	 */
-	name = cfile.file->f_path.dentry->d_name.name;
+	name = cdentry->d_name.name;
 
 	if (!strcmp(name, "memory.usage_in_bytes")) {
 		event->register_event = mem_cgroup_usage_register_event;
@@ -4917,7 +4928,7 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 	 * automatically removed on cgroup destruction but the removal is
 	 * asynchronous, so take an extra ref on @css.
 	 */
-	cfile_css = css_tryget_online_from_dir(cfile.file->f_path.dentry->d_parent,
+	cfile_css = css_tryget_online_from_dir(cdentry->d_parent,
 					       &memory_cgrp_subsys);
 	ret = -EINVAL;
 	if (IS_ERR(cfile_css))
