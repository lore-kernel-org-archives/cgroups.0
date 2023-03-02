From: Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 2/6] mm/memcg: Disable threshold event handlers on
 PREEMPT_RT
Date: Thu, 02 Mar 2023 14:34:25 +0000
Message-ID: <xhsmhv8jjnrwu.mognet@vschneid.remote.csb>
References: <20220226204144.1008339-1-bigeasy@linutronix.de>
 <20220226204144.1008339-3-bigeasy@linutronix.de>
 <xhsmh4jr4pbzc.mognet@vschneid.remote.csb>
 <ZABUMit05SZBDXRQ@dhcp22.suse.cz>
 <xhsmh1qm7pibs.mognet@vschneid.remote.csb>
 <ZACHa4wrtwpQbmP2@dhcp22.suse.cz>
 <xhsmhy1ofnxna.mognet@vschneid.remote.csb>
 <ZACdBuVBHZ/AMAh/@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677767669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5V3alQcVkOJNOkTm4XGYWiJj17BscHIm8UZULKEJ6sI=;
        b=IsHYNie5blTXeBOuDT+Mf45PxS2KSfdzsVBMoaM+MNwHvbkzINbwkAaUdAyejC6M48v39B
        qwZsqszXChqaan5YDf+6glKH6UULrCM9CkTzETgpOD/Y4w7JKDb4/Q+oWwzuL95tz0JRAd
        zLLvLJ/3AoSVfXhC/bnA5jZKcEBNuyw=
In-Reply-To: <ZACdBuVBHZ/AMAh/@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 02/03/23 13:56, Michal Hocko wrote:
> On Thu 02-03-23 12:30:33, Valentin Schneider wrote:
>> On 02/03/23 12:24, Michal Hocko wrote:
>> > On Thu 02-03-23 10:18:31, Valentin Schneider wrote:
>> >> On 02/03/23 08:45, Michal Hocko wrote:
>> >> > On Wed 01-03-23 18:23:19, Valentin Schneider wrote:
>> > [...]
>> >> >> I want cgroupv1 to die as much as the next person, but in that specific
>> >> >> situation I kinda need cgroupv1 to behave somewhat sanely on RT with
>> >> >> threshold events :/
>> >> >
>> >> > Could you expand on the usecase?
>> >> >
>> >>
>> >> In this case it's just some middleware leveraging memcontrol cgroups and
>> >> setting up callbacks for in-cgroup OOM events. This is a supported feature
>> >> in cgroupv2, so this isn't a problem of cgroupv1 vs cgroupv2 feature
>> >> parity, but rather one of being in a transitional phase where the
>> >> middleware itself hasn't fully migrated to using cgroupv2.
>> >
>> > How is this related to the RT kernel config? memcg OOM vs any RT
>> > assumptions do not really get along well AFAICT.
>> >
>>
>> Yep. AIUI the tasks actually relying on RT guarantees DTRT (at least
>> regarding memory allocations, or lack thereof), but other non-RT-reliant
>> tasks on other CPUs come and go, hence the memcg involvement.
>
> So are you suggesting that the RT kernel is used for mixed bag of
> workloads with RT and non RT assumptions? Is this really a reasonable
> and reliable setup?
>

To some extent :-)

> What I am trying to evaluate here is whether it makes sense to support
> and maintain a non-trivial code for something that might be working
> sub-optimally or even not working properly in some corner cases. The
> price for the maintenance is certainly not free.

That's also what I'm trying to make sense of. Either way this will be
frankenkernel territory, the cgroupv1 ship has already sailed for upstream
IMO.

