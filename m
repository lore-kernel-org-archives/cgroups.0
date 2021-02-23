From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] memcg: cleanup root memcg checks
Date: Tue, 23 Feb 2021 12:56:25 -0800
Message-ID: <20210223205625.2792891-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=VjQqR/dV9CmTvhJpIjv+GuV8z4P1stvvAwZgqfJoGxA=;
        b=mbSLgPRCosw1LgNbfZCQnOf60JkRnE/oZ2dfceOMIrdTSFDoq5FVwWZlenlEN3duNu
         LohQcoryhXyJfYxvHKWMDVRZhlyTZN7TguKnQS+JgyeHcABPQA1vfuCU7zw9y6PF1NOv
         vGNMRvc4MSRHE6B10Jeh5MZeB0RSzfOZyOgAKPzC3jN/FH0WswJOXI6mLvbQZC2XS8eW
         CD7xkAu51CFETtgUy622hl5ARPc+8WRj+WqSjXWQPSYcsO4OkXu6hPon8zk01OvAKWke
         aFpjOavUMmudXnqIgS/YEaSbEtC8nBwWU4YEvd78Nyscbp3L6S+HxqkqJOSntxdwCHId
         MHBQ==
Sender: "shakeelb via sendgmr" <shakeelb-rSQFlI6iZjOvss2yl3NHrPyj43VRqXoZVpNB7YpNyf8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Replace the implicit checking of root memcg with explicit root memcg
checking i.e. !css->parent with mem_cgroup_is_root().

Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index dcb5665aeb69..79046ad3eec0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4141,7 +4141,7 @@ static int mem_cgroup_swappiness_write(struct cgroup_subsys_state *css,
 	if (val > 100)
 		return -EINVAL;
 
-	if (css->parent)
+	if (!mem_cgroup_is_root(memcg))
 		memcg->swappiness = val;
 	else
 		vm_swappiness = val;
@@ -4491,7 +4491,7 @@ static int mem_cgroup_oom_control_write(struct cgroup_subsys_state *css,
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
 	/* cannot set to root cgroup and only 0 and 1 are allowed */
-	if (!css->parent || !((val == 0) || (val == 1)))
+	if (mem_cgroup_is_root(memcg) || !((val == 0) || (val == 1)))
 		return -EINVAL;
 
 	memcg->oom_kill_disable = val;
-- 
2.30.0.617.g56c4b15f3c-goog

