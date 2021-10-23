From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH memcg v3 1/3] mm, oom: pagefault_out_of_memory: don't force
 global OOM for dying tasks
Date: Sat, 23 Oct 2021 16:19:28 +0300
Message-ID: <0828a149-786e-7c06-b70a-52d086818ea3@virtuozzo.com>
References: <YXJ/63kIpTq8AOlD@dhcp22.suse.cz>
 <cover.1634994605.git.vvs@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=DX974UacjLa5B8lLKBDGYPr0ueCh9q/0PqGjv1EsfYw=; b=Qqybfz2pU+1i6qU1cl+
        n1/Ryq+c0MgrgrTKsIr+zAZ1FcRW64LaQxmTNiUdj22yblJrcLgq8hzUJ6nLnvPsVJAJt72LMbhfw
        +odGC3WfLkhI4RMty6rnyhpI2Nrq4jD4t5JdjGwt3X6OlFXMtqtk18+4yM2yEuiOzojbz5hH3hs=;
In-Reply-To: <cover.1634994605.git.vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

Any allocation failure during the #PF path will return with VM_FAULT_OOM
which in turn results in pagefault_out_of_memory which in own turn
executes out_out_memory() and can kill a random task.

An allocation might fail when the current task is the oom victim
and there are no memory reserves left. The OOM killer is already
handled at the page allocator level for the global OOM and at the
charging level for the memcg one. Both have much more information
about the scope of allocation/charge request. This means that
either the OOM killer has been invoked properly and didn't lead
to the allocation success or it has been skipped because it couldn't
have been invoked. In both cases triggering it from here is pointless
and even harmful.

It makes much more sense to let the killed task die rather than to
wake up an eternally hungry oom-killer and send him to choose a fatter
victim for breakfast.

Suggested-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 mm/oom_kill.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 831340e7ad8b..1deef8c7a71b 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -1137,6 +1137,9 @@ void pagefault_out_of_memory(void)
 	if (mem_cgroup_oom_synchronize(true))
 		return;
 
+	if (fatal_signal_pending(current))
+		return;
+
 	if (!mutex_trylock(&oom_lock))
 		return;
 	out_of_memory(&oc);
-- 
2.32.0

