Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795230864;
	b=wgPEMC33o4iWlu/VPOYnNDppGqRWAPsCWJuVkdQvWFOysOlpBXY+10BwbsagT3Rp60T9
	 eWhSJmyucQ//I70LVtcHi/IT0GxbABbC1lCV/2PN4B2c6x9Izs/YWIHeBCGbezvZjkEWv
	 qnYDF57/3P5I6ezlAvIeSUo9Jow3FdecBmbM3FTynwD72RT+8rMZ9hV2Jwtk+Z4w1DHXB
	 7pI1+4gqIQbj5MpxZZHtJuKu7oimlND3VxO162xEfVEdkIn1t1F5JsGkhB8XooR+LIlPp
	 Pfdif/geptIv952HgddIEje+49laLjHq3vN+qap/Jk3jJCYzMjV/jA5Ey0wK/UKd+Hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795230864;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=Sr6Rs7BiVm3iRcZw5WL7frN+bAW/6De8CnaYgLnn05o=;
	b=f73vtdQqN7ivZcqa1Bx+fyi6bQRT0C6CHhOpwiFUKnk7LVWmmhN9pFGxL9dVCSxY9sVt
	 g0mjGEGQV7ry/qgBdRckWThUmbAdiptOOjT2LHe1EgxjAKWCEp2C6pxGOUZNIowzCSOy4
	 9X3DpSIFBTUrDHFZR6RSlietR8PGiZwnte3FEH2iRwZ83Skd2gkS+88WFNGGaRaKEUPGg
	 5a7Xjz9DGU03FB39+VHPP+p+dRwvevn5T4izSYJwdycP0/vjf3k+mbZWa+65ALQ/lC3Hf
	 BPLBUEb0L5lBl2mYJdSizfePcs9PNEmbXDQBTzN8LXNOrNdzNKfu5ZYyD4Nr7vkHtPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=jInxqCmV;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF42606A69B
	for <cgroups@vger.kernel.org>; Sat, 21 Nov 2026 03:14:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DF42606A69B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=jInxqCmV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795230860;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sr6Rs7BiVm3iRcZw5WL7frN+bAW/6De8CnaYgLnn05o=;
	b=jInxqCmVJOkMVvKFRQ0+RVWS2kN5K31m4T/Ki4m5HXyRFEx114BVtpRMNviQBphiha+exV
	dYquZJjQFxwtJjV/pNcfqRUUNm3H+an5sDS66cgyBDQkwuvUONTaBlNfIDtivtkbq8vwKf
	goJWkuKsJ/58fW+44dTeyTUVSyDnzi0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-554-P5HoySzzOeC7tXhP7yM_gw-1; Sat,
 21 Nov 2026 03:14:15 +0000
X-MC-Unique: P5HoySzzOeC7tXhP7yM_gw-1
X-Mimecast-MFC-AGG-ID: P5HoySzzOeC7tXhP7yM_gw_1795230852
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9373A18004F9;
	Sat, 21 Nov 2026 03:14:11 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AF82C1956087;
	Sat, 21 Nov 2026 03:14:06 +0000 (UTC)
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
Subject: [PATCH-next 2/3] sched/isolation: Forbid the boot CPU from being isolated
Date: Fri, 20 Nov 2026 22:13:28 -0500
Message-ID: <20261121031329.240177-3-longman@redhat.com>
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

It is reported that with CONFIG_CPUSETS=n, a kernel booted with
isolcpus=domain,0 hits the BUG() in select_fallback_rq() during boot
[1]. At boot time, cpu 0 is the only CPU online and an unbound kworker
cannot be run on a domain isolated CPU causing kernel panic.

Sashiko also reports that domain isolating the boot CPU can break system
suspend and trigger a BUG_ON() [2]. So it is problematic if the boot CPU
is domain isolated.

