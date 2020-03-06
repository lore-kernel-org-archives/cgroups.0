From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] memcg: optimize memory.numa_stat like memory.stat
Date: Thu, 5 Mar 2020 20:41:09 -0800
Message-ID: <20200305204109.be23f5053e2368d3b8ccaa06@linux-foundation.org>
References: <20200304022058.248270-1-shakeelb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583469670;
        bh=jMaNzWwGNyJXrXRBCiJpddGoeLBF0dNI2ZOpUjqJRJQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mGdiXoYeYvFstIQEK7caAUrHjH8h4/xKtNznaLuGjgXgOFKJjYQw11NyqgTvnY4/M
         sU4aRm7gnUt4at7lCieJSD8xlulHfvn+rD51LaJwEQWd5XjtV4rrtX+TQA7R24EV2o
         Gz7apFZYMLJ5s7t0ZDiIIkveSU4NKvblbLuQXVFM=
In-Reply-To: <20200304022058.248270-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue,  3 Mar 2020 18:20:58 -0800 Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> Currently reading memory.numa_stat traverses the underlying memcg tree
> multiple times to accumulate the stats to present the hierarchical view
> of the memcg tree. However the kernel already maintains the hierarchical
> view of the stats and use it in memory.stat. Just use the same mechanism
> in memory.numa_stat as well.
> 
> I ran a simple benchmark which reads root_mem_cgroup's memory.numa_stat
> file in the presense of 10000 memcgs. The results are:
> 
> Without the patch:
> $ time cat /dev/cgroup/memory/memory.numa_stat > /dev/null
> 
> real    0m0.700s
> user    0m0.001s
> sys     0m0.697s
> 
> With the patch:
> $ time cat /dev/cgroup/memory/memory.numa_stat > /dev/null
> 
> real    0m0.001s
> user    0m0.001s
> sys     0m0.000s
> 

Can't you do better than that ;)

>
> +	page_state = tree ? lruvec_page_state : lruvec_page_state_local;
> ...
>
> +	page_state = tree ? memcg_page_state : memcg_page_state_local;
>

All four of these functions are inlined.  Taking their address in this
fashion will force the compiler to generate out-of-line copies.

If we do it the uglier-and-maybe-a-bit-slower way:

--- a/mm/memcontrol.c~memcg-optimize-memorynuma_stat-like-memorystat-fix
+++ a/mm/memcontrol.c
@@ -3658,17 +3658,16 @@ static unsigned long mem_cgroup_node_nr_
 	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 	unsigned long nr = 0;
 	enum lru_list lru;
-	unsigned long (*page_state)(struct lruvec *lruvec,
-				    enum node_stat_item idx);
 
 	VM_BUG_ON((unsigned)nid >= nr_node_ids);
 
-	page_state = tree ? lruvec_page_state : lruvec_page_state_local;
-
 	for_each_lru(lru) {
 		if (!(BIT(lru) & lru_mask))
 			continue;
-		nr += page_state(lruvec, NR_LRU_BASE + lru);
+		if (tree)
+			nr += lruvec_page_state(lruvec, NR_LRU_BASE + lru);
+		else
+			nr += lruvec_page_state_local(lruvec, NR_LRU_BASE + lru);
 	}
 	return nr;
 }
@@ -3679,14 +3678,14 @@ static unsigned long mem_cgroup_nr_lru_p
 {
 	unsigned long nr = 0;
 	enum lru_list lru;
-	unsigned long (*page_state)(struct mem_cgroup *memcg, int idx);
-
-	page_state = tree ? memcg_page_state : memcg_page_state_local;
 
 	for_each_lru(lru) {
 		if (!(BIT(lru) & lru_mask))
 			continue;
-		nr += page_state(memcg, NR_LRU_BASE + lru);
+		if (tree)
+			nr += memcg_page_state(memcg, NR_LRU_BASE + lru);
+		else
+			nr += memcg_page_state_local(memcg, NR_LRU_BASE + lru);
 	}
 	return nr;
 }

Then we get:

                     text    data     bss     dec     hex filename
now:               106705   35641    1024  143370   2300a mm/memcontrol.o
shakeel:           107111   35657    1024  143792   231b0 mm/memcontrol.o
shakeel+the-above: 106805   35657    1024  143486   2307e mm/memcontrol.o

Which do we prefer?  The 100-byte patch or the 406-byte patch?
