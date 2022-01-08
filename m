From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] cgroup: rstat: retrieve current bstat to delta directly
Date: Sat,  8 Jan 2022 00:38:17 +0000
Message-ID: <20220108003817.6619-2-richard.weiyang@gmail.com>
References: <20220108003817.6619-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0tl3tl0Rjc2H0O+Ee2YyH8tQI/ckCB3TAtw6D3Jv5pM=;
        b=adrk8Xw7lRyfAdM25xuBROnlbcbIFuOH92rt485pDgwwZdlOz2u5Yz1u2I8lc6MJQl
         HDg2dxVdKKlLxzHauMj8/yUrURVEd7WRrZ3cqjaNIdwAn+ehUVzwpb0kg7CTLL/WlGin
         lSNEJ/JsbcPp4ml4ICZs1p0pzbVLfRRe/6KTSpr5Gvo9Jgo0roCK4h23XAfRePsqnolr
         LHVKibo5T+STaa19Id/Um9Gj1qNrSnBnJ2QCYkewrZPUJc2UYf0y7Zn+MGV4AoxYW/4q
         arvSMjdA1/ihdOJyKUsw3H98k79N5gW2afa62fQSAMmSmCzjjhE19NiktT0izGYxf4Yc
         2agQ==
In-Reply-To: <20220108003817.6619-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Instead of retrieve current bstat to cur and copy it to delta, let's use
delta directly.

This saves one copy operation and has the same code convention as
propagating delta to parent.

Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup/rstat.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index c626d5a526c4..f66944c53613 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -314,7 +314,7 @@ static void cgroup_base_stat_flush(struct cgroup *cgrp, int cpu)
 {
 	struct cgroup_rstat_cpu *rstatc = cgroup_rstat_cpu(cgrp, cpu);
 	struct cgroup *parent = cgroup_parent(cgrp);
-	struct cgroup_base_stat cur, delta;
+	struct cgroup_base_stat delta;
 	unsigned seq;
 
 	/* Root-level stats are sourced from system-wide CPU stats */
@@ -324,11 +324,10 @@ static void cgroup_base_stat_flush(struct cgroup *cgrp, int cpu)
 	/* fetch the current per-cpu values */
 	do {
 		seq = __u64_stats_fetch_begin(&rstatc->bsync);
-		cur = rstatc->bstat;
+		delta = rstatc->bstat;
 	} while (__u64_stats_fetch_retry(&rstatc->bsync, seq));
 
 	/* propagate percpu delta to global */
-	delta = cur;
 	cgroup_base_stat_sub(&delta, &rstatc->last_bstat);
 	cgroup_base_stat_add(&cgrp->bstat, &delta);
 	cgroup_base_stat_add(&rstatc->last_bstat, &delta);
-- 
2.33.1

