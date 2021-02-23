From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] memcg: enable memcg oom-kill for __GFP_NOFAIL
Date: Tue, 23 Feb 2021 12:43:37 -0800
Message-ID: <20210223204337.2785120-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=tAEo4In/0gx3aeLrRSAmN7UQ8VKqv74lEJhxcNM3pDE=;
        b=pNq6leRfIEyTpbzdvnSYqIa5/6uoeglwemLjqUX0IiWI8TeuF2G5lJMdEEeNcMegkl
         O8gXSmRbFBDs2+LfUtiO8uqvdm+8+6zCwGPlI1kuN6m/K6h4DYXcZQtK5IOqx9zVk4+n
         TUHEIgVRaat0jXeawkQ6LznVLYTsonjsmiFtth44j9oUWYUJyNwp9iM0lUduBUWN4odo
         YvTirH9MQ2knks30Akq6f3ezOTsPcfx/lQ2Z7GKBNvRzoihVWJrOFBn87IWdovViuj4s
         AYm2f0MuddRZ6VYqA/eHzlzS2FhYT/6lCwleqtKPCJpCUgCCiOF2r2v9A7ijcwQ0mMaw
         m46g==
Sender: "shakeelb via sendgmr" <shakeelb-rSQFlI6iZjOvss2yl3NHrPyj43VRqXoZVpNB7YpNyf8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

In the era of async memcg oom-killer, the commit a0d8b00a3381 ("mm:
memcg: do not declare OOM from __GFP_NOFAIL allocations") added the code
to skip memcg oom-killer for __GFP_NOFAIL allocations. The reason was
that the __GFP_NOFAIL callers will not enter aync oom synchronization
path and will keep the task marked as in memcg oom. At that time the
tasks marked in memcg oom can bypass the memcg limits and the oom
synchronization would have happened later in the later userspace
triggered page fault. Thus letting the task marked as under memcg oom
bypass the memcg limit for arbitrary time.

With the synchronous memcg oom-killer (commit 29ef680ae7c21 ("memcg,
oom: move out_of_memory back to the charge path")) and not letting the
task marked under memcg oom to bypass the memcg limits (commit
1f14c1ac19aa4 ("mm: memcg: do not allow task about to OOM kill to bypass
the limit")), we can again allow __GFP_NOFAIL allocations to trigger
memcg oom-kill. This will make memcg oom behavior closer to page
allocator oom behavior.

Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2db2aeac8a9e..dcb5665aeb69 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2797,9 +2797,6 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (gfp_mask & __GFP_RETRY_MAYFAIL)
 		goto nomem;
 
-	if (gfp_mask & __GFP_NOFAIL)
-		goto force;
-
 	if (fatal_signal_pending(current))
 		goto force;
 
-- 
2.30.0.617.g56c4b15f3c-goog

