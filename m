Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D872B4968E6
	for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 18:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786647534; cv=none; b=rv512W+IsADm4iuNLIoOGaj9oV+c9Q9PB0YgcLZEFHLJHcratjKST4KGf7oFghzNDSpiR48kdu3dfJNYSB7qcKBo/G0taVB9Ofch6APrPvqb9bY0A0WvPpxuzQ1D6iG9M3OAInT32Xp84vpoIDg+uP+lSuhbgVdPZpL7V/pyj4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786647534; c=relaxed/simple;
	bh=qeyDf1zf1toovwRK9sFVxz1irGFidwtP1E1vr6ae6BY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4S78CmgIV/Cb+ue1hQhytEn8s/aORZ9gSQe74Y7PwTq1U97mDvHaVS1EvKVM3FRB38jwSxQrpuzCMU+N7opD1bJKJvIIs+jol/Mq5XtTCp0myWTL1Gtczpkkr7B/pnS5cHMIzEbSrv8Eyr85+6uO8idFdy84zsI/HGw5i7E2Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hqPlzD4T; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hqPlzD4T"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cc73e322dbso5201145ad.1
        for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 11:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786647531; x=1787252331; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=j7MPifKM0g+V499r8MTdHDoJMUDv6wW/Ghb2RIQSLiw=;
        b=hqPlzD4TwzSpNtLlKBi0A7aiZru5FAZVYFnxRG0ruRWbe1iE4qu55CfW58jmHgs3H+
         aNr8CsjSLMS4oU0wi3iHzzF96aBztl6mYR9UPTCqTfqh9veqqT4nuzdpy72qKmWIMwVS
         b+Wk7XjD/y+kSOCGUrjrgaQiv4z1RAvT4QP0dUlv5uScWMhPP1gw1erOLtGwLTXs/V+I
         mQgrRjW0YuagvOhQfX+KGBCtrHvq56fNbh44x1x3dx5htpfLblkb/pdvuNyrte4Q3t64
         5iRVBO4DMmPijo/I8mWhqW9qhcKdhXOBeBID4P/tLcg4al8W2EDaX4AXrSWU4xuUA9rj
         5yOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786647531; x=1787252331;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=j7MPifKM0g+V499r8MTdHDoJMUDv6wW/Ghb2RIQSLiw=;
        b=kUKj+pwWlg7PTOM4HnIhvniUguyVlYsw/y2B9MPXxykLdR1nte8Vw1J0lnIvCJG09O
         LP/tVQnmEXxXPifaGrZ5itdBV28+4iuc9QefRn9uw76/R6CvsaMwkeXNdBAYvz3kre/2
         p4IhUzPJvZ+YnLpVvOw6UtuTMQJgqVYgIHNCroRVD3k8NNBTmvYpgAdFB2f1zvbeqNez
         mqjNHML4565bL2RSrhF7Es1W78bgBXrMOiRteJ2jt+TUo6lrjYxBUaXygCK/JViC/7+g
         gEiIQQldEsBiVfCL+wkm/2Qw0fuN1nusLFwwSu4JN8w1Mnsl++js4Ms7vxmQv3Oomoyf
         qALg==
X-Forwarded-Encrypted: i=1; AHgh+RorT59FinXq10QPj9dRDupfvG8ozrhB9kRMPfsLiNqbDXTiRSXDum8rfDqj45vs2XRc8iZzMIUg@vger.kernel.org
X-Gm-Message-State: AOJu0Yyh65gXzvOhJIvWDy/2y2pVsMLLzO0kYzOYEfxP9o4mUDUR6L6x
	f0KrM1y6OlWgGdygTBQH/QYaHcNlRNRipQI8fBAWIPJUufhQSjALEI1R
