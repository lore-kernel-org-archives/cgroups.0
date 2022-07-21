From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: [PATCH 6/9] sched/psi: save percpu memory when !psi_cgroups_enabled
Date: Thu, 21 Jul 2022 12:04:36 +0800
Message-ID: <20220721040439.2651-7-zhouchengming@bytedance.com>
References: <20220721040439.2651-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XAbsx4z61PDmKxVrG+hWql1tanJuLJy0FXV+SbeVNSE=;
        b=n3xRXJ18Eab7FaOtwX3iQ8M5Fy8jiqky4vI6yYmrue1hP+DLKahrynn7eC45oq8pwv
         Rzb4EDX1fZFqqRvmOKFgP/BR33FOpvxGhPiKXyDA59rd8GTuagmsSEN4m/r2JxeZdcRZ
         m4vrsmTlWy1bdAyu70rUvXfq/7GqBOf61jVfLd3wsd+b8A+Wfrbj18dnl8slpV268XN7
         KprkkPcc+QRurpYYTV3ecrMQlGjoFWfs5Fk3SX+DRQwqW3d4CUUkHwSCwE+tuN3eXOVk
         NF3+BfTJt2R2yBh3NVJ3knbcNeIoqjdDdd4qcM1Q5aEnNtD/XFHRN7T6vt+6EAvJE/1H
         k+AQ==
In-Reply-To: <20220721040439.2651-1-zhouchengming@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes@cmpxchg.org, surenb@google.com, mingo@redhat.com, peterz@infradead.org, tj@kernel.org, corbet@lwn.net, akpm@linux-foundation.org, rdunlap@infradead.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com, cgroups@vger.kernel.org, Chengming Zhou <zhouchengming@bytedance.com>

We won't use cgroup psi_group when !psi_cgroups_enabled, so don't
bother to alloc percpu memory and init for it.

Also don't need to migrate task PSI stats between cgroups in
cgroup_move_task().

Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
---
 kernel/sched/psi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 6ba159fe2a4f..aa40bf888102 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -205,6 +205,7 @@ void __init psi_init(void)
 {
 	if (!psi_enable) {
 		static_branch_enable(&psi_disabled);
+		static_branch_disable(&psi_cgroups_enabled);
 		return;
 	}
 
@@ -952,7 +953,7 @@ void psi_memstall_leave(unsigned long *flags)
 #ifdef CONFIG_CGROUPS
 int psi_cgroup_alloc(struct cgroup *cgroup)
 {
-	if (static_branch_likely(&psi_disabled))
+	if (!static_branch_likely(&psi_cgroups_enabled))
 		return 0;
 
 	cgroup->psi.pcpu = alloc_percpu(struct psi_group_cpu);
@@ -964,7 +965,7 @@ int psi_cgroup_alloc(struct cgroup *cgroup)
 
 void psi_cgroup_free(struct cgroup *cgroup)
 {
-	if (static_branch_likely(&psi_disabled))
+	if (!static_branch_likely(&psi_cgroups_enabled))
 		return;
 
 	cancel_delayed_work_sync(&cgroup->psi.avgs_work);
@@ -991,7 +992,7 @@ void cgroup_move_task(struct task_struct *task, struct css_set *to)
 	struct rq_flags rf;
 	struct rq *rq;
 
-	if (static_branch_likely(&psi_disabled)) {
+	if (!static_branch_likely(&psi_cgroups_enabled)) {
 		/*
 		 * Lame to do this here, but the scheduler cannot be locked
 		 * from the outside, so we move cgroups from inside sched/.
-- 
2.36.1

