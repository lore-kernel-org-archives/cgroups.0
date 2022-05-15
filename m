From: Yosry Ahmed <yosryahmed@google.com>
Subject: [RFC PATCH bpf-next v2 2/7] cgroup: bpf: flush bpf stats on rstat flush
Date: Sun, 15 May 2022 02:34:59 +0000
Message-ID: <20220515023504.1823463-3-yosryahmed@google.com>
References: <20220515023504.1823463-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=EUwJph95+QtgVEYpOk4h8MUmP3EN23IIGoIBGE07ovI=;
        b=PDZGlc0QzpODkc7dmkDeYxiYCZPbcORZBrrzUTn6k3D3SZY7PbQm0ZXd2IW+sOUcbS
         Xo/fMyFUqZ1MfPE7KjvD1HFOoKFRkYUHKAVvf1VIFlKP8N7bWGPWYWNRzEnXgpO2PIDH
         808VikSXzNhMH2ZaMUaHgFvbK6M6E+3CmGXWQ/tFRAUGdnThnx5OCM8tB0SDrpb5/K4M
         x0t6mUWNAKdmuRFlk6RTn9mfd5kqItz7GI+N7IBtsJPOKuErr9wiCmXd9ZHUnDVq8d/+
         QwUnKS3979H8Oq+Ejg40FwzfS7cnE1rESwD7zLfGGgUTKx3KVKQ81Nou3l0sEKcUR/hP
         jJBA==
In-Reply-To: <20220515023504.1823463-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>
Cc: Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

When an rstat flush is ongoing for a cgroup, also flush bpf stats by
running any attached rstat flush programs.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 include/linux/bpf-rstat.h |  6 ++++++
 kernel/bpf/rstat.c        | 21 +++++++++++++++++++++
 kernel/cgroup/rstat.c     |  2 ++
 3 files changed, 29 insertions(+)

diff --git a/include/linux/bpf-rstat.h b/include/linux/bpf-rstat.h
index 23cad23b5fc2..55e000fe0f47 100644
--- a/include/linux/bpf-rstat.h
+++ b/include/linux/bpf-rstat.h
@@ -12,6 +12,8 @@
 int bpf_rstat_link_attach(const union bpf_attr *attr,
 				 struct bpf_prog *prog);
 
+void bpf_rstat_flush(struct cgroup *cgrp, int cpu);
+
 #else /* defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_CGROUPS) */
 
 static inline int bpf_rstat_link_attach(const union bpf_attr *attr,
@@ -20,6 +22,10 @@ static inline int bpf_rstat_link_attach(const union bpf_attr *attr,
 	return -ENOTSUPP;
 }
 
+static inline void bpf_rstat_flush(struct cgroup *cgrp, int cpu)
+{
+}
+
 #endif /* defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_CGROUPS) */
 
 #endif  /* _BPF_RSTAT */
diff --git a/kernel/bpf/rstat.c b/kernel/bpf/rstat.c
index 5f529002d4b9..e96bc080f4b9 100644
--- a/kernel/bpf/rstat.c
+++ b/kernel/bpf/rstat.c
@@ -164,3 +164,24 @@ int bpf_rstat_link_attach(const union bpf_attr *attr,
 
 	return bpf_link_settle(&link_primer);
 }
+
+void bpf_rstat_flush(struct cgroup *cgrp, int cpu)
+{
+	struct bpf_rstat_flusher *flusher;
+	struct bpf_rstat_flush_ctx ctx = {
+		.cgrp = cgrp,
+		.parent = cgroup_parent(cgrp),
+		.cpu = cpu,
+	};
+
+	rcu_read_lock();
+	migrate_disable();
+	spin_lock(&bpf_rstat_flushers_lock);
+
+	list_for_each_entry(flusher, &bpf_rstat_flushers, list)
+		(void) bpf_prog_run(flusher->prog, &ctx);
+
+	spin_unlock(&bpf_rstat_flushers_lock);
+	migrate_enable();
+	rcu_read_unlock();
+}
diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 24b5c2ab5598..0285d496e807 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -2,6 +2,7 @@
 #include "cgroup-internal.h"
 
 #include <linux/sched/cputime.h>
+#include <linux/bpf-rstat.h>
 
 static DEFINE_SPINLOCK(cgroup_rstat_lock);
 static DEFINE_PER_CPU(raw_spinlock_t, cgroup_rstat_cpu_lock);
@@ -168,6 +169,7 @@ static void cgroup_rstat_flush_locked(struct cgroup *cgrp, bool may_sleep)
 			struct cgroup_subsys_state *css;
 
 			cgroup_base_stat_flush(pos, cpu);
+			bpf_rstat_flush(pos, cpu);
 
 			rcu_read_lock();
 			list_for_each_entry_rcu(css, &pos->rstat_css_list,
-- 
2.36.0.550.gb090851708-goog

