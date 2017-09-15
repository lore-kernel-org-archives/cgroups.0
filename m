From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: Properly init nr_tasks in cgroup_taskset
Date: Fri, 15 Sep 2017 11:28:35 -0700
Message-ID: <d34d2f65-ef68-29d1-05e8-7f0ba0e0e6cf@redhat.com>
References: <1505421913-29577-1-git-send-email-longman@redhat.com>
 <20170915154743.GF378890@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170915154743.GF378890-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 09/15/2017 08:47 AM, Tejun Heo wrote:
> Hello, Waiman.
>
> On Thu, Sep 14, 2017 at 01:45:13PM -0700, Waiman Long wrote:
>> Commit 610467270fb3 ("cgroup: don't call migration methods if there
>> are no tasks to migrate") introduces a new field nr_tasks to the
>> cgroup_taskset structure for keeping track of the number of tasks
>> contained in the structure.  The initial value of this field, however,
>> is not guaranteed to be 0 as all the cgroup_taskset structures are
>> allocated from stack.  Therefore, we need to explicitly initilized
>> it in the CGROUP_TASKSET_INIT() macro for the new code to behave
>> correctly.
>>
>> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  kernel/cgroup/cgroup-internal.h | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
>> index 5151ff2..6b4c04e 100644
>> --- a/kernel/cgroup/cgroup-internal.h
>> +++ b/kernel/cgroup/cgroup-internal.h
>> @@ -76,6 +76,7 @@ struct cgroup_mgctx {
>>  	.src_csets		= LIST_HEAD_INIT(tset.src_csets),		\
>>  	.dst_csets		= LIST_HEAD_INIT(tset.dst_csets),		\
>>  	.csets			= &tset.src_csets,	Y			\
>> +	.nr_tasks		= 0,						\
> But it's an initialization macro, which means that the only way thhese
> are used is as a part of whole struct initialization and the compiler
> would always set the unspecified fields to zero.
>
> Thanks.
>
You are right. I checked the assembly code and it did initialize the
other fields of the structure to 0. So my fix is bogus.

I sent this patch out because our QE people were still seeing the same
panic in PPC machines even with your patch applied. So I mistakenly
thought maybe the structure initialization wasn't complete. I will have
to further into why this was still happening.

Sorry for bothering you.

Cheers,
Longman

