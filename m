Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794242223;
	b=g9joS+E62D64SxtJpbbCD/OF4uLDBbeR55Qeg4HDf0OpocF+Bh69Gh0hFdtDpuTUGBUR
	 1XIjfKt/Zqw7BMPaanfMvYgaZZF83Z23W8BMZpdueHmeb0AECikYebDbVMMAwWcvlJnK8
	 SBk3V3I61yOeTgBuWzio9Q5/UqNFHYlEeX/b1S7E2bGUaao8MNPnN4RfgGsV61dZN8Yv8
	 QdrPR+IMznsVS8TleEpkPE1u9qnCPYoACBOdeeBJfqzuyl8hxB21papjjOB3WCxOG9KwX
	 pdzB8MeiUPJhRj0SGv2aZ2TBSmit3iWlz9hWwoq2/jN+syz0YV7zLIEj7hvtKHz/UuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794242223;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=p6J5hm0GOFDibiRim/ZqD/ZmyMUOkw5F47dVQ1P/Hd4=;
	b=wjGXYdmgboe5IYOjxA5YxgiWilqQUcOFtPsA6VuvktopWUszoKKTLmUyTSvut9non9cF
	 NtM7HqkjoZmG6nEQhMT2wYQfM6XJ8A5gmSvMb8BlxdO9j+Rx3wvrnuAy/c1tke8yubRXY
	 TB1wjgOFIsEdJfdzLzOJrZofvunUkSisEaj0aLgUO6aeuT5rCFaeuTt/V6UCRJePCtexK
	 jLSRY67wMqUyTCHbGq7jppVi/3ROOEhapf5I4KI/gXUgVepkh385U6FCsHPYPnMd0pgOx
	 P+WDdLJF/sTs8tekqqpW23yLKzmW5mf/SS7jyKm4wc7yprKgos9mkpS8wXMoOIjG42w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=peGi2MI9;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F405C606A875
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 16:37:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F405C606A875
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=peGi2MI9
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a4d7ae1ae9so9994395e9.1
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 08:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794242221; x=1794847021; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p6J5hm0GOFDibiRim/ZqD/ZmyMUOkw5F47dVQ1P/Hd4=;
        b=peGi2MI92KN4hlNnaw2LL/jjXg5j7/GW/imFPOlRCArxymPODdI42tAYTn20EkmIAq
         05FVqW9/PM6xVXSrhMHvsbrEZ5uBFrtmUbMmAu+73JP4JCX1ywBFTk/pEXbaIQOabmFH
         mTnps61a1iv11CbdwwepkdkA7C1sM58S53PSSJJvPHoYP56ZvzU02ooZHk5OVvbYl6j2
         NoQ6qoQgmW27xUxk4jJBfdIOQamXx3+hbFvmNrxIl6MA5sbwS9YWuYHPBcJA1rFuOEPE
         GFbpmW8JcFCMcQKJaievKASw1Ig4BikluJemgG+h5aEAGjTAOq/TrXEw6qfbvPBSDuET
         Rd4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794242221; x=1794847021;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=p6J5hm0GOFDibiRim/ZqD/ZmyMUOkw5F47dVQ1P/Hd4=;
        b=DajTNrhRWBXxW1mTy3i2Dt5d9f6A8HG3r35DWLs0ZuwecJ+X0XD/SsHvfDKylJhGy6
         SykD8n/je/QXYWasoyTf+s3hDO3meo/Xjtl+KDTMIER8+wCZ9X9y8PO0TnDYAUGKKnqE
         4SG+iWPg5XqvDDBoS+N1zzHqd4RFPHdgAsYMu89OtgkAcoweylBtcqIEAZOPo9/MMAhS
         s2X7DaWoinwVWfoATBxoBcm6P/cOyQFQUHD4nNYLEqHdF4b7Ie/yid7tlQ47bA5RXFMl
         06/2S1YBmRoUZRtKOHTC1jNEtiX62R6RMzIUH1w0Q3YLFVvH2Bqn6tlv2C5b0slpf02P
         zWkA==
