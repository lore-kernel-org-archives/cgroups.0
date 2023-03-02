From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v5 2/6] mm/memcg: Disable threshold event handlers on
 PREEMPT_RT
Date: Thu, 2 Mar 2023 13:56:38 +0100
Message-ID: <ZACdBuVBHZ/AMAh/@dhcp22.suse.cz>
References: <20220226204144.1008339-1-bigeasy@linutronix.de>
 <20220226204144.1008339-3-bigeasy@linutronix.de>
 <xhsmh4jr4pbzc.mognet@vschneid.remote.csb>
 <ZABUMit05SZBDXRQ@dhcp22.suse.cz>
 <xhsmh1qm7pibs.mognet@vschneid.remote.csb>
 <ZACHa4wrtwpQbmP2@dhcp22.suse.cz>
 <xhsmhy1ofnxna.mognet@vschneid.remote.csb>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1677761799; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9dfdj+0VRA1atO5irS3WM17Vy2/MRKhULv8ZRzYg1B8=;
        b=obAnjgZcykCoUbbN6rN8SKlIpKGzcD1NSN1YK83PLumRG5PgrbmA/U6H+4pybKywOWd8SP
        LX4PO09z8ZWzd2sP1/uFyLeuFRQHYQjWv60IPVPnMwmmbogjKc7QG4UBUhTDSQMxG3hBrn
        pzwiLv0H0AUaIdaOdUeGuJsuBL7XeOk=
Content-Disposition: inline
In-Reply-To: <xhsmhy1ofnxna.mognet-lVOlpLwaOlUmbyhZVYo91WPO1xz+ivuR@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Thu 02-03-23 12:30:33, Valentin Schneider wrote:
> On 02/03/23 12:24, Michal Hocko wrote:
> > On Thu 02-03-23 10:18:31, Valentin Schneider wrote:
> >> On 02/03/23 08:45, Michal Hocko wrote:
> >> > On Wed 01-03-23 18:23:19, Valentin Schneider wrote:
> > [...]
> >> >> I want cgroupv1 to die as much as the next person, but in that specific
> >> >> situation I kinda need cgroupv1 to behave somewhat sanely on RT with
> >> >> threshold events :/
> >> >
> >> > Could you expand on the usecase?
> >> >
> >>
> >> In this case it's just some middleware leveraging memcontrol cgroups and
> >> setting up callbacks for in-cgroup OOM events. This is a supported feature
> >> in cgroupv2, so this isn't a problem of cgroupv1 vs cgroupv2 feature
> >> parity, but rather one of being in a transitional phase where the
> >> middleware itself hasn't fully migrated to using cgroupv2.
> >
> > How is this related to the RT kernel config? memcg OOM vs any RT
> > assumptions do not really get along well AFAICT.
> >
> 
> Yep. AIUI the tasks actually relying on RT guarantees DTRT (at least
> regarding memory allocations, or lack thereof), but other non-RT-reliant
> tasks on other CPUs come and go, hence the memcg involvement.

So are you suggesting that the RT kernel is used for mixed bag of
workloads with RT and non RT assumptions? Is this really a reasonable
and reliable setup?

What I am trying to evaluate here is whether it makes sense to support
and maintain a non-trivial code for something that might be working
sub-optimally or even not working properly in some corner cases. The
price for the maintenance is certainly not free.
-- 
Michal Hocko
SUSE Labs
