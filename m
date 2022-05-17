From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [RFC] Add swappiness argument to memory.reclaim
Date: Tue, 17 May 2022 16:06:45 -0400
Message-ID: <YoQAVeGj19YpSMDb@cmpxchg.org>
References: <CAJD7tkbDpyoODveCsnaqBBMZEkDvshXJmNdbk51yKSNgD7aGdg@mail.gmail.com>
 <YoNHJwyjR7NJ5kG7@dhcp22.suse.cz>
 <CAJD7tkYnBjuwQDzdeo6irHY=so-E8z=Kc_kZe52anMOmRL+8yA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qcMWVmYSlURTnutvjvuEW7rjU+P4VkwffWxfR8GtrEA=;
        b=LGie6wwZcbo09Ckj8tP/4otrxCtis9dRmDTD9qDyh3biKQ98yrbjUcuchEk8INxwFG
         8b6Tn3W3SJdpgx9i1SgzxcRmFafKytH/WTHsSwLOQmHs27J9KXp/vBkzHb+uWTjBTirT
         EfJwMOHmhj2dsvVunuSViW+twEuUEC4JB5mBUW7T2eYx67PHgrJSz6aiA6vhBE6UHGzg
         tlC5FC/eTVTfo08giVbYDiwZXDE1VXYaZQGAPwdMBEylGSzsA/Wn9+7J3TNiEYaBSS6c
         KjQPd3YJ6BgpCJHNxOlY4gU61In53Pwdr5Mmx2p8GZI4M/sIRwDpUmISWg6pgPneN/vu
         JnUg==
Content-Disposition: inline
In-Reply-To: <CAJD7tkYnBjuwQDzdeo6irHY=so-E8z=Kc_kZe52anMOmRL+8yA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chen Wandun <chenwandun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi Yosry,

On Tue, May 17, 2022 at 11:06:36AM -0700, Yosry Ahmed wrote:
> On Mon, May 16, 2022 at 11:56 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> >
> > On Mon 16-05-22 15:29:42, Yosry Ahmed wrote:
> > > The discussions on the patch series [1] to add memory.reclaim has
> > > shown that it is desirable to add an argument to control the type of
> > > memory being reclaimed by invoked proactive reclaim using
> > > memory.reclaim.
> > >
> > > I am proposing adding a swappiness optional argument to the interface.
> > > If set, it overwrites vm.swappiness and per-memcg swappiness. This
> > > provides a way to enforce user policy on a stateless per-reclaim
> > > basis. We can make policy decisions to perform reclaim differently for
> > > tasks of different app classes based on their individual QoS needs. It
> > > also helps for use cases when particularly page cache is high and we
> > > want to mainly hit that without swapping out.
> >
> > Can you be more specific about the usecase please? Also how do you
> 
> For example for a class of applications it may be known that
> reclaiming one type of pages anon/file is more profitable or will
> incur an overhead, based on userspace knowledge of the nature of the
> app.

I want to make sure I understand what you're trying to correct for
with this bias. Could you expand some on what you mean by profitable?

The way the kernel thinks today is that importance of any given page
is its access frequency times the cost of paging it. swappiness exists
to recognize differences in the second part: the cost involved in
swapping a page vs the cost of a file cache miss.

For example, page A is accessed 10 times more frequently than B, but B
is 10 times more expensive to refault/swapin. Combining that, they
should be roughly equal reclaim candidates.

This is the same with the seek parameter of slab shrinkers: some
objects are more expensive to recreate than others. Once corrected for
that, presence of reference bits can be interpreted on an even level.

While access frequency is clearly a workload property, the cost of
refaulting is conventionally not - let alone a per-reclaim property!

If I understand you correctly, you're saying that the backing type of
a piece of memory can say something about the importance of the data
within. Something that goes beyond the work of recreating it.

Is that true or am I misreading this?

If that's your claim, isn't that, if it happens, mostly incidental?

For example, in our fleet we used to copy executable text into
anonymous memory to get THP backing. With file THP support in the
kernel, the text is back in cache. The importance of the memory
*contents* stayed the same. The backing storage changed, but beyond
that the anon/file distinction doesn't mean anything.

Another example. Probably one of the most common workload structures
is text, heap, logging/startup/error handling: hot file, warm anon,
cold file. How does prioritizing either file or anon apply to this?

Maybe I'm misunderstanding and this IS about per-workload backing
types? Maybe the per-cgroup swapfiles that you guys are using?

> If most of what an app use for example is anon/tmpfs then it might
> be better to explicitly ask the kernel to reclaim anon, and to avoid
> reclaiming file pages in order not to hurt the file cache
> performance.

Hm.

Reclaim ages those pools based on their size, so a dominant anon set
should receive more pressure than a small file set. I can see two
options why this doesn't produce the desired results:

1) Reclaim is broken and doesn't allocate scan rates right, or

2) Access frequency x refault cost alone is not a satisfactory
   predictor for the value of any given page.

Can you see another?

I can sort of see the argument for 2), because it can be workload
dependent: a 50ms refault in a single-threaded part of the program is
likely more disruptive than the same refault in an asynchronous worker
thread. This is a factor we're not really taking into account today.

But I don't think an anon/file bias will capture this coefficient?
