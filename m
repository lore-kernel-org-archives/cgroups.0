Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792434387;
	b=gFN27n15KkdkS62gH6vlO8ChqExJlPczWQ1pv9DIOTIIovTgo8mvmYZzqWJIkOkVZfAy
	 A5wYFo+W9lbSd2JmidHB6+hNGvUiowSHjYRGKj7GGjUL+CzTJl5So1j9yWt89kORT14Gw
	 6yA1Grs2Qn4dQRCjrOv5abA5vg18Gv/hnhmT7Zm6ZZf/tRJhaYCd0lcLXvn8QP6qCNP/P
	 YcBhZHEKIpRSO04jCjigOKcG9vtjHx6k1/1kaVVL5DGEPv9KqXST/lpNzg4KlVhjn8mfe
	 N2F3Dq/Ir98u8ouGMzasy5xKrPpQnxUJ1SWYA2QSMJoSm9lbMRweQNfo96expz5R0+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792434387;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=Nopl7OC6OC3jjxrSDWB4dphBmpfr7ikO8pphH6u9omA=;
	b=dIwYuLI/TaJeuBALQ8XgOCxxE8y8K8WPZR8sFnfKmvjEY4MtVrPrjcyqWgihiWwOJEmg
	 yHuE6l4/IOX4z3gco4KYet5de2NuI6TkdhxKu8u143Qmy4IXRmOhqi840UQjPuynpHTii
	 ELqBKDg1h5K34OTXoV/H3d2WrRwc/Vx4RU2udxN7QAVBrBTVkHVwhPTFDGsOs3/vQpGFq
	 ExYRxr88jTIqxoZtG6moAPuXUHaBQKCwhF25SwbNM7/ZpmbQ6cRFJAmQNpAvEtetjEP3d
	 nNMobu0c/oc/Kd9ivY6Pp9DP3mhPhqdxDN0JdfejygSJ9ozVmJxt7HCF8X4IVhMlyNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linaro.org;
	spf=pass smtp.mailfrom=linaro.org;
	dkim=pass header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=RBEUfkXM;
	arc=none smtp.remote-ip=209.85.221.43
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AEDC606A334
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 18:26:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4AEDC606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=RBEUfkXM
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48af4d4e61fso1479426f8f.2
        for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 11:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1792434385; x=1793039185; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Nopl7OC6OC3jjxrSDWB4dphBmpfr7ikO8pphH6u9omA=;
        b=RBEUfkXMCf4KYG/C82dHXL2TE5UAK+0pssxrCTGern0nBSQitNdTpuEI+b9P7taZW2
         uOFrqu5zlk/wgz9gsipwy5ekQKJ9ScMJO0winpKflAIQu8XkBP6fsH3OAMlOCgsADDhI
         PPj9otpx1fJRXAJe9lPrdbEgL2HLMjUCVS4YAf8PpWReePVnTqW9FwufRW4rnOMfR3gS
         zH95X3DNHEq9Fb6P0NhPGhajQ+K60B25k4usQSZtO/aExwY+bWTxYaouAfw2QkPpnb4U
         AlsbpU7TxnR9L/iOQVZ+Bt7hqhHCW17KHehUQ8x95fxrq/E2YBVVKt1M5GC5TrueIODX
         DxYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792434385; x=1793039185;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Nopl7OC6OC3jjxrSDWB4dphBmpfr7ikO8pphH6u9omA=;
        b=QEiSgybd80cIIRGbTOv1UH1fGFbT/wlJbLOwOVGuKa4i0fRXMEOvPgItKsMTtDX/6E
         Y+s2x6QsIfSO7wirQOiEbEZWfm3FWfSTZzPnRTBZt2C/NpmmvaBnpxWOtv1r57yoXTki
         UCTnnz+4PoCLRwnV+Zp7hUawBr9Euazt8KbUsgaumhscfcQQZ7wA5VqJPvCVp9nchRdT
         6fYxPNfrbGbXlc8IZeawEBtJ1DLM8cvNzTUaL43Z8eAEEOn6SOVJQPGnxUKCn0lunutL
         /V5AF5pMrQOBxTk3keJqUoyPlgQf2aGdLh9jdqdzTDsgXCvxup2Zbgur9PEm+xrl2PXt
         puAQ==
