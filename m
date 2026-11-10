Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=35.155.198.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794309004;
	b=iyfiDxfTDcTjBApshbr1xoGOReWooOAUE4OEiOyOK+WKwSh4VHkRhO1th+AYRI+RgKha
	 V5+2+NLnlyD8X+FrZATBtoy7t/LhsgBNKG05bx12w/gGtgS6H+nvX6PnrhjxslOxuKGpt
	 +lPvUCcAulhT42lPU6Mf0zHHGBK3rFAFbdbEzH0CxTby/FJXS5ImldcgnujeqiDeBZ18o
	 lkwf6tSfU3ksBZMaVmUCKSZIhH8WSalBJj53S6Ndr8EsXxyG2mbaB1rKBuFLJShxFzr2E
	 xtESwwkyqs1yXkDtIrLqqi43r99x7hZtfJ7ED2LFnqkGzQBxzTRvI2tQFrJU9qMJ/VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794309004;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:X-Originating-IP:X-ClientProxiedBy:Content-Type:
	 Content-Transfer-Encoding;
	bh=Mvw0TsgFURMJSUqs9pb48vMPCPDkBjPnh47dx0cihh8=;
	b=5Yp5vUys7r6w8g6cXQxgABzMfOXsC3YzD3erfqYa/N91t8PIgiv3LuD9M9iiYMiKM6IM
	 kAa6DDZHSPmbQSt0orFxch/rT+jmb5T2kALOsmmgiD3TXUJIMbPR2R23W6s01SjIxPTMS
	 YdEn/5TaEfKztyTsIFwXu84bNVOEQu44dg+kAAOo6Ud0LEA0sYgWq0F+aft299IjrwsHZ
	 XSxGzIDp2bSVbb8VSl2fJlTh6UuSM10dBo8TTdeyOAeGR2fn+TYRFF/LfeEP790PtvrOr
	 2LEo/Hf6yy0ZDbTFGGW8bA9UaLtIlF7h73qPzxF+dWQ3b6VczFn1iP8e4rEGOqUxp8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.com;
	spf=pass smtp.mailfrom=amazon.com;
	dkim=pass header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=Ji6bUNlv;
	arc=none smtp.remote-ip=35.155.198.111
Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE16F606A321;
	Tue, 10 Nov 2026 11:10:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CE16F606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=Ji6bUNlv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794309003; x=1825845003;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Mvw0TsgFURMJSUqs9pb48vMPCPDkBjPnh47dx0cihh8=;
  b=Ji6bUNlvg6klxmQth7yryM2IY75+ujDHOSxAhjbrBHCe3s/yM/po/V3J
   RBE0JHH3ikFu7cLPl0JBbPfOXWAkySwCSAitWQ6B/Qk6sHYwJg69osI3v
   IzML+X07DkXdgTkTCFa9REyKiE/8WG8e5V0aBcs1DPZ91s6ssAJsvM5K7
   jbis+SQQE0aEbVNJbRKpnPcbGrFl1U9dDuK7ZdzjaAJBLp78ey+J4Fis7
   KboyvOHm/acfoT+krzwaC2oWiuBiDgtnG4QJ3XHl3QVBs/+q/wKYMF+sT
   GHfKAAb6FVal56gE31U/k7oI9+F/HbwpNXq6tuXxJyV5IeDWj3PJxSfAP
   Q==;
X-CSE-ConnectionGUID: +xTmVE22TF2oPtKVIFOmTA==
X-CSE-MsgGUID: gWpq6dWvRzS7w7Hfl1EJrg==
X-IronPort-AV: E=Sophos;i="6.27,205,1787011200"; 
   d="scan'208";a="33508508"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2026 11:10:01 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:14851]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.46.128:2525] with esmtp (Farcaster)
 id eda8a907-d371-442c-bf41-a7cd90490911; Tue, 10 Nov 2026 11:10:00 +0000 (UTC)
