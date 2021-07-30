From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 4/5] mm, memcg: avoid possible NULL pointer dereferencing
 in mem_cgroup_init()
Date: Thu, 29 Jul 2021 20:12:43 -0700
Message-ID: <YQNuK+jN7pZLJTvT@carbon.lan>
References: <20210729125755.16871-1-linmiaohe@huawei.com>
 <20210729125755.16871-5-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=PEzx+2a/ZKj2U2ou/gU8CKrbFFrilUTmU4EkkU5zLPE=;
 b=Uy6JsIcYbpWdCVOIejUoJq6UEkXqzElWNgHMXV4Z3ksgOrNqtLPpbVn8YPMw+VPjgSBK
 dmjkjP7SuFaaNzCKz8SV9MCCWACeFI7kJsiK4WtYg42jK48qoBN7PesvwYO3Bhl/JELk
 kJRiFZSFqCIXBCR9WP20e4oAIx7YG0CasB0= 
Content-Disposition: inline
In-Reply-To: <20210729125755.16871-5-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jul 29, 2021 at 08:57:54PM +0800, Miaohe Lin wrote:
> rtpn might be NULL in very rare case. We have better to check it before
> dereferencing it. Since memcg can live with NULL rb_tree_per_node in
> soft_limit_tree, warn this case and continue.
> 
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  mm/memcontrol.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 5b4592d1e0f2..70a32174e7c4 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -7109,6 +7109,8 @@ static int __init mem_cgroup_init(void)
>  		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL,
>  				    node_online(node) ? node : NUMA_NO_NODE);
>  
> +		if (WARN_ON_ONCE(!rtpn))
> +			continue;

I also really doubt that it makes any sense to continue in this case.
If this allocations fails (at the very beginning of the system's life, it's an __init function),
something is terribly wrong and panic'ing on a NULL-pointer dereference sounds like
a perfect choice.

Is this a real world problem? Do I miss something?
