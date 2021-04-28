From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH 2/2] ipc: use kmalloc for msg_queue and shmid_kernel
Date: Wed, 28 Apr 2021 08:15:10 +0300
Message-ID: <70805e05-5e56-2ab9-2654-3d48e9fe5a0a@virtuozzo.com>
References: <e67f2a95-4b01-9db2-fe47-0b2210f0b138@virtuozzo.com>
 <b0845b85-f4fe-601d-3328-d707d7db27f5@virtuozzo.com>
 <YIaVKi+0VMrz5LGD@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=0gJMy7DqAS1eYRTK9B131Vy4K+YMVwWNOR4yrE6X82I=; b=lvTFouv53BEh8mHyG
        NY7phcbGM0CieM5FyKUvFOhGkYhy9YpaXThdBSSwtS+55DAF1oe2Tf1w5GoChA6P4wWw8jBtBKm8H
        dNK0NijqbVaj0q9VRVxslSW4Cnu0YuCBEUgfpXxqTJh70FnrJu64+7td8LHRzhWHt8DC5+9slwvdc
        =;
In-Reply-To: <YIaVKi+0VMrz5LGD-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dmitry Safonov <0x7f454c46-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 4/26/21 1:25 PM, Michal Hocko wrote:
> Using kvmalloc for sub page size objects is suboptimal because kmalloc
> can easily fallback into vmalloc under memory pressure and smaller
> objects would fragment memory. Therefore replace kvmalloc by a simple
> kmalloc.

I think you're wrong here:
kvmalloc can failback to vmalloc for size > PAGE_SIZE only

Please take look at mm/util.c::kvmalloc_node()

        if (size > PAGE_SIZE) {
                kmalloc_flags |= __GFP_NOWARN;

                if (!(kmalloc_flags & __GFP_RETRY_MAYFAIL))
                        kmalloc_flags |= __GFP_NORETRY;
        }

        ret = kmalloc_node(size, kmalloc_flags, node);

        /*
         * It doesn't really make sense to fallback to vmalloc for sub page
         * requests
         */
        if (ret || size <= PAGE_SIZE)
                return ret;

        return __vmalloc_node(size, 1, flags, node,
                        __builtin_return_address(0));

For small objects kvmalloc is not much different just from kmalloc,
so the patch is mostly cosmetic.
