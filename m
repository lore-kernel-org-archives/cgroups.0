Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792433777;
	b=Dhw7uvIXy5WLuM5lEF6/Vy9VM9w+0P5dza5DAUmfXSDaJ82T2kMRbZZP0QhpAsjb9lLh
	 49ofQHRDdD60Otc9+ka6Ze91zjpTYOUa2GOGOO7HQv2Yvjj5qPm0mRKZAkpbcUJCOBVIt
	 o1NdiepU/H5cBVITLV8LnpOVDoleXUd4+GcL/j2MIg4QbGALLSmX6nS0Jgi8r7sUeq5u6
	 pK+44NijSfzNtdyRRz15G3clNux8oh/g1RMxwgHd5Zm1Bes2aeUEZxSE5moWy0x6NvUoM
	 GXf5lgTE0XHYbLeLRKbyTooq09WYZdmjcPFdWV9h/gUrKaRzSwDGPdPXyeXUt4dgk+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792433777;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=O0/TE8eMqHolOOyHMRR0hwR2h8un8krdiW92QaauaW4=;
	b=jC2mX3PplWP7qUbMR9xgP9VKcqI4wvUFuqbh6U/WLaGY3AXmOj0M3Oh5W567hy3sYy0o
	 VCcfPwm49p0/OPlWtREAdVlIhqNmk8mHTve4oUW4JaUN0N8x81Paq7OG4IUkjQ3tlYc20
	 QW4UWx8eU2kZedWEIebHa7pysWnAuR9CRW7CXJCdiYX9KH0XWkh3PoX6qkoqdbkQz93mM
	 eQLUgDBmUpqBF8MrsK9QyFnbSBAyIeNaTiIfpKoHaGjC4X2mYrez5EDmrq0VgaQX6Kzyk
	 7GY+Kx1uW3IvuTWjwHpm/+l771IDoWq0dyYhSxslcP+Rl0jrRwsjKXxybMxgx0GQstQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linaro.org;
	spf=pass smtp.mailfrom=linaro.org;
	dkim=pass header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=P15o8bhX;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5743606A32E
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 18:16:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5743606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=P15o8bhX
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a1ddc7c9beso11121895e9.1
        for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 11:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1792433775; x=1793038575; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O0/TE8eMqHolOOyHMRR0hwR2h8un8krdiW92QaauaW4=;
        b=P15o8bhXD4fPfV9e2fC6vwKj/u9yl33N9jQBVq19hy7lOtzsmmrE0D0d9WvRm30g4U
         vm+ECkG0c/IjwrYJTa34UaPEVAzlJU2dgfrjlytZQluoWrzIPZW9NNkQBHc7pcoa/wfz
         kp48qjd+08KE7Y0P64BBu9GPRRd7DmjV7U0VekgjFAEMsRAMwEQf2qgApuhsaGNQQmyN
         NoE1wQb+OIMT5OZIX0j9ekCoUTvHeYTWMlGQaVmboKoZ3MI6oF3c8lE6+ZhY0764l5vQ
         jMFK6fidrFhwkGT/EmhTLfe62z64j8EA0iB0QLkkZ8tjeZv3w8w7wQ37LTWJAJHARFl8
         Z13Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792433775; x=1793038575;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=O0/TE8eMqHolOOyHMRR0hwR2h8un8krdiW92QaauaW4=;
        b=MTjL8GzIi8PO5J5hFgiBtHvu0xhsGIrmu0Te1URfZIHQtqwaUZaYN0w9kLTm8L6E5Q
         y9HkMRq3tI3z9r4lR5O6a1R0Vqr9XMrSbygEp6aFgXnhD/PvK0pbSEdsRiv/FavV3myE
         I5zJDi5jZ+grTAfjB2Xj8UQJbgbRJacby62cpD/1SnmVvqlL2nHewnX5EFgSQrtgQjBd
         wAse6e7+mCpkTbUQOUUzTivb5JxrMWhOJge1VnibEPlw/BVSx4uCbOsLgSPSpqIinUxZ
         vmiDLhoZkvmNEB+/10I0ru3HDzK/lHgbPYJ44o3r1Vmm0cBISKWoDyxbLeugxCbgKa7D
         oasg==
X-Forwarded-Encrypted: i=1; AKwUvBxo7RwJ5yv2u29X0KKlRDKfXUgCJY9OQYnNBrSeHb17h1EGCHf76qIjpJT43SjeS6QKztQPod4Q@vger.kernel.org
X-Gm-Message-State: AFq9FYKm6BpOr3ynTcD2xGUsgqaXMdS8eII1sOAW/HWC6is/1Tp0LnFd
	eEmppDr7OBED2nuv4zimQwMdNzOfvs3gaUTL0CdMnLEUON8H7slsEFvC/Uny/El0HsE=
X-Gm-Gg: AYBFou2pi0hwYJBDjZjyfGpkMgSdGNZMv3r9y9BAeZDo28S5IHbuGzJQMFqsFOMw8p8
	flVGijcRW0EJwyW3cdjuhVWGVXXQH+0csELL5KRi8cbdWKoLMOR0RhtvVBb3/Hv2U/PMOfVRWap
	d4dRZAP4oo4xavDLfQG00t4CnwgmSPMYxLjG6t0Z+1znNyTSCBENu8C3LG5rd2ZwCAtLV9gM7rO
	J4Rh9KJrU9IOo/3n0iJyskNMpzw/Q/njC1WLcLUcgWHQvufb6gCVqYfQJB9oMzRPuRDKM0u+R33
	RFtdiWN6LMPY0EgH9C4D1bO/3nYwDlnyhAxabjkGigpuUNWU4Zo4m/Hu4qnZm9tybgwCt0RE3+C
	j33YgovloCLmC51Df7/B3/74jaqtVBQ8PJwvqFu/gykiUcZaKOM/5mA/aZSEnvDA8Pk3MxK5c3G
	8l/+mr+C6WxbMw9O3ZCaptVZLFy9KoE2W2cogJ6i+kHZVYQ7OA4k16zaJv+VCoF8PxDNIqhfZhi
	R6TkWhGqDPSsyc=
X-Received: by 2002:a05:600c:c0c7:b0:4a1:d743:77f1 with SMTP id 5b1f17b1804b1-4a1d7bc2e33mr120421865e9.24.1792433775118;
        Mon, 19 Oct 2026 11:16:15 -0700 (PDT)
Received: from vingu-cube.home ([2a01:e0a:11f4:3020:aea:8007:d7bd:c2c7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1f2cb8d5csm10596675e9.6.2026.10.19.11.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 11:16:14 -0700 (PDT)
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
Subject: [PATCH] sched/eevdf: Fix sched idle task group preemption
Date: Mon, 19 Oct 2026 20:16:11 +0200
Message-ID: <20261019181611.1461433-1-vincent.guittot@linaro.org>
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
 kernel/sched/fair.c | 81 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 69 insertions(+), 12 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0f2364479f9d..20c33d13a5e7 100644
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
+static inline preempt_wakeup_action
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
@@ -10174,22 +10239,14 @@ static void wakeup_preempt_fair(struct rq *rq, struct task_struct *p, int wake_f
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

