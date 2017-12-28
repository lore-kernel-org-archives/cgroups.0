From: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: fix circular locking dependency
Date: Fri, 29 Dec 2017 02:07:16 +0530
Message-ID: <9843d982-d201-8702-2e4e-0541a4d96b53@codeaurora.org>
References: <CANaxB-zT+sz=z1FFk5npnwMySdfKCBZDkM+P+=JXDkCXbh=rCw@mail.gmail.com>
 <1511868946-23959-1-git-send-email-prsood@codeaurora.org>
 <623f214b-8b9a-f967-7a3d-ca9c06151267@codeaurora.org>
 <20171204202219.GF2421075@devbig577.frc2.facebook.com>
 <20171204225825.GP2421075@devbig577.frc2.facebook.com>
 <20171204230117.GF20227@worktop.programming.kicks-ass.net>
 <20171211152059.GH2421075@devbig577.frc2.facebook.com>
 <cca9aea2-9bff-decf-d669-8f90b928ea18@codeaurora.org>
 <20171213160617.GQ3919388@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1514493451;
        bh=qKzHmPh0SmHVPYWYz86C6ZTP9MjBkof0cqzE0/F5sOQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=oJTGzRju7Kwtduiw7pCcFbDj89zNVvphX3GNXSB9W16XU+5uLN9z90ipp55f8zNPi
         15jvL9tWIiBfLcvfibkgwtVldP44d2V9rxr8Wlcjd2BcyRUUu5UIfpJcouwCZzBUrW
         x/fe1xPwzZZP2GI4mbMDcu2hawl392XCI05xQDx8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1514493450;
        bh=qKzHmPh0SmHVPYWYz86C6ZTP9MjBkof0cqzE0/F5sOQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=cJ4HAxJ3N7y0biLI8DP/2yXq6Sg8cbYMI8D6KzIA6Nid7G/gyCdj3iVHv3DO8RUPm
         asxEFYnhwWUvNpT9KeHWTySD05wfBXApMpzTYPQ5vQFjs1Tx1/tmMRSyJ4SGHc/1Ha
         ShddOCBoBFsYYMkqsvJt5SWPesPTh7E0VJfUIzKQ=
In-Reply-To: <20171213160617.GQ3919388-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org

