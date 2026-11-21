Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795230856;
	b=hNr+JcH/8mnwkyyV7gZZpfUfNaRLW7CMOzLJRoXRXWPwCzx5rSm7L/gwT+qOiwRCGHK3
	 /TYGo86IbdEa0vJYMmFlktZYVlU7+Ca4KOO2hl8vipF1+8KScnRldsBcSH1wvVb4LCzHk
	 pSWIHR2WUgM1WqERiehenUfEO8bTliv3CFQ51l796RvkR7mr5pN2QzdBU1+l71tlMRbYj
	 fIkzgKcJV7q4Ab2nXd3kmR40doc8aBoDetCPCrO9Br6LdmNk4dKu4hxOvpGSwWGbUpjj+
	 J0BKaJyMeCxcPvB4OlV63ecCl2Zrt8vL3gpTB3+vwLxg3o2NSmBJ42pm7fTgj170DLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795230856;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=mRRUy+sJAurb8e7tBGiIHZ6mni03s6qtHfmTBQfhVKU=;
	b=CUPn1TaTQE6m8zYFgAiTrqwg6jtmDXhzVDw0H3mkbOzw0vvJMbQWvNFTjlaZ0aypEDjB
	 8eQLWlDnzT2qcmPXf1siN72x0MLTJPmx5DzJjCDzJmH75QzJV1uCrc+bYnSKIBmin5xxg
	 qEnMpch+iOBIyJ53SxLEfJA+T+uZlZPGbWxd8gzLjiutsBdTuXmQDNFLNtG23KptErFXQ
	 +VswalKM/tNir5owWoT29UYELU8BEBwRWfvMVvqb2GSQdsjiBf9VoIR2lVVX0d+kqzb4k
	 haujFfVDnnXHjMNZJ1fBSrTTj+90Vv1Ljyy/CV7WnZfIxQqn1kQJ+Ylmuvu7rUU458w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hNEKbSui;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9763606A686
	for <cgroups@vger.kernel.org>; Sat, 21 Nov 2026 03:14:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9763606A686
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hNEKbSui
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795230852;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mRRUy+sJAurb8e7tBGiIHZ6mni03s6qtHfmTBQfhVKU=;
	b=hNEKbSuiwc37tVKAW2r8aijLX6TaXUzDrd9RYBvKDI7Pi01llNAW2VaRRSXKSeu2oBVPWk
	fYZmU/RZOORLzIfxsKL1ooTOuMmgvdQQ0jV5EXOxFKf6MdWq78EgpfO1XdsnlSBD5Oz7Dp
	ewVZ7rHu2hOfjSUEGbHqR6UauzGC5wE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-587-eAv4RbTSMGWfj6uhat66mA-1; Sat,
 21 Nov 2026 03:14:10 +0000
X-MC-Unique: eAv4RbTSMGWfj6uhat66mA-1
X-Mimecast-MFC-AGG-ID: eAv4RbTSMGWfj6uhat66mA_1795230847
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 784A71956094;
	Sat, 21 Nov 2026 03:14:06 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A4AE0195B3C0;
	Sat, 21 Nov 2026 03:14:01 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Ridong Chen <ridong.chen@linux.dev>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>
Cc: cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH-next 1/3] tick/sched: Make tick_nohz_full_mask and HK_TYPE_KERNEL_NOISE cpumask consistent
Date: Fri, 20 Nov 2026 22:13:27 -0500
Message-ID: <20261121031329.240177-2-longman@redhat.com>
In-Reply-To: <20261121031329.240177-1-longman@redhat.com>
References: <20261121031329.240177-1-longman@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

When the nohz_full boot parameter is first set, the cpu list parameter is
passed directly to tick_nohz_full_setup() to set up tick_nohz_full_mask
cpumask. Then the HK_TYPE_KERNEL_NOISE cpumask will be set up as the
inverse of given cpu list parameter. Some of the timer code and RCU
uses tick_nohz_full_mask directly while other timer code, scheduler
and other subsystems use the HK_TYPE_KERNEL_NOISE cpumask.

There are two problems that can cause inconsistency between
tick_nohz_full_mask and HK_TYPE_KERNEL_NOISE cpumask. First of all,
if there are more than one nohz_full boot parameters in the boot
command line, only the first one is passed to tick_nohz_full_setup()
while the setting of HK_TYPE_KERNEL_NOISE cpumask is controlled by
the last nohz_full parameter.

Secondly, with CONFIG_PM_SLEEP_SMP && !CONFIG_PM_SLEEP_SMP_NONZERO_CPU
config options, the boot CPU will be cleared from tick_nohz_full_mask if
set while the corresponding HK_TYPE_KERNEL_NOISE cpumask isn't touched.
The nohz_full entry in kernel-parameters.txt does state that the boot
CPU will be forced outside the range to maintain the timekeeping. So it
makes sense that the HK_TYPE_KERNEL_NOISE should be modified accordingly.

