Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794242208;
	b=cowv6r3xnL2ZcHeSTnPAi5Pj7EUN7KOckgKU9p7deZOwomNBpyYVufADzwvCxGscN9nf
	 A46ATai7zbZGE5mtsFcEczJUmD1/QYUTDUP/IolYrXydSXLZyJoHAuOI/gtemNqJj3Sjf
	 MYRK+7rSIX3G0WlFTvCfupwXz55/W2d4vsOaDxgqUWcSN+KMJXvzwVjLMpu9nRkJ5fOPr
	 bZERDk3m+L2WSbVNZp4u6fAgdgxm/Vt4+cuGKrtwLwSzJ3rzNA2CUa+PHNnMEcb40t5lJ
	 1hNcY1T/xEVUTD2TTVjC7QxZiXP8NxGACzx8wXVU6BYhM802bXDin90jnMO1rWSGbgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794242208;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=IrxSe2X7kKSSBjS8XEqbeR8ODZ6jh3UfBb1A6Bk+f+s=;
	b=ciHyhMY/mdZyfAnC6NaJsBnSBBgyMcZV+iiRfN8XJHPm/UspbAT4fQ/fybplXJTa/X3M
	 v/bycOOV+2IoO8INwVIVI969FX64vGSR4iozN62Cm2SqadR8xAC8Yg4ifLMNk9ZcaHcDh
	 /woz/n17lPSUdqSMLCy7WeL8VH+805aLyAYwHNzMtSxCQW2jcH3FpM0vnIvkQVugMahPg
	 PcrjtMrilS9JB7jBc344x1lew6/RRyhwJZFg/ZHl7pR4nEHq929+V7K1/oWdi99yPUmoN
	 +MBl1UWE8mJGCquUs90HuizRjpjNGl3n7RiFgXvutGo5FCX7QilzLVgNSlQPNFQ9GfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="OTPjwy/4";
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF8160A3834
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 16:36:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7CF8160A3834
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OTPjwy/4
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-492f563d1c6so406988f8f.3
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 08:36:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794242207; x=1794847007; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IrxSe2X7kKSSBjS8XEqbeR8ODZ6jh3UfBb1A6Bk+f+s=;
        b=OTPjwy/4ZIEoZabHK6C+fW1OzzN6bYy2RkFTx7Zde2BttWQFAxrH4h3IMMRVe3dPef
         CXAo2qQo/dIaGvFeRWrgM/I5Q2k4Y6ua7oBcBD0Xz6Hvu9rzn874J+jeRZKk7m+rgXIr
         zex3o1DxqbQecxo9fqFuzc+3oEGGTEF6K112lcr38CX3Bm1MRawaQzYaLKDlDyJqmwZe
         sTMipPirsj/+8rFmUkWH+N+MdNDBXx4CjUIDnhTcNAilreeYNWqwtpOKBggb2idEZlcv
         GBDF80JJycvwWIRGpN8SMIdbvTUZZkpVBTV2c5XFeI/A+mhE98Q/BgmoRAMdUnT/JYTl
         VBHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794242207; x=1794847007;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IrxSe2X7kKSSBjS8XEqbeR8ODZ6jh3UfBb1A6Bk+f+s=;
        b=KwpgRCy8zrRqVllNrL/LLSwNsQEQxDZm1nKSIA0VhXFkWhHCGXrryhAOgqwTmRxwqz
         gvKqgCBX3QV5L2yBSMHvPstnqSZ0Whu2Ay5uHBtIZrwnPBk/pxndXqjISEds5v6uJse8
         ogWybEWbJAz4i4KAyknMVdcOSluUr9IOK/HQECCl/6ioTUkSNfK31ZVnShsn/3AIKYmw
         4aOPqf+k4EhRj3RfcVNXK7nhJcon7xp3e6po7kPvsa03GOGILQc+6in8ozlyl1yM7HEw
         /2Y/Tf01+uMpDDJc78JDO/0v9GBFI0aLUFbDq95rIELD5lkpBKd8uY0iXu+NUTOt3u46
         nNkQ==
X-Gm-Message-State: APuU4Z+yulapuBYvuN4fuiiqF2J9QZONnywxSOBmYAYN+G4WU4F0+Y44
	OA0G0NQKHlXaySg7PAABgVWV3r/wmbVKKyQCtFRQ0Xahg7pbCaHg5IZE
