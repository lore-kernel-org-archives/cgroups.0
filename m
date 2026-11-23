Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795407157;
	b=HTUhUAxs0IpZLf7a/EaEX9R1Rer5cWA4ESBYIqm4SYHutgRxm4U73In7RPOGtM4qGmz2
	 7pQlodsIew3vtdGXGjNhQgkv4qA4nOV6u+kPp1xJjjjNvPv8+gq8rIaKNhnq/mEXtgwfD
	 4IRawgRnPWrYF/SL+ammRcoIY6ULOy5nYEzr19ObM9GtiSZPvvaEG6f2rZt1Kv2h5dYzC
	 ICji/H1xL0D3cipng9neJwqg2Vs5af4dCtivgiHEwZxRYTOCqnFpiptm8u3U8uorI8zfb
	 ZzyG/2Rw+kSwlO05gV/fzK/RItGxKqTVr/ccrRjiSDrcqExpGjDtmLAwvRHXAZ9/yMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795407157;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=69Oy60GwcYKbZP4kLRT9wUNdniq18d8Hg3484IGbI+g=;
	b=oa+Q1xS/UXqMWwB/tNA/vAaNN37be+2IrST8qCdA7oUme7C7ixgpWw4LGxpyjfqHa6gf
	 RaAlG57cM+nL+jPb9U4QKZRL+TlybWi20RjufVeci0Re0p6zehqcTmSroN/PEl7tfcKu4
	 c0VU7bH4TpY5Aq8zqpJdbI3Tlw4OgpKOAASmy0d0T92+G1pAsLF3dcoU55JU5+GU8EB3Q
	 1lFjEadI1eDpD8HUFQIG4KErPyDnTaqpzWVmtA2gDGx5iBckGFFtQ3WU4YOGODh8aN3xG
	 yBOl5kxRMFlqMHARZRwttJ0NVpWGZi3aaJ1hb1WqZYNPnogwMPkwL49p91NKCzMGUMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZCCpj7na;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317A2606A31E
	for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 04:12:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 317A2606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZCCpj7na
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795407156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=69Oy60GwcYKbZP4kLRT9wUNdniq18d8Hg3484IGbI+g=;
	b=ZCCpj7naaSh533q6bf5Ht0vNgZXWlAMQaK18DB68+OMfi3pB5Jw7Ie3JmpVSDTaWElJvOk
	tQank/aGwXa3PlZF8yFuzBvqYzgobk1f7EzOWzb72tHBBSL8OHxHzbg0zzFM9e9bgP+cR8
	+miv8wAA7Hweep35iBTlei+AP62coKg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-278-LpAVvjivOZ2I3Mj4Ew7LgA-1; Mon,
 23 Nov 2026 04:12:32 +0000
X-MC-Unique: LpAVvjivOZ2I3Mj4Ew7LgA-1
X-Mimecast-MFC-AGG-ID: LpAVvjivOZ2I3Mj4Ew7LgA_1795407149
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 939721955F45;
	Mon, 23 Nov 2026 04:12:28 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 69D8818011DC;
	Mon, 23 Nov 2026 04:12:23 +0000 (UTC)
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
Subject: [PATCH-next v2 1/3] tick/sched: Make tick_nohz_full_mask and HK_TYPE_KERNEL_NOISE cpumask consistent
Date: Sun, 22 Nov 2026 23:12:07 -0500
Message-ID: <20261123041209.382726-2-longman@redhat.com>
In-Reply-To: <20261123041209.382726-1-longman@redhat.com>
References: <20261123041209.382726-1-longman@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

When the nohz_full boot parameter is first set, the cpu list parameter is
passed directly to tick_nohz_full_setup() to set up tick_nohz_full_mask
cpumask. Then the HK_TYPE_KERNEL_NOISE cpumask will be set up as the
inverse of given cpu list parameter. Some of the timer code and RCU
uses tick_nohz_full_mask directly while other timer code, scheduler
and other subsystems use the HK_TYPE_KERNEL_NOISE cpumask.

With CONFIG_PM_SLEEP_SMP && !CONFIG_PM_SLEEP_SMP_NONZERO_CPU config
options, the boot CPU will be cleared from tick_nohz_full_mask if set
while the corresponding HK_TYPE_KERNEL_NOISE cpumask isn't touched.
The nohz_full entry in kernel-parameters.txt does state that the boot
CPU will be forced outside the range to maintain the timekeeping. So it
makes sense that the HK_TYPE_KERNEL_NOISE should be modified accordingly.

Fix this inconsistency problem by adding a new cpumask_set_cpu() init
function to be called by tick_nohz_init() when the boot CPU is cleared
from tick_nohz_full_mask.

PM_SLEEP_SMP_NONZERO_CPU depends on ARCH_SUSPEND_NONZERO_CPU which can
only be set for the PowerPC architecture. Moreover CONFIG_PM_SLEEP_SMP is
on by default, it means most kernels will not allow CPU 0 to be set in
the tick_nohz_full_mask and hence should be set in HK_TYPE_KERNEL_NOISE
cpumask.

Fixes: 6f1982fedd59 ("sched/isolation: Handle the nohz_full= parameter")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 include/linux/sched/isolation.h |  2 ++
 kernel/sched/isolation.c        | 11 +++++++++++
 kernel/time/tick-sched.c        |  2 ++
 3 files changed, 15 insertions(+)

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
index 156025ef81b7..c0c8b8862cbd 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -120,6 +120,17 @@ bool housekeeping_test_cpu(int cpu, enum hk_type type)
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
+		cpumask_set_cpu(cpu, housekeeping_cpumask_dereference(type));
+}
+
 int housekeeping_update(struct cpumask *isol_mask)
 {
 	struct cpumask *trial, *old = NULL;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 255488366d7c..d9f45c9f9b89 100644
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
@@ -683,6 +684,7 @@ void __init tick_nohz_init(void)
 			pr_warn("NO_HZ: Clearing %d from nohz_full range "
 				"for timekeeping\n", cpu);
 			cpumask_clear_cpu(cpu, tick_nohz_full_mask);
+			housekeeping_set_cpu(cpu, HK_TYPE_KERNEL_NOISE);
 		}
 	}
 
-- 
2.56.1