X-Gm-Gg: AR+sD12e6TMazBOS0rWlgOlh5vXfUGZ5PElAEj5jzItN8bkyhQkIE0KmPT4GzYIX0I3
	3f343lK4CW5o4KI4N3kZgrJEas+X5cTMlEt4h1fJjPAhwwMaJfk8tg0VdpXzYjskY5xM0HWgzZu
	5aTzhqDEASPUl04WRM3A/XH+iLIM+uSyRTF7b3N/SEjebQaXbJPhSjoADqFt/gpsIgzDhvSWzF5
	ISfktf1/KREqC40dban5YUItXrwgtL5zVKhgMVUOXFiIpezdeM26zHjWZUun/yEHTl/yA1oL2UH
	yK+RGocMs7XiVsXVhRwU1D+1W4wtQR2r4usx3Wg38AgO5w15UmJKBnBkZpBZSnl1lr6WLwo2kZv
	GjHFS5fWmF+9V3zKhJ2jnRjJ0h7AQ/95w6tBPxGECMYnhyK1FG23ukznwxRzzkljPWBNc5JzUXr
	Kv3IxAej3vyQDSKD8PB+Jxjt84gZQs2tljW1rmg3ajkZIrN41wxagGhlU=
X-Received: by 2002:a05:6a20:3d1c:b0:3c6:3c5b:f2e3 with SMTP id adf61e73a8af0-3cc5542340bmr10139073637.33.1786647531022;
        Thu, 13 Aug 2026 11:58:51 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:66::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31ebc75d8d6sm11208926eec.4.2026.08.13.11.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 11:58:50 -0700 (PDT)
From: Ziyang Men <ziyang.meme@gmail.com>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Ben Segall <bsegall@google.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Shuah Khan <shuah@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Mykola Lysenko <mykolal@meta.com>,
	Ziyang Men <ziyang.meme@gmail.com>,
	kernel-team@meta.com,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] cgroup, sched: add BPF kfuncs to read a cpu cgroup's stats
Date: Thu, 13 Aug 2026 11:58:45 -0700
Message-ID: <20260813185846.1216892-2-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260813185846.1216892-1-ziyang.meme@gmail.com>
References: <20260813185846.1216892-1-ziyang.meme@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds bpf kfuncs for the cgroup CPU controller, following the
memory controller kfuncs in mm/bpf_memcontrol.c.

Collecting cgroup statistics is expensive: the existing
method is to open and parse a cgroup file. memcg already has an
efficient alternative through BPF; this series extends that idea to cpu.

Design:
- Leave reading the CFS bandwidth counters to the BPF program. They are
  plain fields of tg->cfs_bandwidth, so they need no kernel code.
- Add one kfunc to compute the throttled time. This is necessary because
  it is a sum over every possible cpu, which a user cannot do itself.
- The bpf_cpu_cgroup_cputime() returns all five base CPU-time values in one
  call with one cputime_adjust().

The only part it touches the scheduler part is to discard the static for
throttled_time_self() in order to use externally.

The two kfuncs that take the rstat lock are KF_SLEEPABLE following idea
in the mm/bpf_memcontrol.c

Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Ziyang Men <ziyang.meme@gmail.com>
---
 include/linux/cgroup.h          | 15 +++++++
 kernel/cgroup/Makefile          |  2 +
 kernel/cgroup/bpf_cpu.c         | 80 +++++++++++++++++++++++++++++++++
 kernel/cgroup/cgroup-internal.h |  3 ++
 kernel/cgroup/rstat.c           | 42 +++++++++++++++++
 kernel/sched/core.c             |  2 +-
 6 files changed, 143 insertions(+), 1 deletion(-)
 create mode 100644 kernel/cgroup/bpf_cpu.c

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index f2aa46a4f871..d2a6b5efad51 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -923,4 +923,19 @@ struct cgroup *task_get_cgroup1(struct task_struct *tsk, int hierarchy_id);
 
 struct cgroup_of_peak *of_peak(struct kernfs_open_file *of);
 
