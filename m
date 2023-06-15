From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/2] mm/memcontrol: add check for allocation failure in
 mem_cgroup_init()
Date: Thu, 15 Jun 2023 10:26:22 +0200
Message-ID: <ZIrLLmb+o77Wy2sY@dhcp22.suse.cz>
References: <20230615073226.1343-2-haifeng.xu@shopee.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686817582; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kF+hByK4Y76JqlJkiSCw3idVqJKv+Bhlb9OYXECSA6o=;
        b=Oi4Rr4D7LwzZKXtZXhTOqPefALupc8O9w/CwxHH5AgGPnY3ErZvy9xW+Ziw24qxE8SdmYh
        FXRzzAYYdOOuSL3vasWHumh5F/H9BINWWmQKBiaMYzbqAxtmLNhgW2CVeBAFivdKknMnRb
        UnCzHpZFD3YrqLYxeUYH3gDniCrGbJg=
Content-Disposition: inline
In-Reply-To: <20230615073226.1343-2-haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Cc: roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 15-06-23 07:32:26, Haifeng Xu wrote:
> If mem_cgroup_init() fails to allocate mem_cgroup_tree_per_node, we
> should not try to initilaize it. Add check for this case to avoid
> potential NULL pointer dereference.

Technically yes and it seems that all users of soft_limit_tree.rb_tree_per_node
correctly check for NULL so this would be graceful failure handling. At
least superficially because the feature itself would be semi-broken when
used. But more practically this is a 24B allocation and if we fail to
allocate that early during the boot we are screwed anyway. Would such
a system have any chance to boot all the way to userspace? Woul any
userspace actually work?

Is this patch motivated by a code reading or is there any actual
practical upside of handling the error here?
 
> Signed-off-by: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
> ---
>  mm/memcontrol.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c73c5fb33f65..7ebf64e48b25 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -7422,6 +7422,8 @@ static int __init mem_cgroup_init(void)
>  		struct mem_cgroup_tree_per_node *rtpn;
>  
>  		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, node);
> +		if (!rtpn)
> +			continue;
>  
>  		rtpn->rb_root = RB_ROOT;
>  		rtpn->rb_rightmost = NULL;
> -- 
> 2.25.1

-- 
Michal Hocko
SUSE Labs
