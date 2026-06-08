Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE95637AA72
	for <cgroups@vger.kernel.org>; Mon,  8 Jun 2026 12:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780920961; cv=none; b=igCK1LBbs3u+501QrzbSkaWUSqTONkMgCyyX5McuxBlqZGJmLcELbDFcy/wLXOexDR5i+i7sUpxwdwAwfRfTtF/DXgd2VGxt8WFIHSMccT1QU9ZBBBfSh4HtsDeS7QSuY9Jq9OrKSxQnUAhwPvttwiuj/HfYQ3XQXApBFFAjaVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780920961; c=relaxed/simple;
	bh=92fhzTOKe1eWv26TwL8Usa1oTklYxybytl7/TzxxfVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9MQTv6rxgeAwGwGpWyVt+2X0oyeVY+EfCAMNeKTypSf1E96bBFedh3kVOlGCuGw8J6jsMwCPuIKMLOZ7VZGMUO0AMLSrkUGlnQc7WYuUuQSbm4Y3nrr53BAUgDe2gwGxjN2xwJhPpCim+xlMRwnU7MjxU+pQTSUsY+wPnOxTEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dcvmsug9; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dcvmsug9"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-490b613a17bso41334265e9.3
        for <cgroups@vger.kernel.org>; Mon, 08 Jun 2026 05:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780920956; x=1781525756; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wdaPQPUNpe7pv5r2Wo/aUtFcdIVNOnNCTBCujeA0Bao=;
        b=dcvmsug9oKr93W+xdd9AGH2ornVuZNFyEy00eHvQkZ2qUGAEeBXObPdqc/yidDuLwN
         cqSPnF78WNYhbFcEK74l7U0U4mpOz3zRvd/bKMwYYdHTLlPQyMh3VrWGaTERl2b3i+zq
         7kRB3NMKglszQbppIjqKNDO7niy22VDMxFsfWSA4ed9a6D802L+jkM6rz+8l83DHe3Pk
         2Gwk+guH2VMsLd5Aa+8QliuEBYRfZlabM50C+aMaleiA3GmTi1+O+vOxSsT2WfxLa+kW
         E6fTLVhohq2QR9imyDskb0YRHvHPK3xh1P+fgUsHwGZ2ER+KHX5Xzo7N/WWgNvGS6ZxM
         r6Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780920956; x=1781525756;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wdaPQPUNpe7pv5r2Wo/aUtFcdIVNOnNCTBCujeA0Bao=;
        b=GLZQOBuzLUeD7uXKWt+rCxl29+nQRE4sQUQvqeyZyjO5UJV3gID+ftPWIv9xikrLa5
         U1QD0yGqYWNGGz3d3GGOpJK9uSDhuYQ90XtBL0qFCuQ1g69hEIq2sQmsSfwYfmNrv5Pr
         eV5SwtF36JOB8l003uqy6kwEsuWK7riv5z3oCdcogPJo7i7eI1cWNk3Ob3Qw4SVBKQRc
         OYOENWjrAW4vzarooce3uOXuCOBOXMzAos1NJgelnZ9myvQbRTEnPhfAL8YhQNqJaC4i
         jarPKC7ftw5cTBvjO/0mNgXLkUlcUgYUrOR5tQugYqi/gmIg9F0YARfTsRDLE8Cls07v
         nQpg==
X-Gm-Message-State: AOJu0YxLmfMmQBvgH43RTk2winU8i1kz6alBEvFxIm/3haCO4dcspG3C
	y1ctL5Cc0bxWn2TlGB95d5OGafAk20gUUEHxRfkb7fI1AUMzITywyjN4
X-Gm-Gg: Acq92OGcYC7sCOie+1hTU6yLuVDvHK8pQ297LFnyURivi7qDawfppFDJT1m8P/+y6s1
	DiIo+koNl/DxbcaSeXBeK8jkbGivdXn1gX08GF8EUAxqjZ373SThRl8/ycMOAIYKVzFV5erLuSJ
	Bo/ExVTvy5/J6EMrZDFgn1iEO1m7HZYpiYIfU68vT/y6dNfItNR5nQVuc+DQrmapJcAgFIh+SPc
	GaUnRmMjLxiPJ7zhefO+pfAqH8T+6j10r4kaFYsp3ADHpDkfABhw02EuBxW8u4+anOq6VOhPxqp
	J2KipW3HkbQ8sGU990V8XmHi4DYOMqSHol4aumZ11xQd3EMOUF3FErjPvN7p0tqP2+w+KPSBHq4
	P5aPM9Z5moGKI6gvCiUjPQLQyc1I2fUahrWJpS9EqzdNv9M+pIidgdUDMEJxM1jhBdAVuIjglMy
	V0NU4QV5mMaObDBbz3jZuDn7/2stb5ZHE=