+/* A cgroup's base CPU-time counters in microseconds, as cpu.stat prints them */
+struct cpu_cgroup_cputime {
+	u64 usage_usec;
+	u64 user_usec;
+	u64 system_usec;
+	u64 nice_usec;
+	u64 forceidle_usec;	/* 0 without CONFIG_SCHED_CORE */
+};
+
+/* A task_group's own throttled time in nanoseconds; see cpu.stat.local */
+struct task_group;
+#ifdef CONFIG_CFS_BANDWIDTH
+u64 throttled_time_self(struct task_group *tg);
+#endif
+
 #endif /* _LINUX_CGROUP_H */
diff --git a/kernel/cgroup/Makefile b/kernel/cgroup/Makefile
index ede31601a363..0ba59b7eef48 100644
--- a/kernel/cgroup/Makefile
+++ b/kernel/cgroup/Makefile
@@ -1,6 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-y := cgroup.o rstat.o namespace.o cgroup-v1.o freezer.o
 
+obj-$(CONFIG_BPF_SYSCALL) += bpf_cpu.o
+
 obj-$(CONFIG_CGROUP_FREEZER) += legacy_freezer.o
 obj-$(CONFIG_CGROUP_PIDS) += pids.o
 obj-$(CONFIG_CGROUP_RDMA) += rdma.o
diff --git a/kernel/cgroup/bpf_cpu.c b/kernel/cgroup/bpf_cpu.c
new file mode 100644
index 000000000000..6eb89c8e84fd
--- /dev/null
+++ b/kernel/cgroup/bpf_cpu.c
@@ -0,0 +1,80 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * CPU Controller-related BPF kfuncs
+ *
+ * bpf_cpu_cgroup_cputime() is defined in rstat.c, which owns the locking it
+ * needs, and only registered here.
+ *
+ * Author: Ziyang Men <ziyang.meme@gmail.com>
+ */
+
+#include <linux/bpf.h>
+#include <linux/btf_ids.h>
+#include <linux/cgroup.h>
+
+#include "cgroup-internal.h"
+
+__bpf_kfunc_start_defs();
+
+/**
+ * bpf_cpu_cgroup_flush_stats - Flush a cgroup's base CPU-time statistics
+ * @cgrp: cgroup to flush
+ *
+ * Propagate the cgroup's base CPU-time statistics up the cgroup tree.
+ */
+__bpf_kfunc void bpf_cpu_cgroup_flush_stats(struct cgroup *cgrp)
+{
+	css_rstat_flush(&cgrp->self);
+}
+
+/**
+ * bpf_cpu_cgroup_throttled_self - Read a cgroup's own throttled time
+ * @cgrp: cgroup to read from
+ *
+ * Return: The throttled time in microseconds, or 0 if config is off.
+ */
+__bpf_kfunc u64 bpf_cpu_cgroup_throttled_self(struct cgroup *cgrp)
+{
+/* cpu_cgrp_id needs the cpu controller, which CFS bandwidth depends on */
+#ifdef CONFIG_CFS_BANDWIDTH
+	struct cgroup_subsys_state *css;
+
+	guard(rcu)();
+
+	css = rcu_dereference(cgrp->subsys[cpu_cgrp_id]);
+	if (!css)
+		return 0;
+
+	return div_u64(throttled_time_self((struct task_group *)css),
+		       NSEC_PER_USEC);
+#else
+	return 0;
+#endif
+}
+
+__bpf_kfunc_end_defs();
+
+/* KF_SLEEPABLE keeps the rstat spinlock out of NMI */
+BTF_KFUNCS_START(bpf_cpu_cgroup_kfunc_ids)
+BTF_ID_FLAGS(func, bpf_cpu_cgroup_flush_stats, KF_SLEEPABLE)
+BTF_ID_FLAGS(func, bpf_cpu_cgroup_cputime, KF_SLEEPABLE)
+BTF_ID_FLAGS(func, bpf_cpu_cgroup_throttled_self)
+BTF_KFUNCS_END(bpf_cpu_cgroup_kfunc_ids)
+
+static const struct btf_kfunc_id_set bpf_cpu_cgroup_kfunc_set = {
+	.owner		= THIS_MODULE,
+	.set		= &bpf_cpu_cgroup_kfunc_ids,
+};
+
+static int __init bpf_cpu_cgroup_kfunc_init(void)
+{
+	int err;
+
+	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_UNSPEC,
+					&bpf_cpu_cgroup_kfunc_set);
+	if (err)
+		pr_warn("error while registering cpu cgroup kfuncs: %d\n", err);
+
+	return err;
+}
+late_initcall(bpf_cpu_cgroup_kfunc_init);
diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index 58797123b752..65f5b6318289 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -271,6 +271,9 @@ int css_rstat_init(struct cgroup_subsys_state *css);
 void css_rstat_exit(struct cgroup_subsys_state *css);
 int ss_rstat_init(struct cgroup_subsys *ss);
 void cgroup_base_stat_cputime_show(struct seq_file *seq);