X-Gm-Message-State: APuU4Z8sSfclGO/x06oSRkVioHlRCByylsdp9CqkQOMKOrONcMgumT9j
	S2bgfkPEbQG+/agfIYbe/HWL8DC9AX/+2pcEyszKatoBs/pcDQJofKL5
X-Gm-Gg: AYBFou3cmqXuMrjCB7y66jFZsFsFnFgpalXE29752xjkftxoZyO5I1uUkr89z1tsdXW
	MVt/Q9L5Tc3ybi6vGBvFRQGwGcAs6xr/kPR8fMFQFgn7HPKd5V5XKEp/XOIjJkf4695sKRHv3zh
	mVP13GFY7QbYr28Dv3hJe5yOh3a0v8kzTip4pbYUJpVdBVU4q2h2LC/CsjZqUQu0AL/xT5gsxf8
	aWyKgp2Dwr6MfpeDg6zNiLdWIS5zqilJoDZ0ZHm9/Yr6PytC8VDOdf87gKVjw8jsytzcG0plHOn
	6SGoJIgNBoQE4dUvYLirxW3c3S8+OTHyrhtIqWOkkg9OwdI0LanFvaS0QhZruBwH5m2ERlrS3oJ
	zsxe+3nXHoDT0/wp5B4FOrthlGXJo0Dy0CR/SEHA83D8l6Y6sU14mtoUiv3yErVVHUzHQg/0/lf
	83FRVUtpHB773HeRgBqaDmJ0ZRtF1jVL7lGt5JC8XtJpRvBwJc+OMBsS1cBG6jHNXpdCvKrUT64
	i3atMqYR+0+RHBqC0Q7HWG110prpWlplJbDGC0mc63zJe3g8gpXCQnwSZT96pGf3f8B2mFxg4UH
	q3oXoKd3z5Nkls25+2DzewowSPMBGYDk
X-Received: by 2002:a05:600c:314a:b0:4a5:26b8:4507 with SMTP id 5b1f17b1804b1-4b963c74205mr89464595e9.21.1794242221357;
        Mon, 09 Nov 2026 08:37:01 -0800 (PST)
Received: from victus-lab ([193.205.81.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b96cd012e1sm138851295e9.8.2026.11.09.08.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:37:00 -0800 (PST)
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
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luca Abeni <luca.abeni@santannapisa.it>,
	Yuri Andriaccio <yuri.andriaccio@santannapisa.it>
Subject: [RFC PATCH v7 25/29] sched/rt: Enable HRTICK_DL for HCBS servers.
Date: Mon,  9 Nov 2026 17:36:11 +0100
Message-ID: <20261109163616.195264-26-yurand2000@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261109163616.195264-1-yurand2000@gmail.com>
References: <20261109163616.195264-1-yurand2000@gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If HRTICK_DL is enabled, start hrtick timers whenever a rt-task that is served
by a rt-cgroup is ticked or enqueued for execution.

Signed-off-by: Yuri Andriaccio <yurand2000@gmail.com>
---
 kernel/sched/deadline.c | 13 +++++++++++--
 kernel/sched/rt.c       | 30 ++++++++++++++++++++++++++++++
 kernel/sched/sched.h    |  1 +
 3 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 219493427e0b..6220d793ae91 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2841,10 +2841,20 @@ static void start_hrtick_dl(struct rq *rq, struct sched_dl_entity *dl_se)
 {
 	hrtick_start(rq, dl_se->runtime);
 }
+
+int dl_can_start_hrtick(struct rq *rq, struct sched_dl_entity *dl_se)
+{
+	return dl_se->runtime > 0 && is_leftmost(dl_se, &rq->dl);
+}
 #else /* !CONFIG_SCHED_HRTICK: */
 static void start_hrtick_dl(struct rq *rq, struct sched_dl_entity *dl_se)
 {
 }
+
+int dl_can_start_hrtick(struct rq *rq, struct sched_dl_entity *dl_se)
+{
+	return 0;
+}
 #endif /* !CONFIG_SCHED_HRTICK */
 
 /*
@@ -2975,8 +2985,7 @@ static void task_tick_dl(struct rq *rq, struct task_struct *p, int queued)
 	 * not being the leftmost task anymore. In that case NEED_RESCHED will
 	 * be set and schedule() will start a new hrtick for the next task.
 	 */
-	if (hrtick_enabled_dl(rq) && queued && p->dl.runtime > 0 &&
-	    is_leftmost(&p->dl, &rq->dl))
+	if (hrtick_enabled_dl(rq) && queued && dl_can_start_hrtick(rq, &p->dl))
 		start_hrtick_dl(rq, &p->dl);
 }
 
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 839977b05d53..fffb6ec30e68 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1231,6 +1231,17 @@ static void wakeup_preempt_rt(struct rq *rq, struct task_struct *p, int flags)
 		check_preempt_equal_prio(rq, p);
 }
 
