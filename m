From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] loop: Charge i/o to mem and blk cg
Date: Tue, 16 Mar 2021 09:25:18 -0700
Message-ID: <CALvZod7tDf3vvspJmS551GkiNbSdCH9VWNgWMesmUi2Q3NkgKA@mail.gmail.com>
References: <20210316153655.500806-1-schatzberg.dan@gmail.com> <20210316153655.500806-4-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TPPV6ZX3Tdhvd5ax8oWrAMyN2NntSRwXfaI6WubILUM=;
        b=GqzIDfmCJYvYrFRGXeic57AzgBH3b1U4AAYEYp2J5pjfw4f/EnP9cLB/T6t1r6TAVg
         tMrVgaaocuUTM4D5JtLmSuQIu2yoT7UwXVom1It5Gr99hKftdLRf8bFHTTW90fpDcSxG
         LAklID4UlfQ5039uo09+40JkCw6EmElu4y5DRj8kxbylRlUp4Q2u5Vdg5DPlB9Pd0Bi2
         T4/d+1t2uvMESJRFgocJF9lvTDwHRjPJUtXR2rDn4rU3r5/Gp0EtxNgynOSacujSpjVU
         vmQw90Z074wG2SsY7t61SI+FYrKEojLMY+5Ts4h8dkCyGw/ZjTFaDaYPYDf/Dcb5Mjhn
         wp0w==
In-Reply-To: <20210316153655.500806-4-schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:BLOCK LAYER" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:MEMORY MANAGEMENT" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Tue, Mar 16, 2021 at 8:37 AM Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
[...]
>
>  /* Support for loadable transfer modules */
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 0c04d39a7967..fd5dd961d01f 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1187,6 +1187,17 @@ static inline struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
>         return NULL;
>  }
>
> +static inline struct mem_cgroup *get_mem_cgroup_from_page(struct page *page)
> +{
> +       return NULL;
> +}

The above function has been removed.
