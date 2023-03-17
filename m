From: Waiman Long <longman@redhat.com>
Subject: [PATCH v2 1/4] cgroup/cpuset: Fix partition root's cpuset.cpus update bug
Date: Fri, 17 Mar 2023 11:15:05 -0400
Message-ID: <20230317151508.1225282-2-longman@redhat.com>
References: <20230317151508.1225282-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679066133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yyPOMwQLISxSVk5Hax7mBc5lUymcLlOh64gwiaoZAvQ=;
        b=N/RkptS5aI2xMFm9zDcpLDq6Q1+TBXYIKFRNCAcjfERZltj156vNlXDdWjStoDyEv0xm0i
        4UhKCbqYO2KmsI+MrQeWj+t3YIR2eKKDzHb4i9HiGn1nGOke4kzoSdKwnOpirtfmjv6pfp
        bhda/HJX2Gr/TCBLX//IJklwCUehJvY=
In-Reply-To: <20230317151508.1225282-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Juri Lelli <juri.lelli@redhat.com>, Waiman Long <longman@redhat.com>

It was found that commit 7a2127e66a00 ("cpuset: Call
set_cpus_allowed_ptr() with appropriate mask for task") introduced a bug
that corrupted "cpuset.cpus" of a partition root when it was updated.

It is because the tmp->new_cpus field of the passed tmp parameter
of update_parent_subparts_cpumask() should not be used at all as
it contains important cpumask data that should not be overwritten.
Fix it by using tmp->addmask instead.

Also update update_cpumask() to make sure that trialcs->cpu_allowed
will not be corrupted until it is no longer needed.

Fixes: 7a2127e66a00 ("cpuset: Call set_cpus_allowed_ptr() with appropriate mask for task")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 636f1c682ac0..f310915d1257 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1513,7 +1513,7 @@ static int update_parent_subparts_cpumask(struct cpuset *cs, int cmd,
 	spin_unlock_irq(&callback_lock);
 
 	if (adding || deleting)
-		update_tasks_cpumask(parent, tmp->new_cpus);
+		update_tasks_cpumask(parent, tmp->addmask);
 
 	/*
 	 * Set or clear CS_SCHED_LOAD_BALANCE when partcmd_update, if necessary.
@@ -1770,10 +1770,13 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	/*
 	 * Use the cpumasks in trialcs for tmpmasks when they are pointers
 	 * to allocated cpumasks.
+	 *
+	 * Note that update_parent_subparts_cpumask() uses only addmask &
+	 * delmask, but not new_cpus.
 	 */
 	tmp.addmask  = trialcs->subparts_cpus;
 	tmp.delmask  = trialcs->effective_cpus;
-	tmp.new_cpus = trialcs->cpus_allowed;
+	tmp.new_cpus = NULL;
 #endif
 
 	retval = validate_change(cs, trialcs);
@@ -1838,6 +1841,11 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	}
 	spin_unlock_irq(&callback_lock);
 
+#ifdef CONFIG_CPUMASK_OFFSTACK
+	/* Now trialcs->cpus_allowed is available */
+	tmp.new_cpus = trialcs->cpus_allowed;
+#endif
+
 	/* effective_cpus will be updated here */
 	update_cpumasks_hier(cs, &tmp, false);
 
-- 
2.31.1

