From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-6.0-fixes] cgroup: Fix threadgroup_rwsem <->
 cpus_read_lock() deadlock
Date: Mon, 15 Aug 2022 13:27:38 -1000
Message-ID: <YvrWaml3F+x9Dk+T@slm.duckdns.org>
References: <bbc01477-231b-3dbb-3e09-9338f5413f06@oracle.com>
 <ba48eac5-8ef7-251b-11fe-8163bb7a2d54@quicinc.com>
 <224b19f3-912d-b858-7af4-185b8e55bc66@quicinc.com>
 <YthDz4BnfYHce1od@slm.duckdns.org>
 <YuGTBLkFerUboctl@slm.duckdns.org>
 <dc0cff0e-b744-9d5d-e727-70d1c31b2a74@quicinc.com>
 <20220815090556.GB27407@blackbody.suse.cz>
 <CAB8ipk90LxNNbq5OKamd-ArkqhEZjxS1fFZJXtnbQwGzyyJ3wQ@mail.gmail.com>
 <20220815093934.GA29323@blackbody.suse.cz>
 <f584fecd-6ca4-4ab0-763d-2ed219009c61@quicinc.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=uRkPsDWpO6vIBgu5M+7piD5f4UvaAnIFSBv2N8HBdkA=;
        b=La1AmedYuOvLHpclRcmDVhOGiyvk02QZTwVFP/CKqVKPB/HmCKpH7RP6WqNDlrhblR
         HBZHLp0/bciRj7GBBgLQ2NeDIDJoe0NlIZ9j8/HEs6qdlnOYMw0hvErehS7C5c0mGYYy
         EbDxVfUoghs/ZaA/f9zCrYrH/e/qXfL+WqLYmcqI1SfllKLDhFeD1JTQM8rVCEPw4MGE
         AmcamTwMFZkNnOJdyLLMySpbCM2aCmHy1ER7il+MR9/pxyySFzF4mgh33IkVMuhU250m
         bJkuAMoL7eNdRt3gZ7EiwvUajhPmTKgbVMulo9J4LMRAlWtHbra0Dww6Ojmta4vjJ+2i
         VH4Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f584fecd-6ca4-4ab0-763d-2ed219009c61-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mukesh Ojha <quic_mojha-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Xuewen Yan <xuewen.yan94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Imran Khan <imran.f.khan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, steven.price-5wv7dgnIgG8@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zhao Gongyi <zhaogongyi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Zhang Qiao <zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Bringing up a CPU may involve creating new tasks which requires read-locking
threadgroup_rwsem, so threadgroup_rwsem nests inside cpus_read_lock().
However, cpuset's ->attach(), which may be called with thredagroup_rwsem
write-locked, also wants to disable CPU hotplug and acquires
cpus_read_lock(), leading to a deadlock.

Fix it by guaranteeing that ->attach() is always called with CPU hotplug
disabled and removing cpus_read_lock() call from cpuset_attach().

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Hello, sorry about the delay.

So, the previous patch + the revert isn't quite correct because we sometimes
elide both cpus_read_lock() and threadgroup_rwsem together and
cpuset_attach() woudl end up running without CPU hotplug enabled. Can you
please test whether this patch fixes the problem?

Thanks.

 kernel/cgroup/cgroup.c |   77 ++++++++++++++++++++++++++++++++++---------------
 kernel/cgroup/cpuset.c |    3 -
 2 files changed, 55 insertions(+), 25 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index ffaccd6373f1e..52502f34fae8c 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2369,6 +2369,47 @@ int task_cgroup_path(struct task_struct *task, char *buf, size_t buflen)
 }
 EXPORT_SYMBOL_GPL(task_cgroup_path);
 
+/**
+ * cgroup_attach_lock - Lock for ->attach()
+ * @lock_threadgroup: whether to down_write cgroup_threadgroup_rwsem
+ *
+ * cgroup migration sometimes needs to stabilize threadgroups against forks and
+ * exits by write-locking cgroup_threadgroup_rwsem. However, some ->attach()
+ * implementations (e.g. cpuset), also need to disable CPU hotplug.
+ * Unfortunately, letting ->attach() operations acquire cpus_read_lock() can
+ * lead to deadlocks.
+ *
+ * Bringing up a CPU may involve creating new tasks which requires read-locking
+ * threadgroup_rwsem, so threadgroup_rwsem nests inside cpus_read_lock(). If we
+ * call an ->attach() which acquires the cpus lock while write-locking
+ * threadgroup_rwsem, the locking order is reversed and we end up waiting for an
+ * on-going CPU hotplug operation which in turn is waiting for the
+ * threadgroup_rwsem to be released to create new tasks. For more details:
+ *
+ *   http://lkml.kernel.org/r/20220711174629.uehfmqegcwn2lqzu@wubuntu
+ *
+ * Resolve the situation by always acquiring cpus_read_lock() before optionally
+ * write-locking cgroup_threadgroup_rwsem. This allows ->attach() to assume that
+ * CPU hotplug is disabled on entry.
+ */
+static void cgroup_attach_lock(bool lock_threadgroup)
+{
+	cpus_read_lock();
+	if (lock_threadgroup)
+		percpu_down_write(&cgroup_threadgroup_rwsem);
+}
+
+/**
+ * cgroup_attach_unlock - Undo cgroup_attach_lock()
+ * @lock_threadgroup: whether to up_write cgroup_threadgroup_rwsem
+ */
+static void cgroup_attach_unlock(bool lock_threadgroup)
+{
+	if (lock_threadgroup)
+		percpu_up_write(&cgroup_threadgroup_rwsem);
+	cpus_read_unlock();
+}
+
 /**
  * cgroup_migrate_add_task - add a migration target task to a migration context
  * @task: target task
@@ -2841,8 +2882,7 @@ int cgroup_attach_task(struct cgroup *dst_cgrp, struct task_struct *leader,
 }
 
 struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup,
-					     bool *locked)
-	__acquires(&cgroup_threadgroup_rwsem)
+					     bool *threadgroup_locked)
 {
 	struct task_struct *tsk;
 	pid_t pid;
@@ -2859,12 +2899,8 @@ struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup,
 	 * Therefore, we can skip the global lock.
 	 */
 	lockdep_assert_held(&cgroup_mutex);
