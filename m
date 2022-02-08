From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH 3/4] mm/memcg: Add a local_lock_t for IRQ and TASK object.
Date: Tue, 8 Feb 2022 18:17:35 +0100
Message-ID: <YgKlr+sHZPayWKUP@linutronix.de>
References: <20220125164337.2071854-1-bigeasy@linutronix.de>
 <20220125164337.2071854-4-bigeasy@linutronix.de>
 <7f4928b8-16e2-88b3-2688-1519a19653a9@suse.cz>
 <Yff69slA4UTz5Q1Y@linutronix.de>
 <e068646f-c7f2-5876-8577-6ddf93df07d0@suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1644340657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZnZWZNhs5o+4JIrFiRfBiatdlnub+aor48OWnJbqbV0=;
        b=CymkxE04oxx3Vqb3s56uVlf3f9DLLTymVburTR9hTaQLVjPWRDQRm4Yl8Vx575ctIQjhZw
        YtTb7yTKlTngkIpydJQMZq/byOer/cLp8FOYtGihKBmOdVR56mU5HojvjDmZVlXjQIp7Gh
        3qwK2BEf/WtEHULr0f9hZZEgsCAlTEMu42yUikIPkTj37jrdKbtQSpJGNO24cpEBq7mACj
        Hh5H2CBmCT2E02gj0rLIwZtyb3HhpghKLCAqQ7vo63/SfflKkv+sYcYigLqjIWLYkdomp/
        zTAF5Yrsel7rMBpk1tWCvRTqLNwpl/98moyDjt3UqCTgft6nYwFZdEt56yRbrQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1644340657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZnZWZNhs5o+4JIrFiRfBiatdlnub+aor48OWnJbqbV0=;
        b=8qEQonLSxr1SCnJLKqM8ZxMFBLrXJjd7eFKJ7HlZr2xJ5R10+LM0X39bq7gU2p6RuwE14j
        0AETUFKDpx+QMwDw==
Content-Disposition: inline
In-Reply-To: <e068646f-c7f2-5876-8577-6ddf93df07d0-AlSwsSmVLrQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 2022-02-03 17:01:41 [+0100], Vlastimil Babka wrote:
> > Let me know if a revert is preferred or you want to keep that so that I
> 
> I see that's discussed in the subthread with Michal Hocko, so I would be
> also leaning towards revert unless convincing numbers are provided.
> 
> > can prepare the patches accordingly before posting.
> 
> An acceptable form of this would have to basically replace the bool
> stock_lock_acquried with two variants of the code paths that rely on it,
> feel free to read though the previous occurence :)
> https://lore.kernel.org/all/CAHk-=wiJLqL2cUhJbvpyPQpkbVOu1rVSzgO2=S2jC55hneLtfQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/

I did that locally already. I was referring to the revert.
So repost with bool fixed and the revert will be discussed later or
include the revert at the begin of the series and then rebase these
patches on top of it? I probably don't get to it before FRI so I don't
try to rush anyone here ;)

Sebastian
