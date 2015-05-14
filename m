From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v10 3/4] cgroups: allow a cgroup subsystem to reject a fork
Date: Thu, 14 May 2015 20:57:49 +1000
Message-ID: <CAOviyajt2MSG_N6VOOXwAM8YZ0ReCvgXyyvaj2yPYK2dztv8EA@mail.gmail.com>
References: <1429446154-10660-1-git-send-email-cyphar@cyphar.com>
	<1429446154-10660-4-git-send-email-cyphar@cyphar.com>
	<20150422155445.GD10738@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150422155445.GD10738@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, mingo@redhat.com, Peter Zijlstra <peterz@infradead.org>, richard@nod.at, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Hi Tejun,

>> +/* Ditto for the can_fork/cancel_fork/reapply_fork callbacks. */
>> +static int need_canfork_callback __read_mostly;
>> +static int need_cancelfork_callback __read_mostly;
>
> And given that the reason we have these masks is avoiding iteration in
> relatively hot paths.  Does cancelfork mask make sense?

Do you still want me to remove it? I only added it because it made the
callback code more consistent for cancel_fork and can_fork.

>> +void cgroup_cancel_fork(struct task_struct *child,
>> +                     void *ss_state[CGROUP_PREFORK_COUNT])
>> +{
>> +     struct cgroup_subsys *ss;
>> +     int i;
>> +
>> +     for_each_subsys_which(need_cancelfork_callback, ss, i) {
>> +             void *state = NULL;
>> +
>> +             if (CGROUP_PREFORK_START <= i && i < CGROUP_PREFORK_END)
>> +                     state = ss_state[i - CGROUP_PREFORK_START];
>
> Maybe we want a helper callback which does
>
>         if (CGROUP_PREFORK_START <= ssid && ssid < CGROUP_PREFORK_END)
>                 return &ss_state[ssid - CGROUP_PREFORK_START];
>         return NULL;

What would be a nice name for it? I can't think of anything better
than __get_ss_private() and __get_ss_privatep().

--
Aleksa Sarai (cyphar)
www.cyphar.com
