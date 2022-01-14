From: Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH 2/4] mm/memcg: mem_cgroup_per_node is already set to 0 on
 allocation
Date: Fri, 14 Jan 2022 13:08:28 +0200
Message-ID: <YeFZrEAaPw1Y5wwd@kernel.org>
References: <20220111010302.8864-1-richard.weiyang@gmail.com>
 <20220111010302.8864-2-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642158516;
        bh=OF5OUUAm25dp5cp+JT0GiuvYGOwzKMtdyhATZeQWCM4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=anWYlmeAreoucUVCTnYlq5eLjpIWYUu97Eer6MAZxeInCL2iyNeuvzdkr4wXTCilh
         ADbkMRQOsbDKfGrQhI/Krb3R7WFGc/QG6nzEmEKa0alTS2JpzXrfMo3TEZhlLl22fu
         O/XvQqtC6HrkjNYMciuW/e+EteHpY6ZAvt5AX88lFtxPpWvzn6Pcd5BkA/Buu0SDru
         e1xE+5quxorgWd+xmEB8LlUeq1b3EJ600qkDwcuSgR9Ly/WxVGoAduHQwChY7NaAx+
         0Dtj5KrkdTYWGk26kAp8EQbFDtPRuo2/rBAFXH4k8BrxHPAgx19pRBUIhVExEPYznV
         2326WkH6r4Fng==
Content-Disposition: inline
In-Reply-To: <20220111010302.8864-2-richard.weiyang@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang@gmail.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, shakeelb@google.com, guro@fb.com, vbabka@suse.cz, willy@infradead.org, songmuchun@bytedance.com, shy828301@gmail.com, surenb@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Tue, Jan 11, 2022 at 01:03:00AM +0000, Wei Yang wrote:
> kzalloc_node() would set data to 0, so it's not necessary to set it
> again.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>

Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>

> ---
>  mm/memcontrol.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 11715f7323c0..a504616f904a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5067,8 +5067,6 @@ static int alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
>  	}
>  
>  	lruvec_init(&pn->lruvec);
> -	pn->usage_in_excess = 0;
> -	pn->on_tree = false;
>  	pn->memcg = memcg;
>  
>  	memcg->nodeinfo[node] = pn;
> -- 
> 2.33.1
> 
> 

-- 
Sincerely yours,
Mike.