+#ifdef CONFIG_BPF_SYSCALL
+void bpf_cpu_cgroup_cputime(struct cgroup *cgrp, struct cpu_cgroup_cputime *out);
+#endif
 
 /*
  * namespace.c
diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index de816a43db9f..f9e30719068e 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -752,6 +752,48 @@ void cgroup_base_stat_cputime_show(struct seq_file *seq)
 	cgroup_force_idle_show(seq, &bstat);
 }
 
+#ifdef CONFIG_BPF_SYSCALL
+
+__bpf_kfunc_start_defs();
+
+/**
+ * bpf_cpu_cgroup_cputime - Read a cgroup's base CPU-time data
+ * @cgrp: cgroup to read from
+ * @out: the data in microseconds. Zero it first: the verifier reads the
+ *       whole struct.
+ *
+ * Adjust once and fill all values.
+ */
+__bpf_kfunc void bpf_cpu_cgroup_cputime(struct cgroup *cgrp,
+					struct cpu_cgroup_cputime *out)
+{
+	struct cgroup_base_stat bstat;
+
+	if (cgroup_parent(cgrp)) {
+		__css_rstat_lock(&cgrp->self, -1);
+		bstat = cgrp->bstat;
+		cputime_adjust(&cgrp->bstat.cputime, &cgrp->prev_cputime,
+			       &bstat.cputime.utime, &bstat.cputime.stime);
+		__css_rstat_unlock(&cgrp->self, -1);
+	} else {
+		root_cgroup_cputime(&bstat);
+	}
+
+	out->usage_usec = div_u64(bstat.cputime.sum_exec_runtime, NSEC_PER_USEC);
+	out->user_usec = div_u64(bstat.cputime.utime, NSEC_PER_USEC);
+	out->system_usec = div_u64(bstat.cputime.stime, NSEC_PER_USEC);
+	out->nice_usec = div_u64(bstat.ntime, NSEC_PER_USEC);
+#ifdef CONFIG_SCHED_CORE
+	out->forceidle_usec = div_u64(bstat.forceidle_sum, NSEC_PER_USEC);
+#else
+	out->forceidle_usec = 0;
+#endif
+}
+
+__bpf_kfunc_end_defs();
+
+#endif /* CONFIG_BPF_SYSCALL */
+
 /* Add bpf kfuncs for css_rstat_updated() and css_rstat_flush() */
 BTF_KFUNCS_START(bpf_rstat_kfunc_ids)
 BTF_ID_FLAGS(func, css_rstat_updated)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 96226707c2f6..75735e0e81ef 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -10027,7 +10027,7 @@ static int cpu_cfs_stat_show(struct seq_file *sf, void *v)
 	return 0;
 }
 
-static u64 throttled_time_self(struct task_group *tg)
+u64 throttled_time_self(struct task_group *tg)
 {
 	int i;
 	u64 total = 0;
-- 
2.53.0-Meta

