From: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cpu/hotplug: wait for cpuset_hotplug_work to finish on
 cpu onlining
Date: Thu, 04 Feb 2021 19:39:42 -0500
Message-ID: <87eehvz6sx.fsf@oracle.com>
References: <20210204010157.1823669-1-aklimov@redhat.com>
 <YBvCYhdPai+pb8u2@hirez.programming.kicks-ass.net>
 <CAFBcO+_Z1LKqPPwEKq-XGX+RnWQa+vFBVJ9D9y0MNHGUkM_4Jw@mail.gmail.com>
 <YBv5qDBdb/VAq0Vw@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : content-type :
 mime-version; s=corp-2020-01-29;
 bh=B0oeoIkDQic+Z/sWxuOFhU7kHtMOG+6OE8uBFA33J1E=;
 b=kssS9qudajOD/39Rs5bDcr8O6KOdr8a6ahf1EX3v4rFIyDu4yzM0H5EDWjp4OaAGV2RG
 m1bwSidb1/LT9tByU++IM4APEVd9A3i7KQ1R/htFb37j8J+fbazQc+20w+QC+w0FC8gK
 ODXTlvxua2ck7MAvswi+V8543yqQb0TFgEMjrQKyf1dVNBo0julXd4vlEwM4tlE/+cq5
 zTiLa6jXvQ1FJWdaXpQ9i4b66MjxDd+2r4pW7OwuOlqq+gVqE1ftb9YrvYtnHPOUTU8z
 d2Llb18uYRMnBgz6HNzQssEZUjfYklRL1wyDDevsNzEjZriNfrHr8G8gFKJuqijSPZqJ SA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0oeoIkDQic+Z/sWxuOFhU7kHtMOG+6OE8uBFA33J1E=;
 b=jCp11bJCmsXYKsqyurD/oaun9uUQR3Vcmz1iIq16Vwwvm/GYCARhFg8P/aT6CsJoj4GtCznPxKRgK0hhTVV53Ia1iTZgsMEA9GNF1OMNQ3++5mjp2zUlyJ959378uAdIAfhQSyWgSWSn8tP2BoUiEEDn56wechEz0G7J2x/NmZw=
In-Reply-To: <YBv5qDBdb/VAq0Vw-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Alexey Klimov <aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yury.norov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, Joshua Baker <jobaker-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, audralmitchel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, qais.yousef-5wv7dgnIgG8@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Alexey Klimov <klimov.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> writes:

> On Thu, Feb 04, 2021 at 12:50:34PM +0000, Alexey Klimov wrote:
>> On Thu, Feb 4, 2021 at 9:46 AM Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>> >
>> > On Thu, Feb 04, 2021 at 01:01:57AM +0000, Alexey Klimov wrote:
>> > > @@ -1281,6 +1282,11 @@ static int cpu_up(unsigned int cpu, enum cpuhp_state target)
>> > >       err = _cpu_up(cpu, 0, target);
>> > >  out:
>> > >       cpu_maps_update_done();
>> > > +
>> > > +     /* To avoid out of line uevent */
>> > > +     if (!err)
>> > > +             cpuset_wait_for_hotplug();
>> > > +
>> > >       return err;
>> > >  }
>> > >
>> >
>> > > @@ -2071,14 +2075,18 @@ static void cpuhp_online_cpu_device(unsigned int cpu)
>> > >       struct device *dev = get_cpu_device(cpu);
>> > >
>> > >       dev->offline = false;
>> > > -     /* Tell user space about the state change */
>> > > -     kobject_uevent(&dev->kobj, KOBJ_ONLINE);
>> > >  }
>> > >
>> >
>> > One concequence of this is that you'll now get a bunch of notifications
>> > across things like suspend/hybernate.
>> 
>> The patch doesn't change the number of kobject_uevent()s. The
>> userspace will get the same number of uevents as before the patch (at
>> least if I can rely on my eyes).
>
> bringup_hibernate_cpu() didn't used to generate an event, it does now.
> Same for bringup_nonboot_cpus().

Both of those call cpu_up(), which only gets a cpuset_wait_for_hotplug()
in this patch.  No new events generated from that, right, it's just a
wrapper for a flush_work()?

> Also, looking again, you don't seem to be reinstating the OFFLINE event
> you took out.

It seems to be reinstated in cpuhp_smt_disable()?
