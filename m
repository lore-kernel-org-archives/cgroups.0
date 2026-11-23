Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795407162;
	b=kcd+HM1SpcJHeUzMhAjZfDoL9KB1piHvqH6cPV3KvYnkX6ZRwfz8CAwwNv+gLEJM08nY
	 iXR99q/rUaJwcHe4PNfDKlA0mS0P4hFvYID1/mPCwWKp9Wm/gc6jDj9xapxg0vtrHkAKH
	 1gZjj4HtA2POusK5UY3raPrgP8aSTzJF8UgvaKnavG8D7UaXctL3QQcJS8QVnIl8K2PAt
	 0gBR/C5XhcmYtQLEC811j2KXzRxLcK5i1ihoWUm+QSiElAyeFRadmwI9zIP9lMLH6Buic
	 +Z/xMBlkjlzFtayRsPiBnaU6iu1tmDtppSz/OGNCQjK83D8mPRNLdWhh+yMUMXLMG9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795407162;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=nZU72SgToJr8UidXGch5ZhQEkIh8Zfom3hUseUCJVXo=;
	b=QTOffCIMQslzI5hMT2fnIAm6Th9tEEqiGG3e90e9S44jscFEOIFcLc7WuIQPJzP+H/Uy
	 v2u5JiLGn8XQZotqWF1ojSPogt/KLpUC7vS16qRx+pDyU/hNr/U+esoaU6Jvu0lkgFLy3
	 eTeasGgHRPhRi5m8rupkyMK0XFUmuFtlJjA4Nd0w+RANQKPkSjRtLLDL5TNwmWWrOkme9
	 rheq6EDevA2vdJSu5/QmzGdJnfkuouQ3MQxfwDcUawPIlTrjDsD9jkt8eEV5F+FZO4ImH
	 OOuO0j2LcNT5dPa58j9iwvSq1riXV7tolRluOiFfjP1janyGojJljx6ToN4TC3lwWBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DBugKdIp;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C69606A332
	for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 04:12:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81C69606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DBugKdIp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795407160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nZU72SgToJr8UidXGch5ZhQEkIh8Zfom3hUseUCJVXo=;
	b=DBugKdIpoT5RZY5D1cwINfl5fCqhM+lZS6X+DltfA8crHtyjm9T2NwnWgcNO33hoo+W6wz
	ytMZ9Dj2tOUvSjzQ08Eo6zDJpouKlLgp1eLeLb4jbVHPNQUt54jLjuntOSaA8pcHTXR/TM
	27U4BVnRpgGNMQPJ94SXuM+ZRgcMsL0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-665-CeNqDaJxOFCKHQJBRzRs9w-1; Mon,
 23 Nov 2026 04:12:36 +0000
X-MC-Unique: CeNqDaJxOFCKHQJBRzRs9w-1
X-Mimecast-MFC-AGG-ID: CeNqDaJxOFCKHQJBRzRs9w_1795407153
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 277B51954B1A;
	Mon, 23 Nov 2026 04:12:33 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C687618011D8;
	Mon, 23 Nov 2026 04:12:28 +0000 (UTC)
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
Subject: [PATCH-next v2 2/3] sched/isolation: Forbid the boot CPU from being domain isolated
Date: Sun, 22 Nov 2026 23:12:08 -0500
Message-ID: <20261123041209.382726-3-longman@redhat.com>
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

It is reported that with CONFIG_CPUSETS=n, a kernel booted with
isolcpus=domain,0 hits the BUG() in select_fallback_rq() during boot
[1]. At boot time, cpu 0 is the only CPU online and an unbound kworker
cannot be run on a domain isolated CPU causing kernel panic.

Sashiko also reports that domain isolating the boot CPU can break system
suspend and trigger a BUG_ON() [2]. So it is problematic if the boot CPU
is domain isolated.

There may be other kernel subsystems that have problem if the boot CPU
is domain isolated as most of them won't take into account the fact that
boot CPU is currently allowed to be domain isolated. Given the fact
that the boot CPU is likely to be disallowed from the nohz_full list,
it makes sense that we should not allow the boot CPU from being set in
the isolcpus boot parameter as well. This will also avoid the kind of
problems listed above.

Do that by clearing the boot CPU from the isolcpus range when it is
specified in the boot command line. A warning may also be printed when
that happens. If the users want to have boot CPU in the managed_irq
or nohz isolation list, a standalone isolcpus boot parameter will be
needed instead of combining domain and other flags in the same isolcpus
boot parameter.

This is indeed a change in behavior which is customer visible. So the
kernel-paremeters.txt is updated to mention the fact that boot CPU
cannot be isolated.

[1] https://lore.kernel.org/lkml/20261117144817.265109-1-mathieu.desnoyers@efficios.com
[2] https://sashiko.dev/#/patchset/20261108180849.1268263-1-longman%40redhat.com

Signed-off-by: Waiman Long <longman@redhat.com>
---
 .../admin-guide/kernel-parameters.txt         |  7 +++---
 kernel/sched/isolation.c                      | 22 +++++++++++++++----
 2 files changed, 22 insertions(+), 7 deletions(-)

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
index c0c8b8862cbd..de8152351450 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -231,6 +231,7 @@ static int __init housekeeping_setup(char *str, unsigned long flags)
 {
 	cpumask_var_t non_housekeeping_mask, housekeeping_staging;
 	unsigned int first_cpu;
+	int boot_cpu = smp_processor_id();
 	int err = 0;
 
 	if ((flags & HK_FLAG_KERNEL_NOISE) && !(housekeeping.flags & HK_FLAG_KERNEL_NOISE)) {
@@ -253,12 +254,25 @@ static int __init housekeeping_setup(char *str, unsigned long flags)
 
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
+	} else if ((flags & HK_FLAG_DOMAIN) &&
+		   cpumask_test_cpu(boot_cpu, non_housekeeping_mask)) {
+		/*
+		 * If the same isolcpus boot parameter covers both domain and
+		 * managed_irq/nohz, the boot CPU will also be removed from the
+		 * managed_irq/nohz isolation list. Users have to use a separate
+		 * isolcpus boot parameter for them if they want to include the
+		 * boot CPU.
+		 */
+		pr_warn("Housekeeping: Boot CPU must not be domain isolated, clearing %d from isolcpus range\n",
+			 boot_cpu);
+		__cpumask_set_cpu(boot_cpu, housekeeping_staging);
+		__cpumask_clear_cpu(boot_cpu, non_housekeeping_mask);
 	}
 
 	if (cpumask_empty(non_housekeeping_mask))
-- 
2.56.1

