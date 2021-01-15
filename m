From: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH] cpu/hotplug: wait for cpuset_hotplug_work to
 finish on cpu online
Date: Thu, 14 Jan 2021 22:21:25 -0500
Message-ID: <87im7yc2bu.fsf@oracle.com>
References: <20201203171431.256675-1-aklimov@redhat.com>
 <20201207083827.GD3040@hirez.programming.kicks-ass.net>
 <87k0tritvq.fsf@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=IOXbYHXHreW/DM/cC1BlOLyDYYZQRT6FD474gUtPV4A=;
 b=bEPJJSBKEY26381CteMXcM4TUtEgoNn7H/6Rj2Fypaq1KcWpgvxWwf+JT51UyPqMBfLU
 z4XGtzk1ndfrc/YAierZRu8Y86WIPMsivOrf/Y0gSoD3VutNeQ14tbaclOeHXO6zDT2U
 JDqZC1A1fdnzmxHZJY87mMZdb55T7Z+HczXUWTjsiU6OYzicqpmmTE6AtcFnknnwMjLg
 aXWGjJkmveVKL93gWjnihgvAyIxdmP8K2uKCqQWMSRElLbNy3MpZZTbY6Hq3znlVDiy2
 th6Uds65hwxEYViQeguOCfM9EEcXPWxXXjPogQle01Bu/mBImohggC0CRTiZiBXkdjVI /A== 
In-Reply-To: <87k0tritvq.fsf-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Alexey Klimov <aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yury.norov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, jobaker-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, audralmitchel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, qais.yousef-5wv7dgnIgG8@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, klimov.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> writes:
> Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> writes:
>>> The nature of this bug is also described here (with different consequences):
>>> https://lore.kernel.org/lkml/20200211141554.24181-1-qais.yousef-5wv7dgnIgG8@public.gmane.org/
>>
>> Yeah, pesky deadlocks.. someone was going to try again.
>
> I dug up the synchronous patch
>
>     https://lore.kernel.org/lkml/1579878449-10164-1-git-send-email-prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org/
>
> but surprisingly wasn't able to reproduce the lockdep splat from
>
>     https://lore.kernel.org/lkml/F0388D99-84D7-453B-9B6B-EEFF0E7BE4CC-J5quhbR+WMc@public.gmane.org/
>
> even though I could hit it a few weeks ago.

oh okay, you need to mount a legacy cpuset hierarchy.

So as the above splat shows, making cpuset_hotplug_workfn() synchronous
means cpu_hotplug_lock (and "cpuhp_state-down") can be acquired before
cgroup_mutex.

But there are at least four cgroup paths that take the locks in the
opposite order.  They're all the same, they take cgroup_mutex and then
cpu_hotplug_lock later on to modify one or more static keys.

cpu_hotplug_lock should probably be ahead of cgroup_mutex because the
latter is taken in a hotplug callback, and we should keep the static
branches in cgroup, so the only way out I can think of is moving
cpu_hotplug_lock to just before cgroup_mutex is taken and switching to
_cpuslocked flavors of the static key calls.

lockdep quiets down with that change everywhere, but it puts another big
lock around a lot of cgroup paths.  Seems less heavyhanded to go with
this RFC.  What do you all think?

Absent further discussion, Alexey, do you plan to post another version?