On 12/13/2017 09:36 PM, Tejun Heo wrote:
> Hello, Prateek.
> 
> On Wed, Dec 13, 2017 at 01:20:46PM +0530, Prateek Sood wrote:
>> This change makes the usage of cpuset_hotplug_workfn() from cpu
>> hotplug path synchronous. For memory hotplug it still remains
>> asynchronous.
> 
> Ah, right.
> 
>> Memory migration happening from cpuset_hotplug_workfn() is
>> already asynchronous by queuing cpuset_migrate_mm_workfn() in
>> cpuset_migrate_mm_wq.
>>
>> cpuset_hotplug_workfn()
>>    cpuset_hotplug_workfn(()
>>       cpuset_migrate_mm()
>>          queue_work(cpuset_migrate_mm_wq)
>>
>> It seems that memory migration latency might not have
>> impact with this change.
>>
>> Please let me know if you meant something else by cpuset
>> migration taking time when memory migration is turned on.
> 
> No, I didn't.  I was just confused about which part became
> synchronous.  So, I don't have anything against making the cpu part
> synchronous, but let's not do that as the fix to the deadlocks cuz,
> while we can avoid them by changing cpuset, I don't think cpuset is
> the root cause for them.  If there are benefits to making cpuset cpu
> migration synchronous, let's do that for those benefits.
> 
> Thanks.
> 

TJ,

One more deadlock scenario

Task: sh 
[<ffffff874f917290>] wait_for_completion+0x14
[<ffffff874e8a82e0>] cpuhp_kick_ap_work+0x80 //waiting for cpuhp/2
[<ffffff874f913780>] _cpu_down+0xe0
[<ffffff874e8a9934>] cpu_down+0x38
[<ffffff874ef6e4ec>] cpu_subsys_offline+0x10

Task: cpuhp/2 
[<ffffff874f91645c>] schedule+0x38
[<ffffff874e92c76c>] _synchronize_rcu_expedited+0x2ec
[<ffffff874e92c874>] synchronize_sched_expedited+0x60
[<ffffff874e92c9f8>] synchronize_sched+0xb0
[<ffffff874e9104e4>] sugov_stop+0x58
[<ffffff874f36967c>] cpufreq_stop_governor+0x48
[<ffffff874f36a89c>] cpufreq_offline+0x84
[<ffffff874f36aa30>] cpuhp_cpufreq_offline+0xc
[<ffffff874e8a797c>] cpuhp_invoke_callback+0xac
[<ffffff874e8a89b4>] cpuhp_down_callbacks+0x58
[<ffffff874e8a95e8>] cpuhp_thread_fun+0xa8

_synchronize_rcu_expedited is waiting for execution of rcu
expedited grace period work item wait_rcu_exp_gp()

Task: kworker/2:1 
[<ffffff874f91645c>] schedule+0x38
[<ffffff874f916870>] schedule_preempt_disabled+0x20
[<ffffff874f918df8>] __mutex_lock_slowpath+0x158
[<ffffff874f919004>] mutex_lock+0x14
[<ffffff874e8a77b0>] get_online_cpus+0x34 //waiting for cpu_hotplug_lock
[<ffffff874e96452c>] rebuild_sched_domains+0x30
[<ffffff874e964648>] cpuset_hotplug_workfn+0xb8
[<ffffff874e8c27b8>] process_one_work+0x168
[<ffffff874e8c2ff4>] worker_thread+0x140
[<ffffff874e8c95b8>] kthread+0xe0

cpu_hotplug_lock is acquired by task: sh


Task: kworker/2:3
[<ffffff874f91645c>] schedule+0x38
[<ffffff874f91a384>] schedule_timeout+0x1d8
[<ffffff874f9171d4>] wait_for_common+0xb4
[<ffffff874f917304>] wait_for_completion_killable+0x14 //waiting for kthreadd 
[<ffffff874e8c931c>] __kthread_create_on_node+0xec
[<ffffff874e8c9448>] kthread_create_on_node+0x64
[<ffffff874e8c2d88>] create_worker+0xb4
[<ffffff874e8c3194>] worker_thread+0x2e0
[<ffffff874e8c95b8>] kthread+0xe0


Task: kthreadd
[<ffffff874e8858ec>] __switch_to+0x94
[<ffffff874f915ed8>] __schedule+0x2a8
[<ffffff874f91645c>] schedule+0x38
[<ffffff874f91a0ec>] rwsem_down_read_failed+0xe8
[<ffffff874e913dc4>] __percpu_down_read+0xfc
[<ffffff874e8a4ab0>] copy_process.isra.72.part.73+0xf60
[<ffffff874e8a53b8>] _do_fork+0xc4
[<ffffff874e8a5720>] kernel_thread+0x34
[<ffffff874e8ca83c>] kthreadd+0x144

kthreadd is waiting for cgroup_threadgroup_rwsem acquired
by task T

Task: T
[<ffffff874f91645c>] schedule+0x38
[<ffffff874f916870>] schedule_preempt_disabled+0x20
[<ffffff874f918df8>] __mutex_lock_slowpath+0x158
[<ffffff874f919004>] mutex_lock+0x14 
[<ffffff874e962ff4>] cpuset_can_attach+0x58
[<ffffff874e95d640>] cgroup_taskset_migrate+0x8c
[<ffffff874e95d9b4>] cgroup_migrate+0xa4
[<ffffff874e95daf0>] cgroup_attach_task+0x100
[<ffffff874e95df28>] __cgroup_procs_write.isra.35+0x228
[<ffffff874e95e00c>] cgroup_tasks_write+0x10
[<ffffff874e958294>] cgroup_file_write+0x44
[<ffffff874eaa4384>] kernfs_fop_write+0xc0

task T is waiting for cpuset_mutex acquired
by kworker/2:1

sh ==> cpuhp/2 ==> kworker/2:1 ==> sh 

kworker/2:3 ==> kthreadd ==> Task T ==> kworker/2:1

It seems that my earlier patch set should fix this scenario:
1) Inverting locking order of cpuset_mutex and cpu_hotplug_lock.
2) Make cpuset hotplug work synchronous.


Could you please share your feedback.


Thanks

-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation
Center, Inc., is a member of Code Aurora Forum, a Linux Foundation
Collaborative Project
