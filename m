From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH v4 12/16] memcg: enable accounting for posix_timers_cache slab
Date: Fri, 07 May 2021 17:48:16 +0200
Message-ID: <87r1iimtof.ffs@nanos.tec.linutronix.de>
References: <8664122a-99d3-7199-869a-781b21b7e712@virtuozzo.com> <41e1ebc8-4f95-4a3f-3665-3fe139786d8e@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1620402497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u8xnyANDKNSkvt5YrG1NH2QAtW1TH6g1ROBYf6y7AZU=;
        b=IZYl6+DJTBqwM43/24DZhOJZSwEFcEfUhKM6FcsIN2N3Gk6uIWqGcGYantoO7ZsywhadY4
        QntLGZZ9KefJF1aULowbN95fV067yAfjBEvPZc1JZUtis3JPVcY4HhSDcv+Gglr4MXgsob
        RXct+DIHg4eK9JuRGNmGIcO8MEcf8dZw/b8e/4OBMje7mRHo5kfkXF361SAWNlT0iO0xeJ
        q3gpBwhQ+A21e8sqFBoxHX1kplK20F7uct9wMpi4QrKmGKoQLgfauZlaPkLXGFFp/zrPJa
        yS4UlVZyRnDu7+YywDDvBWEHcD91eUuPnbQlK49RunI2QAA8AR8BC6moMImJqQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1620402497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u8xnyANDKNSkvt5YrG1NH2QAtW1TH6g1ROBYf6y7AZU=;
        b=srWkvOdm1PfhZYesjT3FoEpAkq2deSBQJg0/rXJc39X1HwHUPeF25zYNpoLy3rRcgs5DTU
        tEB8NhbpI3GmgJCQ==
In-Reply-To: <41e1ebc8-4f95-4a3f-3665-3fe139786d8e-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Apr 28 2021 at 09:53, Vasily Averin wrote:

> A program may create multiple interval timers using timer_create().
> For each timer the kernel preallocates a "queued real-time signal",
> Consequently, the number of timers is limited by the RLIMIT_SIGPENDING
> resource limit. The allocated object is quite small, ~250 bytes,
> but even the default signal limits allow to consume up to 100 megabytes
> per user.
>
> It makes sense to account for them to limit the host's memory consumption
> from inside the memcg-limited container.
>
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

Reviewed-by: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
