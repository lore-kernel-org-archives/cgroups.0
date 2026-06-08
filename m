Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB911372EF3
	for <cgroups@vger.kernel.org>; Mon,  8 Jun 2026 12:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780920960; cv=none; b=afs9gFM+OlISoXswCBYpgGxfF4+zB04oQzs1iNCwM75iTsd3T1zTn/mABjLNzRi53HmiTTxrmpq3x9eT4KAuWeVkSQFP+6K9P6b2mWYFL6Fj9Kbj8ULjPLcjidc3PbU3Qu5gIVqxSNWnH7S2mzl+nWZ35lxlKlDU+/CQHbfbHKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780920960; c=relaxed/simple;
	bh=iwi1n/GaegwIdKWm3vvM+QonyYzEKh7dlyHKXurUVmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNObBUT477oSydEe3x7Z8E+OTdWEixXXWXHHtdQb7Tgfi4AJECdqAco5xA4OuDalLRfCXaoSzwlfiU3QVsMynFzPIQAdhMKDa0KrvWwxcPdzd08OOnEC4mMJlpp+vEzgYo+76X3E8TeCmdFG8h3iaTGloYSWz+xC6+c72nrrvxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p0ny/cJQ; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p0ny/cJQ"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-46013161068so2052142f8f.2
        for <cgroups@vger.kernel.org>; Mon, 08 Jun 2026 05:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780920953; x=1781525753; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zPYebrpCD2c79LMO4tVw7qbstFYmvk0kD7UuVMMLoIY=;
        b=p0ny/cJQbGLhRDoz40lzMtdANYnsoGXKoj3LfwHcKUo9xRmFag80XK8dnW3KcYm8cS
         ZGEjCv/LUlRW5LSKs/+RDK2igqSdRuzq6G1++LOjOTaX5E0daa8bEgVDG85XX2hKARhm
         qTO15LxQuoAB+vQv3BoIb0LEy6WA7J5gx0pw0BwEKtrdBaK68D7vWXXgQeL5/AqKkdYq
         lq/wZbGjrmXFi5Lt64E7aWIIzChK6A3RGKrNtPCrPREby4omu58XKKqifXaqQzh2RaVh
         SL/L8tlq6qesXT4w7AXCZwzpq3jRKCkHYfz/d6EMcQi8hmKGc4AxInwSljrOYmAZ061d
         salA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780920953; x=1781525753;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zPYebrpCD2c79LMO4tVw7qbstFYmvk0kD7UuVMMLoIY=;
        b=MBIxEJr/E3m4sSKCyEp8eII//mKQMYpsqrCBL0VO/YGXPGjAxCAUWcerEP3wTHk9hx
         RrFniNPmxUYN/pLTYw8oGVt5ZCHF5LSIJUG8pwEgSSqT7x4TKux/fSYES1spo17sURbr
         Blwlfwqu/q2qonw3AovkNxDdD1ztfU1RXSlrzJee+XJdEvcoQqxqUzUGFjnsQzX28hEx
         CH+K/3hudcVhmsf5+3SdL2FRAgm2LAaUDTkGeTs/6d3WfZEAgzDoi7bql6LPb6UmJ7rU
         7DPYXoJoKeE5048hKcUaHguKeU9XO7zso4eOYdfK+jziXKeosidFtxKFFgICGzimnB1t
         I82g==
X-Gm-Message-State: AOJu0YwRvjMGUJ1D1tIHfTETKnbrKhAvryuevJbmasuce4t3Rjl+qBwq
	IA8h/rOT3yi+7HgkBl9mxHjt3rp/M5vZwun2OhCJjkmtnNOJhK8rTJKl
X-Gm-Gg: Acq92OFOwToW+ftYeR2/rP6RDjxOQZJF+Y/vvM+rL0YjrGXvWTD73wpgBWsJeElCMPK
	u8KM4U/22lZwUl29XKS11vuSq7Wg8zt4x8uT9ebquURy6JHMZ6drB9f795cAdSTQ3gLG0FIpnlq
	Z1tua230PEiMbPIcgNKIVuTCH9KPoLFD5TrMfAp9reIC/UTT0MyDwdp/CzEIOdVGydlCHUJLJ0m
	e+AP+AU8UCRAoRYSMfj4Y1nH8MD3VUAaK0pfekgVt3/iRggK6AvL8VkLdoxCq8cmfTAId68atXO
	VnWk3FyAQSy2G635XkEEc44iapMrFapR4HUDKAQiA/JSVds2md5Cp7V3n1uL+OYsYgNDWGZSzxW
	eBVllsXRrSDip3VIuUDtD5Vc13A/+vJwpseH0QhC2kMZPQ5QOsEid81RzquNjRkvMuUQ8RCV+E3
	ZSTlQ6N6gqxu2EVDwM6ufTuYql+BgKCvE=
X-Received: by 2002:a5d:53c6:0:b0:45e:f29d:d42d with SMTP id ffacd0b85a97d-46030632bdbmr17813458f8f.25.1780920953377;
        Mon, 08 Jun 2026 05:15:53 -0700 (PDT)
