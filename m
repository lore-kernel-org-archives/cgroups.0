From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH 0/3] mm/memcg: Address PREEMPT_RT problems instead of
 disabling it.
Date: Wed, 5 Jan 2022 15:59:56 +0100
Message-ID: <20220105145956.GB6464@blackbody.suse.cz>
References: <20211222114111.2206248-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1641394802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xOj26D6fm43j15dqVrf0hceSd4J2qRRwl3HK5gQlMgA=;
        b=lvvYVwwLH4vMlbFEB91tnplSrOLp+7YwQpo+uhlNySKemJH50KpRgtNLRV+8JEgAQW3pE0
        +DwGzmzVdOrklBFLEP8GypjyaSR+oNPq9LM1+dHYuPav0bZGbgAUrX/7UDQS2XY05K3cdK
        psrao+/yya4S3ciUOoOT46zGanM5pvM=
Content-Disposition: inline
In-Reply-To: <20211222114111.2206248-1-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Wed, Dec 22, 2021 at 12:41:08PM +0100, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:
> - lockdep complains were triggered by test_core and test_freezer (both
>   had to run):

This doesn't happen on the patched kernel, correct?

Thanks,
Michal
