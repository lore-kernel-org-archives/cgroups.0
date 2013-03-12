From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/6] memcg: Don't account root memcg PGFAULT/PGMAJFAULT events
Date: Tue, 12 Mar 2013 18:11:08 +0800
Message-ID: <1363083068-3867-1-git-send-email-handai.szj@taobao.com>
References: <1363082773-3598-1-git-send-email-handai.szj@taobao.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=H+3P8XadaN0y7hMiZT2Eb5LUMHe7zEQmW0yMoXSF++s=;
        b=UxVJ3b4wo87sqVPkUqKI6ZCBO36xNWHosGEdqymTZG8EVGNr2EbuIXzHS1SD9KURCW
         5SS2be8thJHK6y75Zs2mwJj8ePvKMC6ipZL7cO9alxyPH3qC6tjBvmZwDHCRiKhJ/b6K
         31VyGCDhaSk6Jnxh6xVfPo4TlWED7ofYavvcSR3TBmBq+vR+s3GAlxOkknP/AbMKNP91
         PIkctTa8nTHomRpvwb52gZ+lrZdFC/rDC1yTi8oCQ2jV6+QGheUG7qT0rV2ePw9sMMxW
         NyyHUYD+uHJAiIFqv9PO78SfGRQrlkoNia+dg32O+IjieyOt5hMfJzQ8rkxh0Mndbpm3
         rtsw==
In-Reply-To: <1363082773-3598-1-git-send-email-handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: mhocko-AlSwsSmVLrQ@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

Use the similar way to handle root memcg PGFAULT/PGMAJFAULT events.
So
	nr(MEM_CGROUP_EVENTS_PGFAULT/PGMAJFAULT) = global_event_states -
		sum_of_all_memcg(MEM_CGROUP_EVENTS_PGFAULT/PGMAJFAULT);

Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c |   50 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 47 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b73758e..cea4b02 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -53,6 +53,7 @@
 #include <linux/page_cgroup.h>
 #include <linux/cpu.h>
 #include <linux/oom.h>
+#include <linux/vmstat.h>
 #include "internal.h"
 #include <net/sock.h>
 #include <net/ip.h>
@@ -1252,6 +1253,10 @@ void __mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx)
 
 	rcu_read_lock();
 	memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
+
+	if (mem_cgroup_is_root(memcg))
+		goto out;
+
 	if (unlikely(!memcg))
 		goto out;
 
@@ -4983,6 +4988,18 @@ static unsigned long mem_cgroup_recursive_stat(struct mem_cgroup *memcg,
 	return val;
 }
 
+static unsigned long mem_cgroup_recursive_events(struct mem_cgroup *memcg,
+					       enum mem_cgroup_events_index idx)
+{
+	struct mem_cgroup *iter;
+	unsigned long val = 0;
+
+	for_each_mem_cgroup_tree(iter, memcg)
+		val += mem_cgroup_read_events(iter, idx);
+
+	return val;
+}
+
 static inline u64 mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
 {
 	u64 val;
@@ -5455,6 +5472,7 @@ static int memcg_stat_show(struct cgroup *cont, struct cftype *cft,
 	enum zone_stat_item global_stat[] = {NR_FILE_PAGES, NR_ANON_PAGES,
 					NR_FILE_MAPPED};
 	long root_stat[MEM_CGROUP_STAT_NSTATS] = {0};
+	unsigned long root_events[MEM_CGROUP_EVENTS_NSTATS] = {0};
 
 	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
 		long val = 0;
@@ -5475,9 +5493,30 @@ static int memcg_stat_show(struct cgroup *cont, struct cftype *cft,
 					val * PAGE_SIZE);
 	}
 
-	for (i = 0; i < MEM_CGROUP_EVENTS_NSTATS; i++)
-		seq_printf(m, "%s %lu\n", mem_cgroup_events_names[i],
-			   mem_cgroup_read_events(memcg, i));
+	for (i = 0; i < MEM_CGROUP_EVENTS_NSTATS; i++) {
+		unsigned long val = 0;
+
+		if (mem_cgroup_is_root(memcg) &&
+			((i == MEM_CGROUP_EVENTS_PGFAULT) ||
+			  i == MEM_CGROUP_EVENTS_PGMAJFAULT)) {
+			int cpu;
+
+			get_online_cpus();
+			for_each_online_cpu(cpu) {
+				struct vm_event_state *this = &per_cpu(vm_event_states, cpu);
+				if (i == MEM_CGROUP_EVENTS_PGFAULT)
+					val += this->event[PGFAULT];
+				else
+					val += this->event[PGMAJFAULT];
+			}
+			put_online_cpus();
+
+			val = val - mem_cgroup_recursive_events(memcg, i);
+			root_events[i] = val = val < 0 ? 0 : val;
+		} else
+			val = mem_cgroup_read_events(memcg, i);
+		seq_printf(m, "%s %lu\n", mem_cgroup_events_names[i], val);
+	}
 
 	for (i = 0; i < NR_LRU_LISTS; i++)
 		seq_printf(m, "%s %lu\n", mem_cgroup_lru_names[i],
@@ -5513,6 +5552,11 @@ static int memcg_stat_show(struct cgroup *cont, struct cftype *cft,
 
 		for_each_mem_cgroup_tree(mi, memcg)
 			val += mem_cgroup_read_events(mi, i);
+
+		/* Adding local events of root memcg */
+		if (mem_cgroup_is_root(memcg))
+			val += root_events[i];
+
 		seq_printf(m, "total_%s %llu\n",
 			   mem_cgroup_events_names[i], val);
 	}
-- 
1.7.9.5
