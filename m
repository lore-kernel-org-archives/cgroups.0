From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/10] cgroup: Fix reference counting bug in cgroup_procs_write()
Date: Sat, 10 Jun 2017 10:03:44 -0400
Message-ID: <20170610140351.10703-4-tj@kernel.org>
References: <20170610140351.10703-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+DpFh76kS7Zcs2FMQFIyXncvc1CXPEw/lB9vTs70VYk=;
        b=MltinqGVXkIHrcdQi/cznonrt3bVc9tx+EWsxYfDf+3VQcERwFJMNrKYZ8Mf/x9Mm2
         CVGfaiwJ64EHsFqMyXYS8gVOghLTui5agwsxttm0cRyfBMs0gQbCdCfa5QZSN11aqRaq
         zW+zvEERrngg+uIVllN5F91ke6Om1KAHTSN2nvHYMy68ihEhBYKxVx4JvNJqrLyWHsdA
         rRdqUpgz+c31lZi84GJGA9m6VZSMTwIzPqw6pM79SWG16r1Z8MjiAwaoR+v6s0xfhm27
         fTSvo4SZjm6qI4ZnkIikUbejlifq3CZXLqR1QKt13ZTHF6ibp8p/XZBLd4zC9Qa/L4KW
         AQGA==
In-Reply-To: <20170610140351.10703-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, longman@redhat.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Tejun Heo <tj@kernel.org>

From: Waiman Long <longman@redhat.com>

The cgroup_procs_write_start() took a reference to the task structure
which was not properly released within cgroup_procs_write() and so
on. So a put_task_struct() call is added to cgroup_procs_write_finish()
to match the get_task_struct() in cgroup_procs_write_start() to fix
this reference counting error.

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup/cgroup-internal.h | 2 +-
 kernel/cgroup/cgroup-v1.c       | 2 +-
 kernel/cgroup/cgroup.c          | 8 +++++---
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index f0a0dba97bad..2c8e3a949fc5 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -182,7 +182,7 @@ int cgroup_attach_task(struct cgroup *dst_cgrp, struct task_struct *leader,
 		       bool threadgroup);
 struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup)
 	__acquires(&cgroup_threadgroup_rwsem);
-void cgroup_procs_write_finish(void)
+void cgroup_procs_write_finish(struct task_struct *task)
 	__releases(&cgroup_threadgroup_rwsem);
 
 void cgroup_lock_and_drain_offline(struct cgroup *cgrp);
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index f13ccab992c7..f6dba423e8ff 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -549,7 +549,7 @@ static ssize_t __cgroup1_procs_write(struct kernfs_open_file *of,
 	ret = cgroup_attach_task(cgrp, task, threadgroup);
 
 out_finish:
-	cgroup_procs_write_finish();
+	cgroup_procs_write_finish(task);
 out_unlock:
 	cgroup_kn_unlock(of->kn);
 
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 78a2c9788d40..ddcbfda642cd 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2438,12 +2438,15 @@ struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup)
 	return tsk;
 }
 
-void cgroup_procs_write_finish(void)
+void cgroup_procs_write_finish(struct task_struct *task)
 	__releases(&cgroup_threadgroup_rwsem)
 {
 	struct cgroup_subsys *ss;
 	int ssid;
 
+	/* release reference from cgroup_procs_write_start() */
+	put_task_struct(task);
+
 	percpu_up_write(&cgroup_threadgroup_rwsem);
 	for_each_subsys(ss, ssid)
 		if (ss->post_attach)
@@ -3102,7 +3105,6 @@ static int cgroup_addrm_files(struct cgroup_subsys_state *css,
 
 static int cgroup_apply_cftypes(struct cftype *cfts, bool is_add)
 {
-	LIST_HEAD(pending);
 	struct cgroup_subsys *ss = cfts[0].ss;
 	struct cgroup *root = &ss->root->cgrp;
 	struct cgroup_subsys_state *css;
@@ -3793,7 +3795,7 @@ static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
 	ret = cgroup_attach_task(cgrp, task, true);
 
 out_finish:
-	cgroup_procs_write_finish();
+	cgroup_procs_write_finish(task);
 out_unlock:
 	cgroup_kn_unlock(of->kn);
 
-- 
2.13.0

