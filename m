From: David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: fix some comments in page_alloc.c and mempolicy.c
Date: Thu, 1 Oct 2020 14:27:20 +0200
Message-ID: <10c1b339-b352-7643-7adf-d82c941c7d2c@redhat.com>
References: <20200925160650.GA42847@rlk>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601555250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=LySvwW8/i/KgoIAR8gg2Hb4AfYLJvSh7SZI2POcIioQ=;
        b=AG95pOADdYHl3jF0YpGOBv9dfNuDapSYFkthXWF0xtvr/KLfGiWck/5bvIqoacbhOoiGyg
        YxwaKL7P0piRrpggLN/HPu1W76No+TJoO1m51XCMKLl8VQXtAq7VkOl2WIreSgIl7l7M+3
        dHALKy2quB4Zl6dy1hQpMWXk35X+2JI=
In-Reply-To: <20200925160650.GA42847@rlk>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Hui Su <sh_def-9Onoh4P/yGk@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 25.09.20 18:06, Hui Su wrote:
> 1. the cpuset.c has been moved from kernel/cpuset.c to
> kernel/cgroup/cpuset.c long time ago, but the comment is stale,
> so we update it.
> 2. get_page_from_freelist() may alloc many pages according to
> order, we may use pages for better.
> 
> Signed-off-by: Hui Su <sh_def-9Onoh4P/yGk@public.gmane.org>
> ---
>  kernel/cgroup/cpuset.c | 2 +-
>  mm/mempolicy.c         | 2 +-
>  mm/page_alloc.c        | 4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 642415b8c3c9..1d3011c1aab6 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1,5 +1,5 @@
>  /*
> - *  kernel/cpuset.c
> + *  kernel/cgroup/cpuset.c
>   *
>   *  Processor and Memory placement constraints for sets of tasks.
>   *
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index eddbe4e56c73..ac59b049b16c 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2295,7 +2295,7 @@ int vma_dup_policy(struct vm_area_struct *src, struct vm_area_struct *dst)
>   * rebinds the mempolicy its copying by calling mpol_rebind_policy()
>   * with the mems_allowed returned by cpuset_mems_allowed().  This
>   * keeps mempolicies cpuset relative after its cpuset moves.  See
> - * further kernel/cpuset.c update_nodemask().
> + * further kernel/cgroup/cpuset.c update_nodemask().
>   *
>   * current's mempolicy may be rebinded by the other task(the task that changes
>   * cpuset's mems), so we needn't do rebind work for current task.
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index fab5e97dc9ca..1e3c7493e1cb 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3709,7 +3709,7 @@ static inline unsigned int current_alloc_flags(gfp_t gfp_mask,
>  
>  /*
>   * get_page_from_freelist goes through the zonelist trying to allocate
> - * a page.
> + * pages.

"a page" is correct here - it's a single page of the given order (which
might be composed out of various order-0 pages, but that's not the point).


-- 
Thanks,

David / dhildenb

