From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: Export memcg->watermark via sysfs for v2
 memcg
Date: Fri, 6 May 2022 16:49:41 -0400
Message-ID: <YnWJ5QgRyc+Ualjx@cmpxchg.org>
References: <20220505121329.GA32827@us192.sjc.aristanetworks.com>
 <YnU3EuaWCKL5LZLy@cmpxchg.org>
 <CALvZod6jcdhHqFEo1r-y5QufA+LxeCDy9hnD2ag_8vkvxXtp2Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kM1Re2q1+o0mt7HNTzM9pmXb6Uv+LgAUNdOExkGF+Sk=;
        b=nCHZ2VjR2LksJL8hdsGYZ4YP8kaLy7y7F6GQMdz9S/7UTbw/6qCJQA9cmKW5G4fvEK
         /nrOkjPS9aulj5o7hdS9zR69R2yovdEm6GdgAtRvQfFTBhvcYYGrIBZxKRcrQsHfKt59
         PWcTPtpYxK+8sL58NOSDkbq4jtTVF8o0O7MVP55ECx2Vnwk7dNRqhxwAIsgFEYqluaaR
         7U2Ed+uAGYvDnd36Aem7eflCHJ5Fnmp5OYyhPx7RJzCyWZQvuRVxqnKlpNTwIhr5P5MQ
         k7YzRaQHr5ptE/nQqk/ADvfd7lOXxDdNS6xmjkb2dY0GhfS+HZ1cl8yCexk56ZIB12d5
         Il/w==
Content-Disposition: inline
In-Reply-To: <CALvZod6jcdhHqFEo1r-y5QufA+LxeCDy9hnD2ag_8vkvxXtp2Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Fri, May 06, 2022 at 08:56:31AM -0700, Shakeel Butt wrote:
> On Fri, May 6, 2022 at 7:57 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> >
> > On Thu, May 05, 2022 at 05:13:30AM -0700, Ganesan Rajagopal wrote:
> > > v1 memcg exports memcg->watermark as "memory.mem_usage_in_bytes" in
> > > sysfs. This is missing for v2 memcg though "memory.current" is exported.
> > > There is no other easy way of getting this information in Linux.
> > > getrsuage() returns ru_maxrss but that's the max RSS of a single process
> > > instead of the aggregated max RSS of all the processes. Hence, expose
> > > memcg->watermark as "memory.watermark" for v2 memcg.
> > >
> > > Signed-off-by: Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
> >
> > This wasn't initially added to cgroup2 because its usefulness is very
> > specific: it's (mostly) useless on limited cgroups, on long-running
> > cgroups, and on cgroups that are recycled for multiple jobs. And I
> > expect these categories apply to the majority of cgroup usecases.
> >
> > However, for the situation where you want to measure the footprint of
> > a short-lived, unlimited one-off cgroup, there really is no good
> > alternative. And it's a legitimate usecase. It doesn't cost much to
> > maintain this info. So I think we should go ahead with this patch.
> >
> > But please add a blurb to Documentation/admin-guide/cgroup-v2.rst.
> 
> No objection from me. I do have two points: (1) watermark is not a
> good name for this interface, maybe max_usage or something.

How about memory.peak? It'd be nice to avoid underscores.

> (2) a way to reset (i.e. write to it, reset it).

We used to have that with cgroup1, but it gets weird in modern cgroup
environments when there can be multiple consumers. One of them resets
the stat for their own purpose, now the others have no idea what
sample time frame they are looking at.

It'd be more robust if we just said "peak usage since birth of
cgroup". If you want to sample new work, create a new cgroup.
