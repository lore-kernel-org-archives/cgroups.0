From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] memcg: optimize memory.numa_stat like memory.stat
Date: Thu, 23 Apr 2020 16:10:09 -0700
Message-ID: <20200423161009.973c645420a4d17ded2a67ee@linux-foundation.org>
References: <20200304022058.248270-1-shakeelb@google.com>
        <20200305204109.be23f5053e2368d3b8ccaa06@linux-foundation.org>
        <CALvZod7W-Qwa4BRKW0_Ts5f68fwkcqD72SF_4NqZRgEMgA_1-g@mail.gmail.com>
        <CALvZod4R68wNgzOF9dN=i6LwyUYMBhvM7SXaRJGW9Wn_SmeGGA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587683410;
        bh=igt1K/a1ZMxJiTPpRElNSn87vNdw8wzrU/2oEcIWO+I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zJjycQhOOkbHFuEq2ic7HPwLXbL4kcXh8j0YbwEliwqANWjvplYZB3Vc9h24jK6ay
         5nBE4e1ZOlWoMaDWMu/AKWNiLLALT5keROykushwTF9e+05WMJFNa3ben3F3qUOE3G
         x/+i15LpU0m/5eKFhKcitOfYP5J3CXXPmIRgBcP0=
In-Reply-To: <CALvZod4R68wNgzOF9dN=i6LwyUYMBhvM7SXaRJGW9Wn_SmeGGA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Thu, 23 Apr 2020 15:59:41 -0700 Shakeel Butt <shakeelb@google.com> wrote:

> > >                      text    data     bss     dec     hex filename
> > > now:               106705   35641    1024  143370   2300a mm/memcontrol.o
> > > shakeel:           107111   35657    1024  143792   231b0 mm/memcontrol.o
> > > shakeel+the-above: 106805   35657    1024  143486   2307e mm/memcontrol.o
> > >
> > > Which do we prefer?  The 100-byte patch or the 406-byte patch?
> >
> > I would go with the 100-byte one. The for-loop is just 5 iteration, so
> > doing a check in each iteration should not be an issue.
> >
> 
> Andrew, anything more needed for this patch to be merged?

Some feedback from hannes & mhocko would be appreciated?


From: Shakeel Butt <shakeelb@google.com>
Subject: mm/memcg: optimize memory.numa_stat like memory.stat

Currently reading memory.numa_stat traverses the underlying memcg tree
multiple times to accumulate the stats to present the hierarchical view of
the memcg tree.  However the kernel already maintains the hierarchical
view of the stats and use it in memory.stat.  Just use the same mechanism
in memory.numa_stat as well.

I ran a simple benchmark which reads root_mem_cgroup's memory.numa_stat
file in the presense of 10000 memcgs.  The results are:

Without the patch:
$ time cat /dev/cgroup/memory/memory.numa_stat > /dev/null

real    0m0.700s
user    0m0.001s
sys     0m0.697s

With the patch:
$ time cat /dev/cgroup/memory/memory.numa_stat > /dev/null

real    0m0.001s
user    0m0.001s
sys     0m0.000s

[akpm@linux-foundation.org: avoid forcing out-of-line code generation]
Link: http://lkml.kernel.org/r/20200304022058.248270-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   49 +++++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 24 deletions(-)

--- a/mm/memcontrol.c~memcg-optimize-memorynuma_stat-like-memorystat
+++ a/mm/memcontrol.c
@@ -3688,7 +3688,7 @@ static int mem_cgroup_move_charge_write(
 #define LRU_ALL	     ((1 << NR_LRU_LISTS) - 1)
 
 static unsigned long mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
-					   int nid, unsigned int lru_mask)
+				int nid, unsigned int lru_mask, bool tree)
 {
 	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 	unsigned long nr = 0;
@@ -3699,13 +3699,17 @@ static unsigned long mem_cgroup_node_nr_
 	for_each_lru(lru) {
 		if (!(BIT(lru) & lru_mask))
 			continue;
-		nr += lruvec_page_state_local(lruvec, NR_LRU_BASE + lru);
+		if (tree)
+			nr += lruvec_page_state(lruvec, NR_LRU_BASE + lru);
+		else
+			nr += lruvec_page_state_local(lruvec, NR_LRU_BASE + lru);
 	}
 	return nr;
 }
 
 static unsigned long mem_cgroup_nr_lru_pages(struct mem_cgroup *memcg,
-					     unsigned int lru_mask)
+					     unsigned int lru_mask,
+					     bool tree)
 {
 	unsigned long nr = 0;
 	enum lru_list lru;
@@ -3713,7 +3717,10 @@ static unsigned long mem_cgroup_nr_lru_p
 	for_each_lru(lru) {
 		if (!(BIT(lru) & lru_mask))
 			continue;
-		nr += memcg_page_state_local(memcg, NR_LRU_BASE + lru);
+		if (tree)
+			nr += memcg_page_state(memcg, NR_LRU_BASE + lru);
+		else
+			nr += memcg_page_state_local(memcg, NR_LRU_BASE + lru);
 	}
 	return nr;
 }
@@ -3733,34 +3740,28 @@ static int memcg_numa_stat_show(struct s
 	};
 	const struct numa_stat *stat;
 	int nid;
-	unsigned long nr;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
 	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
-		nr = mem_cgroup_nr_lru_pages(memcg, stat->lru_mask);
-		seq_printf(m, "%s=%lu", stat->name, nr);
-		for_each_node_state(nid, N_MEMORY) {
-			nr = mem_cgroup_node_nr_lru_pages(memcg, nid,
-							  stat->lru_mask);
-			seq_printf(m, " N%d=%lu", nid, nr);
-		}
+		seq_printf(m, "%s=%lu", stat->name,
+			   mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
+						   false));
+		for_each_node_state(nid, N_MEMORY)
+			seq_printf(m, " N%d=%lu", nid,
+				   mem_cgroup_node_nr_lru_pages(memcg, nid,
+							stat->lru_mask, false));
 		seq_putc(m, '\n');
 	}
 
 	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
-		struct mem_cgroup *iter;
 
-		nr = 0;
-		for_each_mem_cgroup_tree(iter, memcg)
-			nr += mem_cgroup_nr_lru_pages(iter, stat->lru_mask);
-		seq_printf(m, "hierarchical_%s=%lu", stat->name, nr);
-		for_each_node_state(nid, N_MEMORY) {
-			nr = 0;
-			for_each_mem_cgroup_tree(iter, memcg)
-				nr += mem_cgroup_node_nr_lru_pages(
-					iter, nid, stat->lru_mask);
-			seq_printf(m, " N%d=%lu", nid, nr);
-		}
+		seq_printf(m, "hierarchical_%s=%lu", stat->name,
+			   mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
+						   true));
+		for_each_node_state(nid, N_MEMORY)
+			seq_printf(m, " N%d=%lu", nid,
+				   mem_cgroup_node_nr_lru_pages(memcg, nid,
+							stat->lru_mask, true));
 		seq_putc(m, '\n');
 	}
 
_