X-Gm-Gg: AYBFou06copBNj9fU+bLbPBG4d+wXOJTjYpMuLqErFxe6cmwyFoKwlY4ICwACmpccng
	fpwcrUYQ0L54eLXwrCu3mBdEkGhLJSyIHMVSJPjtCXOXuSzojoud+lsc1xX7AJchC8q1ervqjHi
	vWlyDottldJFPneraOKwof/q+wAoZWdOHlco5sC/NTwFeroRGdDbUk71Qb5adMRwjn/9XhUkH/v
	04AhsrploLTM156n00hpv1d2ve/XJBkc9yFL9OGzFU4hJboVn52pQrK2HN4eT6D73TodeL6Av6U
	5GOYchnaESZqi8/b3t9ZqPpaw++1QSMDVURRVWJTCSYFmSje/ch6vOhKJZfrjoyJw7Hv7ege9LA
	1dF6lBSA82VI3fABv4WTBunwjm3CYeqPaOEiJR+rL8iqW1YIjCpCL6/Ft4VhcpeLL7WqeseSAbW
	sSYFXZz2F5WV1GHITBM+AEh4Sa0nLuBKCgB3ZaSx+VY0zn80ySHV8tnCNR9qN+1BQPeqirdZLse
	wdFkQLrd6C62NhmFYgZnBUBqHb4dl9RnIO8CoTraqGkl/qFQ05WhGquOS6wu3yh4qhYhl2S9p/H
	GqW7UR4gXKu/xyaHwgfN28WAcw==
X-Received: by 2002:a05:600c:1c02:b0:4a2:74f:46c1 with SMTP id 5b1f17b1804b1-4b9633cee71mr104324895e9.8.1794242206692;
        Mon, 09 Nov 2026 08:36:46 -0800 (PST)
