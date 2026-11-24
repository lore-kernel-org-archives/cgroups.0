Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795494511;
	b=NJ8YC3yplT7SHnHa407tprz8uYxE4Bu55Zl+y1QNFulTvAU2YWrFjCgv5aBh19NwzcjE
	 YdxqtUqLgxEfCczqtD5Tgl8ayw0z1Zr+46vRI82RjKMjzT1qoA7Ve61MCoKzFCVBlasMx
	 4+GqI9Kdpq5FO2VGw+3h/XZRQhp8JNTYr7BvFdYwZppFy+QVhi1JdH9XpTpZjVZ126UmJ
	 7YbmgvAB5nFK7rRLbCgekBynhc1/zsHsTvZJEZD5vVbhX4YPqdxKLw7mpw0ffWXqVcqxT
	 uemJ1McosPg0ZbZrOfp5hPjr9n+njBnWU6ejvLJrRgUmR1WTQE4KA8VsE9JVMdUw4kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795494511;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=B5Nbip6TzYi7GMeSs8uz5LlNsZqZbiwKYLK2KGz0yaE=;
	b=jxxiHxUCF6dkVXksvdicJfUI+YGgCTMPyfxfTXLp/25QKPMtD9RUE6fyD9GsdeoeZ+ES
	 ZMPcoAg+cb/eCfQnXf7XMM2+2ppIJIJK5oeTFhU5PEwpAhsDq+eXAnGTRtTtC88H5ncSp
	 k5hv3tBUpDditUefIV1CAwKyZklaFta0oIY16cnNARTwZUjHoxAxyGntai/x0UCgyJXhe
	 oZB7Nj4eTSlhQmpCr2+vnAPMLMk2DPIUyb56mkIkg99m7uDH1iIAfyh5KUl91/a9ROFSy
	 gzp2Qdth2Qp4YQKdlkpWP9HeZnTUG6CjLv+LR/WhOmdXBMcWYIxFFhGIuftG7wjx35w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=W15FXkwc;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CA1606A33C
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 04:28:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4CA1606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=W15FXkwc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795494509;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B5Nbip6TzYi7GMeSs8uz5LlNsZqZbiwKYLK2KGz0yaE=;
	b=W15FXkwcMHl34aqURi5aUM6K9yftWlFb+jFImkfZ8uMf9K8hjC0cSvoZGyX9sNAzrqik01
	luRANxhpYZIy9vpXPvsiCSx4jzM0b/vTvQe2fYdeSFg0Giafqqk5udRn+UlRRMvVI+7TmF
	flhdPPFKZYdKUuXPBbTnw1us2s4SUjo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-661-g94d1F3YMbmZc3nWerwmGQ-1; Tue,
 24 Nov 2026 04:28:23 +0000
X-MC-Unique: g94d1F3YMbmZc3nWerwmGQ-1
X-Mimecast-MFC-AGG-ID: g94d1F3YMbmZc3nWerwmGQ_1795494500
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 79D711955DE1;
	Tue, 24 Nov 2026 04:28:19 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id ABF3818004F7;
	Tue, 24 Nov 2026 04:28:14 +0000 (UTC)
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
Subject: [PATCH-next v3 1/3] tick/sched: Make tick_nohz_full_mask and HK_TYPE_KERNEL_NOISE cpumask consistent
Date: Mon, 23 Nov 2026 23:28:00 -0500
Message-ID: <20261124042802.532633-2-longman@redhat.com>
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

In the special case that "nohz_full=0" and CPU 0 is cleared in
tick_nohz_init(), tick_nohz_full_running will be set to false. However,
housekeeping_enabled(HK_TYPE_KERNEL_NOISE) will stil be true with
housekeeping_cpumask(HK_TYPE_KERNEL_NOISE) equal to cpu_possible_mask.
So some unneeded code paths will be activated, but no harm will be done
other than wasting some CPU cycles.

Another problem that needs further thought but is not handled in
this patch is when arch_irq_work_has_interrupt() turns out to be
false. When this happens, tick_nohz_full_mask will be cleared and
tick_nohz_full_running will be set back to false in tick_nohz_init().

PM_SLEEP_SMP_NONZERO_CPU depends on ARCH_SUSPEND_NONZERO_CPU which can
only be set for the PowerPC architecture. Moreover CONFIG_PM_SLEEP_SMP is
on by default, it means most kernels will not allow CPU 0 to be set in
the tick_nohz_full_mask and hence should be set in HK_TYPE_KERNEL_NOISE
cpumask.

Fixes: 6f1982fedd59 ("sched/isolation: Handle the nohz_full= parameter")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Acked-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Tested-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 include/linux/sched/isolation.h |  2 ++
 kernel/sched/isolation.c        | 11 +++++++++++
 kernel/time/tick-sched.c        |  6 ++++++
 3 files changed, 19 insertions(+)

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
index 255488366d7c..99ca2982e29d 100644
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
@@ -683,6 +684,11 @@ void __init tick_nohz_init(void)
 			pr_warn("NO_HZ: Clearing %d from nohz_full range "
 				"for timekeeping\n", cpu);
 			cpumask_clear_cpu(cpu, tick_nohz_full_mask);
+			housekeeping_set_cpu(cpu, HK_TYPE_KERNEL_NOISE);
+			if (cpumask_empty(tick_nohz_full_mask)) {
+				tick_nohz_full_running = false;
+				return;
+			}
 		}
 	}
 
-- 
2.56.1

