From: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2, 3/4] mm, memcg: Prevent memory.oom_control load/store tearing
Date: Mon,  6 Mar 2023 23:41:37 +0800
Message-ID: <20230306154138.3775-4-findns94@gmail.com>
References: <20230306154138.3775-1-findns94@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678117337;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Pu8gC0LE8S+gTMZ95T5G8zWPtdy0mtS5OOYges0wR78=;
        b=SktXouP2u6iR+PuI3ihPB0oXgFl+wFxiiVq1JIZ3tE+tE4sOmr1Lbs5jbm66PznnlR
         kovLcAf/bc063xYce2U2FcEy7NfMkuYO8JoFH7K31GVBQBb6xAM2vzsJSlhVeunCYvRD
         8EdtfAd7SDVWsB9Tp4JRbo732vcFHfMtgysX4rMVavgWY5Mox+K5fKlvGPputGgXIgaG
         DM57pLuWYHI3SwiTgJOzdvKFOO3gi8g3VBC8aMOstDyDvaevAbq4cFxgSKqswnbda0b0
         nuxqThgomDx5Q1b2CAAy4IcQSGnfRE/6ejxbCiihoVF8U3zSeZ8nwbRo1HagXKSqXp0x
         kHVg==
In-Reply-To: <20230306154138.3775-1-findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tangyeechou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

The knob for cgroup v1 memory controller: memory.oom_control
is not protected by any locking so it can be modified while it is used.
This is not an actual problem because races are unlikely.
But it is better to use READ_ONCE/WRITE_ONCE to prevent compiler from
doing anything funky.

The access of memcg->oom_kill_disable is lockless,
so it can be concurrently set at the same time as we are
trying to read it.

Signed-off-by: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index dca895c66a9b..26605b2f51b1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4515,7 +4515,7 @@ static int mem_cgroup_oom_control_read(struct seq_file *sf, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(sf);
 
-	seq_printf(sf, "oom_kill_disable %d\n", memcg->oom_kill_disable);
+	seq_printf(sf, "oom_kill_disable %d\n", READ_ONCE(memcg->oom_kill_disable));
 	seq_printf(sf, "under_oom %d\n", (bool)memcg->under_oom);
 	seq_printf(sf, "oom_kill %lu\n",
 		   atomic_long_read(&memcg->memory_events[MEMCG_OOM_KILL]));
@@ -4531,7 +4531,7 @@ static int mem_cgroup_oom_control_write(struct cgroup_subsys_state *css,
 	if (mem_cgroup_is_root(memcg) || !((val == 0) || (val == 1)))
 		return -EINVAL;
 
-	memcg->oom_kill_disable = val;
+	WRITE_ONCE(memcg->oom_kill_disable, val);
 	if (!val)
 		memcg_oom_recover(memcg);
 
-- 
2.17.1

