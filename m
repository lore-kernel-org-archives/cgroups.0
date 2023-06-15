From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/2] mm/memcontrol: do not tweak node in mem_cgroup_init()
Date: Thu, 15 Jun 2023 10:14:39 +0200
Message-ID: <ZIrIb7pgRXln27nv@dhcp22.suse.cz>
References: <20230615073226.1343-1-haifeng.xu@shopee.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686816880; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u7K1dHo3suajr80VD6qXH9vvOWaAMLy7kkTVGXspF0U=;
        b=NqJM711WfcvRab2CCaoqcmrc5nGT/TblaFgad0EStN8zcLon2DOpDqyckZfG0d1tMo9TYO
        njZ+Dt7dQ6Vq0Buvu34Dj+dF0oXQ+hHimcR/YKbjQMAexlPM/zyPJ2g0Pwlw9fMTyzXqLD
        YLlR1w9ba2JUdWw9auY99dxXXZMSTDk=
Content-Disposition: inline
In-Reply-To: <20230615073226.1343-1-haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Cc: roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 15-06-23 07:32:25, Haifeng Xu wrote:
> mem_cgroup_init() request for allocations from each possible node, and
> it's used to be a problem because NODE_DATA is not allocated for offline
> node. Things have already changed since commit 09f49dca570a9 ("mm: handle
> uninitialized numa nodes gracefully"), so it's unnecessary to check for
> !node_online nodes here.

How have you tested this patch?

I am not saying it is wrong and it looks like the right thing to do. But
the early init code has proven to be more subtle than expected so it is
definitely good to know that this has been tested on memory less setup
and passed.

> Signed-off-by: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
> ---
>  mm/memcontrol.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 4b27e245a055..c73c5fb33f65 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -7421,8 +7421,7 @@ static int __init mem_cgroup_init(void)
>  	for_each_node(node) {
>  		struct mem_cgroup_tree_per_node *rtpn;
>  
> -		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL,
> -				    node_online(node) ? node : NUMA_NO_NODE);
> +		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, node);
>  
>  		rtpn->rb_root = RB_ROOT;
>  		rtpn->rb_rightmost = NULL;
> -- 
> 2.25.1

-- 
Michal Hocko
SUSE Labs
