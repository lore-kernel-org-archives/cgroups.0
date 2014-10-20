From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch] mm: memcontrol: clarify migration where old page is
 uncharged
Date: Mon, 20 Oct 2014 21:45:05 +0200
Message-ID: <20141020194505.GE505@dhcp22.suse.cz>
References: <1413732647-16043-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=jxPPhEjtaLkmCgs5u+XfgOTzM7crnvfC6xgAuL9j6Vo=;
        b=ZGxbBO1iaKSQu8OlN+7JXSOav9WOQtWwc5L2MNv+CWvg9oBcGtdCCjIYBFfUpfBEfX
         R+ERcruO78FGX18yhFDv7lFuLmlSjUQLqNwlxxBVRH/Aei1LbsHBTyR4Q8TltrHf06zt
         0DQlpGYw/ExRMnp4ksRD/IHibQAoSucdPNZYEOfDXRkz6CgtE0+v5SE9AEtt+fORrimL
         iHiJG9meWC6HqFgz8pMfgdF4BkYjtKx2ShctbIz8DGus2alAktigJbcQihBXrTkTGXgz
         /ghkIwep1VbayPcWYfCB9uRxqlHG123B74uXe+lcH0Q8LH4S1aiojw8IGaebd4xk7LqL
         f2og==
Content-Disposition: inline
In-Reply-To: <1413732647-16043-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun 19-10-14 11:30:47, Johannes Weiner wrote:
> Better explain re-entrant migration when compaction races with
> reclaim, and also mention swapcache readahead pages as possible
> uncharged migration sources.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index fc1d7ca96b9d..76892eb89d26 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6166,7 +6166,12 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
>  	if (PageCgroupUsed(pc))
>  		return;
>  
> -	/* Re-entrant migration: old page already uncharged? */
> +	/*
> +	 * Swapcache readahead pages can get migrated before being
> +	 * charged, and migration from compaction can happen to an
> +	 * uncharged page when the PFN walker finds a page that
> +	 * reclaim just put back on the LRU but has not released yet.
> +	 */
>  	pc = lookup_page_cgroup(oldpage);
>  	if (!PageCgroupUsed(pc))
>  		return;
> -- 
> 2.1.2
> 

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
