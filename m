From: Alexey Klimov <aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cpu/hotplug: wait for cpuset_hotplug_work to finish on
 cpu onlining
Date: Thu, 11 Feb 2021 14:09:39 +0000
Message-ID: <CAFBcO+_zMa8kC0cHnjAK6axX=CEL7UvS31ak_Vxr2gBO-JnH0Q@mail.gmail.com>
References: <20210204010157.1823669-1-aklimov@redhat.com> <YBvCYhdPai+pb8u2@hirez.programming.kicks-ass.net>
 <CAFBcO+_Z1LKqPPwEKq-XGX+RnWQa+vFBVJ9D9y0MNHGUkM_4Jw@mail.gmail.com>
 <YBv5qDBdb/VAq0Vw@hirez.programming.kicks-ass.net> <87eehvz6sx.fsf@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613052594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1db50KVoxPV8DsdAaKXwwrLzCGY6SPMsnN2pRLnSac0=;
        b=RMdJEepTCqa1COsmf9XWUqTLQ/TrvG5lmR7c8g0l3p7Jr+yVhuOCkQc66r9EgVSH/AiUSP
        e65xr+gfTmOWJlvu491xC8kqXTP4NOmwpfnLMyac6rpDSJpLRkMd4Fo1mx5056WoOEE0HV
        +ULFstSMqkN6svYcTYfSwumaYEpSHpA=
In-Reply-To: <87eehvz6sx.fsf-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yury.norov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, Joshua Baker <jobaker-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, audralmitchel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Alexey Klimov <klimov.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Fri, Feb 5, 2021 at 12:41 AM Daniel Jordan
<daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>
> Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> writes:

[...]

> >> > One concequence of this is that you'll now get a bunch of notifications
> >> > across things like suspend/hybernate.
> >>
> >> The patch doesn't change the number of kobject_uevent()s. The
> >> userspace will get the same number of uevents as before the patch (at
> >> least if I can rely on my eyes).
> >
> > bringup_hibernate_cpu() didn't used to generate an event, it does now.
> > Same for bringup_nonboot_cpus().
>
> Both of those call cpu_up(), which only gets a cpuset_wait_for_hotplug()
> in this patch.  No new events generated from that, right, it's just a
> wrapper for a flush_work()?
>
> > Also, looking again, you don't seem to be reinstating the OFFLINE event
> > you took out.
>
> It seems to be reinstated in cpuhp_smt_disable()?

Peter, what Daniel said.
cpuset_wait_for_hotplug() doesn't generate an event.

The offline event was moved below in the same function:

+
+ /* Tell user space about the state changes */
+ for_each_cpu(cpu, mask) {
+ dev = get_cpu_device(cpu);
+ kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
+ }
+
+ free_cpumask_var(mask);

Daniel,
thanks for your comments. I'll update the patch and resend.

Best regards,
Alexey

