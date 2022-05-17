From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] Add swappiness argument to memory.reclaim
Date: Tue, 17 May 2022 11:13:10 -0700
Message-ID: <CAJD7tkbbiP0RusWBdCvozjauKN-vhgvzWtsL3Hu5y2dLr63idQ@mail.gmail.com>
References: <CAJD7tkbDpyoODveCsnaqBBMZEkDvshXJmNdbk51yKSNgD7aGdg@mail.gmail.com>
 <YoPHtHXzpK51F/1Z@carbon>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SxdLGiW7G4yy4xMRD8hfhHfhbpz1FE3G/RxrHKIn0i4=;
        b=dlOjwguLoSABSlSgnpYbdu/+hz6xKKTWhzMk/C7LJGmIpRXsihQvKoARr8bmjTriEN
         CnZHHPI2C6oDaLfkZ/omNpk2kv0RAjqvQFOH1wjzYlmNblToLm7kwdYRSORYVgTzy0TX
         x43CqGlTOW1HisGyl/oCzP8SWveY/V6ov38GxWtdQ8CjCkCQMPiNjeBLGeHRIXMTCCNQ
         5tFyi/hY0V1RA7m53sC3PKKtrvyTOju4KPAXPgE9CjhmIumupMoyfhcxAfdfeO8b1T18
         J7mie+Ri7kqib9BUe8Ys0WGxdy5mjIjG5eEIc6KeN0U5Rz8uIL1LV+0NDyoqZqumhfU8
         BdKQ==
In-Reply-To: <YoPHtHXzpK51F/1Z@carbon>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chen Wandun <chenwandun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Tue, May 17, 2022 at 9:05 AM Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
>
> On Mon, May 16, 2022 at 03:29:42PM -0700, Yosry Ahmed wrote:
> > The discussions on the patch series [1] to add memory.reclaim has
> > shown that it is desirable to add an argument to control the type of
> > memory being reclaimed by invoked proactive reclaim using
> > memory.reclaim.
> >
> > I am proposing adding a swappiness optional argument to the interface.
> > If set, it overwrites vm.swappiness and per-memcg swappiness. This
> > provides a way to enforce user policy on a stateless per-reclaim
> > basis. We can make policy decisions to perform reclaim differently for
> > tasks of different app classes based on their individual QoS needs. It
> > also helps for use cases when particularly page cache is high and we
> > want to mainly hit that without swapping out.
> >
> > The interface would be something like this (utilizing the nested-keyed
> > interface we documented earlier):
> >
> > $ echo "200M swappiness=30" > memory.reclaim
>
> What are the anticipated use cases except swappiness == 0 and
> swappiness == system_default?
>
> IMO it's better to allow specifying the type of memory to reclaim,
> e.g. type="file"/"anon"/"slab", it's a way more clear what to expect.

I imagined swappiness would give user space flexibility to reclaim a
ratio of file vs. anon as it sees fit based on app class or userspace
policy, but I agree that the guarantees of swappiness are weak and we
might want an explicit argument that directly controls the return
value of get_scan_count() or whether or not we call shrink_slab(). My
fear is that this interface may be less flexible, for example if we
only want to avoid reclaiming file pages, but we are fine with anon or
slab. Maybe in the future we will have a new type of memory to
reclaim, does it get implicitly reclaimed when other types are
specified or not?

Maybe we can use one argument per type instead? E.g.
    $ echo "200M file=no anon=yes slab=yes" > memory.reclaim

The default value would be "yes" for all types unless stated
otherwise. This is also leaves room for future extensions (maybe
file=clean to reclaim clean file pages only?). Interested to hear your
thoughts on this!

>
> E.g. what
> $ echo "200M swappiness=1" > memory.reclaim
> means if there is only 10M of pagecache? How much of anon memory will
> be reclaimed?

Good point. I agree that the type argument or per-type arguments have
multiple advantages over swappiness.

>
> Thanks!
