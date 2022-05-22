From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH mm v2 7/9] memcg: enable accounting for large allocations
 in mem_cgroup_css_alloc
Date: Sun, 22 May 2022 14:47:42 +0800
Message-ID: <CAMZfGtX1pste5vY_RE3N5LQ1_+BUjyRbSUa1yf0v7vboJj_iOg@mail.gmail.com>
References: <Yn6aL3cO7VdrmHHp@carbon> <9925d0ba-40d7-e3a8-1fef-054968b26ce6@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v+86wYP36U311zaok342X50l9ECadNdMvxTZhZZ14tg=;
        b=2UtmFRcCttqhVCYCxkvMGj1oc42Q+TyiCf7Rh2JlB+DFl9as9uUEP04r2Tx9KZzwMw
         YWV/0SVPIrdAzgtlxIJrFaVbtgMWlklBLxambHEJKDPlReq8UdjzGw9drwD6TMoVRO+V
         G54/gUVExox3CmE1K3kCF1KpEpk5ioGFI0a7ASDRM35NvxidOzMd4230U4oSfpZ0yP+T
         9tbyFvrynWSP5oVmMaPsVvyuiRX5LsOgS1R53xUZvsa7JZo/GbuTq8yT44YuCxf0I8LU
         nX0KSUO+R0vfTSTblwBGQDCKkvV6ljOTr/wf/pLoT6nYKV5jR0DXNCg9O+TZ7a4MlAQ8
         4XAQ==
In-Reply-To: <9925d0ba-40d7-e3a8-1fef-054968b26ce6-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Sun, May 22, 2022 at 12:38 AM Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
>
> Creation of each memory cgroup allocates few huge objects in
> mem_cgroup_css_alloc(). Its size exceeds the size of memory
> accounted in common part of cgroup creation:
>
> common part:    ~11Kb   +  318 bytes percpu
> memcg:          ~17Kb   + 4692 bytes percpu
>
> memory:
> ------
> Allocs  Alloc   $1*$2   Sum     Allocation
> number  size
> --------------------------------------------
> 1   +   8192    8192    8192    (mem_cgroup_css_alloc+0x4a) <NB
> 14  ~   352     4928    13120   KERNFS
> 1   +   2048    2048    15168   (mem_cgroup_css_alloc+0xdd) <NB
> 1       1024    1024    16192   (alloc_shrinker_info+0x79)
> 1       584     584     16776   (radix_tree_node_alloc.constprop.0+0x89)
> 2       64      128     16904   (percpu_ref_init+0x6a)
> 1       64      64      16968   (mem_cgroup_css_online+0x32)
>
> 1   =   3684    3684    3684    call_site=mem_cgroup_css_alloc+0x9e
> 1   =   984     984     4668    call_site=mem_cgroup_css_alloc+0xfd
> 2       12      24      4692    call_site=percpu_ref_init+0x23
>
>      '=' -- already accounted,
>      '+' -- to be accounted,
>      '~' -- partially accounted
>
> Accounting for this memory helps to avoid misuse inside memcg-limited
> contianers.
>
> Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
