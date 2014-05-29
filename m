From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [patch 0/9] mm: memcontrol: naturalize charge lifetime v2
Date: Thu, 29 May 2014 12:15:52 -0400
Message-ID: <1401380162-24121-1-git-send-email-hannes@cmpxchg.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=Message-Id:Date:Subject:Cc:To:From; bh=rd6Z/UWIX9yQcx9A/k/Tzza7piZDLbeegr9xRf/WCbg=;
	b=KVSIfjZjfQLa88cN+D0IJ2zrAf4WPACc4wJRA0bjQQwyUAXsgR3mEjqSG/ZCV2ML9ZtZEnWzTw85q2Dt2qTpeZOODj2jeB77DWgcrJzeCGVOAsPMuReyLTWR/xtNqKJPU6P9JQQKhHKrRZ7YoUEGd+4YojBEL7bSihFFTiTLyBY=;
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

this is version 2 of the memcg charge naturalization series.  Changes
since v1 include:

o document mem_cgroup_account_move() exclusion
o catch uncharged swapin readahead pages in mem_cgroup_swapout()
o fix DEBUG_VM build after last-minute identifier rename
o drop duplicate lru_cache_add_active_or_unevictable() in THP migration
o make __GFP_NORETRY try reclaim at least once
o improve precharge failure path documentation (Michal)
o improve changelog on page_cgroup write ordering removal (Michal)
o document why kmem's page_cgroup writing is safe (Michal)
o clarify justification of the charge API rewrite (Michal)
o avoid mixing code move with logical changes (Michal)
o consolidate uncharge batching sections (Kame)
o rebase to latest mmots and add acks

These patches rework memcg charge lifetime to integrate more naturally
with the lifetime of user pages.  This drastically simplifies the code
and reduces charging and uncharging overhead.  The most expensive part
of charging and uncharging is the page_cgroup bit spinlock, which is
removed entirely after this series.

Here are the top-10 profile entries of a stress test that reads a 128G
sparse file on a freshly booted box, without even a dedicated cgroup
(i.e. executing in the root memcg).  Before:

    15.36%              cat  [kernel.kallsyms]   [k] copy_user_generic_string                  
    13.31%              cat  [kernel.kallsyms]   [k] memset                                    
    11.48%              cat  [kernel.kallsyms]   [k] do_mpage_readpage                         
     4.23%              cat  [kernel.kallsyms]   [k] get_page_from_freelist                    
     2.38%              cat  [kernel.kallsyms]   [k] put_page                                  
     2.32%              cat  [kernel.kallsyms]   [k] __mem_cgroup_commit_charge                
     2.18%          kswapd0  [kernel.kallsyms]   [k] __mem_cgroup_uncharge_common              
     1.92%          kswapd0  [kernel.kallsyms]   [k] shrink_page_list                          
     1.86%              cat  [kernel.kallsyms]   [k] __radix_tree_lookup                       
     1.62%              cat  [kernel.kallsyms]   [k] __pagevec_lru_add_fn                      

After:

    15.67%           cat  [kernel.kallsyms]   [k] copy_user_generic_string                  
    13.48%           cat  [kernel.kallsyms]   [k] memset                                    
    11.42%           cat  [kernel.kallsyms]   [k] do_mpage_readpage                         
     3.98%           cat  [kernel.kallsyms]   [k] get_page_from_freelist                    
     2.46%           cat  [kernel.kallsyms]   [k] put_page                                  
     2.13%       kswapd0  [kernel.kallsyms]   [k] shrink_page_list                          
     1.88%           cat  [kernel.kallsyms]   [k] __radix_tree_lookup                       
     1.67%           cat  [kernel.kallsyms]   [k] __pagevec_lru_add_fn                      
     1.39%       kswapd0  [kernel.kallsyms]   [k] free_pcppages_bulk                        
     1.30%           cat  [kernel.kallsyms]   [k] kfree                                     

As you can see, the memcg footprint has shrunk quite a bit.

The code has survived prolonged stress testing, including a swapping
workload being moved continuously between memcgs.

   text    data     bss     dec     hex filename
  38606   10084     400   49090    bfc2 mm/memcontrol.o.old
  35903   10084     400   46387    b533 mm/memcontrol.o.new

 Documentation/cgroups/memcg_test.txt |  160 +---
 include/linux/memcontrol.h           |   94 +--
 include/linux/page_cgroup.h          |   43 +-
 include/linux/swap.h                 |   15 +-
 kernel/events/uprobes.c              |    1 +
 mm/filemap.c                         |   13 +-
 mm/huge_memory.c                     |   55 +-
 mm/memcontrol.c                      | 1425 ++++++++++++----------------------
 mm/memory.c                          |   43 +-
 mm/migrate.c                         |   44 +-
 mm/rmap.c                            |   20 -
 mm/shmem.c                           |   32 +-
 mm/swap.c                            |   40 +
 mm/swap_state.c                      |    8 +-
 mm/swapfile.c                        |   21 +-
 mm/truncate.c                        |    9 -
 mm/vmscan.c                          |   12 +-
 mm/zswap.c                           |    2 +-
 18 files changed, 716 insertions(+), 1321 deletions(-)
