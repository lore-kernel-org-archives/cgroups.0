From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Tue, 15 Oct 2013 11:47:19 +0800
Message-ID: <525CBAC7.7050903@huawei.com>
References: <4431690.ZqnBIdaGMg@akheu22.uni-muenster.de> <5257F7CE.90702@huawei.com> <CA+SBX_Pa8sJbRq3aOghzqam5tDUbs_SPnVTaewtg-pRmvUqSzA@mail.gmail.com> <5258E584.70500@huawei.com> <CA+SBX_MQVMuzWKroASK7Cr5J8cu9ajGo=CWr7SRs+OWh83h4_w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+SBX_MQVMuzWKroASK7Cr5J8cu9ajGo=CWr7SRs+OWh83h4_w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2013/10/14 16:06, Markus Blank-Burian wrote:
> The crash utility indicated, that the lock was held by a kworker
> thread, which was idle at the moment. So there might be a case, where
> no unlock is done. I am trying to reproduce the problem at the moment
> with CONFIG_PROVE_LOCKING, but without luck so far. It seems, that my
> test-job is quite bad at reproducing the bug. I'll let you know, if I
> can find out more.
> 

Another way to find out who has been holding cgroup_mutex.

Do a s/mutex_lock(&cgroup_mutex)/cgroup_lock()/g in kernel/cgroup.c,
and add debug printks in cgroup_lock.

When the deadlock happens, the last dump_stack() shows the code path
to cgroup_lock() which leads to deadlock. We won't see idle this way.

=====

based on v3.11.3


