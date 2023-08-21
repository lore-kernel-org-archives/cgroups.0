From: Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/4] mm: Add orphaned kernel-doc to the rst files.
Date: Mon, 21 Aug 2023 17:55:48 +0300
Message-ID: <20230821145548.GE9849@kernel.org>
References: <20230818200630.2719595-1-willy@infradead.org>
 <20230818200630.2719595-5-willy@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692629774;
        bh=JzR+Jr/LbLcg3R+8alMuMPEoX/4+6Yrco6xCCTNqmmI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k6PRd1kpuLk4oe04CIlvYkbQxfyIIYRNqOxLmMc04/9+2rjj6g6Ut6iZXGnB5Ldva
         v78sy92rfrpcA9dkV2fWwK5KAxV63wElUa1P0Kz0SrgZ+C6WLBADa9pHaMiWpzUjeP
         pDXYif0syTetoV2/u3tD8eHuoHSSF3puadWCBKN5fCxji6kkL+FwQK2d7WRKj3Pzpl
         XmjCoW66X28u7nHPxmdleBUquaXrn/OPV3d4YcEYIKUYKRD6tO/vOKVN0YopTn9mSS
         q0HT2omqz5fVrqL+HOfrcvit2vpzIfJDMcJyWlW+Oii9WwU4w9pvdaLBeFZgvxadqr
         5eExUI6OVyqHQ==
Content-Disposition: inline
In-Reply-To: <20230818200630.2719595-5-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Aug 18, 2023 at 09:06:30PM +0100, Matthew Wilcox (Oracle) wrote:
> There are many files in mm/ that contain kernel-doc which is not
> currently published on kernel.org.  Some of it is easily categorisable,
> but most of it is going into the miscellaneous documentation section to
> be organised later.
> 
> Some files aren't ready to be included; they contain documentation with
> build errors.  Or they're nommu.c which duplicates documentation from
> "real" MMU systems.  Those files are noted with a # mark (although really
> anything which isn't a recognised directive would do to prevent inclusion)
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Acked-by: Mike Rapoport (IBM) <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

> ---
>  Documentation/core-api/mm-api.rst | 25 +++++++++++++++++++++++++
>  Documentation/mm/highmem.rst      |  1 +
>  Documentation/mm/zsmalloc.rst     |  5 +++++
>  3 files changed, 31 insertions(+)
> 
> diff --git a/Documentation/core-api/mm-api.rst b/Documentation/core-api/mm-api.rst
> index f5dde5bceaea..2d091c873d1e 100644
> --- a/Documentation/core-api/mm-api.rst
> +++ b/Documentation/core-api/mm-api.rst
> @@ -115,3 +115,28 @@ More Memory Management Functions
>  .. kernel-doc:: include/linux/mmzone.h
>  .. kernel-doc:: mm/util.c
>     :functions: folio_mapping
> +
> +.. kernel-doc:: mm/rmap.c
> +.. kernel-doc:: mm/migrate.c
> +.. kernel-doc:: mm/mmap.c
> +.. kernel-doc:: mm/kmemleak.c
> +.. #kernel-doc:: mm/hmm.c (build warnings)
> +.. kernel-doc:: mm/memremap.c
> +.. kernel-doc:: mm/hugetlb.c
> +.. kernel-doc:: mm/swap.c
> +.. kernel-doc:: mm/zpool.c
> +.. kernel-doc:: mm/memcontrol.c
> +.. #kernel-doc:: mm/memory-tiers.c (build warnings)
> +.. kernel-doc:: mm/shmem.c
> +.. kernel-doc:: mm/migrate_device.c
> +.. #kernel-doc:: mm/nommu.c (duplicates kernel-doc from other files)
> +.. kernel-doc:: mm/mapping_dirty_helpers.c
> +.. #kernel-doc:: mm/memory-failure.c (build warnings)
> +.. kernel-doc:: mm/percpu.c
> +.. kernel-doc:: mm/maccess.c
> +.. kernel-doc:: mm/vmscan.c
> +.. kernel-doc:: mm/memory_hotplug.c
> +.. kernel-doc:: mm/mmu_notifier.c
> +.. kernel-doc:: mm/balloon_compaction.c
> +.. kernel-doc:: mm/huge_memory.c
> +.. kernel-doc:: mm/io-mapping.c
> diff --git a/Documentation/mm/highmem.rst b/Documentation/mm/highmem.rst
> index fe68e02fc8ff..9d92e3f2b3d6 100644
> --- a/Documentation/mm/highmem.rst
> +++ b/Documentation/mm/highmem.rst
> @@ -209,4 +209,5 @@ Functions
>  =========
>  
>  .. kernel-doc:: include/linux/highmem.h
> +.. kernel-doc:: mm/highmem.c
>  .. kernel-doc:: include/linux/highmem-internal.h
> diff --git a/Documentation/mm/zsmalloc.rst b/Documentation/mm/zsmalloc.rst
> index a3c26d587752..76902835e68e 100644
> --- a/Documentation/mm/zsmalloc.rst
> +++ b/Documentation/mm/zsmalloc.rst
> @@ -263,3 +263,8 @@ is heavy internal fragmentation and zspool compaction is unable to relocate
>  objects and release zspages. In these cases, it is recommended to decrease
>  the limit on the size of the zspage chains (as specified by the
>  CONFIG_ZSMALLOC_CHAIN_SIZE option).
> +
> +Functions
> +=========
> +
> +.. kernel-doc:: mm/zsmalloc.c
> -- 
> 2.40.1
> 

-- 
Sincerely yours,
Mike.
