From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: cgroup: INFO: suspicious RCU usage. in cgroup_name
Date: Thu, 7 Mar 2013 14:21:29 +0800
Message-ID: <513831E9.80304@huawei.com>
References: <5137687E.50701@oracle.com> <5138309A.2060804@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5138309A.2060804-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michael Wang <wangyun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2013/3/7 14:15, Michael Wang wrote:
> On 03/07/2013 12:02 AM, Sasha Levin wrote:
>> Hi all,
>>
>> While fuzzing with trinity inside a KVM tools guest running latest -next kernel
>> I've stumbled on the following:
>>
>> [  450.180599] ===============================
>> [  450.181392] [ INFO: suspicious RCU usage. ]
>> [  450.182101] 3.9.0-rc1-next-20130305-sasha-00048-g35e9ec5-dirty #1032 Tainted: G        W
>> [  450.183482] -------------------------------
>> [  450.184343] include/linux/cgroup.h:429 suspicious rcu_dereference_check() usage!
>> [  450.185575]
>> [  450.185575] other info that might help us debug this:
>> [  450.185575]
>> [  450.186961]
>> [  450.186961] rcu_scheduler_active = 1, debug_locks = 1
>> [  450.188001] 4 locks held by kworker/u:0/6:
>> [  450.188646]  #0:  (khelper){.+.+.+}, at: [<ffffffff8112ba98>] process_one_work+0x238/0x570
>> [  450.190186]  #1:  ((&sub_info->work)){+.+.+.}, at: [<ffffffff8112ba98>] process_one_work+0x238/0x570
>> [  450.191824]  #2:  (&(&p->alloc_lock)->rlock){+.+.-.}, at: [<ffffffff812036d3>] dump_header+0x43/0xe0
> 
> Hi, Sasha
> 
> I suppose this is the warn context:
> 
> cpuset_print_task_mems_allowed() -> task_cs() -> task_subsys_state()
> 
> and this is the definition of task_subsys_state():
> 
> #define task_subsys_state_check(task, subsys_id, __c)                   \
>         rcu_dereference_check(task->cgroups->subsys[subsys_id],         \
>                               lockdep_is_held(&task->alloc_lock) ||     \
>                               cgroup_lock_is_held() || (__c))
> 
> the condition "lockdep_is_held(&task->alloc_lock)" should match (#2
> lock), the warn doesn't make sense to me...
> 

nope..note this is 3.9-rc1-next, not 3.9-rc1.

The warning is from this:

/* Caller should hold rcu_read_lock() */
static inline const char *cgroup_name(const struct cgroup *cgrp)
{
        return rcu_dereference(cgrp->name)->name;
}

I've cooked up a patch. Will send out today.
