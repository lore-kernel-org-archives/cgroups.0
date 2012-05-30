From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v3 3/6] expose fine-grained per-cpu data for cpuacct stats
Date: Wed, 30 May 2012 16:20:15 +0400
Message-ID: <4FC6107F.9020802@parallels.com>
References: <1338371317-5980-1-git-send-email-glommer@parallels.com> <1338371317-5980-4-git-send-email-glommer@parallels.com> <CAPM31RJanAvDB+pZ+h5J3W6KXvAwPgbbeXgw6C_56tx_Mc+cgA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPM31RJanAvDB+pZ+h5J3W6KXvAwPgbbeXgw6C_56tx_Mc+cgA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew.Phillips-xheW4WVAX9Y@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On 05/30/2012 03:24 PM, Paul Turner wrote:
>> +static int cpuacct_stats_percpu_show(struct cgroup *cgrp, struct cftype *cft,
>> >  +                                    struct cgroup_map_cb *cb)
>> >  +{
>> >  +       struct cpuacct *ca = cgroup_ca(cgrp);
>> >  +       int cpu;
>> >  +
>> >  +       for_each_online_cpu(cpu) {
>> >  +               do_fill_cb(cb, ca, "user", cpu, CPUTIME_USER);
>> >  +               do_fill_cb(cb, ca, "nice", cpu, CPUTIME_NICE);
>> >  +               do_fill_cb(cb, ca, "system", cpu, CPUTIME_SYSTEM);
>> >  +               do_fill_cb(cb, ca, "irq", cpu, CPUTIME_IRQ);
>> >  +               do_fill_cb(cb, ca, "softirq", cpu, CPUTIME_SOFTIRQ);
>> >  +               do_fill_cb(cb, ca, "guest", cpu, CPUTIME_GUEST);
>> >  +               do_fill_cb(cb, ca, "guest_nice", cpu, CPUTIME_GUEST_NICE);
>> >  +       }
>> >  +
> I don't know if there's much that can be trivially done about it but I
> suspect these are a bit of a memory allocation time-bomb on a many-CPU
> machine.  The cgroup:seq_file mating (via read_map) treats everything
> as/one/  record.  This means that seq_printf is going to end up
> eventually allocating a buffer that can fit_everything_  (as well as
> every power-of-2 on the way there).  Adding insult to injury is that
> that the backing buffer is kmalloc() not vmalloc().
>
> 200+ bytes per-cpu above really is not unreasonable (46 bytes just for
> the text, plus a byte per base 10 digit we end up reporting), but that
> then  leaves us looking at order-12/13 allocations just to print this
> thing when there are O(many) cpus.
>

And how's /proc/stat different ?
It will suffer from the very same problems, since it also have this very 
same information (actually more, since I am skipping some), per-cpu.

Now, if you guys are okay with a file per-cpu, I can do it as well.
It pollutes the filesystem, but at least protects against the fact that 
this is kmalloc-backed.
