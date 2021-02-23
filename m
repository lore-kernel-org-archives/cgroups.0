From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] mm: memcontrol: fix get_active_memcg return value
Date: Tue, 23 Feb 2021 07:35:49 -0800
Message-ID: <YDUg1TJm5NBvLbQS@carbon.lan>
References: <20210223091101.42150-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=t7MoVFMyDGzTVq+Xv80L4c65BmjPKBTDREne1vgTmrg=;
 b=Czk8fnyYOX62zfB8HvQSTeZlnxbxI/ed3Ec393p72x/VxL90o2dhIHZM0v5+1NGJWJvf
 icSUwFtOEQ15aYbXPZZ2iPl6cMN7Rfr9TibCdTMJ+Lxnu51ps9bwNpEm6ICBDmMdnoX+
 dQsEJ6Bi3azYoViBfXCV+hCUhlQ4T1B84mc= 
Content-Disposition: inline
In-Reply-To: <20210223091101.42150-1-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun@bytedance.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, shakeelb@google.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Tue, Feb 23, 2021 at 05:11:01PM +0800, Muchun Song wrote:
> We use a global percpu int_active_memcg variable to store the remote
> memcg when we are in the interrupt context. But get_active_memcg always
> return the current->active_memcg or root_mem_cgroup. The remote memcg
> (set in the interrupt context) is ignored. This is not what we want.
> So fix it.
> 
> Fixes: 37d5985c003d ("mm: kmem: prepare remote memcg charging infra for interrupt contexts")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  mm/memcontrol.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index be6bc5044150..bbe25655f7eb 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1061,13 +1061,9 @@ static __always_inline struct mem_cgroup *get_active_memcg(void)
>  
>  	rcu_read_lock();
>  	memcg = active_memcg();
> -	if (memcg) {
> -		/* current->active_memcg must hold a ref. */
> -		if (WARN_ON_ONCE(!css_tryget(&memcg->css)))
> -			memcg = root_mem_cgroup;
> -		else
> -			memcg = current->active_memcg;
> -	}
> +	/* remote memcg must hold a ref. */
> +	if (memcg && WARN_ON_ONCE(!css_tryget(&memcg->css)))
> +		memcg = root_mem_cgroup;

Ouch, this is a good one!

Reviewed-by: Roman Gushchin <guro@fb.com>

Thank you!