Received: from victus-lab ([193.205.81.5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2ec711sm50644906f8f.12.2026.06.08.05.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 05:15:52 -0700 (PDT)
From: Yuri Andriaccio <yurand2000@gmail.com>
To: Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luca Abeni <luca.abeni@santannapisa.it>,
	Yuri Andriaccio <yuri.andriaccio@santannapisa.it>
Subject: [RFC PATCH v6 06/25] sched/rt: Move functions from rt.c to sched.h
Date: Mon,  8 Jun 2026 14:15:25 +0200
Message-ID: <20260608121546.69910-7-yurand2000@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260608121546.69910-1-yurand2000@gmail.com>
References: <20260608121546.69910-1-yurand2000@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: luca abeni <luca.abeni@santannapisa.it>

Make the following functions/macros be non-static and move them in
sched.h, so that they can be also used in other source files:

- rt_entity_is_task()
- rt_task_of()
- rq_of_rt_rq()
- rt_rq_of_se()
- rq_of_rt_se()

There are no functional changes, apart from the use of container_of_const()
instead of container_of() where applicable. This is needed by future patches.

Signed-off-by: luca abeni <luca.abeni@santannapisa.it>
Signed-off-by: Yuri Andriaccio <yurand2000@gmail.com>
---
 kernel/sched/rt.c    | 56 ------------------------------------------
 kernel/sched/sched.h | 58 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 56 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 0f0d9c283bd4..fe5b58f8fc69 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -166,36 +166,6 @@ static void destroy_rt_bandwidth(struct rt_bandwidth *rt_b)
 	hrtimer_cancel(&rt_b->rt_period_timer);
 }
 
-#define rt_entity_is_task(rt_se) (!(rt_se)->my_q)
-
-static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
-{
-	WARN_ON_ONCE(!rt_entity_is_task(rt_se));
-
-	return container_of(rt_se, struct task_struct, rt);
-}
-
-static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
-{
-	/* Cannot fold with non-CONFIG_RT_GROUP_SCHED version, layout */
-	WARN_ON(!rt_group_sched_enabled() && rt_rq->tg != &root_task_group);
-	return rt_rq->rq;
-}
-
-static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
-{
-	WARN_ON(!rt_group_sched_enabled() && rt_se->rt_rq->tg != &root_task_group);
-	return rt_se->rt_rq;
-}
-
-static inline struct rq *rq_of_rt_se(struct sched_rt_entity *rt_se)
-{
-	struct rt_rq *rt_rq = rt_se->rt_rq;
-
-	WARN_ON(!rt_group_sched_enabled() && rt_rq->tg != &root_task_group);
-	return rt_rq->rq;
-}
-
 void unregister_rt_sched_group(struct task_group *tg)
 {
 	if (!rt_group_sched_enabled())
@@ -294,32 +264,6 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 
 #else /* !CONFIG_RT_GROUP_SCHED: */
 
-#define rt_entity_is_task(rt_se) (1)
-
-static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
-{
-	return container_of(rt_se, struct task_struct, rt);
-}
-
-static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
-{
-	return container_of(rt_rq, struct rq, rt);
-}
-
-static inline struct rq *rq_of_rt_se(struct sched_rt_entity *rt_se)
-{
-	struct task_struct *p = rt_task_of(rt_se);
-
-	return task_rq(p);
-}
-
-static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
-{
-	struct rq *rq = rq_of_rt_se(rt_se);
-
-	return &rq->rt;
-}
-
 void unregister_rt_sched_group(struct task_group *tg) { }
 
 void free_rt_sched_group(struct task_group *tg) { }
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 970386ce4dbf..a03866f68a3b 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -3332,6 +3332,64 @@ extern void set_rq_offline(struct rq *rq);
 
 extern bool sched_smp_initialized;
 
+#ifdef CONFIG_RT_GROUP_SCHED
+#define rt_entity_is_task(rt_se) (!(rt_se)->my_q)
+
+static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
+{
+	WARN_ON_ONCE(!rt_entity_is_task(rt_se));
+
+	return container_of_const(rt_se, struct task_struct, rt);
+}
+
+static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
+{
+	/* Cannot fold with non-CONFIG_RT_GROUP_SCHED version, layout */
+	WARN_ON(!rt_group_sched_enabled() && rt_rq->tg != &root_task_group);
+	return rt_rq->rq;
+}
+
+static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
+{
+	WARN_ON(!rt_group_sched_enabled() && rt_se->rt_rq->tg != &root_task_group);
+	return rt_se->rt_rq;
+}
+
+static inline struct rq *rq_of_rt_se(struct sched_rt_entity *rt_se)
+{
+	struct rt_rq *rt_rq = rt_se->rt_rq;
+
+	WARN_ON(!rt_group_sched_enabled() && rt_rq->tg != &root_task_group);
+	return rt_rq->rq;
+}
+#else
+#define rt_entity_is_task(rt_se) (1)
+
+static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
+{
+	return container_of_const(rt_se, struct task_struct, rt);
+}
+
+static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
+{
+	return container_of_const(rt_rq, struct rq, rt);
+}
+
+static inline struct rq *rq_of_rt_se(struct sched_rt_entity *rt_se)
+{
+	struct task_struct *p = rt_task_of(rt_se);
+
+	return task_rq(p);
+}
+
+static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
+{
+	struct rq *rq = rq_of_rt_se(rt_se);
+
+	return &rq->rt;
+}
+#endif
+
 DEFINE_LOCK_GUARD_2(double_rq_lock, struct rq,
 		    double_rq_lock(_T->lock, _T->lock2),
 		    double_rq_unlock(_T->lock, _T->lock2))
-- 
2.54.0