--- kernel/cgroup.c.old	2013-10-15 11:21:10.000000000 +0800
+++ kernel/cgroup.c	2013-10-15 11:24:06.000000000 +0800
@@ -86,6 +86,13 @@ EXPORT_SYMBOL_GPL(cgroup_mutex);	/* only
 static DEFINE_MUTEX(cgroup_mutex);
 #endif
 
+void cgroup_lock(void)
+{
+	mutex_lock(&cgroup_mutex);
+	pr_info("cgroup_lock: %d (%s)\n", task_tgid_nr(current), current->comm);
+	dump_stack();
+}
+
 static DEFINE_MUTEX(cgroup_root_mutex);
 
 /*
@@ -316,7 +323,7 @@ static inline struct cftype *__d_cft(str
  */
 static bool cgroup_lock_live_group(struct cgroup *cgrp)
 {
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	if (cgroup_is_dead(cgrp)) {
 		mutex_unlock(&cgroup_mutex);
 		return false;
@@ -847,7 +854,7 @@ static void cgroup_free_fn(struct work_s
 	struct cgroup *cgrp = container_of(work, struct cgroup, destroy_work);
 	struct cgroup_subsys *ss;
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	/*
 	 * Release the subsystem state objects.
 	 */
@@ -1324,7 +1331,7 @@ static void drop_parsed_module_refcounts
 	struct cgroup_subsys *ss;
 	int i;
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	for_each_subsys(ss, i)
 		if (subsys_mask & (1UL << i))
 			module_put(cgroup_subsys[i]->module);
@@ -1345,7 +1352,7 @@ static int cgroup_remount(struct super_b
 	}
 
 	mutex_lock(&cgrp->dentry->d_inode->i_mutex);
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	mutex_lock(&cgroup_root_mutex);
 
 	/* See what subsystems are wanted */
@@ -1587,7 +1594,7 @@ static struct dentry *cgroup_mount(struc
 	struct inode *inode;
 
 	/* First find the desired set of subsystems */
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	ret = parse_cgroupfs_options(data, &opts);
 	mutex_unlock(&cgroup_mutex);
 	if (ret)
@@ -1631,7 +1638,7 @@ static struct dentry *cgroup_mount(struc
 		inode = sb->s_root->d_inode;
 
 		mutex_lock(&inode->i_mutex);
-		mutex_lock(&cgroup_mutex);
+		cgroup_lock();
 		mutex_lock(&cgroup_root_mutex);
 
 		/* Check for name clashes with existing mounts */
@@ -1746,7 +1753,7 @@ static void cgroup_kill_sb(struct super_
 	BUG_ON(root->number_of_cgroups != 1);
 	BUG_ON(!list_empty(&cgrp->children));
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	mutex_lock(&cgroup_root_mutex);
 
 	/* Rebind all subsystems back to the default hierarchy */
@@ -1866,7 +1873,7 @@ int task_cgroup_path(struct task_struct
 	if (buflen < 2)
 		return -ENAMETOOLONG;
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 
 	root = idr_get_next(&cgroup_hierarchy_idr, &hierarchy_id);
 
@@ -2251,7 +2258,7 @@ int cgroup_attach_task_all(struct task_s
 	struct cgroupfs_root *root;
 	int retval = 0;
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	for_each_active_root(root) {
 		struct cgroup *from_cg = task_cgroup_from_root(from, root);
 
@@ -2819,7 +2826,7 @@ static void cgroup_cfts_prepare(void)
 	 * Instead, we use cgroup_for_each_descendant_pre() and drop RCU
 	 * read lock before calling cgroup_addrm_files().
 	 */
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 }
 
 static void cgroup_cfts_commit(struct cgroup_subsys *ss,
@@ -2852,7 +2859,7 @@ static void cgroup_cfts_commit(struct cg
 	/* @root always needs to be updated */
 	inode = root->dentry->d_inode;
 	mutex_lock(&inode->i_mutex);
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	cgroup_addrm_files(root, ss, cfts, is_add);
 	mutex_unlock(&cgroup_mutex);
 	mutex_unlock(&inode->i_mutex);
@@ -2871,7 +2878,7 @@ static void cgroup_cfts_commit(struct cg
 		prev = cgrp->dentry;
 
 		mutex_lock(&inode->i_mutex);
-		mutex_lock(&cgroup_mutex);
+		cgroup_lock();
 		if (cgrp->serial_nr < update_before && !cgroup_is_dead(cgrp))
 			cgroup_addrm_files(cgrp, ss, cfts, is_add);
 		mutex_unlock(&cgroup_mutex);
@@ -3406,7 +3413,7 @@ static void cgroup_transfer_one_task(str
 {
 	struct cgroup *new_cgroup = scan->data;
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	cgroup_attach_task(new_cgroup, task, false);
 	mutex_unlock(&cgroup_mutex);
 }
@@ -4596,7 +4603,7 @@ static void cgroup_offline_fn(struct wor
 	struct dentry *d = cgrp->dentry;
 	struct cgroup_subsys *ss;
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 
 	/*
 	 * css_tryget() is guaranteed to fail now.  Tell subsystems to
@@ -4630,7 +4637,7 @@ static int cgroup_rmdir(struct inode *un
 {
 	int ret;
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	ret = cgroup_destroy_locked(dentry->d_fsdata);
 	mutex_unlock(&cgroup_mutex);
 
@@ -4657,7 +4664,7 @@ static void __init cgroup_init_subsys(st
 
 	printk(KERN_INFO "Initializing cgroup subsys %s\n", ss->name);
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 
 	/* init base cftset */
 	cgroup_init_cftsets(ss);
@@ -4736,7 +4743,7 @@ int __init_or_module cgroup_load_subsys(
 	/* init base cftset */
 	cgroup_init_cftsets(ss);
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	cgroup_subsys[ss->subsys_id] = ss;
 
 	/*
@@ -4824,7 +4831,7 @@ void cgroup_unload_subsys(struct cgroup_
 	 */
 	BUG_ON(ss->root != &cgroup_dummy_root);
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 
 	offline_css(ss, cgroup_dummy_top);
 
@@ -4934,7 +4941,7 @@ int __init cgroup_init(void)
 	}
 
 	/* allocate id for the dummy hierarchy */
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	mutex_lock(&cgroup_root_mutex);
 
 	/* Add init_css_set to the hash table */
@@ -5001,7 +5008,7 @@ int proc_cgroup_show(struct seq_file *m,
 
 	retval = 0;
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 
 	for_each_active_root(root) {
 		struct cgroup_subsys *ss;
@@ -5044,7 +5051,7 @@ static int proc_cgroupstats_show(struct
 	 * cgroup_mutex is also necessary to guarantee an atomic snapshot of
 	 * subsys/hierarchy state.
 	 */
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 
 	for_each_subsys(ss, i)
 		seq_printf(m, "%s\t%d\t%d\t%d\n",
@@ -5273,7 +5280,7 @@ static void check_for_release(struct cgr
 static void cgroup_release_agent(struct work_struct *work)
 {
 	BUG_ON(work != &release_agent_work);
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	raw_spin_lock(&release_list_lock);
 	while (!list_empty(&release_list)) {
 		char *argv[3], *envp[3];
@@ -5309,7 +5316,7 @@ static void cgroup_release_agent(struct
 		 * be a slow process */
 		mutex_unlock(&cgroup_mutex);
 		call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
-		mutex_lock(&cgroup_mutex);
+		cgroup_lock();
  continue_free:
 		kfree(pathbuf);
 		kfree(agentbuf);
