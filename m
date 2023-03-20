From: Cai Xinchen <caixinchen1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/1] Fix vmstat_percpu incorrect subtraction after reparent
Date: Mon, 20 Mar 2023 03:06:47 +0000
Message-ID: <20230320030648.50663-1-caixinchen1@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mpenttil-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

Hello, I see the patch-series (Use obj_cgroup APIs to charge the LRU
pages).
Link: https://lore.kernel.org/all/20220621125658.64935-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/

There are two problems left:

     root
     /  \
    A    B
   / \    \
  C   E    D

1. In some case of reparent, some page cache may be used by other memcg
D but it charges to the parent memcg A of dying memcg E. D is getting
away with using the page for free while A is taxed.

For this problem, the page may be shared by many memcgs. Which memcg
should be recharged to? It is hard to select. And for recharge method,
for example, the user rmdir E. If we recharge the page to D, some pages
of process attached to D may be reclaimed. The user may feel confused
about the phenomenon that I rmdir E but the processes attached to D are
reclaiming their pages and running slower.

And for cgroup v2, the page is charged to the memcg when it alloc and the
stats is counted to its parent. The method of reparent seems to follow
the rule.

2. The stats problem of vmstats_percpu. When memcg C is offllined, its 
pages are reparented to memcg P, so far P->vmstats (hierarchical) have
those pages, and P->vmstats_percpu (non-hierarchical) don't. When those
 pages get uncharged, P->vmstats (hierachical) decreases, which is correct,
but P->vmstats_percpu (non-hierarchical) also decreases, which is wrong, 
as those stats were never added to P->vmstats_percpu to begin with. If the
reparented memory exceeds the original non-hierarchical memory in P, some
arg such as cache which is show in memory.stat will be zero (if x < 0, it
shows 0)

I think propagate vmstats_percpu stats of dying memcg to its parent can 
solve this problem. If we do not propagate, the reparented memory exceeds
the original non-hierarchical memory in P, (hierarchical_usage -
non-hierarchical_usage(shows 0, but exactly negative number) - 
children_hierarchical_usage) may be meaningless.

And I want to ask for your opinions about problem 1, how to define the 
actions of charging pages to memcg when the memcg is died.

Cai Xinchen (1):
  mm: memcontrol: fix vmstats_percpu state incorrect subtraction after
    reparent

 kernel/cgroup/cgroup.c |  5 +++++
 mm/memcontrol.c        | 43 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 47 insertions(+), 1 deletion(-)

-- 
2.17.1

