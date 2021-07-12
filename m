From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 1/3] mm, memcg: add mem_cgroup_disabled checks in
 vmpressure and swap-related functions
Date: Mon, 12 Jul 2021 08:55:00 -0700
Message-ID: <CAJuCfpEWUqE6iuMC02Qac3TBLx7Zy12y3iSwr6Tsvcd-tAMOrw@mail.gmail.com>
References: <20210710003626.3549282-1-surenb@google.com> <YOvrKzvG+nHJpV+V@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+R+buwilcZJPqYitjTRHvClHpz5qW+7Zf9f3EMnGV/A=;
        b=hWvlM8rao4P3XGZzXkW/CYN7nJSLsBhLSfupdLB5AO4qrn9z8yU7lpr8/r4p/673D6
         /84v/MB7BpZbegwEzPtqiOm9hiaTI/lfnQbByU0WqKSQ/gpJF4rM3bt2GRnE3GshSpus
         T1tCCsMBfLcsieo7Rq4IYZxBCPFqZiXITsFIAS9L9EA9z8mA+JScy9XTDpeJ8m67VRyT
         6tLWTeoTNFClUrp/K1/7BgZJSU5pd47rmVOxKwmSvSMeQkalxfJ6AfI130ptNl2BZIfB
         VjN5D7QfyGWhr/Etgc6eqMMtpZNDWZzhkIZ8IfsEOnEFdKSDUOf0UQaOBmzwiMQDqTzO
         jzew==
In-Reply-To: <YOvrKzvG+nHJpV+V-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, kernel-team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>

On Mon, Jul 12, 2021 at 12:11 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Fri 09-07-21 17:36:24, Suren Baghdasaryan wrote:
> > Add mem_cgroup_disabled check in vmpressure, mem_cgroup_uncharge_swap a=
nd
> > cgroup_throttle_swaprate functions. This minimizes the memcg overhead i=
n
> > the pagefault and exit_mmap paths when memcgs are disabled using
> > cgroup_disable=3Dmemory command-line option.
> > This change results in ~2.1% overhead reduction when running PFT test
>
> What is PFT test?

Christoph Lamenter=E2=80=99s pagefault tool
(https://lkml.org/lkml/2006/8/29/294). I'll add the link in the
description for clarity.

>
> > comparing {CONFIG_MEMCG=3Dn, CONFIG_MEMCG_SWAP=3Dn} against {CONFIG_MEM=
CG=3Dy,
> > CONFIG_MEMCG_SWAP=3Dy, cgroup_disable=3Dmemory} configuration on an 8-c=
ore
> > ARM64 Android device.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>
> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks!

>
> Thanks!
>
> > ---
> >  mm/memcontrol.c | 3 +++
> >  mm/swapfile.c   | 3 +++
> >  mm/vmpressure.c | 7 ++++++-
> >  3 files changed, 12 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index ae1f5d0cb581..a228cd51c4bd 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -7305,6 +7305,9 @@ void mem_cgroup_uncharge_swap(swp_entry_t entry, =
unsigned int nr_pages)
> >       struct mem_cgroup *memcg;
> >       unsigned short id;
> >
> > +     if (mem_cgroup_disabled())
> > +             return;
> > +
> >       id =3D swap_cgroup_record(entry, 0, nr_pages);
> >       rcu_read_lock();
> >       memcg =3D mem_cgroup_from_id(id);
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 1e07d1c776f2..707fa0481bb4 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -3778,6 +3778,9 @@ void cgroup_throttle_swaprate(struct page *page, =
gfp_t gfp_mask)
> >       struct swap_info_struct *si, *next;
> >       int nid =3D page_to_nid(page);
> >
> > +     if (mem_cgroup_disabled())
> > +             return;
> > +
> >       if (!(gfp_mask & __GFP_IO))
> >               return;
> >
> > diff --git a/mm/vmpressure.c b/mm/vmpressure.c
> > index d69019fc3789..9b172561fded 100644
> > --- a/mm/vmpressure.c
> > +++ b/mm/vmpressure.c
> > @@ -240,7 +240,12 @@ static void vmpressure_work_fn(struct work_struct =
*work)
> >  void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
> >               unsigned long scanned, unsigned long reclaimed)
> >  {
> > -     struct vmpressure *vmpr =3D memcg_to_vmpressure(memcg);
> > +     struct vmpressure *vmpr;
> > +
> > +     if (mem_cgroup_disabled())
> > +             return;
> > +
> > +     vmpr =3D memcg_to_vmpressure(memcg);
> >
> >       /*
> >        * Here we only want to account pressure that userland is able to
> > --
> > 2.32.0.93.g670b81a890-goog
>
> --
> Michal Hocko
> SUSE Labs
