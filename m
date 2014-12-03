From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] mm: memcontrol.c:  Cleaning up function that are not
 used anywhere
Date: Wed, 3 Dec 2014 10:22:48 +0100
Message-ID: <20141203092248.GA23236@dhcp22.suse.cz>
References: <1417560083-27157-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=I/4EqFZSew3v/i1hwoEcUT0aoBu1xz8eF+AHSGgcPPQ=;
        b=zcsaJlX4mw7MBxTKRrODFpfJkj6waubr2SaP5IIvfNcUQl4WLbKNkX2+9Ic1FCeg52
         uA4fZqb7fQribNWPDDod7rh6+kCMKh2n9IGRwX7ucuPJa4XWOSZ39BpXUPPFlNhL3VWe
         Qw52DdFFuQCUg+2Yza7ftzzQX2tIJrAiS+u5U1wSonJRIhg3OVtVEhJ70xt7c4MGr5OC
         BbBf/axIjB9CuiE6VNq0aui6Xftws09CRtnEtSe4eGh+sXyl9NqfM0r6sUc76AQpbVoz
         NbqBLPDJFU/605fSo9FzLhJP7J0d6W3owXiPWok+9gekemXEVucNJ1kCnAqZY2bozjMr
         Jf9w==
Content-Disposition: inline
In-Reply-To: <1417560083-27157-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Tue 02-12-14 23:41:23, Rickard Strandqvist wrote:
> Remove function mem_cgroup_lru_names_not_uptodate() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c |    5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d6ac0e3..5edd1fe 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4379,11 +4379,6 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
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
