Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98632D8DA3;
	Wed, 25 Feb 2026 05:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771995687; cv=none; b=TXl/lx++U+TIjn+VhpT1Lxl2DSDQ7jKR5pPqKTIhY597C27ZLp6CjbZ4M9eXqwjTTJxCJTt9iisxYFcwynYqtyDYFZlbUwbJ5LqV+9ppg2UWQZhkiFgTCG3jPN1c91jJgUmXw9pW4Z5PMkZOeBWXvNmV2HqAEeN8f/qZ3iEu+cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771995687; c=relaxed/simple;
	bh=I8IHNpau1zUarOYe9fmf4pYeesGlJlnX3Ozna07J6U0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQ8BWFVY0Jtr7nnqnFf44Td/Gc12rj/MvoFm7pKEIfM/2tcwasMuViV6Tm4QnVmlMxRZy0cUXA03hJWcg9FgdJ7f2VFq0odTWMFUVTtmF/JSU/pGoVyEjSM3jNAZAtdmqIpeJXrB4tT2Vadpe8QTzv4vOBjd0qZ+RneXehfzj3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FqHjVOtY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FqHjVOtY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6797DC19422;
	Wed, 25 Feb 2026 05:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771995687;
	bh=I8IHNpau1zUarOYe9fmf4pYeesGlJlnX3Ozna07J6U0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FqHjVOtY7Dmj+do5McbEn+s3tGorAjdqjoBcaeghNt7vw13Zu1613zLBF3EiUBgJD
	 g4jdSq1qaM14BYlaw5irQFAPXQMeVCO9NckGBAbjBf/d4QaHhI3qKMQQ2MEEqAE4Ck
	 9tL2GgMp5IiKKJghMYoPbu0NApceCbHeBhv3J8lVamFEE4FU66WXRcw6mEWy8Qb/d3
	 tLkHUE2q13KI76oDl/ZPeBReIvmxT4Sj18q0ffNI7Q89ICV9tysQkWuT8k07g662JH
	 IhyWUFIbnlO1Nzxe/CAiZDKhdfHuU7YyM1SuOZTBXFvGIclSYmz/wfvwZvipXSbner
	 g1v2z64+GheXg==
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org,
	sched-ext@lists.linux.dev
Cc: void@manifault.com,
	arighi@nvidia.com,
	changwoo@igalia.com,
	emil@etsalapatis.com,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	cgroups@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 16/34] sched_ext: Move aborting flag to per-scheduler field
Date: Tue, 24 Feb 2026 19:00:51 -1000
Message-ID: <20260225050109.1070059-17-tj@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225050109.1070059-1-tj@kernel.org>
References: <20260225050109.1070059-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The abort state was tracked in the global scx_aborting flag which was used to
break out of potential live-lock scenarios when an error occurs. With
hierarchical scheduling, each scheduler instance must track its own abort
state independently so that an aborting scheduler doesn't interfere with
others.

Move the aborting flag into struct scx_sched and update all access sites. The
early initialization check in scx_root_enable() that warned about residual
aborting state is no longer needed as each scheduler instance now starts with
a clean state.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/sched/ext.c          | 10 +++-------
 kernel/sched/ext_internal.h |  1 +
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index eee0d1c05b68..ef11a537acc5 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -44,7 +44,6 @@ static atomic_t scx_enable_state_var = ATOMIC_INIT(SCX_DISABLED);
 static int scx_bypass_depth;
 static cpumask_var_t scx_bypass_lb_donee_cpumask;
 static cpumask_var_t scx_bypass_lb_resched_cpumask;
-static bool scx_aborting;
 static bool scx_init_task_enabled;
 static bool scx_switching_all;
 DEFINE_STATIC_KEY_FALSE(__scx_switched_all);
@@ -2147,7 +2146,7 @@ static bool consume_dispatch_q(struct scx_sched *sch, struct rq *rq,
 		 * the system into the bypass mode. This can easily live-lock the
 		 * machine. If aborting, exit from all non-bypass DSQs.
 		 */
-		if (unlikely(READ_ONCE(scx_aborting)) && dsq->id != SCX_DSQ_BYPASS)
+		if (unlikely(READ_ONCE(sch->aborting)) && dsq->id != SCX_DSQ_BYPASS)
 			break;
 
 		if (rq == task_rq) {
@@ -4659,7 +4658,6 @@ static void scx_root_disable(struct scx_sched *sch)
 
 	/* guarantee forward progress and wait for descendants to be disabled */
 	scx_bypass(true);
-	WRITE_ONCE(scx_aborting, false);
 	drain_descendants(sch);
 
 	switch (scx_set_enable_state(SCX_DISABLING)) {
@@ -4820,7 +4818,7 @@ static bool scx_claim_exit(struct scx_sched *sch, enum scx_exit_kind kind)
 	 * flag to break potential live-lock scenarios, ensuring we can
 	 * successfully reach scx_bypass().
 	 */
-	WRITE_ONCE(scx_aborting, true);
+	WRITE_ONCE(sch->aborting, true);
 
 	/*
 	 * Propagate exits to descendants immediately. Each has a dedicated
@@ -5458,8 +5456,6 @@ static s32 scx_root_enable(struct sched_ext_ops *ops, struct bpf_link *link)
 	 */
 	WARN_ON_ONCE(scx_set_enable_state(SCX_ENABLING) != SCX_DISABLED);
 	WARN_ON_ONCE(scx_root);
-	if (WARN_ON_ONCE(READ_ONCE(scx_aborting)))
-		WRITE_ONCE(scx_aborting, false);
 
 	atomic_long_set(&scx_nr_rejected, 0);
 
@@ -6692,7 +6688,7 @@ static bool scx_dsq_move(struct bpf_iter_scx_dsq_kern *kit,
 	 * If the BPF scheduler keeps calling this function repeatedly, it can
 	 * cause similar live-lock conditions as consume_dispatch_q().
 	 */
-	if (unlikely(READ_ONCE(scx_aborting)))
+	if (unlikely(READ_ONCE(sch->aborting)))
 		return false;
 
 	if (unlikely(!scx_task_on_sched(sch, p))) {
diff --git a/kernel/sched/ext_internal.h b/kernel/sched/ext_internal.h
index bd8619905ed1..96c8e75f2930 100644
--- a/kernel/sched/ext_internal.h
+++ b/kernel/sched/ext_internal.h
@@ -951,6 +951,7 @@ struct scx_sched {
 	struct scx_sched_pcpu __percpu *pcpu;
 
 	u64			slice_dfl;
+	bool			aborting;
 	s32			level;
 
 	/*
-- 
2.53.0

