From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v5 3/6] mm/memcg: Protect per-CPU counter by disabling
 preemption on PREEMPT_RT where needed.
Date: Mon, 28 Feb 2022 12:23:12 +0100
Message-ID: <YhywoBOPDuQmwmq0@dhcp22.suse.cz>
References: <20220226204144.1008339-1-bigeasy@linutronix.de>
 <20220226204144.1008339-4-bigeasy@linutronix.de>
 <YhyCWQYL8vxRSLrd@dhcp22.suse.cz>
 <YhytODB1IQFLfx4h@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1646047396; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KR6yo3C6hJQk5k7SpkBMoRJDBxwgQp2yNNIt116CbC8=;
        b=LjHmtuP3WDYlvPgswTQU7/wTCdZoXJ1pFMe8y4EoxX49PehbYAMD7AHzqyREGFBNGmBAqi
        ELrQuydUDJEL9gAnbxWYbqBjnyq7RHgn/TOd6EYCgpHndNmiXudczQnjR3HjDu9TaRCQhG
        0ru55ZKi/CMeP62MvOCMIHLrP15v+ek=
Content-Disposition: inline
In-Reply-To: <YhytODB1IQFLfx4h-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On Mon 28-02-22 12:08:40, Sebastian Andrzej Siewior wrote:
> On 2022-02-28 09:05:45 [+0100], Michal Hocko wrote:
> > Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> > 
> > TBH I am not a fan of the counter special casing for the debugging
> > enabled warnings but I do not feel strong enough to push you trhough an
> > additional version round.
> 
> do you want to get rid of the warnings completely? Since we had the
> check in memcg_stats_lock() it kinda felt useful to add something in
> __memcg_stats_lock() case, too.

The thing that I dislike is that there is no other way for potential
users of those counters to know these expectations. This is not
documented anywhere so it mostly describes the _current_ state of the
code which might change in the future. We can be more thorough and
document counters wrt. to the context they can be used in which would
make this less of a concern of course. But this can be done on top hence
I do not want to push you for another versions. It is good to have your
current work merged in the next merge window as long as there are no
fallouts and for that it would be good to have it in the linux next and
exposed for some more testing rather than dealing with this deatails.
-- 
Michal Hocko
SUSE Labs
