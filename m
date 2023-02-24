From: Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v12 3/8] sched/core: Propagate parent task's latency requirements to the child task
Date: Fri, 24 Feb 2023 10:34:49 +0100
Message-ID: <20230224093454.956298-4-vincent.guittot@linaro.org>
References: <20230224093454.956298-1-vincent.guittot@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oe0Uu935GUv7Os5h4xnlj3hjmH+1d59YLoRXBZZGIAY=;
        b=M/oQDDEh1x3rok6xB3rswBzsh2CRxoaZDID2byS65RkMGb0GDD3MqQmZH9MppTnquq
         fTby+i2kplGA5hVWZsaxpw1fs5xuLjf142dgQ0zIhorxZwv1qQC743lB+ZBvxIB3XpgX
         ejykMcqofVFzvaWswtOlR/1nyi3ch4k59aW9F2s1awuNUohXaJ6NmHbZ042zD6GD2Lwm
         8ex+yj1V149qNPNyUdSrZ1rxeAVrMLA081+RP1BnvvM8je801xgRaPigur0shh0gwhxr
         PCqmbsxGGIhXYM9IQZM/+ChhpzH7cxxHHVenlx5XW5jPf/1IM8YtzbrnZziibwY+MF2w
         zS0g==
In-Reply-To: <20230224093454.956298-1-vincent.guittot@linaro.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, bristot@redhat.com, vschneid@redhat.com, linux-kernel@vger.kernel.org, parth@linux.ibm.com, tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, corbet@lwn.net, linux-doc@vger.kernel.org
Cc: qyousef@layalina.io, chris.hyser@oracle.com, patrick.bellasi@matbug.net, David.Laight@aculab.com, pjt@google.com, pavel@ucw.cz, qperret@google.com, tim.c.chen@linux.intel.com, joshdon@google.com, timj@gnu.org, kprateek.nayak@amd.com, yu.c.chen@intel.com, youssefesmat@chromium.org, joel@joelfernandes.org, Vincent Guittot <vincent.guittot@linaro.org>

From: Parth Shah <parth@linux.ibm.com>

Clone parent task's latency_nice attribute to the forked child task.

Reset the latency_nice value to default value when the child task is
set to sched_reset_on_fork.

Also, initialize init_task.latency_nice value with DEFAULT_LATENCY_NICE
value

Signed-off-by: Parth Shah <parth@linux.ibm.com>
[rebase]
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
---
 init/init_task.c    | 1 +
 kernel/sched/core.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/init/init_task.c b/init/init_task.c
index ff6c4b9bfe6b..7dd71dd2d261 100644
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -78,6 +78,7 @@ struct task_struct init_task
 	.prio		= MAX_PRIO - 20,
 	.static_prio	= MAX_PRIO - 20,
 	.normal_prio	= MAX_PRIO - 20,
+	.latency_nice	= DEFAULT_LATENCY_NICE,
 	.policy		= SCHED_NORMAL,
 	.cpus_ptr	= &init_task.cpus_mask,
 	.user_cpus_ptr	= NULL,
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4580fe3e1d0c..28b397f9698b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4681,6 +4681,7 @@ int sched_fork(unsigned long clone_flags, struct task_struct *p)
 		p->prio = p->normal_prio = p->static_prio;
 		set_load_weight(p, false);
 
+		p->latency_nice = DEFAULT_LATENCY_NICE;
 		/*
 		 * We don't need the reset flag anymore after the fork. It has
 		 * fulfilled its duty:
-- 
2.34.1

