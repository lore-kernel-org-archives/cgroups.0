From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH bpf-next v1 1/5] cgroup: bpf: add a hook for bpf progs to
 attach to rstat flushing
Date: Fri, 20 May 2022 01:21:29 +0000
Message-ID: <20220520012133.1217211-2-yosryahmed@google.com>
References: <20220520012133.1217211-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=69cx6mPg1rWURoZo4NX3ijOmJtwQkSNn64F/hEHNYSU=;
        b=BCreR+XUKTegtpZpREe5xPvg68UCcKsrUAIVbGh5bI2zogHrCn+YHLq0FMySF7Z8+U
         3nTv8stgycmvTmhhg+YPkCLz4UYr3ZJz7474U4xhyJE3TKlT4rYlAp0vn5NBMmGoe2ov
         dgweabl3iJGlpFuwJTqJRwak1koJWau8g/NP85L4CjmiJUzSKn4LzPc2hkHvubatyBQP
         /96s5b/5xzfSh2L2JFvPZ2hVNpAhSiLyYoCG5VatpXZ/1CZSaKHDY0Xa+XvkgrFotW3c
         B1tX82bRy1h3iblza4rY3Q+jRM97bMVY3aW48bY0dTk7oUfdIoNGjySPHVcDY3xSepq3
         Yujw==
In-Reply-To: <20220520012133.1217211-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>
Cc: Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

Add an empty bpf_rstat_flush() hook that is called during rstat
flushing. bpf programs that make use of rstat and want to flush their
stats can attach to bpf_rstat_flush().

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 kernel/cgroup/rstat.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 24b5c2ab5598..e7a88d2600bd 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -141,6 +141,12 @@ static struct cgroup *cgroup_rstat_cpu_pop_updated(struct cgroup *pos,
 	return pos;
 }
 
+/* A hook for bpf stat collectors to attach to and flush their stats */
+__weak noinline void bpf_rstat_flush(struct cgroup *cgrp,
+				     struct cgroup *parent, int cpu)
+{
+}
+
 /* see cgroup_rstat_flush() */
 static void cgroup_rstat_flush_locked(struct cgroup *cgrp, bool may_sleep)
 	__releases(&cgroup_rstat_lock) __acquires(&cgroup_rstat_lock)
@@ -168,6 +174,7 @@ static void cgroup_rstat_flush_locked(struct cgroup *cgrp, bool may_sleep)
 			struct cgroup_subsys_state *css;
 
 			cgroup_base_stat_flush(pos, cpu);
+			bpf_rstat_flush(pos, cgroup_parent(pos), cpu);
 
 			rcu_read_lock();
 			list_for_each_entry_rcu(css, &pos->rstat_css_list,
-- 
2.36.1.124.g0e6072fb45-goog

