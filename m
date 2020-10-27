From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [External] Re: [PATCH 5/5] mm: memcontrol: Simplify the
 mem_cgroup_page_lruvec
Date: Tue, 27 Oct 2020 15:31:41 +0100
Message-ID: <20201027143141.GX20500@dhcp22.suse.cz>
References: <20201027080256.76497-1-songmuchun@bytedance.com>
 <20201027080256.76497-6-songmuchun@bytedance.com>
 <20201027133639.GT20500@dhcp22.suse.cz>
 <CAMZfGtUDguQkO0nF8Vt5qUVmmu4rCQcXx4nOhqUBSLnMYs2_BA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1603809106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uuw37CmdGgaUF2rTsLXZIxdwBi56keqYJAASysIsH4U=;
        b=QScZCtVJ88Ft10nSiaAM31z9hd30tvg7sm0uLaSV0xvsBBwNiIAiXthx+uw5HdJDHCO2gL
        /LScYs8N/+/Y/g1sEzi3bViteDVWpDr9u5cLVN927E+Y2dug78ERP+RSXwlnzu8X2JnfZ0
        dPK7a+yMSWEJqpmUm9TGElUUj2fhHV4=
Content-Disposition: inline
In-Reply-To: <CAMZfGtUDguQkO0nF8Vt5qUVmmu4rCQcXx4nOhqUBSLnMYs2_BA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, areber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Marco Elver <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Tue 27-10-20 22:15:16, Muchun Song wrote:
> On Tue, Oct 27, 2020 at 9:36 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> >
> > On Tue 27-10-20 16:02:56, Muchun Song wrote:
> > > We can reuse the code of mem_cgroup_lruvec() to simplify the code
> > > of the mem_cgroup_page_lruvec().
> >
> > yes, removing the code duplication is reasonable. But ...
> >
> > >
> > > Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> > > ---
> > >  include/linux/memcontrol.h | 44 +++++++++++++++++++++++++++-----------
> > >  mm/memcontrol.c            | 40 ----------------------------------
> > >  2 files changed, 32 insertions(+), 52 deletions(-)
> > >
> > > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > > index 95807bf6be64..5e8480e54cd8 100644
> > > --- a/include/linux/memcontrol.h
> > > +++ b/include/linux/memcontrol.h
> > > @@ -451,16 +451,9 @@ mem_cgroup_nodeinfo(struct mem_cgroup *memcg, int nid)
> > >       return memcg->nodeinfo[nid];
> > >  }
> > >
> > > -/**
> > > - * mem_cgroup_lruvec - get the lru list vector for a memcg & node
> > > - * @memcg: memcg of the wanted lruvec
> > > - *
> > > - * Returns the lru list vector holding pages for a given @memcg &
> > > - * @node combination. This can be the node lruvec, if the memory
> > > - * controller is disabled.
> > > - */
> > > -static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
> > > -                                            struct pglist_data *pgdat)
> > > +static inline struct lruvec *mem_cgroup_node_lruvec(struct mem_cgroup *memcg,
> > > +                                                 struct pglist_data *pgdat,
> > > +                                                 int nid)
> >
> > This is just wrong interface. Either take nid or pgdat. You do not want
> > both because that just begs for wrong usage.
> 
> If we want to avoid abuse of mem_cgroup_node_lruvec. We can move
> those functions to the memcontrol.c. And add the "static" attribute to the
> mem_cgroup_node_lruvec. Just export mem_cgroup_lruvec and
> mem_cgroup_page_lruvec. Is this OK?

Sorry, I was probably not clear enough. I am not against the function
per se. I just do not think we want to make it trickier to use than
necessary. That means either use pgdat or nid argument. Not both because
they should always be in sync and you can trivially get from one to the
other and vice versa.
-- 
Michal Hocko
SUSE Labs