Received: from victus-lab ([193.205.81.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b96cd012e1sm138851295e9.8.2026.11.09.08.36.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:36:45 -0800 (PST)
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
Subject: [RFC PATCH v7 15/29] sched/rt: Remove support for cgroups-v1
Date: Mon,  9 Nov 2026 17:36:01 +0100
Message-ID: <20261109163616.195264-16-yurand2000@gmail.com>
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

Disable control files for cgroups-v1.

Remove cpu_rt_group_init function and functions related to the
cgroup-v1 control files 'rt_runtime_us' and 'rt_period_us'.

Signed-off-by: Yuri Andriaccio <yurand2000@gmail.com>
---
 kernel/sched/core.c  | 50 --------------------------------------------
 kernel/sched/rt.c    | 49 +------------------------------------------
 kernel/sched/sched.h |  4 ----
 3 files changed, 1 insertion(+), 102 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0425d2c98240..20297c2123d2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -10185,32 +10185,6 @@ static int cpu_burst_write_u64(struct cgroup_subsys_state *css,
 }
 #endif /* CONFIG_GROUP_SCHED_BANDWIDTH */
 
-#ifdef CONFIG_RT_GROUP_SCHED
-static int cpu_rt_runtime_write(struct cgroup_subsys_state *css,
-				struct cftype *cft, s64 val)
-{
-	return sched_group_set_rt_runtime(css_tg(css), val);
-}
-
-static s64 cpu_rt_runtime_read(struct cgroup_subsys_state *css,
-			       struct cftype *cft)
-{
-	return sched_group_rt_runtime(css_tg(css));
-}
-
-static int cpu_rt_period_write_uint(struct cgroup_subsys_state *css,
-				    struct cftype *cftype, u64 rt_period_us)
-{
-	return sched_group_set_rt_period(css_tg(css), rt_period_us);
-}
-
-static u64 cpu_rt_period_read_uint(struct cgroup_subsys_state *css,
-				   struct cftype *cft)
-{
-	return sched_group_rt_period(css_tg(css));
-}
-#endif /* CONFIG_RT_GROUP_SCHED */
-
 #ifdef CONFIG_GROUP_SCHED_WEIGHT
 static s64 cpu_idle_read_s64(struct cgroup_subsys_state *css,
 			       struct cftype *cft)
@@ -10288,20 +10262,6 @@ static struct cftype cpu_legacy_files[] = {
 };
 
 #ifdef CONFIG_RT_GROUP_SCHED
-static struct cftype rt_group_files[] = {
-	{
-		.name = "rt_runtime_us",
-		.read_s64 = cpu_rt_runtime_read,
-		.write_s64 = cpu_rt_runtime_write,
-	},
-	{
-		.name = "rt_period_us",
-		.read_u64 = cpu_rt_period_read_uint,
-		.write_u64 = cpu_rt_period_write_uint,
-	},
-	{ }	/* Terminate */
-};
-
 # ifdef CONFIG_RT_GROUP_SCHED_DEFAULT_DISABLED
 DEFINE_STATIC_KEY_FALSE(rt_group_sched);
 # else
@@ -10324,16 +10284,6 @@ static int __init setup_rt_group_sched(char *str)
 	return 1;
 }
 __setup("rt_group_sched=", setup_rt_group_sched);
-
-static int __init cpu_rt_group_init(void)
-{
-	if (!rt_group_sched_enabled())
-		return 0;
-
-	WARN_ON(cgroup_add_legacy_cftypes(&cpu_cgrp_subsys, rt_group_files));
-	return 0;
-}
-subsys_initcall(cpu_rt_group_init);
 #endif /* CONFIG_RT_GROUP_SCHED */
 
 static int cpu_extra_stat_show(struct seq_file *sf,
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index b7ea6b5da9e4..1df87d25fda2 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1,3 +1,4 @@
+#pragma GCC diagnostic ignored "-Wunused-function"
 // SPDX-License-Identifier: GPL-2.0
 /*
  * Real-Time Scheduling Class (mapped to the SCHED_FIFO and SCHED_RR
@@ -2290,54 +2291,6 @@ static int tg_set_rt_bandwidth(struct task_group *tg,
 	return err;
 }
 
-int sched_group_set_rt_runtime(struct task_group *tg, long rt_runtime_us)
-{
-	u64 rt_runtime, rt_period;
-
-	rt_period = ktime_to_ns(tg->rt_bandwidth.rt_period);
-	rt_runtime = (u64)rt_runtime_us * NSEC_PER_USEC;
-	if (rt_runtime_us < 0)
-		rt_runtime = RUNTIME_INF;
-	else if ((u64)rt_runtime_us > U64_MAX / NSEC_PER_USEC)
-		return -EINVAL;
-
-	return tg_set_rt_bandwidth(tg, rt_period, rt_runtime);
-}
-
-long sched_group_rt_runtime(struct task_group *tg)
-{
-	u64 rt_runtime_us;
-
-	if (tg->rt_bandwidth.rt_runtime == RUNTIME_INF)
-		return -1;
-
-	rt_runtime_us = tg->rt_bandwidth.rt_runtime;
-	do_div(rt_runtime_us, NSEC_PER_USEC);
-	return rt_runtime_us;
-}
-
-int sched_group_set_rt_period(struct task_group *tg, u64 rt_period_us)
-{
-	u64 rt_runtime, rt_period;
-
-	if (rt_period_us > U64_MAX / NSEC_PER_USEC)
-		return -EINVAL;
-
-	rt_period = rt_period_us * NSEC_PER_USEC;
-	rt_runtime = tg->rt_bandwidth.rt_runtime;
-
-	return tg_set_rt_bandwidth(tg, rt_period, rt_runtime);
-}
-
-long sched_group_rt_period(struct task_group *tg)
-{
-	u64 rt_period_us;
-
-	rt_period_us = ktime_to_ns(tg->rt_bandwidth.rt_period);
-	do_div(rt_period_us, NSEC_PER_USEC);
-	return rt_period_us;
-}
-
 int sched_rt_can_attach(struct task_group *tg)
 {
 	/* Don't accept real-time tasks when there is no way for them to run */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ef11619cfc30..047d564e8f71 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -599,10 +599,6 @@ extern void start_cfs_bandwidth(struct cfs_bandwidth *cfs_b);
 extern void unthrottle_cfs_rq(struct cfs_rq *cfs_rq);
 extern bool cfs_task_bw_constrained(struct task_struct *p);
 
-extern int sched_group_set_rt_runtime(struct task_group *tg, long rt_runtime_us);
-extern int sched_group_set_rt_period(struct task_group *tg, u64 rt_period_us);
-extern long sched_group_rt_runtime(struct task_group *tg);
-extern long sched_group_rt_period(struct task_group *tg);
 extern int sched_rt_can_attach(struct task_group *tg);
 
 extern struct task_group *sched_create_group(struct task_group *parent);
-- 
2.56.0

