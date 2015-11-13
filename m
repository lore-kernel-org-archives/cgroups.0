From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 08/14] net: tcp_memcontrol: sanitize tcp memory
 accounting callbacks
Date: Thu, 12 Nov 2015 20:53:38 -0800
Message-ID: <1447390418.22599.34.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1447371693-25143-1-git-send-email-hannes@cmpxchg.org>
	 <1447371693-25143-9-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-type:mime-version:content-transfer-encoding;
        bh=LICf+q+IFZuZgX/Z4sa/R0l7LJIIxBniWan56jDe5EI=;
        b=dGz6uTDdameX+voGmDhP6OapzKp1PFnTuiZQizqcxkB9Zh76ErO771DT5k1JR6kLdj
         ZQLiTBcbRuC7q1xgx2vSnYCdSPc+ETFqef01KHlhhp4zhDXQvsscKE36NqQ74VqIObLw
         J98w1u8sA3wDrmMASbaA+AW9w6t7X7EbDAw1YoQRJiGh4opz815tTA+NjALRJi6wUhd2
         D/3FqsVSy8o16BX7kf5t6ij2P2T+L9QELge4K2ShkLmYAbGG+espGWltTFZ2E356AroV
         j8ml1VtyyIDUL0ibvzrNhFbV3GcFnPRRPlP931F7WemXlwUpePRsyk89ojzp4d/niyRC
         Y1yA==
In-Reply-To: <1447371693-25143-9-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Miller <davem@davemloft.net>, Andrew Morton <akpm@linux-foundation.org>, Vladimir Davydov <vdavydov@virtuozzo.com>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>, netdev@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, 2015-11-12 at 18:41 -0500, Johannes Weiner wrote:


> @@ -711,6 +705,12 @@ static inline void mem_cgroup_wb_stats(struct bdi_writeback *wb,
>  struct sock;
>  void sock_update_memcg(struct sock *sk);
>  void sock_release_memcg(struct sock *sk);
> +bool mem_cgroup_charge_skmem(struct cg_proto *proto, unsigned int nr_pages);
> +void mem_cgroup_uncharge_skmem(struct cg_proto *proto, unsigned int nr_pages);
> +static inline bool mem_cgroup_under_socket_pressure(struct cg_proto *proto)
> +{
> +	return proto->memory_pressure;
> +}
>  #endif /* CONFIG_INET && CONFIG_MEMCG_KMEM */
>  
>  #ifdef CONFIG_MEMCG_KMEM
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 2eefc99..8cc7613 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1126,8 +1126,8 @@ static inline bool sk_under_memory_pressure(const struct sock *sk)
>  	if (!sk->sk_prot->memory_pressure)
>  		return false;
>  
> -	if (mem_cgroup_sockets_enabled && sk->sk_cgrp)
> -		return !!sk->sk_cgrp->memory_pressure;
> +	if (mem_cgroup_sockets_enabled && sk->sk_cgrp &&
> +	    mem_cgroup_under_socket_pressure(sk->sk_cgrp))
>  
>  	return !!*sk->sk_prot->memory_pressure;
>  }


This looks wrong ?

if (A && B && C)
    return !!*sk->sk_prot->memory_pressure;

<compiler should eventually barf, 
as this function should not return void>
}







--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
