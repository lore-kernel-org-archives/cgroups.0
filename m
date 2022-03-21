From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [RFC PATCH 1/5] mm: memcg: make memcg huge page split support
 any order split.
Date: Mon, 21 Mar 2022 11:57:11 -0700
Message-ID: <YjjKh2NoWGcq28Oo@carbon.dhcp.thefacebook.com>
References: <20220321142128.2471199-1-zi.yan@sent.com>
 <20220321142128.2471199-2-zi.yan@sent.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1647889038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/f628apkMpQsjSicVFzN0gWVenPYv3XtQ9ROsVjz1zw=;
        b=NLKvTkWVtIcr90tfxAO2XU/dNqfJbG6SpakXGsYu4nUm1t+IsyQ57Teq3ybpNZQL1sahsQ
        CbjbE+jOO3LR4Tu4y76Yxkw+BX+9uIhZFxOV6+BGKrEJiE7ReVDr5g7ZEjQGn7ivkPzlYF
        G7Y2bm7vKrmhEixspnA5N6snIVmDdDE=
Content-Disposition: inline
In-Reply-To: <20220321142128.2471199-2-zi.yan-vRdzynncJC4@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Mar 21, 2022 at 10:21:24AM -0400, Zi Yan wrote:
> From: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> 
> It sets memcg information for the pages after the split. A new parameter
> new_order is added to tell the new page order, always 0 for now. It
> prepares for upcoming changes to support split huge page to any lower
> order.
> 
> Signed-off-by: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> ---
>  include/linux/memcontrol.h |  2 +-
>  mm/huge_memory.c           |  2 +-
>  mm/memcontrol.c            | 10 +++++-----
>  mm/page_alloc.c            |  2 +-
>  4 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 89b14729d59f..e71189454bf0 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1116,7 +1116,7 @@ static inline void memcg_memory_event_mm(struct mm_struct *mm,
>  	rcu_read_unlock();
>  }
>  
> -void split_page_memcg(struct page *head, unsigned int nr);
> +void split_page_memcg(struct page *head, unsigned int nr, unsigned int new_order);

It looks a bit inconsistent, can't we switch to use either nr or order for both
arguments? The latter is preferable.

Other than that, the patch looks good to me.

Thanks!
