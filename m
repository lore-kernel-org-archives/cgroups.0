From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/6] sched: split out css_online/css_offline from tg
 creation/destruction
Date: Fri, 25 Jan 2013 09:38:25 +0800
Message-ID: <5101E211.20606@huawei.com>
References: <5100D4FE.9080205@huawei.com> <5100D518.8000103@huawei.com> <20130124100434.GD26351@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130124100434.GD26351-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2013/1/24 18:04, Ingo Molnar wrote:
> 
> * Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> 
>>  extern struct task_group *sched_create_group(struct task_group *parent);
>> +extern void sched_online_group(struct task_group *tg,
>> +			       struct task_group *parent);
>>  extern void sched_destroy_group(struct task_group *tg);
>> +extern void sched_offline_group(struct task_group *tg);
> 
> Btw., a rename of these APIs might be in order, along the usual 
> patterns:
> 
>   sched_task_group_create()
>   sched_task_group_online()
>   sched_task_group_offline()
>   sched_task_group_destroy()
> 
>   etc.
> 
> that way the naming is more hierarchical and there's no clash 
> with the sched_group concept which is about something else.
> 
> (In a separate patch.)
> 

Agreed. I'll send a cleanup patch to you when those patches hit mainline.
(That will be 3.9-rc1 or later)
