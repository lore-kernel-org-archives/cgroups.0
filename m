From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: [PATCH v2 06/10] sched/psi: save percpu memory when !psi_cgroups_enabled
Date: Mon,  8 Aug 2022 19:03:37 +0800
Message-ID: <20220808110341.15799-7-zhouchengming@bytedance.com>
References: <20220808110341.15799-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uLMRRkpz76WFAC6w4foL1Edra508Vk6fX2ixUPszkRg=;
        b=U6k3lehDVxN49RqBtV2xHyF+h26ildCUx/hcQLS9PcepCqK9IKcw4CdPAOeUIuPG1s
         mnq493zh8DB20EHT/ai2shQdEyKlIWuxBPLr9RwwFptYyqtgSHSYvaBTR82EiYDsqV+B
         7HioJDTamptDapEshQrGUO5P4EWY1LC7erYwBHO8bW/02kfj0t9ek1st38Td6Fs+vuDX
         Uip9TgU+7YcBuNOJSM+ttx3zWrfaftX4/gZQJY14Tp23U8DKeiK1omha+8GKoSjbwSaT
         sM8kDBGUzcZbCVFNmleTqCYfQeZcqXfVtc+VLHbpn2Gpw9+9B+i7ZIHuDzt2KArEeqAH
         Svuw==
In-Reply-To: <20220808110341.15799-1-zhouchengming@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes@cmpxchg.org, tj@kernel.org, corbet@lwn.net, surenb@google.com, mingo@redhat.com, peterz@infradead.org, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com, Chengming Zhou <zhouchengming@bytedance.com>

We won't use cgroup psi_group when !psi_cgroups_enabled, so don't
bother to alloc percpu memory and init for it.

Also don't need to migrate task PSI stats between cgroups in
cgroup_move_task().

Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
---
 kernel/sched/psi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 974471f212a3..595a6c8230b7 100644
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

