From: Alexey Klimov <aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cpu/hotplug: wait for cpuset_hotplug_work to finish on
 cpu onlining
Date: Thu, 11 Feb 2021 13:38:51 +0000
Message-ID: <CAFBcO+81bFBUuR=MrLttBEs8gKh0hx+EcJA2MCbqMzu=CUoybg@mail.gmail.com>
References: <20210204010157.1823669-1-aklimov@redhat.com> <YBvCYhdPai+pb8u2@hirez.programming.kicks-ass.net>
 <20210205112219.kxdjpvjykrv6fi3x@e107158-lin>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613050746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JGimXPuqcoE+a6jS2uYizeEDGioIlqVcs0oa7fVjFEs=;
        b=eoOKuVQuUlbULVHDfyhDPJGOLDvCYnOKY+bibZBgGRcTJRW9HgZUZv4FVW8JoJAFOqKs1T
        Ymw/lREW35uPn5ivZxr2v5ky1drRaxx+AEAVxD+Jdmz7hk+rV2zbRn2zxPGaMROophzM5D
        ZAwwHtZydPWvM0HEtb7cScGiZNE0Hbs=
In-Reply-To: <20210205112219.kxdjpvjykrv6fi3x@e107158-lin>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yury.norov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, Joshua Baker <jobaker-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, audralmitchel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Alexey Klimov <klimov.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Fri, Feb 5, 2021 at 11:22 AM Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org> wrote:
>
> On 02/04/21 10:46, Peter Zijlstra wrote:
> > On Thu, Feb 04, 2021 at 01:01:57AM +0000, Alexey Klimov wrote:
> > > @@ -1281,6 +1282,11 @@ static int cpu_up(unsigned int cpu, enum cpuhp_state target)
> > >     err = _cpu_up(cpu, 0, target);
> > >  out:
> > >     cpu_maps_update_done();
> > > +
> > > +   /* To avoid out of line uevent */
> > > +   if (!err)
> > > +           cpuset_wait_for_hotplug();
> > > +
> > >     return err;
> > >  }
> > >
> >
> > > @@ -2071,14 +2075,18 @@ static void cpuhp_online_cpu_device(unsigned int cpu)
> > >     struct device *dev = get_cpu_device(cpu);
> > >
> > >     dev->offline = false;
> > > -   /* Tell user space about the state change */
> > > -   kobject_uevent(&dev->kobj, KOBJ_ONLINE);
> > >  }
> > >
> >
> > One concequence of this is that you'll now get a bunch of notifications
> > across things like suspend/hybernate.
>
> And the resume latency will incur 5-30ms * nr_cpu_ids.
>
> Since you just care about device_online(), isn't cpu_device_up() a better place
> for the wait? This function is special helper for device_online(), leaving
> suspend/resume and kexec paths free from having to do this unnecessary wait.

Yup, the same idea here once Peter mentioned bringup_nonboot_cpus()
and bringup_hibernate_cpu().

Best regards,
Alexey

