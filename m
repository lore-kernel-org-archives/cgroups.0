From: Pankaj Gupta <pankaj.gupta.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 1/7] mm: memcontrol: fix NR_ANON_THPS accounting in
 charge moving
Date: Fri, 11 Dec 2020 08:33:34 +0100
Message-ID: <CAM9Jb+gc-xqPNP0jsuRV5xczBh31rM=cgL46SxxAYSohe8RvwQ@mail.gmail.com>
References: <20201211041954.79543-1-songmuchun@bytedance.com> <20201211041954.79543-2-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v5HpxdPWwk62UINvDZk+rcjGzodsUyDT59+6kcdYqLY=;
        b=UuSx1zwxSFyQ3GOKZPndz1Tc7V8nFIvuFUBR8XbCXonEXa/XEZK873OgDWO1WKAxQk
         xcg3++SlORlx+0DWHNTCHFq7Zuo11PQaeHDOZTYDn22vZ19NluY2W2a2Fbc5MU99I/pJ
         nM4pak6ZupQAvqGpu9xvLkaJqRUeKvpnOG6r6JS3lhf26yhelnGnVSmwUOjZ/pT3mZb3
         pMypx52dKsij5h0z0Dc+dVnx67o8UjCJgjNnnMfS5xy5CeK+9oeThog2DL0PUNXAjOzf
         6VsG2mXexTC0hH+p9cdUbtr0/oGltOyvtPfvG1kTEpXIOG8SFRiO6oMCvDGWMw5eDLtq
         d9bg==
In-Reply-To: <20201211041954.79543-2-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, guro-b10kYP2dOMg@public.gmane.org, Sami Tolvanen <samitolvanen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> The unit of NR_ANON_THPS is HPAGE_PMD_NR already. So it should inc/dec
> by one rather than nr_pages.
>
> Fixes: 468c398233da ("mm: memcontrol: switch to native NR_ANON_THPS counter")
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> ---
>  mm/memcontrol.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b80328f52fb4..8818bf64d6fe 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5653,10 +5653,8 @@ static int mem_cgroup_move_account(struct page *page,
>                         __mod_lruvec_state(from_vec, NR_ANON_MAPPED, -nr_pages);
>                         __mod_lruvec_state(to_vec, NR_ANON_MAPPED, nr_pages);
>                         if (PageTransHuge(page)) {
> -                               __mod_lruvec_state(from_vec, NR_ANON_THPS,
> -                                                  -nr_pages);
> -                               __mod_lruvec_state(to_vec, NR_ANON_THPS,
> -                                                  nr_pages);
> +                               __dec_lruvec_state(from_vec, NR_ANON_THPS);
> +                               __inc_lruvec_state(to_vec, NR_ANON_THPS);
>                         }
>
>                 }

Acked-by: Pankaj Gupta <pankaj.gupta-8+5b1tb3oTXfrHaScsAUWw@public.gmane.org>
