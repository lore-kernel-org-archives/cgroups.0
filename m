From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] mm/page_owner: Extend page_owner to show memcg
Date: Fri, 28 Jan 2022 14:56:40 -0500
Message-ID: <20220128195642.416743-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643399848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4AGco3DPR26g1wodgd1tvssEUzEAzvT6zrwEdwptTuI=;
        b=O2RyyyQTcsLDCoHy8P5gN8RCTM1P4YNXAecVG4YyurJgpeF3ccBj+M1Lp9QxbYrIyI5j3y
        ufRV1HV1qtI2WYNTrQI3wIXB8GodNA8Jwo8+XXNqTcFyB4UNabUVOi8uFbE6KBZYkYZzNa
        3m7mWRsPexD8D18VIAapfM+oqB9cyXc=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

While debugging the constant increase in percpu memory consumption on
a system that spawned large number of containers, it was found that a
lot of offlined mem_cgroup structures remained in place without being
freed. Further investigation indicated that those mem_cgroup structures
were pinned by some pages.

In order to find out what those pages are, the existing page_owner
debugging tool is extended to show memory cgroup information and whether
those memcgs are offlined or not. With the enhanced page_owner tool,
the following is a typical page that pinned the mem_cgroup structure
in my test case:

Page allocated via order 0, mask 0x1100cca(GFP_HIGHUSER_MOVABLE), pid 62760, ts 119274296592 ns, free_ts 118989764823 ns
PFN 1273412 type Movable Block 2487 type Movable Flags 0x17ffffc00c001c(uptodate|dirty|lru|reclaim|swapbacked|node=0|zone=2|lastcpupid=0x1fffff)
 prep_new_page+0x8e/0xb0
 get_page_from_freelist+0xc4d/0xe50
 __alloc_pages+0x172/0x320
 alloc_pages_vma+0x84/0x230
 shmem_alloc_page+0x3f/0x90
 shmem_alloc_and_acct_page+0x76/0x1c0
 shmem_getpage_gfp+0x48d/0x890
 shmem_write_begin+0x36/0xc0
 generic_perform_write+0xed/0x1d0
 __generic_file_write_iter+0xdc/0x1b0
 generic_file_write_iter+0x5d/0xb0
 new_sync_write+0x11f/0x1b0
 vfs_write+0x1ba/0x2a0
 ksys_write+0x59/0xd0
 do_syscall_64+0x37/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
Charged to offlined memcg libpod-conmon-e59cc83faf807bacc61223fec6a80c1540ebe8f83c802870c6af4708d58f77ea

So the page was not freed because it was part of a shmem segment. That
is useful information that can help users to diagnose similar problems.

Waiman Long (2):
  mm/page_owner: Introduce SNPRINTF() macro that includes length error
    check
  mm/page_owner: Dump memcg information

 mm/page_owner.c | 76 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 50 insertions(+), 26 deletions(-)

-- 
2.27.0

