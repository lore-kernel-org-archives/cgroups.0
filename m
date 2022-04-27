From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] memcg: accounting for objects allocated for new netdevice
Date: Wed, 27 Apr 2022 16:01:53 +0200
Message-ID: <20220427140153.GC9823@blackbody.suse.cz>
References: <7e867cb0-89d6-402c-33d2-9b9ba0ba1523@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1651068114; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rtEd6e1tTShJTnCJcYs65RbsArilbR2cAspTgrMECHg=;
        b=InPtbRKyqPnLyRc4lNpBPdIgoPKrVjYvlGinsX0swe8z63mZmZLe+hjtuQVEEBmBMWafjh
        aQ2Bges0I0+i4O+uhCH5nABzz41ag5HpDK76UpUhk5JJtaWIIrh6PjmvD2cO5EizQEXU7M
        sRVuQIiTePcpSjg7K8BV/a7Wo+iGgD8=
Content-Disposition: inline
In-Reply-To: <7e867cb0-89d6-402c-33d2-9b9ba0ba1523-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello Vasily.

On Wed, Apr 27, 2022 at 01:37:50PM +0300, Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
> diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
> index cfa79715fc1a..2881aeeaa880 100644
> --- a/fs/kernfs/mount.c
> +++ b/fs/kernfs/mount.c
> @@ -391,7 +391,7 @@ void __init kernfs_init(void)
>  {
>  	kernfs_node_cache = kmem_cache_create("kernfs_node_cache",
>  					      sizeof(struct kernfs_node),
> -					      0, SLAB_PANIC, NULL);
> +					      0, SLAB_PANIC | SLAB_ACCOUNT, NULL);

kernfs accounting you say?
kernfs backs up also cgroups, so the parent-child accounting comes to my
mind.
See the temporary switch to parent memcg in mem_cgroup_css_alloc().

(I mean this makes some sense but I'd suggest unlumping the kernfs into
a separate path for possible discussion and its not-only-netdevice
effects.)

Thanks,
Michal
