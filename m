From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 -mm 1/2] memcg: remove unused mem_cgroup->oom_wakeups
Date: Thu, 4 Jun 2015 00:19:53 +0900
Message-ID: <20150603151953.GF20091@mtj.duckdns.org>
References: <20150603023824.GA7579@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=upFyJDNLHFFYB5uBsOHr69D6lHrPQI4tK68E+U/uTPk=;
        b=Sc9f5y9/vgGj5pi4QQMnrOyGLHOHcaOc9xOVdqy26l9VnDzUxJDggwgmc1yxeT/WG7
         8RoQY3yRjg0PDrxUw9Bd+8L6Z+O/YsYrbKTiKO7Mq2eHKKGDVwe0Ehhv1LzMQNd5ljO1
         aSZr/d8/pRgFhYVD7LL7gon4OtF0G+rO+505/hYQ97WHk95WMfo8tEI1fZz6Z46k7P/I
         eJkJ2HP9W9Is29Jgl2LMCVw2FZkNSkRlaSjBoM+3m2h2yP6XmTbPI5hPbsOZWEyePwq0
         wUTcyV7BxkT2sUKY1NbZq5eP0NOXWtKx1prB+K/0kFe3PyxH8c5tARDHKoiKdLSEwoxz
         3SWA==
Content-Disposition: inline
In-Reply-To: <20150603023824.GA7579-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Since 4942642080ea ("mm: memcg: handle non-error OOM situations more
gracefully"), nobody uses mem_cgroup->oom_wakeups.  Remove it.

While at it, also fold memcg_wakeup_oom() into memcg_oom_recover()
which is its only user.  This cleanup was suggested by Michal.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
Patch updated.  I dropped the comment as it's kinda obvious from the
context and the use of __wake_up().

Thanks.

 mm/memcontrol.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -287,7 +287,6 @@ struct mem_cgroup {
 
 	bool		oom_lock;
 	atomic_t	under_oom;
-	atomic_t	oom_wakeups;
 
 	int	swappiness;
 	/* OOM-Killer disable */
@@ -1850,17 +1849,10 @@ static int memcg_oom_wake_function(wait_
 	return autoremove_wake_function(wait, mode, sync, arg);
 }
 
-static void memcg_wakeup_oom(struct mem_cgroup *memcg)
-{
-	atomic_inc(&memcg->oom_wakeups);
-	/* for filtering, pass "memcg" as argument. */
-	__wake_up(&memcg_oom_waitq, TASK_NORMAL, 0, memcg);
-}
-
 static void memcg_oom_recover(struct mem_cgroup *memcg)
 {
 	if (memcg && atomic_read(&memcg->under_oom))
-		memcg_wakeup_oom(memcg);
+		__wake_up(&memcg_oom_waitq, TASK_NORMAL, 0, memcg);
 }
 
 static void mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int order)
