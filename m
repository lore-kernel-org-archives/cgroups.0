From: Alexey Klimov <aklimov@redhat.com>
Subject: Re: [PATCH v2] cpu/hotplug: wait for cpuset_hotplug_work to finish on
 cpu onlining
Date: Tue, 16 Mar 2021 03:15:13 +0000
Message-ID: <CAFBcO+99Ax5MuOtzNx=NrmnUN=+913Sc-DV83ObOi01A=kkN3w@mail.gmail.com>
References: <20210212003032.2037750-1-aklimov@redhat.com> <87tuqhrs3d.fsf@oracle.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615864527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PgTYgUrUjzuxenxAnT33mXHPaYITveEH9VmNhTwLT9M=;
        b=NqVT9RHENRggJAIjd3vRujEcQMIuz/MAv/1h4mRyWQEf93Axih9NS0m8UjIH4mJ78dx27U
        v2ShXygmlQxBerjozZI8rcoyUasoLTL13DV12OSTVQWxIBadNYepcDbqvYJvpG9NJ++Hff
        0OW4GKG7vsnIWBRKEOKbWEIk1N8poq4=
In-Reply-To: <87tuqhrs3d.fsf@oracle.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, yury.norov@gmail.com, tglx@linutronix.de, Joshua Baker <jobaker@redhat.com>, audralmitchel@gmail.com, arnd@arndb.de, gregkh@linuxfoundation.org, rafael@kernel.org, tj@kernel.org, Qais Yousef <qais.yousef@arm.com>, hannes@cmpxchg.org, Alexey Klimov <klimov.linux@gmail.com>

On Fri, Feb 12, 2021 at 7:42 PM Daniel Jordan
<daniel.m.jordan@oracle.com> wrote:
>
> Alexey Klimov <aklimov@redhat.com> writes:
> > int cpu_device_up(struct device *dev)
>
> Yeah, definitely better to do the wait here.
>
> >  int cpuhp_smt_disable(enum cpuhp_smt_control ctrlval)
> >  {
> > -     int cpu, ret = 0;
> > +     struct device *dev;
> > +     cpumask_var_t mask;
> > +     int cpu, ret;
> > +
> > +     if (!zalloc_cpumask_var(&mask, GFP_KERNEL))
> > +             return -ENOMEM;
> >
> > +     ret = 0;
> >       cpu_maps_update_begin();
> >       for_each_online_cpu(cpu) {
> >               if (topology_is_primary_thread(cpu))
> > @@ -2099,18 +2098,35 @@ int cpuhp_smt_disable(enum cpuhp_smt_control ctrlval)
> >                * called under the sysfs hotplug lock, so it is properly
> >                * serialized against the regular offline usage.
> >                */
> > -             cpuhp_offline_cpu_device(cpu);
> > +             dev = get_cpu_device(cpu);
> > +             dev->offline = true;
> > +
> > +             cpumask_set_cpu(cpu, mask);
> >       }
> >       if (!ret)
> >               cpu_smt_control = ctrlval;
> >       cpu_maps_update_done();
> > +
> > +     /* Tell user space about the state changes */
> > +     for_each_cpu(cpu, mask) {
> > +             dev = get_cpu_device(cpu);
> > +             kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
> > +     }
> > +
> > +     free_cpumask_var(mask);
> >       return ret;
> >  }
>
> Hrm, should the dev manipulation be kept in one place, something like
> this?

The first section of comment seems problematic to me with regards to such move:

                 * As this needs to hold the cpu maps lock it's impossible
                 * to call device_offline() because that ends up calling
                 * cpu_down() which takes cpu maps lock. cpu maps lock
                 * needs to be held as this might race against in kernel
                 * abusers of the hotplug machinery (thermal management).

Cpu maps lock is released in cpu_maps_update_done() hence we will move
dev->offline out of cpu maps lock. Maybe I misunderstood the comment
and it relates to calling cpu_down_maps_locked() under lock to avoid
race?
I failed to find the abusers of hotplug machinery in drivers/thermal/*
to track down the logic of potential race but I might have overlooked.
Anyway, if we move the update of dev->offline out, then it makes sense
to restore cpuhp_{offline,online}_cpu_device back and just use it.

I guess I'll update and re-send the patch and see how it goes.

> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 8817ccdc8e112..aa21219a7b7c4 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -2085,11 +2085,20 @@ int cpuhp_smt_disable(enum cpuhp_smt_control ctrlval)
>                 ret = cpu_down_maps_locked(cpu, CPUHP_OFFLINE);
>                 if (ret)
>                         break;
> +
> +               cpumask_set_cpu(cpu, mask);
> +       }
> +       if (!ret)
> +               cpu_smt_control = ctrlval;
> +       cpu_maps_update_done();
> +
> +       /* Tell user space about the state changes */
> +       for_each_cpu(cpu, mask) {
>                 /*
> -                * As this needs to hold the cpu maps lock it's impossible
> +                * When the cpu maps lock was taken above it was impossible
>                  * to call device_offline() because that ends up calling
>                  * cpu_down() which takes cpu maps lock. cpu maps lock
> -                * needs to be held as this might race against in kernel
> +                * needed to be held as this might race against in kernel
>                  * abusers of the hotplug machinery (thermal management).
>                  *
>                  * So nothing would update device:offline state. That would

Yeah, reading how you re-phrased it, this seems to be about
cpu_down_maps_locked()/device_offline() locks and race rather than
updating stale dev->offline.

Thank you,
Alexey