+#ifdef CONFIG_SCHED_HRTICK
+static void start_hrtick_rt(struct rq *rq, struct sched_dl_entity *dl_se)
+{
+	hrtick_start(rq, dl_se->runtime);
+}
+#else /* !CONFIG_SCHED_HRTICK: */
+static void start_hrtick_dl(struct rq *rq, struct sched_dl_entity *dl_se)
+{
+}
+#endif /* !CONFIG_SCHED_HRTICK */
+
 static inline void set_next_task_rt(struct rq *rq, struct task_struct *p, enum snt_e type)
 {
 	struct sched_rt_entity *rt_se = &p->rt;
@@ -1258,6 +1269,12 @@ static inline void set_next_task_rt(struct rq *rq, struct task_struct *p, enum s
 		update_rt_rq_load_avg(rq_clock_pelt(rq), rq, 0);
 
 	rt_queue_push_tasks(rt_rq);
+
+	if (!is_dl_group(rt_rq))
+		return;
+
+	if (hrtick_enabled_dl(rq))
+		start_hrtick_rt(rq, dl_group_of(rt_rq));
 }
 
 static struct sched_rt_entity *pick_next_rt_entity(struct rt_rq *rt_rq)
@@ -2254,6 +2271,8 @@ static inline void watchdog(struct rq *rq, struct task_struct *p) { }
 static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
 {
 	struct sched_rt_entity *rt_se = &p->rt;
+	struct sched_dl_entity *dl_se;
+	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
 
 	update_curr_rt(rq);
 	update_rt_rq_load_avg(rq_clock_pelt(rq), rq, 1);
@@ -2281,6 +2300,17 @@ static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
 		resched_curr(rq);
 		return;
 	}
+
+	if (!is_dl_group(rt_rq))
+		return;
+
+	/*
+	 * update_curr_rt() might have resulted our dl_server to not be anymore
+	 * the leftmost deadline entity, similarly to task_tick_dl.
+	 */
+	dl_se = dl_group_of(rt_rq);
+	if (hrtick_enabled_dl(rq) && queued && dl_can_start_hrtick(rq, dl_se))
+		start_hrtick_rt(rq, dl_se);
 }
 
 static unsigned int get_rr_interval_rt(struct rq *rq, struct task_struct *task)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 835af319b78d..323befba5609 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -356,6 +356,7 @@ extern bool dl_param_changed(struct task_struct *p, const struct sched_attr *att
 extern int  dl_cpuset_cpumask_can_shrink(const struct cpumask *cur, const struct cpumask *trial);
 extern int  dl_bw_deactivate(int cpu);
 extern s64 dl_scaled_delta_exec(struct rq *rq, struct sched_dl_entity *dl_se, s64 delta_exec);
+extern int  dl_can_start_hrtick(struct rq *rq, struct sched_dl_entity *dl_se);
 /*
  * SCHED_DEADLINE supports servers (nested scheduling) with the following
  * interface:
-- 
2.56.0

