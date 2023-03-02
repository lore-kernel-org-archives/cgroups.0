From: Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 2/6] mm/memcg: Disable threshold event handlers on
 PREEMPT_RT
Date: Thu, 02 Mar 2023 10:18:31 +0000
Message-ID: <xhsmh1qm7pibs.mognet@vschneid.remote.csb>
References: <20220226204144.1008339-1-bigeasy@linutronix.de>
 <20220226204144.1008339-3-bigeasy@linutronix.de>
 <xhsmh4jr4pbzc.mognet@vschneid.remote.csb>
 <ZABUMit05SZBDXRQ@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677752316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=drADIWeR5WqaFv7Oh+ltYqYvRuiCs23o1kgF+pSQhdM=;
        b=CDti7wZ+wXGOtIfEqtmEadMGDgbQfhS7CkKLTH6TYpOqfS9FdTu6+6NwMvp5PPbsUxlhVR
        92UV3pAIzKBaHw13CobGSps6JZ1EJtndfuBPDkRVpM+IsHZNDx3qEKNOxJdlV3edXe67h2
        w1Hy8lQCkKbam0M2Cu6Lp+Cs8oI8ccE=
In-Reply-To: <ZABUMit05SZBDXRQ-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 02/03/23 08:45, Michal Hocko wrote:
> On Wed 01-03-23 18:23:19, Valentin Schneider wrote:
>> On 26/02/22 21:41, Sebastian Andrzej Siewior wrote:
>> > During the integration of PREEMPT_RT support, the code flow around
>> > memcg_check_events() resulted in `twisted code'. Moving the code around
>> > and avoiding then would then lead to an additional local-irq-save
>> > section within memcg_check_events(). While looking better, it adds a
>> > local-irq-save section to code flow which is usually within an
>> > local-irq-off block on non-PREEMPT_RT configurations.
>> >
>>
>> Hey, sorry for necro'ing a year-old thread - would you happen to remember
>> what the issues were with memcg_check_events()? I ran tests against
>> cgroupv1 using an eventfd on OOM with the usual debug arsenal and didn't
>> detect anything, I'm guessing it has to do with the IRQ-off region
>> memcg_check_events() is called from?
>
> I would have to look into details but IIRC the resulting code to make
> the code RT safe was dreaded and hard to maintain as a result. As we
> didn't really have any real life usecase, disabling the code was an
> easier way to go forward. So it is not the code would be impossible to
> be enabled for RT it just doeasn't seam to be worth all the complexity.
>

Right, thanks for having a look.

>> I want cgroupv1 to die as much as the next person, but in that specific
>> situation I kinda need cgroupv1 to behave somewhat sanely on RT with
>> threshold events :/
>
> Could you expand on the usecase?
>

In this case it's just some middleware leveraging memcontrol cgroups and
setting up callbacks for in-cgroup OOM events. This is a supported feature
in cgroupv2, so this isn't a problem of cgroupv1 vs cgroupv2 feature
parity, but rather one of being in a transitional phase where the
middleware itself hasn't fully migrated to using cgroupv2.

> --
> Michal Hocko
> SUSE Labs