X-Farcaster-Flow-ID: eda8a907-d371-442c-bf41-a7cd90490911
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Tue, 10 Nov 2026 11:10:00 +0000
Received: from dev-dsk-sieberf-metal-1a-7543e84d.eu-west-1.amazon.com
 (172.19.116.227) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Tue, 10 Nov 2026
 11:09:55 +0000
From: Fernand Sieber <sieberf@amazon.com>
To: <mingo@redhat.com>, <peterz@infradead.org>, <juri.lelli@redhat.com>,
	<vincent.guittot@linaro.org>, <tj@kernel.org>
CC: <bsegall@google.com>, <dietmar.eggemann@arm.com>, <rostedt@goodmis.org>,
	<mgorman@suse.de>, <vschneid@redhat.com>, <kprateek.nayak@amd.com>,
	<hannes@cmpxchg.org>, <mkoutny@suse.com>, <void@manifault.com>,
	<arighi@nvidia.com>, <changwoo@igalia.com>, <skhan@linuxfoundation.org>,
	<corbet@lwn.net>, <rdunlap@infradead.org>, <cgroups@vger.kernel.org>,
	<sched-ext@lists.linux.dev>, <linux-doc@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <bpf@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <nh-open-source@amazon.com>,
	<hborghor@amazon.de>, <fmubeen@amazon.de>, <dwmw@amazon.co.uk>,
	<karataev@amazon.com>, <sieberf@amazon.com>
Subject: [PATCH v2 3/4] sched_ext: add cgroup_set_runtime ops callback
Date: Tue, 10 Nov 2026 13:08:50 +0200
Message-ID: <a07b9717684d5e20d8ff7a778a5f031d1092f18a.1794303670.git.sieberf@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1794303670.git.sieberf@amazon.com>
References: <cover.1794303670.git.sieberf@amazon.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWA001.ant.amazon.com (10.13.139.88) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add a sched_ext_ops callback, and its cid-form variant, that is invoked
when userspace writes cpu.max.runtime. A BPF scheduler that implements
ops.cgroup_set_bandwidth() to enforce a cgroup's CPU bandwidth also
needs the written runtime, so that its budget for the cgroup matches the
fair class's, for example after userspace restores a saved runtime or
adds to it.

The callback is invoked on every write, after the fair class has applied
it. Unlike cgroup_set_bandwidth(), it does not skip a write of the value
last written. The runtime goes down as the cgroup runs, so writing the
same value again is a top-up.

A new tg_bandwidth_mutex is held across the fair class's update and the
callback, by the cpu.max.runtime write and by tg_set_bandwidth(), which
the cpu.max and cgroup v1 cpu.cfs_* writes go through and which calls
cgroup_set_bandwidth(). The runtime passed is then at most the quota +
burst the scheduler was last given, and cpu.max and cpu.max.runtime
writes reach it in the order the fair class applied them. The mutex is
taken before, and the callbacks run after, the fair class's
cpus_read_lock() and cfs_constraints_mutex sections, so
cgroup_set_bandwidth() runs as it did before.

Like cgroup_set_bandwidth(), the callback runs in process context and
may be sleepable.

Signed-off-by: Fernand Sieber <sieberf@amazon.com>
---
 Documentation/admin-guide/cgroup-v2.rst |  4 +++-
 kernel/sched/core.c                     | 25 +++++++++++++++++++++++--
 kernel/sched/ext/ext.c                  | 19 +++++++++++++++++++
 kernel/sched/ext/ext.h                  |  2 ++
 kernel/sched/ext/internal.h             | 21 +++++++++++++++++++++
 5 files changed, 68 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 2c220e5998639..b77ca6f8ca548 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1256,7 +1256,9 @@ will be referred to. All time durations are in microseconds.
 	from it, at most a slice each (sched_cfs_bandwidth_slice_us).
 	A write leaves that with the CPUs.
 
