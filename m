From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] mm: memcontrol.c:  Cleaning up function that are not
 used anywhere
Date: Sun, 7 Dec 2014 11:31:05 +0100
Message-ID: <20141207103105.GI15892@dhcp22.suse.cz>
References: <1417884356-3086-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=wDipg+DeIb2CRCoOyh5uhojsZwnw71frSPLHVI3fWzY=;
        b=jL4983FLVdw+MncuYgNyo/2g4TLT4+WdIayZDBZYNDqyVWRVkPe+yxB0I+L5ITWWVp
         SQRD3YDIdAca1INmi8oMZWbYjlvNsB1wCdHe4WrFJ8rLQGg9lnko4zcnHgJ0kD0Xy0PL
         0VWFH1eG7ESjKQT9H3pymnfmcd9Ynm3peNJUqj2xtoQvwnsuU7LEBqhVVpv7bt8yP5fJ
         YUm/+EGRItVa/1tfhaP1feZ+Ox8B8lNhOcQONZg22WUbg5MwgvWSBduurKIeM1Z4bx7z
         nnoX1emSwHmusmtSEpKLqjhZW3K7qInXrIDcLZOuDC6viGwuK0w0JbH4a3ggppqG39Ss
         2sCg==
Content-Disposition: inline
In-Reply-To: <1417884356-3086-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Sat 06-12-14 17:45:56, Rickard Strandqvist wrote:
> Remove function mem_cgroup_lru_names_not_uptodate() that is not used anywhere.
> And move BUILD_BUG_ON() to the beginning of memcg_stat_show() instead.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c |    7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d6ac0e3..5e2f0f3 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4379,17 +4379,14 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
>  }
>  #endif /* CONFIG_NUMA */
>  
> -static inline void mem_cgroup_lru_names_not_uptodate(void)
> -{
> -	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_lru_names) != NR_LRU_LISTS);
> -}
> -
>  static int memcg_stat_show(struct seq_file *m, void *v)
>  {
>  	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
>  	struct mem_cgroup *mi;
>  	unsigned int i;
>  
> +	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_lru_names) != NR_LRU_LISTS);
> +
>  	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
>  		if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
>  			continue;
> -- 
> 1.7.10.4
> 

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
