From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH mmotm] mm, oom: reduce dependency on tasklist_lock: fix
Date: Mon, 16 Jul 2012 00:42:37 -0700 (PDT)
Message-ID: <alpine.LSU.2.00.1207160039120.3936@eggly.anvils>
References: <alpine.DEB.2.00.1206251846020.24838@chino.kir.corp.google.com> <alpine.DEB.2.00.1206291404530.6040@chino.kir.corp.google.com> <alpine.DEB.2.00.1206291406110.6040@chino.kir.corp.google.com> <20120713143206.GA4511@tiehlicka.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=nkf+6cmJt43DWPt8a6uISw2leG1BsUreICLpd9ovVuI=;
        b=Y1yrrqvs9imZ2dOhw3ESDzalQ391To27j012elBIuvzyCesny46ArBNmLSvyccnLJG
         3xspimDNw2QG6uRmM7spF/0a2RsJMsCqPRyV1rg16ClG+3fe1AObHlOEOg5U8nCqdtrx
         m41pvAmik26dohiGro98o1vdpsOUykL1lDcB0tv53R3FQy4ZvotBdJX5TzRoMpXsdhkc
         WO0IoMaU8RTVzq6VmUnq+QUNctEgM03GYcQz+ZApGDGDDdyP1yHjmyEG7tZGP+ILvbe4
         4Qws8kGH0WHKjB36GZUtMqd3kn/+1ogZilVqiRMqzK7OzKsz9kB/9dYh59/uFKS1f4DD
         /p8w==
In-Reply-To: <20120713143206.GA4511-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Slab poisoning gave me a General Protection Fault on the
	atomic_dec(&__task_cred(p)->user->processes);
line of release_task() called from wait_task_zombie(),
every time my dd to USB testing generated a memcg OOM.

oom_kill_process() now does the put_task_struct(),
mem_cgroup_out_of_memory() should not repeat it.

Signed-off-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---

 mm/memcontrol.c |    1 -
 1 file changed, 1 deletion(-)

--- mmotm/mm/memcontrol.c	2012-07-11 14:50:29.808349013 -0700
+++ linux/mm/memcontrol.c	2012-07-15 12:21:26.234289161 -0700
@@ -1533,7 +1533,6 @@ void mem_cgroup_out_of_memory(struct mem
 	points = chosen_points * 1000 / totalpages;
 	oom_kill_process(chosen, gfp_mask, order, points, totalpages, memcg,
 			 NULL, "Memory cgroup out of memory");
-	put_task_struct(chosen);
 }
 
 static unsigned long mem_cgroup_reclaim(struct mem_cgroup *memcg,
