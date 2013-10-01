From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [patch for-3.12] mm, memcg: protect mem_cgroup_read_events for cpu
 hotplug
Date: Tue, 1 Oct 2013 16:31:23 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1310011629350.27758@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version
         :content-type;
        bh=Licu6C83bW05qeMU0PnEBjvATaprv0Dy4UAXV2Y2ju0=;
        b=OSjCHGD4ImS9XMPvEjFyB/J1EfUWxuZdcbwcAq/vctQKDoQOOEsCCU2TyS36a4uAYb
         bsqYlLVsznG7OlqxipZux5t2JHaKRdUljwSWX2kytu6sWuhT3h2t7uMGnhAVDdTtaGqE
         bPBmC8WkCRWBffWLxj1WjutCbnmQsVh4My6HmM7IxvndGHQwUxCdguryQ50ABkvLICDt
         PpQYUC7SI1scl0uADlfWLvdIrJ149OqjYUVlJAuc+b5t8dw1ox+t7wtAHKOVjOxaSxn4
         duhORk1JwIFExBWh9COo0m6eVV+OZLfF9sWURQilAn8vTLL6ly1SaVkoYJFjulVtddOi
         AgpQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

for_each_online_cpu() needs the protection of {get,put}_online_cpus() so
cpu_online_mask doesn't change during the iteration.

Signed-off-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -866,6 +866,7 @@ static unsigned long mem_cgroup_read_events(struct mem_cgroup *memcg,
 	unsigned long val = 0;
 	int cpu;
 
+	get_online_cpus();
 	for_each_online_cpu(cpu)
 		val += per_cpu(memcg->stat->events[idx], cpu);
 #ifdef CONFIG_HOTPLUG_CPU
@@ -873,6 +874,7 @@ static unsigned long mem_cgroup_read_events(struct mem_cgroup *memcg,
 	val += memcg->nocpu_base.events[idx];
 	spin_unlock(&memcg->pcp_counter_lock);
 #endif
+	put_online_cpus();
 	return val;
 }
 
