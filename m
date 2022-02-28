From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH v5 3/6] mm/memcg: Protect per-CPU counter by disabling
 preemption on PREEMPT_RT where needed.
Date: Mon, 28 Feb 2022 13:35:26 +0100
Message-ID: <YhzBjviBEMHlbIyA@linutronix.de>
References: <20220226204144.1008339-1-bigeasy@linutronix.de>
 <20220226204144.1008339-4-bigeasy@linutronix.de>
 <YhyCWQYL8vxRSLrd@dhcp22.suse.cz>
 <YhytODB1IQFLfx4h@linutronix.de>
 <YhywoBOPDuQmwmq0@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646051727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NrXkZIXCIbcCdTt1MSpZIrgg4yhy+z0slRqeYoIDKJQ=;
        b=zfPFtUvutLYYHKGpmWQcWje1s6f2f+G6B8+9yNeAZwmQW7kJNPL43+vYWrB3aejmPeGdb5
        xP4ZBpfjp2h/ILzvE0WoYqRIl3nrhQyPkwRU1ooZp3C4TywyBL2VJENpXTLPOI2jF4InDn
        J0F6b8AhkbptW7hr+ABVOY4KcHJYrZzwdSR26BH2ZTrQpdvibthwj0YRMSlgOO3SqvG4yG
        5Ps8VMnMejBUqkgBNJOVIVu+baSAWusRHhfcssIi5vAoaBMaq5IHk9Ztp2wFRnD2/9kiAq
        usISL7szkGNL6DutISpY6xOorqvchmbakdZ7qSH8XdQP6sc5k461pvXHIDoBLw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646051727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NrXkZIXCIbcCdTt1MSpZIrgg4yhy+z0slRqeYoIDKJQ=;
        b=siDmoQ6Xa3WguvR8ZjduUL4qXi7hQbJtZxBsk8HnrmRdRn4DpCdBK8kT53PBGqI0tj6Kav
        va+l7WlflT0jFTCg==
Content-Disposition: inline
In-Reply-To: <YhywoBOPDuQmwmq0-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On 2022-02-28 12:23:12 [+0100], Michal Hocko wrote:
> On Mon 28-02-22 12:08:40, Sebastian Andrzej Siewior wrote:
> > On 2022-02-28 09:05:45 [+0100], Michal Hocko wrote:
> > > Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> > > 
> > > TBH I am not a fan of the counter special casing for the debugging
> > > enabled warnings but I do not feel strong enough to push you trhough an
> > > additional version round.
> > 
> > do you want to get rid of the warnings completely? Since we had the
> > check in memcg_stats_lock() it kinda felt useful to add something in
> > __memcg_stats_lock() case, too.
> 
> The thing that I dislike is that there is no other way for potential
> users of those counters to know these expectations. This is not
> documented anywhere so it mostly describes the _current_ state of the
> code which might change in the future. We can be more thorough and
> document counters wrt. to the context they can be used in which would
> make this less of a concern of course. But this can be done on top hence
> I do not want to push you for another versions. It is good to have your
> current work merged in the next merge window as long as there are no
> fallouts and for that it would be good to have it in the linux next and
> exposed for some more testing rather than dealing with this deatails.

Okay. Then I would suggest then I document the usage context of these
counters once things settled down. Now there is no validation at all, so
if someone uses the wrong context for a counter and you don't spot it
during the review then there will be no warning at runtime.

Sebastian
