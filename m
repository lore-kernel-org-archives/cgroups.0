From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 3/4] mm/memcg: Add a local_lock_t for IRQ and TASK object.
Date: Tue, 8 Feb 2022 18:28:54 +0100
Message-ID: <YgKoVo8e0tZI9zGQ@dhcp22.suse.cz>
References: <20220125164337.2071854-1-bigeasy@linutronix.de>
 <20220125164337.2071854-4-bigeasy@linutronix.de>
 <7f4928b8-16e2-88b3-2688-1519a19653a9@suse.cz>
 <Yff69slA4UTz5Q1Y@linutronix.de>
 <e068646f-c7f2-5876-8577-6ddf93df07d0@suse.cz>
 <YgKlr+sHZPayWKUP@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1644341335; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=084qkkVKwxLtc8ghPiqPMfhm1DMYA6O/V2WaZEb6smo=;
        b=jqZ9+RlJpu2xYhBXfWYhPVl3HqCHQ+sLPeCxx54h2OdqdT9BuO2wBEqg3+EKf8vnkgkrv8
        jIyrj47WXCn6zHDDWqHfRxMmnscqZEJ/tltl18hFq/wg/C/eXUHkr0z5605D2MYeUOHd58
        IjhYrPIcLOuF28URKVmQ+XnOSJlNO00=
Content-Disposition: inline
In-Reply-To: <YgKlr+sHZPayWKUP-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Tue 08-02-22 18:17:35, Sebastian Andrzej Siewior wrote:
> On 2022-02-03 17:01:41 [+0100], Vlastimil Babka wrote:
> > > Let me know if a revert is preferred or you want to keep that so that I
> > 
> > I see that's discussed in the subthread with Michal Hocko, so I would be
> > also leaning towards revert unless convincing numbers are provided.
> > 
> > > can prepare the patches accordingly before posting.
> > 
> > An acceptable form of this would have to basically replace the bool
> > stock_lock_acquried with two variants of the code paths that rely on it,
> > feel free to read though the previous occurence :)
> > https://lore.kernel.org/all/CAHk-=wiJLqL2cUhJbvpyPQpkbVOu1rVSzgO2=S2jC55hneLtfQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/
> 
> I did that locally already. I was referring to the revert.
> So repost with bool fixed and the revert will be discussed later or
> include the revert at the begin of the series and then rebase these
> patches on top of it? I probably don't get to it before FRI so I don't
> try to rush anyone here ;)

If you start with the revert then you should be able to get rid of a lot
of complexity, right? We still haven't heard from Weiman about his
original optimization reasoning. There might be good reasons for it
which just hasn't been explicitly mentioned yet.

As already said, if the optimization is visible only in microbenchmarks
without any real workload benefiting from it I would rather consider
reverting it and make the RT addoption easier. Micro optimizations can
always be done on top.
-- 
Michal Hocko
SUSE Labs
