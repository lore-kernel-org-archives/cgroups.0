Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795494513;
	b=rdFlfSaBSmNWIL9q0jcCNoEC9S5AVLMDymUCv98wlv9M0pyiJAKBkR3iq4npy96px8Sd
	 YS8MdgZTUR5yDOb6vf7JbejHi4EEAPggeE026eXv84OITlbM4PnKuKKojvL9RP23Waiec
	 Rw3enwSm+/zeKly+6rnquoAi6fDnQ/HFgx7Q4nFmFB9LM92HQyJV1htzJ+hoj126nJqZT
	 X4oNv0mydqtlF2un3u173ulYlOuDCvmN2gXGskr5FtNfprfaMjtJM1w1xbkiL74gBzb+p
	 azBuiJDGTd0twK4/wJyw2sSvrWEsHJAzSSTctvb0xQSOOEb4lvoCmOrgDB6zbpvOF/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795494513;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=mnbVql9exwLWONX5EZsGWnq9Up0Dw115AfwnQc3AkO8=;
	b=IHMolZJAq715eehBZTHPgEhXpsixZ7/3+If4N1PlbLrgnCK42avAhKvSK54ek3Eh1KYt
	 6sa/YYFbS4Pw1kZ46x/iXaEXiKTT2Dty3tvuedR2ong5UK/UTXpCZ9uiEhfY6+m3324tb
	 qDfeANvO/zY7XYbZFo/MK4y7GveUMWjhLttUd5XZXz+WXwrRW6PSlT1ScoTKJVm/xe5Ka
	 XTGeQ1b56uESZbQMNhE3EH3nXXyMWtM9iHpHPUZqow29rSSxQS/WdREsdSPuWT8gn9otT
	 HM3ViudxOifoI08fscRV/a7mueL7E8KofPFVobYAgIZEzk5zPHlAq6757oCOlKkefCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ajw3EdKm;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B67F606A693
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 04:28:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B67F606A693
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ajw3EdKm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795494511;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mnbVql9exwLWONX5EZsGWnq9Up0Dw115AfwnQc3AkO8=;
	b=ajw3EdKmDWey4gxYK0qhrEOsVomyyY6DEU0mJv3jGWmgh1dat8KFMUAU1JneiZrVnNXQJj
	/aw7ePOWfQcdUkDA0hr0UX5z+0947z7u8Nhkv4NF7fQWodP7P468F1aRLkqcRr1QZA9pd0
	E2zQtmwPBlYWHaMcETwhmKGV2AlYqyY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-673-7_w97j7TNDm5ga3lMsbyeQ-1; Tue,
 24 Nov 2026 04:28:27 +0000
X-MC-Unique: 7_w97j7TNDm5ga3lMsbyeQ-1
X-Mimecast-MFC-AGG-ID: 7_w97j7TNDm5ga3lMsbyeQ_1795494504
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5101619773CA;
	Tue, 24 Nov 2026 04:28:24 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B30481800551;
	Tue, 24 Nov 2026 04:28:19 +0000 (UTC)
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
	Waiman Long <longman@redhat.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH-next v3 2/3] sched/isolation: Forbid the boot CPU from being domain isolated
Date: Mon, 23 Nov 2026 23:28:01 -0500
Message-ID: <20261124042802.532633-3-longman@redhat.com>
In-Reply-To: <20261124042802.532633-1-longman@redhat.com>
References: <20261124042802.532633-1-longman@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

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
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Acked-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Tested-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
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

