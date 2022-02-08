From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 0/4] mm/page_owner: Extend page_owner to show memcg information
Date: Mon,  7 Feb 2022 19:05:28 -0500
Message-ID: <20220208000532.1054311-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644278763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hp8wvZdS1P5SZuwA1phL5v+8erUCnmBhdeZatALDNps=;
        b=S3807IxVpMFwFCoOnlluXXKiKxldcNHJeU4uKmqgNWOGiEEcJvoZx/vzRQNlKmOadns/bU
        +jt9kQwfkmVRXS8SkXw+gVXjzPi1Ti6EE1utWV3Gi/in94r07THbPmA3ubHDKzCU02fX32
        CwsEgtEQe9TUc3oAB+Krqy+aPsEuCD4=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

 v5:
  - Apply the following changes to patch 3
    1) Make cgroup_name() write directly into kbuf without using an
       intermediate buffer.
    2) Change the terminology from "offline memcg" to "dying memcg" to align
       better with similar terms used elsewhere in the kernel.

 v4:
  - Take rcu_read_lock() when memcg is being accessed as suggested by
    Michal.
  - Make print_page_owner_memcg() return the new offset into the buffer
    and put CONFIG_MEMCG block inside as suggested by Mike.
  - Directly use TASK_COMM_LEN as length of name buffer as suggested by
    Roman.

 v3:
  - Add unlikely() to patch 1 and clarify that -1 will not be returned.
  - Use a helper function to print out memcg information in patch 3.
  - Add a new patch 4 to store task command name in page_owner
    structure.

While debugging the constant increase in percpu memory consumption on
a system that spawned large number of containers, it was found that a
lot of dying mem_cgroup structures remained in place without being
freed. Further investigation indicated that those mem_cgroup structures
were pinned by some pages.

In order to find out what those pages are, the existing page_owner
debugging tool is extended to show memory cgroup information and whether
those memcgs are dying or not. With the enhanced page_owner tool,
the following is a typical page that pinned the mem_cgroup structure
in my test case:

Page allocated via order 0, mask 0x1100cca(GFP_HIGHUSER_MOVABLE), pid 70984 (podman), ts 5421278969115 ns, free_ts 5420935666638 ns
PFN 3205061 type Movable Block 6259 type Movable Flags 0x17ffffc00c001c(uptodate|dirty|lru|reclaim|swapbacked|node=0|zone=2|lastcpupid=0x1fffff)
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
Charged to dying memcg libpod-conmon-fbc62060b5377479a7371cc16c5c596002945f2aa00d3d6d73a0cd0d148b6637.scope

So the page was not freed because it was part of a shmem segment. That
is useful information that can help users to diagnose similar problems.

With cgroup v1, /proc/cgroups can be read to find out the total number
of memory cgroups (online + dying). With cgroup v2, the cgroup.stat
of the root cgroup can be read to find the number of dying cgroups
(most likely pinned by dying memcgs).

The page_owner feature is not supposed to be enabled for production
system due to its memory overhead. However, if it is suspected that
dying memcgs are increasing over time, a test environment with page_owner
enabled can then be set up with appropriate workload for further analysis
on what may be causing the increasing number of dying memcgs.

Waiman Long (4):
  lib/vsprintf: Avoid redundant work with 0 size
  mm/page_owner: Use scnprintf() to avoid excessive buffer overrun check
  mm/page_owner: Print memcg information
  mm/page_owner: Record task command name

 lib/vsprintf.c  |  8 +++---
 mm/page_owner.c | 72 ++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 62 insertions(+), 18 deletions(-)

-- 
2.27.0

