From: Alexey Klimov <aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] cpu/hotplug: wait for cpuset_hotplug_work to finish on
 cpu onlining
Date: Thu, 15 Apr 2021 02:30:03 +0100
Message-ID: <CAFBcO+8NBZxNdXtVuTXt9_m9gWTq7kxrcDcdFntvVjR_0rM13A@mail.gmail.com>
References: <20210317003616.2817418-1-aklimov@redhat.com> <87tuowcnv3.ffs@nanos.tec.linutronix.de>
 <CALW4P+L9_tYgfOPv0riWWnv54HPhKPDJ4EK4yYaWsz0MdDGqfw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618450217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NuT37Vpiz4KczvJjbLuhVhLsnc1sKQ6bWyp9Fysxc0M=;
        b=SKhq/xnRzymw3OROtwY8Am/xi4wnDKFx6mlhKxf3ulA5LZ0UsKhsYL0ilIA/HsK7JbMUFM
        FfWHcbHQL1OtIZV1bfto5mYPQr+DUpRAxiBQXwK+lhCTMrVGyP275AyoSnogh9+QFPs1uK
        C5yPAWVNvZHCOLh9hrAryxbpT7ASXVM=
In-Reply-To: <CALW4P+L9_tYgfOPv0riWWnv54HPhKPDJ4EK4yYaWsz0MdDGqfw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yury Norov <yury.norov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Joshua Baker <jobaker-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, audralmitchel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Alexey Klimov <klimov.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Sun, Apr 4, 2021 at 3:32 AM Alexey Klimov <klimov.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> On Sat, Mar 27, 2021 at 9:01 PM Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:

[...]

Now, the patch:

>> Subject: cpu/hotplug: Cure the cpusets trainwreck
>> From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
>> Date: Sat, 27 Mar 2021 15:57:29 +0100
>>
>> Alexey and Joshua tried to solve a cpusets related hotplug problem which is
>> user space visible and results in unexpected behaviour for some time after
>> a CPU has been plugged in and the corresponding uevent was delivered.
>>
>> cpusets delegate the hotplug work (rebuilding cpumasks etc.) to a
>> workqueue. This is done because the cpusets code has already a lock
>> nesting of cgroups_mutex -> cpu_hotplug_lock. A synchronous callback or
>> waiting for the work to finish with cpu_hotplug_lock held can and will
>> deadlock because that results in the reverse lock order.
>>
>> As a consequence the uevent can be delivered before cpusets have consistent
>> state which means that a user space invocation of sched_setaffinity() to
>> move a task to the plugged CPU fails up to the point where the scheduled
>> work has been processed.
>>
>> The same is true for CPU unplug, but that does not create user observable
>> failure (yet).
>>
>> It's still inconsistent to claim that an operation is finished before it
>> actually is and that's the real issue at hand. uevents just make it
>> reliably observable.
>>
>> Obviously the problem should be fixed in cpusets/cgroups, but untangling
>> that is pretty much impossible because according to the changelog of the
>> commit which introduced this 8 years ago:
>>
>>  3a5a6d0c2b03("cpuset: don't nest cgroup_mutex inside get_online_cpus()")
>>
>> the lock order cgroups_mutex -> cpu_hotplug_lock is a design decision and
>> the whole code is built around that.
>>
>> So bite the bullet and invoke the relevant cpuset function, which waits for
>> the work to finish, in _cpu_up/down() after dropping cpu_hotplug_lock and
>> only when tasks are not frozen by suspend/hibernate because that would
>> obviously wait forever.
>>
>> Waiting there with cpu_add_remove_lock, which is protecting the present
>> and possible CPU maps, held is not a problem at all because neither work
>> queues nor cpusets/cgroups have any lockchains related to that lock.
>>
>> Waiting in the hotplug machinery is not problematic either because there
>> are already state callbacks which wait for hardware queues to drain. It
>> makes the operations slightly slower, but hotplug is slow anyway.
>>
>> This ensures that state is consistent before returning from a hotplug
>> up/down operation. It's still inconsistent during the operation, but that's
>> a different story.
>>
>> Add a large comment which explains why this is done and why this is not a
>> dump ground for the hack of the day to work around half thought out locking
>> schemes. Document also the implications vs. hotplug operations and
>> serialization or the lack of it.
>>
>> Thanks to Alexy and Joshua for analyzing why this temporary
>> sched_setaffinity() failure happened.
>>
>> Reported-by: Alexey Klimov <aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Reported-by: Joshua Baker <jobaker-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
>> Cc: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> Cc: Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org>

Feel free to use:
Tested-by: Alexey Klimov <aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

The bug doesn't reproduce with this change, I had the testcase running
for ~25 hrs without failing under different workloads.

Are you going to submit the patch? Or I can do it on your behalf if you like.

[...]

Best regards,
Alexey

