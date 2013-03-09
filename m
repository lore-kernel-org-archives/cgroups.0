From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: lockdep trace from prepare_bprm_creds
Date: Sat, 9 Mar 2013 10:11:51 +0800
Message-ID: <513A9A67.60909@huawei.com>
References: <20130306223657.GA7392@redhat.com> <20130307172545.GA10353@redhat.com> <20130307180139.GD29601@htj.dyndns.org> <20130307180332.GE29601@htj.dyndns.org> <20130307191242.GA18265@redhat.com> <20130307193820.GB3209@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130307193820.GB3209-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2013/3/8 3:38, Tejun Heo wrote:
> Hello,
> 
> On Thu, Mar 07, 2013 at 08:12:42PM +0100, Oleg Nesterov wrote:
>> Well yes, I agree. I think that perfomance-wise threadgroup_change_begin()
>> in de_thread() is fine, and perhaps it is even more clean because we are
>> going to do the thread-group change. The scope of cred_guard_mutex is huge,
>> it doesn't look very nice in threadgroup_lock().
>>
>> But we should avoid the cgroup-specific hooks as much as possible, so I
>> like your patch more.
> 
> I don't really mind how it's done but while my approach seems to limit
> itself to cgroup proper, threadgroup locking is actually more invasive
> by meddling with cred_mutex.  As you said, yours is the cleaner and
> probably more permanent one here.
> 

Agreed.

Now we need that patch to be resent with SOB and proper changelog.

>>> +	if (threadgroup && !thread_group_leader(tsk)) {
>>> +		/*
>>> +		 * a race with de_thread from another thread's exec() may
>>> +		 * strip us of our leadership, if this happens, there is no
>>> +		 * choice but to throw this task away and try again; this
>>> +		 * is "double-double-toil-and-trouble-check locking".
>>> +		 */
>>> +		threadgroup_unlock(tsk);
>>> +		put_task_struct(tsk);
>>> +		goto retry_find_task;
>>> +	}
>>>
>>> +	ret = -ENODEV;
>>> +	if (cgroup_lock_live_group(cgrp)) {
>>> +		if (threadgroup)
>>> +			ret = cgroup_attach_proc(cgrp, tsk);
>>
>> Offtopic, but with or without this change I do not understand the
>> thread_group_leader/retry_find_task logic.
>>
>> Why do we actually need to restart? We do not really care if it is leader
>> or not, we only need to ensure we can safely use while_each_thread() to
>> find all !PF_EXITING threads.
> 
> If my memory serves me right (which BTW often fails), it's cgroup API
> thing.  cgroup wants to guarantee to the controllers that if multiple
> tasks are migrated together, they always constitute a threadgroup and
> the first one is the leader.  ISTR a controller callback which depends
> on the first one being the leader.
> 

It did serve you right this time. :)