PM_SLEEP_SMP_NONZERO_CPU depends on ARCH_SUSPEND_NONZERO_CPU which can
only be set for the PowerPC architecture. Moreover CONFIG_PM_SLEEP_SMP is
on by default, it means most kernels will not allow CPU 0 to be set in
the tick_nohz_full_mask and hence should be set in HK_TYPE_KERNEL_NOISE
cpumask.

The first inconsistency problem is fixed by calling tick_nohz_full_setup()
every time a nohz_full parameter is hit with tick_nohz_full_setup()
modified to allow multiple calls. The second problem is fixed by adding
a new cpumask_set_cpu() init function to be called by tick_nohz_init()
when the boot CPU is cleared from tick_nohz_full_mask.

Fixes: 6010d245ddc9 ("sched/isolation: Consolidate housekeeping cpumasks that are always identical")
Fixes: 6f1982fedd59 ("sched/isolation: Handle the nohz_full= parameter")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 include/linux/sched/isolation.h |  2 ++
 kernel/sched/isolation.c        | 14 +++++++++++++-
 kernel/time/tick-sched.c        |  8 ++++++--
 3 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index cf0fd03dd7a2..ae5109450ac9 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -44,6 +44,7 @@ extern bool housekeeping_enabled(enum hk_type type);
 extern void housekeeping_affine(struct task_struct *t, enum hk_type type);
 extern bool housekeeping_test_cpu(int cpu, enum hk_type type);
 extern int housekeeping_update(struct cpumask *isol_mask);
+extern void __init housekeeping_set_cpu(int cpu, enum hk_type type);
 extern void __init housekeeping_init(void);
 
 #else
@@ -72,6 +73,7 @@ static inline bool housekeeping_test_cpu(int cpu, enum hk_type type)
 }
 
 static inline int housekeeping_update(struct cpumask *isol_mask) { return 0; }
+static inline void housekeeping_set_cpu(int cpu, enum hk_type type) { }
 static inline void housekeeping_init(void) { }
 #endif /* CONFIG_CPU_ISOLATION */
 
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 156025ef81b7..18b50c0d807a 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -120,6 +120,18 @@ bool housekeeping_test_cpu(int cpu, enum hk_type type)
 }
 EXPORT_SYMBOL_GPL(housekeeping_test_cpu);
 
+void __init housekeeping_set_cpu(int cpu, enum hk_type type)
+{
+	/* Only CPU setting of HK_TYPE_KERNEL_NOISE is currently supported */
+	if (type != HK_TYPE_KERNEL_NOISE)
+		return;
+
+	if (static_branch_unlikely(&housekeeping_overridden) &&
+	    READ_ONCE(housekeeping.flags) & BIT(type))
+		cpumask_set_cpu(cpu, housekeeping.cpumasks[type]);
+}
+EXPORT_SYMBOL_GPL(housekeeping_set_cpu);
+
 int housekeeping_update(struct cpumask *isol_mask)
 {
 	struct cpumask *trial, *old = NULL;
@@ -301,7 +313,7 @@ static int __init housekeeping_setup(char *str, unsigned long flags)
 			housekeeping_setup_type(type, housekeeping_staging);
 	}
 
-	if ((flags & HK_FLAG_KERNEL_NOISE) && !(housekeeping.flags & HK_FLAG_KERNEL_NOISE))
+	if (flags & HK_FLAG_KERNEL_NOISE)
 		tick_nohz_full_setup(non_housekeeping_mask);
 
 	housekeeping.flags |= flags;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 255488366d7c..a4dbb154242f 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -22,6 +22,7 @@
 #include <linux/sched/stat.h>
 #include <linux/sched/nohz.h>
 #include <linux/sched/loadavg.h>
+#include <linux/sched/isolation.h>
 #include <linux/module.h>
 #include <linux/irq_work.h>
 #include <linux/posix-timers.h>
@@ -634,9 +635,11 @@ void __tick_nohz_task_switch(void)
 /* Get the boot-time nohz CPU list from the kernel parameters. */
 void __init tick_nohz_full_setup(cpumask_var_t cpumask)
 {
-	alloc_bootmem_cpumask_var(&tick_nohz_full_mask);
+	if (!tick_nohz_full_running) {
+		alloc_bootmem_cpumask_var(&tick_nohz_full_mask);
+		tick_nohz_full_running = true;
+	}
 	cpumask_copy(tick_nohz_full_mask, cpumask);
-	tick_nohz_full_running = true;
 }
 
 bool tick_nohz_cpu_hotpluggable(unsigned int cpu)
@@ -683,6 +686,7 @@ void __init tick_nohz_init(void)
 			pr_warn("NO_HZ: Clearing %d from nohz_full range "
 				"for timekeeping\n", cpu);
 			cpumask_clear_cpu(cpu, tick_nohz_full_mask);
+			housekeeping_set_cpu(cpu, HK_TYPE_KERNEL_NOISE);
 		}
 	}
 
-- 
2.56.1

