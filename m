From: Rafael Aquini <aquini@redhat.com>
Subject: Re: [PATCH v4 0/4] mm/page_owner: Extend page_owner to show memcg
 information
Date: Wed, 2 Feb 2022 18:06:51 -0500
Message-ID: <YfsOi38nXkyCrYam@optiplex-fbsd>
References: <20220131192308.608837-5-longman@redhat.com>
 <20220202203036.744010-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643843216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=srHq4RerCPcuK2/I9lWBI5nczQqLUr4zYMys9nonwW0=;
        b=ANHHMEoEt4kme7PJSzZBjj3biAAgFIaNGmWaDG62aj49RUPavtiX6235XGQ+nM/Ujpq3L/
        rIfzsl9T9wEBizsO/qTCKd+8YrhVswQpFyCxekSzqghzOobv74asghUS6tWYHam7OdDaIt
        YqWDL/Yz3GlXUlf2bzJ/WHdnPYpJl2k=
Content-Disposition: inline
In-Reply-To: <20220202203036.744010-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Ira Weiny <ira.weiny@intel.com>, Mike Rapoport <rppt@kernel.org>, David Rientjes <rientjes@google.com>, Roman Gushchin <guro@fb.com>

On Wed, Feb 02, 2022 at 03:30:32PM -0500, Waiman Long wrote:
>  v4:
>   - Take rcu_read_lock() when memcg is being accessed as suggested by
>     Michal.
>   - Make print_page_owner_memcg() return the new offset into the buffer
>     and put CONFIG_MEMCG block inside as suggested by Mike.
>   - Directly use TASK_COMM_LEN as length of name buffer as suggested by
>     Roman.
> 
>  v3:
>   - Add unlikely() to patch 1 and clarify that -1 will not be returned.
>   - Use a helper function to print out memcg information in patch 3.
>   - Add a new patch 4 to store task command name in page_owner
>     structure.
> 
>  v2:
>   - Remove the SNPRINTF() macro as suggested by Ira and use scnprintf()
>     instead to remove some buffer overrun checks.
>   - Add a patch to optimize vscnprintf with a size parameter of 0.
> 
> While debugging the constant increase in percpu memory consumption on
> a system that spawned large number of containers, it was found that a
> lot of offline mem_cgroup structures remained in place without being
> freed. Further investigation indicated that those mem_cgroup structures
> were pinned by some pages.
> 
> In order to find out what those pages are, the existing page_owner
> debugging tool is extended to show memory cgroup information and whether
> those memcgs are offline or not. With the enhanced page_owner tool,
> the following is a typical page that pinned the mem_cgroup structure
> in my test case:
> 
> Page allocated via order 0, mask 0x1100cca(GFP_HIGHUSER_MOVABLE), pid 162970 (podman), ts 1097761405537 ns, free_ts 1097760838089 ns
> PFN 1925700 type Movable Block 3761 type Movable Flags 0x17ffffc00c001c(uptodate|dirty|lru|reclaim|swapbacked|node=0|zone=2|lastcpupid=0x1fffff)
>  prep_new_page+0xac/0xe0
>  get_page_from_freelist+0x1327/0x14d0
>  __alloc_pages+0x191/0x340
>  alloc_pages_vma+0x84/0x250
>  shmem_alloc_page+0x3f/0x90
>  shmem_alloc_and_acct_page+0x76/0x1c0
>  shmem_getpage_gfp+0x281/0x940
>  shmem_write_begin+0x36/0xe0
>  generic_perform_write+0xed/0x1d0
>  __generic_file_write_iter+0xdc/0x1b0
>  generic_file_write_iter+0x5d/0xb0
>  new_sync_write+0x11f/0x1b0
>  vfs_write+0x1ba/0x2a0
>  ksys_write+0x59/0xd0
>  do_syscall_64+0x37/0x80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> Charged to offline memcg libpod-conmon-15e4f9c758422306b73b2dd99f9d50a5ea53cbb16b4a13a2c2308a4253cc0ec8.
> 
> So the page was not freed because it was part of a shmem segment. That
> is useful information that can help users to diagnose similar problems.
> 
> With cgroup v1, /proc/cgroups can be read to find out the total number
> of memory cgroups (online + offline). With cgroup v2, the cgroup.stat of
> the root cgroup can be read to find the number of dying cgroups (most
> likely pinned by dying memcgs).
> 
> The page_owner feature is not supposed to be enabled for production
> system due to its memory overhead. However, if it is suspected that
> dying memcgs are increasing over time, a test environment with page_owner
> enabled can then be set up with appropriate workload for further analysis
> on what may be causing the increasing number of dying memcgs.
> 
> Waiman Long (4):
>   lib/vsprintf: Avoid redundant work with 0 size
>   mm/page_owner: Use scnprintf() to avoid excessive buffer overrun check
>   mm/page_owner: Print memcg information
>   mm/page_owner: Record task command name
> 
>  lib/vsprintf.c  |  8 +++---
>  mm/page_owner.c | 70 ++++++++++++++++++++++++++++++++++++++-----------
>  2 files changed, 60 insertions(+), 18 deletions(-)
> 
> -- 
> 2.27.0
>

Thank you, Waiman.

Acked-by: Rafael Aquini <aquini@redhat.com>

