From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH v2] mm: memcg/slab: Fix return child memcg
 objcg for root memcg
Date: Fri, 30 Oct 2020 00:08:58 +0800
Message-ID: <CAMZfGtW38sFcdpnx3Xx+RgRL37WzpQsq8qvfdnmhbh4H9Ex0cg@mail.gmail.com>
References: <20201028035013.99711-1-songmuchun@bytedance.com> <CALvZod6p_y2fTEK5fzAL=JfPsguqYbttgWC4_GPc=rF1PsN6TQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+mBWfRe+OIpv7WsNMP7DYo0jsOnffJofR1p3pyhBTUE=;
        b=aAk00euheapwS9xRA1bncmzHvN9I+6nyRyTCd3xMc2dkkXTXJBxXHQPbZj5LEfqx2a
         5P+ylRRBoUhWmx7cNyr2tT/0FsGSiu3nvxnCMR60vF9ivHhn7fN6PfuI7sSI1nTmTQmo
         Cpv5WwRe5QSPQqqek07hNLOVeAKodbAY9krPKSDnktsyWuvqYizgHIugu8JcKb31NMV+
         OkdSCjhNrEIJar/D7QI6ipEpTto94dnCyjP78etZHXvq5x1mi0cYudGrBkKUQoTv7PFr
         aKrrRWp/VwMw6wgCLeR+efWZkXG26cYmtDRxlzGMJkKASKCh05U6EQc7wd9f0/9YGzS6
         Wz7A==
In-Reply-To: <CALvZod6p_y2fTEK5fzAL=JfPsguqYbttgWC4_GPc=rF1PsN6TQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "Peter Zijlstra (Intel)" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, areber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Marco Elver <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Thu, Oct 29, 2020 at 11:48 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Tue, Oct 27, 2020 at 8:50 PM Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
> >
> > Consider the following memcg hierarchy.
> >
> >                     root
> >                    /    \
> >                   A      B
> >
> > If we get the objcg of memcg A failed,
>
> Please fix the above statement.

Sorry, could you be more specific, I don't quite understand.
Thanks.


>
> > the get_obj_cgroup_from_current
> > can return the wrong objcg for the root memcg.
> >
> > Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")
> > Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> > ---
> >  changelog in v2:
> >  1. Do not use a comparison with the root_mem_cgroup
> >
> >  mm/memcontrol.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 1337775b04f3..8c8b4c3ed5a0 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2961,6 +2961,7 @@ __always_inline struct obj_cgroup *get_obj_cgroup_from_current(void)
> >                 objcg = rcu_dereference(memcg->objcg);
> >                 if (objcg && obj_cgroup_tryget(objcg))
> >                         break;
> > +               objcg = NULL;
>
> Roman, in your cleanup, are you planning to have objcg for root memcg as well?
>
> >         }
> >         rcu_read_unlock();
> >
> > --
> > 2.20.1
> >


