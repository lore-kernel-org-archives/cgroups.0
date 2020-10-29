From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v2] mm: memcg/slab: Fix return child memcg objcg for root
 memcg
Date: Thu, 29 Oct 2020 14:25:57 -0700
Message-ID: <20201029212557.GJ827280@carbon.dhcp.thefacebook.com>
References: <20201028035013.99711-1-songmuchun@bytedance.com>
 <CALvZod6p_y2fTEK5fzAL=JfPsguqYbttgWC4_GPc=rF1PsN6TQ@mail.gmail.com>
 <20201029170955.GI827280@carbon.dhcp.thefacebook.com>
 <CALvZod65MhzQiwGgLM89_gZzCFDaeSZofn08viPgcvra0JRvSg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=NULL1jFkMVxKNQ8qfqLQp2HhKq8uLzw6n1P2kqs2Wvo=;
 b=giX/Zi4EvnlqtHWzqa6L7QIhLLUjwei8oZn8g8Gh/TYC0d0aEkq+fqWZvWP853uHZBoz
 ymhBifeEYM3iqJza3jalaV6c1c77nD5mKxhObk7k2PGfVIR0g6j5v2uDO96jGpwB4mFt
 18RjALoN8kh+JqYLUWP4t0RSde1RwzZLbEc= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NULL1jFkMVxKNQ8qfqLQp2HhKq8uLzw6n1P2kqs2Wvo=;
 b=f8k5m1UmmE69HjXaBzFjwPhIKuozOJqsGSRoBPs0g1am//k/+kCf9ynNlO5y1TKVFwTtKTbs2jH+/FGxSlaJJRcyAvSBPNIjIcJ9tgi45wf64AUMadFxa78SMYdH/cBIwacOYwfSL47VItdhhcTAcgbcjE0YUOyqIpEqp8BL/HI=
Content-Disposition: inline
In-Reply-To: <CALvZod65MhzQiwGgLM89_gZzCFDaeSZofn08viPgcvra0JRvSg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "Peter Zijlstra (Intel)" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, areber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Marco Elver <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Thu, Oct 29, 2020 at 01:34:57PM -0700, Shakeel Butt wrote:
> On Thu, Oct 29, 2020 at 10:10 AM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
> >
> > On Thu, Oct 29, 2020 at 08:48:45AM -0700, Shakeel Butt wrote:
> > > On Tue, Oct 27, 2020 at 8:50 PM Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
> > > >
> > > > Consider the following memcg hierarchy.
> > > >
> > > >                     root
> > > >                    /    \
> > > >                   A      B
> > > >
> > > > If we get the objcg of memcg A failed,
> > >
> > > Please fix the above statement.
> > >
> > > > the get_obj_cgroup_from_current
> > > > can return the wrong objcg for the root memcg.
> > > >
> > > > Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")
> > > > Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> > > > ---
> > > >  changelog in v2:
> > > >  1. Do not use a comparison with the root_mem_cgroup
> > > >
> > > >  mm/memcontrol.c | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > >
> > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > index 1337775b04f3..8c8b4c3ed5a0 100644
> > > > --- a/mm/memcontrol.c
> > > > +++ b/mm/memcontrol.c
> > > > @@ -2961,6 +2961,7 @@ __always_inline struct obj_cgroup *get_obj_cgroup_from_current(void)
> > > >                 objcg = rcu_dereference(memcg->objcg);
> > > >                 if (objcg && obj_cgroup_tryget(objcg))
> > > >                         break;
> > > > +               objcg = NULL;
> > >
> > > Roman, in your cleanup, are you planning to have objcg for root memcg as well?
> >
> > Yes. I'll just change the for loop to include the root_mem_cgroup.
> >
> 
> Then do we really need this patch since it's not tagged for stable?

A good question.

Honestly, I really doubt that obj_cgroup_tryget() can fail even with the current code.
But, formally speaking, it's possible. So there is likely no practical difference if
we'll apply this patch or not, even without the root handling cleanup.

But you're right, with the root handling cleanup, it will make even less of a difference.

Thanks!


