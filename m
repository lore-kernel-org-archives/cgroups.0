From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH net-next v5 2/3] sock: Always take memcg pressure into consideration
Date: Fri, 2 Jun 2023 20:41:59 +0000
Message-ID: <20230602204159.vo7fmuvh3y2pdfi5@google.com>
References: <20230602081135.75424-1-wuyun.abel@bytedance.com> <20230602081135.75424-3-wuyun.abel@bytedance.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685738521; x=1688330521;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A3JKXYSTKUDDfkWw2z2gFFNkpbBKNRDNZFCjBvxP6b8=;
        b=4ap8xeEQ+RrljIBH8n4l6V33lwJ2Ruabow/MOb1HhRfUfARoCeT4iYuXw+5l0SCo1w
         BsWI8/x9bXZBOvdJo1nG7sA5se5dE+HdTPScOynYnBPtujmO+2mbGH4y5vJQKw9v4rOw
         gnCthwhPd2SORL80DDL7SINMo9fZkjj3SDmP7dBoTn46ljI83h1VbWJv1ptjzK9lEU7z
         RVshQ+BK50eYyTbWnyILBZv6qnaHQde490IuSaMFd+guECLHZM6vbGCTl5FKCAnymjwt
         izJA+opMgbMAg1shFiX9Oa0hTgWiLoDPb09pts6sfLXPjsl4VWV7Z79pkFnOGtx0Vak5
         7wJw==
In-Reply-To: <20230602081135.75424-3-wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Simon Horman <simon.horman-JqlR5BE4aJhWk0Htik3J/w@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Willem de Bruijn <willemdebruijn.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

+Willem

On Fri, Jun 02, 2023 at 04:11:34PM +0800, Abel Wu wrote:
> The sk_under_memory_pressure() is called to check whether there is
> memory pressure related to this socket. But now it ignores the net-
> memcg's pressure if the proto of the socket doesn't care about the
> global pressure, which may put burden on its memcg compaction or
> reclaim path (also remember that socket memory is un-reclaimable).
> 
> So always check the memcg's vm status to alleviate memstalls when
> it's in pressure.
> 

This is interesting. UDP is the only protocol which supports memory
accounting (i.e. udp_memory_allocated) but it does not define
memory_pressure. In addition, it does have sysctl_udp_mem. So
effectively UDP supports a hard limit and ignores memcg pressure at the
moment. This patch will change its behavior to consider memcg pressure
as well. I don't have any objection but let's get opinion of UDP
maintainer.

> Signed-off-by: Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> ---
>  include/net/sock.h | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 3f63253ee092..ad1895ffbc4a 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1411,13 +1411,11 @@ static inline bool sk_has_memory_pressure(const struct sock *sk)
>  
>  static inline bool sk_under_memory_pressure(const struct sock *sk)
>  {
> -	if (!sk->sk_prot->memory_pressure)
> -		return false;
> -
>  	if (mem_cgroup_under_socket_pressure(sk->sk_memcg))
>  		return true;
>  
> -	return !!*sk->sk_prot->memory_pressure;
> +	return sk->sk_prot->memory_pressure &&
> +		*sk->sk_prot->memory_pressure;
>  }
>  
>  static inline long
> -- 
> 2.37.3
> 
