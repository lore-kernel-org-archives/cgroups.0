From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: rstat: optimize flush through speculative test
Date: Mon, 4 Oct 2021 08:21:18 -1000
Message-ID: <YVtGHoboSix3rexr@slm.duckdns.org>
References: <20210929235936.2859271-1-shakeelb@google.com>
 <YVszNI97NAAYpHpm@slm.duckdns.org>
 <CALvZod5OKz=7pFpxCt1CONPyJO4wR5t+PH0nzdbFBT1SYpjrsg@mail.gmail.com>
 <YVs9eJnNJYwF/3f3@slm.duckdns.org>
 <CALvZod47r=9j_MhZz9ngWv_JE4oqF1CrXTOQ2GpSSNFftZAsVA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2VzbwvFNZu13mZZTP9Y+UENOKafpTTohfJbme2kfEgk=;
        b=Nw7b1+oJPMMyD4gdc1HlxMBGwqpg1a0O8BDrm4iOUJ1zhJvddhzC1gjb3wgFj/rSLo
         dMrdraj87cftAtFT19pLNJJltx3epgPhpDJc/ESkdDN+jKkXbdMEh9mCQe9/39u7CcNQ
         3SSzmFkAPeLC/QXWVH5ZO7iMK2XECt1jqDu3PmYLY5dEHrM8RCLm+1YMwKQmey12c9PG
         IOQ9bU2N14yMYDeg+dmB9FwsLRtz0Q6i6sKT/Se/I6tIjbqgS0mWaIPQZLrIMTDbhraG
         hjRvxhRmhu9UaSENJr1e9ei59xgDzy8PQZazWr1/FOuQiu3ofrRr0tpvmugBV9ezplmv
         0UkA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALvZod47r=9j_MhZz9ngWv_JE4oqF1CrXTOQ2GpSSNFftZAsVA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Oct 04, 2021 at 11:07:45AM -0700, Shakeel Butt wrote:
> > Sorry for being so slow but can you point to the exact call path which gets
> > slowed down so significantly?
> 
> This is the mem_cgroup_flush_stats() inside workingset_refault() in
> mm/workingset.c.

I see. Was looking at a repo which was too old.

> > I'm mostly wondering whether we need some sort
> > of time-batched flushes because even with lock avoidance the flush path
> > really isn't great when called frequently. We can mitigate it further if
> > necessary - e.g. by adding an "updated" bitmap so that the flusher doesn't
> > have to go around touching the cachelines for all the cpus.
> 
> For the memcg stats, I already proposed a batched flush at [1].
> 
> I actually did perform the same experiment with the proposed patch
> along with [1] and it improves around just 1%. More specifically for
> memcg stats [1] is good enough but that is memcg specific and this
> patch has merits on its own.

So, the current rstat code doesn't pay a lot of attention to optimizing the
read path - the reasoning being that as long as we avoid O(nr_cgroups), the
flush operations aren't frequent enough to be problematic. The use in
refault path seems to change that balance and it likely is worthwhile to
update rstat accordingly. As I mentioned above, a next step could be adding
a cpumask which tracks cpus with populated updated list, which should add
pretty small cost to the writers while making frequent flushes significantly
cheaper.

What do you think about that approach? While the proposed patch looks fine,
it kinda bothers me that it's a very partial optimization - ie. if flush
frequency is high enough for this to matter, that for_each_possible_cpu()
scanning loop really isn't appropriate.

Thanks.

-- 
tejun