X-Forwarded-Encrypted: i=1; AKwUvBx8M6PVO6bGPR9grZzdx4ctHTR4eJF51/RlERwboI3fMzRO8YAZvyv5OKXv2LOJjdBqyxEju03v@vger.kernel.org
X-Gm-Message-State: AFq9FYIK3oxz0w4/Lc6IL0phCKYJitOXzMxpgbwWc8vtSVP8kjekrqGa
	146oA2ED4O1nW2fapztRG4BVIf3eSAcrUHLy2zlLKvmuBEaVr1VDx8Y6WSnNQkfbPKg=
X-Gm-Gg: AYBFou3/wBxWFxUrjzgkn5BcXliSC5IZgPsFqpRu0jnxkr8zf53S9Jt48w4imwi+FoU
	5oZ8PBWE0BODj2ukyB6voSAUXwJrDuZ37+Qj6yRaB8hoSngren5YqdsbSbiA0muhv6jOGz9VWl8
	Oecoeed9zCfhrrFjg/LT0nLKjb5GfM4wtWgPZx0V0qGe3Szkp/ReXmYkqBJELpphEuR841gLnKo
	NBfGqyEHeZrD2fwwT0tomlCRW4Dj5EMqMQ1M/mGKT6d7+7AezbHxeYJtxa9mP+Nl7M6hsAF/GTQ
	B0APr881p5FQSCeaoAsAW9fGWRrwXHUOdDWsTuB6RYCCV4AssOXntlKWJWjsNMbCYLux39BPRDS
	F3dHbQgDiZdkfXqUUfKfE1GZh3ds1/Y1oHYlalURHS/imqoEPhXqWVfTKnuyGiaryRabqpJJJkg
	JRiS6qq2XKjHyu2ef8BA5wMfpjOl+74jJSh/JtjfFSTlCdjBy6yHR2U4MlT9Nu3EJz1NZkKk0FL
	jVuUIrYjn1bPFc=
X-Received: by 2002:adf:f881:0:b0:48c:5cf9:88d6 with SMTP id ffacd0b85a97d-48e07bbe2f6mr12777929f8f.2.1792434385541;
        Mon, 19 Oct 2026 11:26:25 -0700 (PDT)
Received: from vingu-cube.home ([2a01:e0a:11f4:3020:aea:8007:d7bd:c2c7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e1d830e91sm520008f8f.54.2026.10.19.11.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 11:26:24 -0700 (PDT)
From: Vincent Guittot <vincent.guittot@linaro.org>
To: mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	linux-kernel@vger.kernel.org,
	jakub@okonski.org
Cc: longman@redhat.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	cgroups@vger.kernel.org,
	jstultz@google.com,
	qyousef@layalina.io,
	Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v2] sched/eevdf: Fix sched idle task group preemption
Date: Mon, 19 Oct 2026 20:26:22 +0200
Message-ID: <20261019182622.1584454-1-vincent.guittot@linaro.org>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Even with flat hierarchy which puts all runnable tasks in the same cfs rq,
we need to parse the hierarchy to check for sched_idle task group.

Reported-by: Jakub Okoński <jakub@okonski.org>
Link: https://lore.kernel.org/all/58dc8e8a-7260-43ce-aebb-8d9c29a6afc9@okonski.org/
Fixes: 85570f10a4c6 ("sched/eevdf: Move to a single runqueue")
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---

Changes since v1:
- fix prototype and cleanup unsued variable

 kernel/sched/fair.c | 82 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 69 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0f2364479f9d..27ce3eb467a0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -433,6 +433,38 @@ static inline struct sched_entity *parent_entity(const struct sched_entity *se)
 	return se->parent;
 }
 