X-Received: by 2002:a05:600c:19d2:b0:490:47e3:929a with SMTP id 5b1f17b1804b1-490c25ada0dmr261074695e9.6.1780920956340;
        Mon, 08 Jun 2026 05:15:56 -0700 (PDT)
Received: from victus-lab ([193.205.81.5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2ec711sm50644906f8f.12.2026.06.08.05.15.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 05:15:55 -0700 (PDT)
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
Subject: [RFC PATCH v6 09/25] sched/rt: Introduce HCBS specific structs in task_group
Date: Mon,  8 Jun 2026 14:15:28 +0200
Message-ID: <20260608121546.69910-10-yurand2000@gmail.com>
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

Add an array of sched_dl_entity objects in task_group.

Create the dl_bandwidth struct and add a field for it in task_group.

Add a rq pointer field in struct rt_rq.

---

For each CPU on the host system, the task_group manages a sched_dl_entity and
a rt_rq object, which in turn keeps a pointer to its locally managed runqueue.
The sched_dl_entity object manages the deadline server which will be scheduled
for execution on the CPU, while the rt_rq object is instead used to reference
the local runqueue's specific data and entities and it is used when an actual
task must be scheduled when the CPU is given to the dl_server.

The dl_bandwidth object keeps track of the currently allocated bandwidth for
the cgroup and the currently active context. RT-cgroups can either run tasks
themselves or can delegate the scheduling of their tasks to their parent, the
active_context field keeps track of which cgroup is serving the tasks.

Co-developed-by: Alessio Balsini <a.balsini@sssup.it>
Signed-off-by: Alessio Balsini <a.balsini@sssup.it>
Co-developed-by: Andrea Parri <parri.andrea@gmail.com>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Co-developed-by: Yuri Andriaccio <yurand2000@gmail.com>
Signed-off-by: Yuri Andriaccio <yurand2000@gmail.com>
Signed-off-by: luca abeni <luca.abeni@santannapisa.it>
---
 kernel/sched/sched.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 3aa29fe932fc..f3c259ab9344 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -322,6 +322,15 @@ struct rt_bandwidth {
 	unsigned int		rt_period_active;
 };

+struct dl_bandwidth {
+	raw_spinlock_t		dl_runtime_lock;
+	u64			dl_runtime;
+	u64			dl_internal_runtime;
+	u64			dl_period;
+	struct task_group	*active_context;
+};
+
+
 static inline int dl_bandwidth_enabled(void)
 {
 	return sysctl_sched_rt_runtime >= 0;
@@ -495,10 +504,17 @@ struct task_group {
 #endif /* CONFIG_FAIR_GROUP_SCHED */

 #ifdef CONFIG_RT_GROUP_SCHED
+	/*
+	 * Each task group manages a different scheduling entity per CPU, i.e. a
+	 * different deadline server, and a runqueue per CPU. All the dl-servers
+	 * share the same dl_bandwidth object.
+	 */
 	struct sched_rt_entity	**rt_se;
+	struct sched_dl_entity	**dl_se;
 	struct rt_rq		**rt_rq;

 	struct rt_bandwidth	rt_bandwidth;
+	struct dl_bandwidth	dl_bandwidth;
 #endif

 	struct scx_task_group	scx;
@@ -861,6 +877,12 @@ struct rt_rq {
 #ifdef CONFIG_CGROUP_SCHED
 	struct task_group	*tg; /* this tg has "this" rt_rq on given CPU for runnable entities */
 #endif
+
+	/*
+	 * The cgroup's served runqueue if the rt_rq entity belongs to a cgroup,
+	 * otherwise the top-level global runqueue.
+	 */
+	struct rq		*rq;
 };

 static inline bool rt_rq_is_runnable(struct rt_rq *rt_rq)
--
2.54.0