-	This file affects only processes under the fair-class scheduler.
+	This file affects only processes under the fair-class scheduler and a BPF
+	scheduler with the ``cgroup_set_runtime`` callback depending on what
+	the callback actually does.
 
   cpu.pressure
 	A read-write nested-keyed file.
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 75a5f5d1b8f54..25a4acb72106c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -10099,6 +10099,14 @@ static u64 cpu_period_read_u64(struct cgroup_subsys_state *css,
 	return period_us;
 }
 
+/*
+ * Held across a bandwidth or runtime write and the sched_ext callback that
+ * follows it, so that the BPF scheduler gets the writes in the order the fair
+ * class applied them. The callback runs after the fair class's update has
+ * dropped cpus_read_lock() and cfs_constraints_mutex.
+ */
+static DEFINE_MUTEX(tg_bandwidth_mutex);
+
 static int tg_set_bandwidth(struct task_group *tg,
 			    u64 period_us, u64 quota_us, u64 burst_us)
 {
@@ -10140,6 +10148,8 @@ static int tg_set_bandwidth(struct task_group *tg,
 	if (quota_us != RUNTIME_INF && burst_us > max_bw_runtime_us - quota_us)
 		return -EINVAL;
 
+	guard(mutex)(&tg_bandwidth_mutex);
+
 #ifdef CONFIG_CFS_BANDWIDTH
 	ret = tg_set_cfs_bandwidth(tg, period_us, quota_us, burst_us);
 #endif /* CONFIG_CFS_BANDWIDTH */
@@ -10204,12 +10214,23 @@ static int cpu_runtime_write_u64(struct cgroup_subsys_state *css,
 				 struct cftype *cftype, u64 runtime_us)
 {
 	struct task_group *tg = css_tg(css);
+	int ret;
 
 	if (runtime_us > max_bw_runtime_us)
 		return -EINVAL;
 
-	return cfs_bandwidth_set_runtime(&tg->cfs_bandwidth,
-					 runtime_us * NSEC_PER_USEC);
+	/*
+	 * Serialize against tg_set_bandwidth(), so that the BPF scheduler gets
+	 * the runtime checked against the current quota + burst, and this and
+	 * cpu.max writes reach it in the order the fair class took them.
+	 */
+	guard(mutex)(&tg_bandwidth_mutex);
+
+	ret = cfs_bandwidth_set_runtime(&tg->cfs_bandwidth,
+					runtime_us * NSEC_PER_USEC);
+	if (!ret)
+		scx_group_set_runtime(tg, runtime_us);
+	return ret;
 }
 
 static u64 cpu_runtime_read_u64(struct cgroup_subsys_state *css,
diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index ebdf7b91f9d37..265a80dd93282 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -5817,6 +5817,19 @@ void scx_group_set_bandwidth(struct task_group *tg,
 
 	percpu_up_read(&scx_cgroup_ops_rwsem);
 }
+
+void scx_group_set_runtime(struct task_group *tg, u64 runtime_us)
+{
+	struct scx_sched *sch;
+
+	percpu_down_read(&scx_cgroup_ops_rwsem);
+	sch = scx_tg_knob_sched(tg);
+
+	if (scx_cgroup_enabled && sch && SCX_HAS_OP(sch, cgroup_set_runtime))
+		SCX_CALL_OP(sch, cgroup_set_runtime, NULL, tg_cgrp(tg), runtime_us);
+
+	percpu_up_read(&scx_cgroup_ops_rwsem);
+}
 #endif	/* CONFIG_EXT_GROUP_SCHED */
 
 #if defined(CONFIG_EXT_GROUP_SCHED) || defined(CONFIG_EXT_SUB_SCHED)
@@ -9230,6 +9243,7 @@ static int bpf_scx_check_member(const struct btf_type *t,
 	case offsetof(struct sched_ext_ops, cgroup_exit):
 	case offsetof(struct sched_ext_ops, cgroup_prep_move):
 	case offsetof(struct sched_ext_ops, cgroup_set_bandwidth):
+	case offsetof(struct sched_ext_ops, cgroup_set_runtime):
 #endif
 	case offsetof(struct sched_ext_ops, cpu_online):
 	case offsetof(struct sched_ext_ops, cpu_offline):
@@ -9392,6 +9406,7 @@ static void sched_ext_ops__cgroup_cancel_move(struct task_struct *p, struct cgro
 static void sched_ext_ops__cgroup_set_weight(struct cgroup *cgrp, u32 weight) {}
 static void sched_ext_ops__cgroup_set_bandwidth(struct cgroup *cgrp, u64 period_us, u64 quota_us, u64 burst_us) {}
 static void sched_ext_ops__cgroup_set_idle(struct cgroup *cgrp, bool idle) {}
+static void sched_ext_ops__cgroup_set_runtime(struct cgroup *cgrp, u64 runtime_us) {}
 #endif	/* CONFIG_EXT_GROUP_SCHED */
 static s32 sched_ext_ops__sub_attach(struct scx_sub_attach_args *args) { return -EINVAL; }
 static void sched_ext_ops__sub_detach(struct scx_sub_detach_args *args) {}
@@ -9434,6 +9449,7 @@ static struct sched_ext_ops __bpf_ops_sched_ext_ops = {
 	.cgroup_set_weight	= sched_ext_ops__cgroup_set_weight,
 	.cgroup_set_bandwidth	= sched_ext_ops__cgroup_set_bandwidth,
 	.cgroup_set_idle	= sched_ext_ops__cgroup_set_idle,
+	.cgroup_set_runtime	= sched_ext_ops__cgroup_set_runtime,
 #endif
 	.sub_attach		= sched_ext_ops__sub_attach,
 	.sub_detach		= sched_ext_ops__sub_detach,
@@ -9502,6 +9518,7 @@ static struct sched_ext_ops_cid __bpf_ops_sched_ext_ops_cid = {
 	.cpuctl_set_weight	= sched_ext_ops__cgroup_set_weight,
 	.cpuctl_set_bandwidth	= sched_ext_ops__cgroup_set_bandwidth,
 	.cpuctl_set_idle	= sched_ext_ops__cgroup_set_idle,
+	.cpuctl_set_runtime	= sched_ext_ops__cgroup_set_runtime,
 #endif
 	.sub_attach		= sched_ext_ops__sub_attach,
 	.sub_detach		= sched_ext_ops__sub_detach,
@@ -12226,6 +12243,7 @@ static const u32 scx_kf_allow_flags[] = {
 	[SCX_OP_IDX(cgroup_set_weight)]	= SCX_KF_ALLOW_UNLOCKED,
 	[SCX_OP_IDX(cgroup_set_bandwidth)] = SCX_KF_ALLOW_UNLOCKED,
 	[SCX_OP_IDX(cgroup_set_idle)]	= SCX_KF_ALLOW_UNLOCKED,
+	[SCX_OP_IDX(cgroup_set_runtime)] = SCX_KF_ALLOW_UNLOCKED,
 #endif	/* CONFIG_EXT_GROUP_SCHED */
 	[SCX_OP_IDX(sub_attach)]	= SCX_KF_ALLOW_UNLOCKED,
 	[SCX_OP_IDX(sub_detach)]	= SCX_KF_ALLOW_UNLOCKED,
@@ -12395,6 +12413,7 @@ static int __init scx_init(void)
 	CID_OFFSET_MATCH(cgroup_set_weight, cpuctl_set_weight);
 	CID_OFFSET_MATCH(cgroup_set_bandwidth, cpuctl_set_bandwidth);
 	CID_OFFSET_MATCH(cgroup_set_idle, cpuctl_set_idle);
+	CID_OFFSET_MATCH(cgroup_set_runtime, cpuctl_set_runtime);
 #endif
 	/* @priv tail must align since both share the same data block */
 	CID_OFFSET_MATCH(priv, priv);
diff --git a/kernel/sched/ext/ext.h b/kernel/sched/ext/ext.h
index d32bc01071b01..6d1ce582bf724 100644
--- a/kernel/sched/ext/ext.h
+++ b/kernel/sched/ext/ext.h
@@ -94,6 +94,7 @@ void scx_cgroup_cancel_attach(struct cgroup_taskset *tset);
 void scx_group_set_weight(struct task_group *tg, unsigned long cgrp_weight);
 void scx_group_set_idle(struct task_group *tg, bool idle);
 void scx_group_set_bandwidth(struct task_group *tg, u64 period_us, u64 quota_us, u64 burst_us);
+void scx_group_set_runtime(struct task_group *tg, u64 runtime_us);
 #else	/* CONFIG_EXT_GROUP_SCHED */
 static inline void scx_tg_init(struct task_group *tg) {}
 static inline int scx_tg_online(struct task_group *tg) { return 0; }
@@ -104,5 +105,6 @@ static inline void scx_cgroup_cancel_attach(struct cgroup_taskset *tset) {}
 static inline void scx_group_set_weight(struct task_group *tg, unsigned long cgrp_weight) {}
 static inline void scx_group_set_idle(struct task_group *tg, bool idle) {}
 static inline void scx_group_set_bandwidth(struct task_group *tg, u64 period_us, u64 quota_us, u64 burst_us) {}
+static inline void scx_group_set_runtime(struct task_group *tg, u64 runtime_us) {}
 #endif	/* CONFIG_EXT_GROUP_SCHED */
 #endif	/* CONFIG_CGROUP_SCHED */
diff --git a/kernel/sched/ext/internal.h b/kernel/sched/ext/internal.h
index ff0a3d508533f..e794507596d6f 100644
--- a/kernel/sched/ext/internal.h
+++ b/kernel/sched/ext/internal.h
@@ -863,6 +863,26 @@ struct sched_ext_ops {
 	 */
 	void (*cgroup_set_idle)(struct cgroup *cgrp, bool idle);
 
+	/**
+	 * @cgroup_set_runtime: A cgroup's runtime is being set
+	 * @cgrp: cgroup whose runtime is being set
+	 * @runtime_us: runtime in microseconds
+	 *
+	 * Set the runtime @cgrp has accumulated and not used yet to
+	 * @runtime_us. This is from the cpu.max.runtime cgroup interface,
+	 * which exists with CONFIG_CFS_BANDWIDTH only. It is called on every
+	 * write, also of an unchanged value. The runtime goes down as @cgrp
+	 * runs, so a write of the same value is a top-up.
+	 *
+	 * @cgrp has a quota, and @runtime_us is at most the quota + burst the
+	 * scheduler was last given, by @cgroup_init or @cgroup_set_bandwidth:
+	 * cpu.max and cpu.max.runtime writes reach the scheduler in the order
+	 * the fair class applied them.
+	 *
+	 * Delivery follows the same rule as cgroup_set_weight().
+	 */
+	void (*cgroup_set_runtime)(struct cgroup *cgrp, u64 runtime_us);
+
 #endif	/* CONFIG_EXT_GROUP_SCHED */
 
 	/**
@@ -1239,6 +1259,7 @@ struct sched_ext_ops_cid {
 	void (*cpuctl_set_bandwidth)(struct cgroup *cgrp, u64 period_us, u64 quota_us,
 				     u64 burst_us);
 	void (*cpuctl_set_idle)(struct cgroup *cgrp, bool idle);
+	void (*cpuctl_set_runtime)(struct cgroup *cgrp, u64 runtime_us);
 #endif	/* CONFIG_EXT_GROUP_SCHED */
 	s32 (*sub_attach)(struct scx_sub_attach_args *args);
 	void (*sub_detach)(struct scx_sub_detach_args *args);
-- 
2.47.3




Amazon Development Centre (South Africa) (Proprietary) Limited
29 Gogosoa Street, Observatory, Cape Town, Western Cape, 7925, South Africa
Registration Number: 2004 / 034463 / 07

