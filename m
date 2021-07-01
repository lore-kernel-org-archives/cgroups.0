From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 10/18] mm/memcg: Convert mem_cgroup_uncharge() to take
 a folio
Date: Thu, 1 Jul 2021 08:17:48 +0100
Message-ID: <YN1sHPnWUysOZiJm@infradead.org>
References: <20210630040034.1155892-1-willy@infradead.org>
 <20210630040034.1155892-11-willy@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AO10H4pBYDXfj/GCG8I7YNtdmQX0P/FBy3uAzevfrYY=; b=YHVMxe4+ZCiCB/P9GLSQuCArCA
        ej7RrWbCiOh8iBi+p5GSYbUhnBrGn6VyP7cFQwsZ/OmwSJsUGpeyJp9Ow+QpkAHtsjZgi8llNPn22
        Tv3Vhnv4ABQ/UR86yx5Ve/ZZPENgDBoHlW1glJQzXXuVriXDl95x6jRyvjUa0QYcjnSNH39k+JsPb
        yBcDaOUY87BKEcGL9XrsFfHTB36viWHYrIQIcdfT59ELinCYH+cR1NMA6YQGYWZcHcijIPkMa3eZ9
        /REH3vSN4d0GcqfnrynhoPB251+k2wpzaOZ1oc4Kt+JCq7Okaouzs9s+9E/hrW9SAnDh2uNiro36r
        FB6Phk7Q==;
Content-Disposition: inline
In-Reply-To: <20210630040034.1155892-11-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, Jun 30, 2021 at 05:00:26AM +0100, Matthew Wilcox (Oracle) wrote:
> Convert all the callers to call page_folio().
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> ---
>  include/linux/memcontrol.h |  4 ++--
>  mm/filemap.c               |  2 +-
>  mm/khugepaged.c            |  4 ++--
>  mm/memcontrol.c            | 14 +++++++-------
>  mm/memory-failure.c        |  2 +-
>  mm/memremap.c              |  2 +-
>  mm/page_alloc.c            |  2 +-
>  mm/swap.c                  |  2 +-
>  8 files changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 90d48b0e3191..d6386a2b9d7a 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -710,7 +710,7 @@ int mem_cgroup_swapin_charge_page(struct page *page, struct mm_struct *mm,
>  				  gfp_t gfp, swp_entry_t entry);
>  void mem_cgroup_swapin_uncharge_swap(swp_entry_t entry);
>  
> -void mem_cgroup_uncharge(struct page *page);
> +void mem_cgroup_uncharge(struct folio *);

why do you drop the parameter name?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
