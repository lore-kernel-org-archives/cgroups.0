From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH bpf-next 0/5] bpf, mm: introduce cgroup.memory=nobpf
Date: Thu, 9 Feb 2023 19:28:01 +0800
Message-ID: <CALOAHbBzev_Bi5kzD0O2Sppv3SO2_Qbxe4McXy2i-08dPqVwRg@mail.gmail.com>
References: <20230205065805.19598-1-laoar.shao@gmail.com> <Y+QL8s1VEHlolXM3@P9FQF9L96D.corp.robot.car>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cDkWXAEEhy2VoXh+Bc3398ODh0oG5X691Xoq6e7LZmg=;
        b=K055cZuD84EE4vZQSZTVkgvlYu6HEsqiYoe0wUMw1gXWvVpibA8mZVBwCnGtHYDZjj
         vCeA0nXg0VBUFLVkpn8DaNNZiR0uFOc8MzsnALrn3of8Zfpjvr20WerxDWbyWAqvjnT4
         wJYREah2Bzt1cZu2v+KGxKGL7jRm8Uj4xcpHb38gq5rJic3U/2+lXLsWwast+ErQUBRi
         PMno/k5THMgxcHw39OD4fW6z15xJnDVP6An9Ajhpr5emlZS5RYonCETfxXryUGlVu1B3
         rg4rERM/ld+83BXTfwnH29Bhjcc1cO6vyDUpBrBgkwryqLwyHiKxZ4fZ1DNHLYi04l4c
         3GVw==
In-Reply-To: <Y+QL8s1VEHlolXM3-+xijCwNIfdoLQcUKs7qKB+WAnPUfkyWGUBSOeVevoDU@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kafai-b10kYP2dOMg@public.gmane.org, songliubraving-b10kYP2dOMg@public.gmane.org, yhs-b10kYP2dOMg@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu, Feb 9, 2023 at 4:54 AM Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
>
> On Sun, Feb 05, 2023 at 06:58:00AM +0000, Yafang Shao wrote:
> > The bpf memory accouting has some known problems in contianer
> > environment,
> >
> > - The container memory usage is not consistent if there's pinned bpf
> >   program
> >   After the container restart, the leftover bpf programs won't account
> >   to the new generation, so the memory usage of the container is not
> >   consistent. This issue can be resolved by introducing selectable
> >   memcg, but we don't have an agreement on the solution yet. See also
> >   the discussions at https://lwn.net/Articles/905150/ .
> >
> > - The leftover non-preallocated bpf map can't be limited
> >   The leftover bpf map will be reparented, and thus it will be limited by
> >   the parent, rather than the container itself. Furthermore, if the
> >   parent is destroyed, it be will limited by its parent's parent, and so
> >   on. It can also be resolved by introducing selectable memcg.
> >
> > - The memory dynamically allocated in bpf prog is charged into root memcg
> >   only
> >   Nowdays the bpf prog can dynamically allocate memory, for example via
> >   bpf_obj_new(), but it only allocate from the global bpf_mem_alloc
> >   pool, so it will charge into root memcg only. That needs to be
> >   addressed by a new proposal.
> >
> > So let's give the user an option to disable bpf memory accouting.
> >
> > The idea of "cgroup.memory=nobpf" is originally by Tejun[1].
> >
> > [1]. https://lwn.net/ml/linux-mm/YxjOawzlgE458ezL-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org/
> >
> > Yafang Shao (5):
> >   mm: memcontrol: add new kernel parameter cgroup.memory=nobpf
> >   bpf: use bpf_map_kvcalloc in bpf_local_storage
> >   bpf: introduce bpf_memcg_flags()
> >   bpf: allow to disable bpf map memory accounting
> >   bpf: allow to disable bpf prog memory accounting
>
> Hello Yafang!
>
> Overall the patch looks good to me, please, feel free to add
> Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
>
> I'd squash patch (3) into (4), but up to you.
>

Sure. Will do it.

-- 
Regards
Yafang
