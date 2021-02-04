From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] cpu/hotplug: wait for cpuset_hotplug_work to finish on
 cpu onlining
Date: Thu, 4 Feb 2021 14:42:00 +0100
Message-ID: <YBv5qDBdb/VAq0Vw@hirez.programming.kicks-ass.net>
References: <20210204010157.1823669-1-aklimov@redhat.com>
 <YBvCYhdPai+pb8u2@hirez.programming.kicks-ass.net>
 <CAFBcO+_Z1LKqPPwEKq-XGX+RnWQa+vFBVJ9D9y0MNHGUkM_4Jw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=esfcV78RrU8nXrE72X9LckMx7X5reL/P0pwhKEpoq3w=; b=EEFa99xE3ECGRhB28SI4ZjY4Yi
        2zi2lbL6t/w3MDJsqbSTTXxUCdkmZqMCffLyoGa4IXzIkJUDPq7rHzsGvE1/JYKmPObvd6XPxTjHK
        f+DJOdmlIuE9n6P33PTnV3QEg5Z3a+ZlgO1dCIsog9ISzdkaPbj7f0DfcTU4AooM6CflEI1pOZQAn
        J76NZlxMOEMnWAvW1L0hycrU6rlq+RaSYTZOBqJYv3/WVZ8mpCOpDuAO2yA58ifD+umhnRBTmNAc3
        leFwjnf15NZFu8n4wCvXpHg28KOKHhyARfSXOvPz6P1do77EDtYVz4dwaVqihgV7O6m3QUjbvepck
        KlC815Ug==;
Content-Disposition: inline
In-Reply-To: <CAFBcO+_Z1LKqPPwEKq-XGX+RnWQa+vFBVJ9D9y0MNHGUkM_4Jw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexey Klimov <aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yury.norov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, Joshua Baker <jobaker-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, audralmitchel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, qais.yousef-5wv7dgnIgG8@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Alexey Klimov <klimov.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Thu, Feb 04, 2021 at 12:50:34PM +0000, Alexey Klimov wrote:
> On Thu, Feb 4, 2021 at 9:46 AM Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> >
> > On Thu, Feb 04, 2021 at 01:01:57AM +0000, Alexey Klimov wrote:
> > > @@ -1281,6 +1282,11 @@ static int cpu_up(unsigned int cpu, enum cpuhp_state target)
> > >       err = _cpu_up(cpu, 0, target);
> > >  out:
> > >       cpu_maps_update_done();
> > > +
> > > +     /* To avoid out of line uevent */
> > > +     if (!err)
> > > +             cpuset_wait_for_hotplug();
> > > +
> > >       return err;
> > >  }
> > >
> >
> > > @@ -2071,14 +2075,18 @@ static void cpuhp_online_cpu_device(unsigned int cpu)
> > >       struct device *dev = get_cpu_device(cpu);
> > >
> > >       dev->offline = false;
> > > -     /* Tell user space about the state change */
> > > -     kobject_uevent(&dev->kobj, KOBJ_ONLINE);
> > >  }
> > >
> >
> > One concequence of this is that you'll now get a bunch of notifications
> > across things like suspend/hybernate.
> 
> The patch doesn't change the number of kobject_uevent()s. The
> userspace will get the same number of uevents as before the patch (at
> least if I can rely on my eyes).

bringup_hibernate_cpu() didn't used to generate an event, it does now.
Same for bringup_nonboot_cpus().

Also, looking again, you don't seem to be reinstating the OFFLINE event
you took out.


