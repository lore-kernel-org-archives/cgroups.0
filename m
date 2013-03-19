From: Tejun Heo <tj@kernel.org>
Subject: [PATCH cgroup/for-3.10] cgroup: make cgroup_mutex outer to
 threadgroup_lock
Date: Tue, 19 Mar 2013 15:02:46 -0700
Message-ID: <20130319220246.GR3042@htj.dyndns.org>
References: <20130306223657.GA7392@redhat.com>
 <20130307172545.GA10353@redhat.com>
 <20130307180139.GD29601@htj.dyndns.org>
 <20130307180332.GE29601@htj.dyndns.org>
 <20130307191242.GA18265@redhat.com>
 <20130307193820.GB3209@htj.dyndns.org>
 <513A9A67.60909@huawei.com>
 <20130309032936.GT14556@mtj.dyndns.org>
 <513AE918.7020704@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=PvfWntzLgzlna53v/Eutwg3W8pJe5wt0asTddlyll+M=;
        b=d1oQv5J901KK8Zr8EkDQI+0D7NIENHnkZlFItWJn5l/7Rkx1WAUyZERUdRVivy2BaA
         pVYW+7IAOR8vHIbfZq7xoYNNYkWQqxNA9RI5hd6qPzxIZXNnDeCSo4ihIR56ocZPQWL8
         6P4TuKptWNuG73G2FPFF3G+rcElfXP7dAgwaJro6a5nSUgV6AdBdHDvMHn/VgUc0pO+Z
         rCIx7XPRzeEwep/4qek4eFOa1d6jRgC9qLRP/9Xu/s//B/GnZnqSDWS62pJbRhVIXKjk
         MM9Hf7M7pj758IoCFhNkYPgTIxes38Fzmd7dR+UBQC9y2C4vAfPuk66MnjCZJ60pqTNd
         3c0Q==
Content-Disposition: inline
In-Reply-To: <513AE918.7020704@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, cgroups@vger.kernel.org

It doesn't make sense to nest cgroup_mutex inside threadgroup_lock
when it should be outer to most all locks used by all cgroup
controllers.  It was nested inside threadgroup_lock only because some
controllers were abusing cgroup_mutex inside controllers leading to
locking order inversion.

cgroup_mutex is no longer abused by controllers and can be put outer
to threadgroup_lock.  Reverse the locking order in
attach_task_by_pid().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
---
Li, can you please ack this?

Thanks!

 kernel/cgroup.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 04fa2ab..24106b8 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2134,17 +2134,13 @@ static int attach_task_by_pid(struct cgroup *cgrp, u64 pid, bool threadgroup)
 	const struct cred *cred = current_cred(), *tcred;
 	int ret;
 
-	if (!cgroup_lock_live_group(cgrp))
-		return -ENODEV;
-
 retry_find_task:
 	rcu_read_lock();
 	if (pid) {
 		tsk = find_task_by_vpid(pid);
 		if (!tsk) {
 			rcu_read_unlock();
-			ret= -ESRCH;
-			goto out_unlock_cgroup;
+			return -ESRCH;
 		}
 		/*
 		 * even if we're attaching all tasks in the thread group, we
@@ -2155,8 +2151,7 @@ retry_find_task:
 		    !uid_eq(cred->euid, tcred->uid) &&
 		    !uid_eq(cred->euid, tcred->suid)) {
 			rcu_read_unlock();
-			ret = -EACCES;
-			goto out_unlock_cgroup;
+			return -EACCES;
 		}
 	} else
 		tsk = current;
@@ -2170,9 +2165,8 @@ retry_find_task:
 	 * with no rt_runtime allocated.  Just say no.
 	 */
 	if (tsk == kthreadd_task || (tsk->flags & PF_THREAD_BOUND)) {
-		ret = -EINVAL;
 		rcu_read_unlock();
-		goto out_unlock_cgroup;
+		return -EINVAL;
 	}
 
 	get_task_struct(tsk);
@@ -2194,13 +2188,14 @@ retry_find_task:
 		}
 	}
 
-	ret = cgroup_attach_task(cgrp, tsk, threadgroup);
+	ret = -ENODEV;
+	if (cgroup_lock_live_group(cgrp)) {
+		ret = cgroup_attach_task(cgrp, tsk, threadgroup);
+		cgroup_unlock();
+	}
 
 	threadgroup_unlock(tsk);
-
 	put_task_struct(tsk);
-out_unlock_cgroup:
-	cgroup_unlock();
 	return ret;
 }
 