-	if (pid || threadgroup) {
-		percpu_down_write(&cgroup_threadgroup_rwsem);
-		*locked = true;
-	} else {
-		*locked = false;
-	}
+	*threadgroup_locked = pid || threadgroup;
+	cgroup_attach_lock(*threadgroup_locked);
 
 	rcu_read_lock();
 	if (pid) {
@@ -2895,17 +2931,14 @@ struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup,
 	goto out_unlock_rcu;
 
 out_unlock_threadgroup:
-	if (*locked) {
-		percpu_up_write(&cgroup_threadgroup_rwsem);
-		*locked = false;
-	}
+	cgroup_attach_unlock(*threadgroup_locked);
+	*threadgroup_locked = false;
 out_unlock_rcu:
 	rcu_read_unlock();
 	return tsk;
 }
 
-void cgroup_procs_write_finish(struct task_struct *task, bool locked)
-	__releases(&cgroup_threadgroup_rwsem)
+void cgroup_procs_write_finish(struct task_struct *task, bool threadgroup_locked)
 {
 	struct cgroup_subsys *ss;
 	int ssid;
@@ -2913,8 +2946,8 @@ void cgroup_procs_write_finish(struct task_struct *task, bool locked)
 	/* release reference from cgroup_procs_write_start() */
 	put_task_struct(task);
 
-	if (locked)
-		percpu_up_write(&cgroup_threadgroup_rwsem);
+	cgroup_attach_unlock(threadgroup_locked);
+
 	for_each_subsys(ss, ssid)
 		if (ss->post_attach)
 			ss->post_attach();
@@ -3000,8 +3033,7 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 	 * write-locking can be skipped safely.
 	 */
 	has_tasks = !list_empty(&mgctx.preloaded_src_csets);
-	if (has_tasks)
-		percpu_down_write(&cgroup_threadgroup_rwsem);
+	cgroup_attach_lock(has_tasks);
 
 	/* NULL dst indicates self on default hierarchy */
 	ret = cgroup_migrate_prepare_dst(&mgctx);
@@ -3022,8 +3054,7 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 	ret = cgroup_migrate_execute(&mgctx);
 out_finish:
 	cgroup_migrate_finish(&mgctx);
-	if (has_tasks)
-		percpu_up_write(&cgroup_threadgroup_rwsem);
+	cgroup_attach_unlock(has_tasks);
 	return ret;
 }
 
@@ -4971,13 +5002,13 @@ static ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
 	struct task_struct *task;
 	const struct cred *saved_cred;
 	ssize_t ret;
-	bool locked;
+	bool threadgroup_locked;
 
 	dst_cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!dst_cgrp)
 		return -ENODEV;
 
-	task = cgroup_procs_write_start(buf, threadgroup, &locked);
+	task = cgroup_procs_write_start(buf, threadgroup, &threadgroup_locked);
 	ret = PTR_ERR_OR_ZERO(task);
 	if (ret)
 		goto out_unlock;
@@ -5003,7 +5034,7 @@ static ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
 	ret = cgroup_attach_task(dst_cgrp, task, threadgroup);
 
 out_finish:
-	cgroup_procs_write_finish(task, locked);
+	cgroup_procs_write_finish(task, threadgroup_locked);
 out_unlock:
 	cgroup_kn_unlock(of->kn);
 
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 58aadfda9b8b3..1f3a55297f39d 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2289,7 +2289,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 	cgroup_taskset_first(tset, &css);
 	cs = css_cs(css);
 
-	cpus_read_lock();
+	lockdep_assert_cpus_held();	/* see cgroup_attach_lock() */
 	percpu_down_write(&cpuset_rwsem);
 
 	guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
@@ -2343,7 +2343,6 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 		wake_up(&cpuset_attach_wq);
 
 	percpu_up_write(&cpuset_rwsem);
-	cpus_read_unlock();
 }
 
 /* The various types of files and directories in a cpuset file system */