There may be other kernel subsystems that have problem if the boot CPU
is domain isolated as most of them won't take into account the fact
that boot CPU is currently allowed to be domain isolated. The current
housekeeping code enforces the rule that if both isolcpus and nohz_full
boot parameters are set, they should match each other. Given the fact
that the boot CPU is likely to be disallowed from the nohz_full list,
it makes sense that we should not allow the boot CPU from being set
in the isolcpus boot parameter as well. This will also avoid the above
problems due to boot CPU being domain isolated.

Do that by clearing the boot CPU from the isolcpus range when it is
specified in the boot command line. A warning will also be printed when
that happens.

This is indeed a change in behavior which is customer visible. So the
kernel-paremeters.txt is updated to mention the fact that boot CPU
cannot be isolated.

[1] https://lore.kernel.org/lkml/20261117144817.265109-1-mathieu.desnoyers@efficios.com
[2] https://sashiko.dev/#/patchset/20261108180849.1268263-1-longman%40redhat.com

Signed-off-by: Waiman Long <longman@redhat.com>
---
 Documentation/admin-guide/kernel-parameters.txt |  7 ++++---
 kernel/sched/isolation.c                        | 16 ++++++++++++----
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 930cee4de79a..1c8bf3583b0b 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2954,11 +2954,12 @@ Kernel parameters
 
 			  You can move a process onto or off an "isolated" CPU via
 			  the CPU affinity syscalls or cpuset.
-			  <cpu number> begins at 0 and the maximum value is
-			  "number of CPUs in system - 1".
+			  <cpu number> begins at 0 and the maximum value
+			  is "number of CPUs in system - 1". However boot
+			  CPU (cpu 0) cannot be domain isolated as it
+			  may cause problem with some kernel subsystems.
 
 			managed_irq
-
 			  Isolate from being targeted by managed interrupts
 			  which have an interrupt mask containing isolated
 			  CPUs. The affinity of managed interrupts is
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 18b50c0d807a..ef4aa5126dc5 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -232,6 +232,7 @@ static int __init housekeeping_setup(char *str, unsigned long flags)
 {
 	cpumask_var_t non_housekeeping_mask, housekeeping_staging;
 	unsigned int first_cpu;
+	int boot_cpu = smp_processor_id();
 	int err = 0;
 
 	if ((flags & HK_FLAG_KERNEL_NOISE) && !(housekeeping.flags & HK_FLAG_KERNEL_NOISE)) {
@@ -254,14 +255,21 @@ static int __init housekeeping_setup(char *str, unsigned long flags)
 
 	first_cpu = cpumask_first_and(cpu_present_mask, housekeeping_staging);
 	if (first_cpu >= nr_cpu_ids || first_cpu >= setup_max_cpus) {
-		__cpumask_set_cpu(smp_processor_id(), housekeeping_staging);
-		__cpumask_clear_cpu(smp_processor_id(), non_housekeeping_mask);
+		__cpumask_set_cpu(boot_cpu, housekeeping_staging);
+		__cpumask_clear_cpu(boot_cpu, non_housekeeping_mask);
 		if (!housekeeping.flags) {
-			pr_warn("Housekeeping: must include one present CPU, "
-				"using boot CPU:%d\n", smp_processor_id());
+			pr_warn("Housekeeping: must include one present CPU, using boot CPU:%d\n",
+				boot_cpu);
 		}
 	}
 
+	if ((flags & HK_FLAG_DOMAIN) && cpumask_test_cpu(boot_cpu, non_housekeeping_mask)) {
+		pr_warn("Housekeeping: Boot CPU must not be isolated, clearing %d from isolcpus range\n",
+			 boot_cpu);
+		__cpumask_set_cpu(boot_cpu, housekeeping_staging);
+		__cpumask_clear_cpu(boot_cpu, non_housekeeping_mask);
+	}
+
 	if (cpumask_empty(non_housekeeping_mask))
 		goto free_housekeeping_staging;
 
-- 
2.56.1