+static void
+find_matching_se(struct sched_entity **se, struct sched_entity **pse)
+{
+	int se_depth, pse_depth;
+
+	/*
+	 * preemption test can be made between sibling entities who are in the
+	 * same cfs_rq i.e who have a common parent. Walk up the hierarchy of
+	 * both tasks until we find their ancestors who are siblings of common
+	 * parent.
+	 */
+
+	/* First walk up until both entities are at same depth */
+	se_depth = (*se)->depth;
+	pse_depth = (*pse)->depth;
+
+	while (se_depth > pse_depth) {
+		se_depth--;
+		*se = parent_entity(*se);
+	}
+
+	while (pse_depth > se_depth) {
+		pse_depth--;
+		*pse = parent_entity(*pse);
+	}
+
+	while (!is_same_group(*se, *pse)) {
+		*se = parent_entity(*se);
+		*pse = parent_entity(*pse);
+	}
+}
+
 static int tg_is_idle(struct task_group *tg)
 {
 	return tg->idle > 0;
@@ -476,6 +508,11 @@ static inline struct sched_entity *parent_entity(struct sched_entity *se)
 	return NULL;
 }
 
+static inline void
+find_matching_se(struct sched_entity **se, struct sched_entity **pse)
+{
+}
+
 static inline int tg_is_idle(struct task_group *tg)
 {
 	return 0;
@@ -10129,7 +10166,35 @@ preempt_sync(struct rq *rq, int wake_flags,
 }
 
 /*
- * Preempt the current task with a newly woken task if needed:
+ * Preempt an idle entity in favor of a non-idle entity (and don't preempt
+ * in the inverse case).
+ */
+static inline enum preempt_wakeup_action
+wakeup_preempt_sched_idle(struct sched_entity *cse, struct sched_entity *pse)
+{
+	int cse_is_idle, pse_is_idle;
+
+	find_matching_se(&cse, &pse);
+	WARN_ON_ONCE(!pse);
+
+	cse_is_idle = se_is_idle(cse);
+	pse_is_idle = se_is_idle(pse);
+
+	/*
+	 * Preempt an idle entity in favor of a non-idle entity (and don't preempt
+	 * in the inverse case).
+	 */
+	if (cse_is_idle && !pse_is_idle)
+		return PREEMPT_WAKEUP_RESCHED;
+
+	if (cse_is_idle != pse_is_idle)
+		return PREEMPT_WAKEUP_NONE;
+
+	return PREEMPT_WAKEUP_PICK;
+}
+
+/*
+ * Preempt the current task with a newly woken task if needed.
  */
 static void wakeup_preempt_fair(struct rq *rq, struct task_struct *p, int wake_flags)
 {
@@ -10137,7 +10202,6 @@ static void wakeup_preempt_fair(struct rq *rq, struct task_struct *p, int wake_f
 	struct task_struct *donor = rq->donor;
 	struct sched_entity *nse, *se = &donor->se, *pse = &p->se;
 	struct cfs_rq *cfs_rq = &rq->cfs;
-	int cse_is_idle, pse_is_idle;
 
 	/*
 	 * XXX Getting preempted by higher class, try and find idle CPU?
@@ -10174,22 +10238,14 @@ static void wakeup_preempt_fair(struct rq *rq, struct task_struct *p, int wake_f
 	if (!sched_feat(WAKEUP_PREEMPTION))
 		return;
 
-	WARN_ON_ONCE(!pse);
-
-	cse_is_idle = se_is_idle(se);
-	pse_is_idle = se_is_idle(pse);
+	preempt_action = wakeup_preempt_sched_idle(se, pse);
 
-	nse = se;
-	/*
-	 * Preempt an idle entity in favor of a non-idle entity (and don't preempt
-	 * in the inverse case).
-	 */
-	if (cse_is_idle && !pse_is_idle)
+	if (preempt_action == PREEMPT_WAKEUP_RESCHED)
 		goto preempt;
 
 	update_curr_fair(rq);
 
-	if (cse_is_idle != pse_is_idle)
+	if (preempt_action == PREEMPT_WAKEUP_NONE)
 		goto update;
 
 	/*
-- 
2.53.0

