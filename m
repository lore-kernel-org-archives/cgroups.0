Received: from mail-dy2-f43.google.com (mail-dy2-f43.google.com [74.125.229.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DA639E9DD
	for <cgroups@vger.kernel.org>; Fri,  2 Oct 2026 13:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790946649; cv=none; b=mXb6vSlxCAbbfHbEse2B+yclDKJfukunmHeERnn5A1Tums+GdPKcu0DM+MG9JgrB3Xq8tPmgZwB35Gcl9nbrwjd7vmRWtS2aXIR/2lpgWkVxy6m67/kJm8p34KtnSFzUg/3/Ku1n4VP4KRRvMx24nqGkpqcbUPY68IqkoQhk1Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790946649; c=relaxed/simple;
	bh=VYu2s7V7tuI3j4DSs+/I3dDcWFXXgIVo+r3pYJ3vuXo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VrwwSM0Fq46/AYWtov4mVyw6aXn3//Ut2ulizj4XzaP4uIIAWPz55mDsZ+G84H1eYJZG8D3LXEN2Fj1ZpVBLeYsVIdOYWBAgNX8s69WNik97fH3/Svm8mvE7dmnLJUQKIm7G53Qtkhy53Bjzd44YFEbEaoRrtByYeBh2qEeKZmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KmHO+Lpp; arc=none smtp.client-ip=74.125.229.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KmHO+Lpp"
Received: by mail-dy2-f43.google.com with SMTP id 5a478bee46e88-340f56c44b0so3276432eec.1
        for <cgroups@vger.kernel.org>; Fri, 02 Oct 2026 06:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790946644; x=1791551444; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H/ZMPlbFfkEDnolicQDHcuBaOmTguhoV9ZPfz4BueHg=;
        b=KmHO+LppA/IBFpzoU30tXzxl8WGYOHuCKfRadJbyBZaWtO0ciJCN668GRwzRy+Uiw4
         f4I/OHDJObdcTgpZ1OYgEZ4j8WV4SLPQRPdPApNpFAUJKoHa+LhalgFBLUwNjkULY8bR
         /FR5gsnHJAFisrdAq+Xk8RxJSd7iP++xfnSSNJPAwXw/8hURB3vRagDwe9ajz4hr0sxA
         psMMTSHTCXzm07+hjD4f73Y9G/f7BU3pzV+sx58lQt61v3ov/R/xICkNnn/brFqYmjGu
         M1tWeV5DCRMNhDXLKvQ7iX/jekGZAlrMr4ejq2jjnCcdnD6IVAjcLtNR8axJkWSAH/j8
         ilZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790946644; x=1791551444;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H/ZMPlbFfkEDnolicQDHcuBaOmTguhoV9ZPfz4BueHg=;
        b=a55WGMY2ukOouSAVd1NPOlsMo03pYldUuOXqwUtVx3T22pFdjdZfkKCOgGhsJWQf60
         9EOIcjt4m3rJ0kz8dqo0tCg5WC2iM99r08vBB4u2cFgpDS4PAqVay2ke5rlxg/N1usdo
         oiiw1jA/7lNBVryXeqFQ+BJzAImTAd86JiVbHHHFQeCLCFzbWZ11sA6ncGN4aPTUE+Pp
         N5EuxAhAM4hZrqr5xr6FmP9DAbBNX2StUZU5YrX2EXN7/v+mEE2IIsoNQzxdudWQ2ing
         ndSbWtV8dienG5Ro9Wyj65QqXE12PDzhO8pP91iHQswjrsZoS3khF0HlCqGxg5zZXtd2
         wrHw==
X-Forwarded-Encrypted: i=1; AKwUvBxk0QqgTIBBas//ACJkm/6IQG5rzGoJqd4inymMOP0NSUV0g8q1nYX8QJ9hpIc98DMH+O/jUsge@vger.kernel.org
X-Gm-Message-State: AFq9FYJZW44xNU4uDCsOfNGaiTV6x2JGVcE7cFam4Yu7NVhJTkDNKxqR
	5zW5AR/hpHTYeYxCPT8COrSaxL8qS+TCGWj3n7BoyAz6QHTxhblq3Eri
X-Gm-Gg: AYBFou1Si6JiDs1obM2J78roYV7oxNqqIirdAd+PWeOLyb6Q0QESGPP6LE1CYXlJzWM
	1r6JYoVFTKKlLmXNUYbt98WG7qjKNIczLizwHXebqLRvgkIu2rblpdol5m6SYHTGMiQ/VmddpPE
	yEIgUDDUr0Of9Tx0+0WqYPnE3D1aYGiuo6TKF0xgClRMSh+0FIKkMOLr9gAQrr3z9rpzBYObBAv
	RQR/nbIIXcFRvRQPvj0Wwwn0KefzRK5fDJ0h+ZhRBaAPUsZnGeU5OJDSarqKPB1MiuHIx65odod
	AOBfwk/hPKfwJEbexFEVr7IM9WyN4lafF1/x40IrqUGQktPFxM+B1xOl3elH8NiFvehVKqpN5C8
	x9vwOOCT8r3tjjCRKHQKeXHXqenmSh81gRZq2rqdFV094Es88fBs41yMaQwHNfhCdyWH664AhKA
	jC2pvA8BVdDPTKplQcbk3iZyEtLE3uveXVaN0uHIFvePw46U+i5T7vyk1RUQZYmhk0EQ==
X-Received: by 2002:a05:7300:3f11:b0:346:7c2c:1d25 with SMTP id 5a478bee46e88-34f219c110amr3175792eec.41.1790946639090;
        Fri, 02 Oct 2026 06:10:39 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34f0672c739sm7309347eec.3.2026.10.02.06.10.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 06:10:38 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Fri, 02 Oct 2026 21:10:21 +0800
Subject: [PATCH v5 01/12] sched/isolation: Enforce nohz_full as a subset of
 isolcpus=domain at boot
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261002-wujing-dhm-v5-1-78a6996d87ad@gmail.com>
References: <20261002-wujing-dhm-v5-0-78a6996d87ad@gmail.com>
In-Reply-To: <20261002-wujing-dhm-v5-0-78a6996d87ad@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
 Joel Fernandes <joelagnelf@nvidia.com>, 
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, Tejun Heo <tj@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@kernel.org>
Cc: Waiman Long <longman@redhat.com>, linux-kernel@vger.kernel.org, 
 rcu@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0

HK_TYPE_KERNEL_NOISE and HK_TYPE_DOMAIN are configured independently
when nohz_full=/isolcpus=nohz and isolcpus=domain are passed as
separate boot parameters, or when nohz_full=/isolcpus=nohz is passed
without isolcpus=domain at all.  Nothing stops a CPU from ending up
tick-suppressed (nohz_full) while still scheduled as part of the
normal, non-isolated sched domain, which defeats the point of
isolating it from kernel noise in the first place.

A CPU with the tick stopped must always be excluded from the normal
scheduler domain: HK_TYPE_KERNEL_NOISE's housekeeping set has to stay
a superset of HK_TYPE_DOMAIN's.  Checking this while __setup()
parameters are still being parsed is order-dependent: rejecting
nohz_full= the moment it is seen, before a later isolcpus=domain on
the same command line has been parsed yet, would discard a
perfectly valid combination just because of argument order.

Check the invariant once in housekeeping_init() instead, which runs
after every __setup() cmdline parameter has been parsed regardless of
order.  Disable HK_TYPE_KERNEL_NOISE rather than panicking or leaving
the inconsistency in place: this gives the same end state as not
having passed nohz_full=/isolcpus=nohz at all.

housekeeping_cpumask() only dereferences the real per-type masks once
housekeeping_overridden is enabled; before that every call returns
cpu_possible_mask regardless of housekeeping.flags.  Enable the static
key before the subset check runs, not after: checking first would
compare cpu_possible_mask against itself for both sides and never
reject anything.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 12 ++++++++++++
 kernel/sched/isolation.c                        | 24 ++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index e75344f4e0cde..cd4fb6d752a6c 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2810,6 +2810,11 @@ Kernel parameters
 			  so to protect individual CPUs the 'cpumask' file has to
 			  be configured manually after bootup.
 
+			  When 'domain' is configured through a separate
+			  isolcpus= or nohz_full= invocation, every 'nohz'
+			  CPU must also be a 'domain' CPU; a combination that
+			  violates this is rejected at boot with a warning.
+
 			domain
 			  Isolate from the general SMP balancing and scheduling
 			  algorithms. Note that performing domain isolation this way
@@ -4564,6 +4569,13 @@ Kernel parameters
 			Note that this argument takes precedence over
 			the CONFIG_RCU_NOCB_CPU_DEFAULT_ALL option.
 
+			When isolcpus=domain is also given, every CPU in
+			this list (or in isolcpus=nohz) must also be in
+			the isolcpus=domain list: a tick-suppressed CPU
+			must always be excluded from the normal scheduler
+			domain.  A combination that violates this is
+			rejected at boot with a warning.
+
 	noinitrd	[Deprecated,RAM] Tells the kernel not to load any configured
 			initial RAM disk. Currently this parameter applies to
 			initrd only, not to initramfs. But it applies to both
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 156025ef81b75..c6a41095a9002 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -171,8 +171,32 @@ void __init housekeeping_init(void)
 	if (!housekeeping.flags)
 		return;
 
+	/*
+	 * housekeeping_cpumask() only dereferences the real per-type masks
+	 * once housekeeping_overridden is live; before that it always
+	 * returns cpu_possible_mask regardless of housekeeping.flags, which
+	 * would make the subset check below vacuously pass for every type.
+	 * Enable it first so the check actually sees the parsed masks.
+	 */
 	static_branch_enable(&housekeeping_overridden);
 
+	/*
+	 * A nohz_full CPU must always run on an isolated sched domain:
+	 * reject nohz_full=/isolcpus=nohz unless isolcpus=domain covers
+	 * at least the same CPUs.  Checked here, after all __setup()
+	 * cmdline parsing has run, so the outcome does not depend on
+	 * which of the two parameters came first on the command line.
+	 */
+	if ((housekeeping.flags & HK_FLAG_KERNEL_NOISE) &&
+	    !cpumask_subset(housekeeping_cpumask(HK_TYPE_DOMAIN),
+			    housekeeping_cpumask(HK_TYPE_KERNEL_NOISE))) {
+		pr_warn("Housekeeping: nohz_full=/isolcpus=nohz must be a subset "
+			"of isolcpus=domain, disabling nohz_full\n");
+		housekeeping.flags &= ~HK_FLAG_KERNEL_NOISE;
+		if (!housekeeping.flags)
+			return;
+	}
+
 	if (housekeeping.flags & HK_FLAG_KERNEL_NOISE)
 		sched_tick_offload_init();
 	/*

-- 
2.43.0

