From: Xiubo Li <xiubli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cgroup: deadlock between cpu_hotplug_lock and freezer_mutex
Date: Wed, 15 Feb 2023 18:36:02 +0800
Message-ID: <90147a2b-982e-ae57-9b7c-062bee0fab07@redhat.com>
References: <20230215072501.3764-1-hdanton@sina.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676457369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0DULdTVfIZoN5gfe54AIlB0FglUr8CaQBCm49yRWhdM=;
        b=CgZ+cYfjvhwVCBJ8SgIa1eNrfT6zqK72UN/T4nPtWYtu+4zIjF+/lHu1fK/4iMUjUC3fyC
        c+FJI30UogSeYIKiacMetXAtVFzK59LuDiHkoKaBqwln1W0RqnAcaaU7EGCknm+A1hQ3lL
        NSS9yEAQJcsZEqQMPlTZQuT19GGwtac=
Content-Language: en-US
In-Reply-To: <20230215072501.3764-1-hdanton-k+cT0dCbe1g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Hillf,

On 15/02/2023 15:25, Hillf Danton wrote:
> On Wed, 15 Feb 2023 10:07:23 +0800 Xiubo Li <xiubli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Hi
>>
>> Recently when running some test cases for ceph we hit the following
>> deadlock issue in cgroup code. Has this been fixed ? I have checked the
>> latest code and it seems no any commit is fixing this.
>>
>> This call trace could also be found in
>> https://tracker.ceph.com/issues/58564#note-4, which is more friendly to
>> read.
>>
>>    ======================================================
>>    WARNING: possible circular locking dependency detected
>>    6.1.0-rc5-ceph-gc90f64b588ff #1 Tainted: G S
>>    ------------------------------------------------------
>>    runc/90769 is trying to acquire lock:
>>    ffffffff82664cb0 (cpu_hotplug_lock){++++}-{0:0}, at:
>> static_key_slow_inc+0xe/0x20
>>    #012but task is already holding lock:
>>    ffffffff8276e468 (freezer_mutex){+.+.}-{3:3}, at: freezer_write+0x89/0x530
>>    #012which lock already depends on the new lock.
>>    #012the existing dependency chain (in reverse order) is:
>>    #012-> #2 (freezer_mutex){+.+.}-{3:3}:
>>          __mutex_lock+0x9c/0xf20
>>          freezer_attach+0x2c/0xf0
>>          cgroup_migrate_execute+0x3f3/0x4c0
>>          cgroup_attach_task+0x22e/0x3e0
>>          __cgroup1_procs_write.constprop.12+0xfb/0x140
>>          cgroup_file_write+0x91/0x230
>>          kernfs_fop_write_iter+0x137/0x1d0
>>          vfs_write+0x344/0x4d0
>>          ksys_write+0x5c/0xd0
>>          do_syscall_64+0x34/0x80
>>          entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>    #012-> #1 (cgroup_threadgroup_rwsem){++++}-{0:0}:
>>          percpu_down_write+0x45/0x2c0
>>          cgroup_procs_write_start+0x84/0x270
>>          __cgroup1_procs_write.constprop.12+0x57/0x140
>>          cgroup_file_write+0x91/0x230
>>          kernfs_fop_write_iter+0x137/0x1d0
>>          vfs_write+0x344/0x4d0
>>          ksys_write+0x5c/0xd0
>>          do_syscall_64+0x34/0x80
>>          entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>    #012-> #0 (cpu_hotplug_lock){++++}-{0:0}:
>>          __lock_acquire+0x103f/0x1de0
>>          lock_acquire+0xd4/0x2f0
>>          cpus_read_lock+0x3c/0xd0
>>          static_key_slow_inc+0xe/0x20
>>          freezer_apply_state+0x98/0xb0
>>          freezer_write+0x307/0x530
>>          cgroup_file_write+0x91/0x230
>>          kernfs_fop_write_iter+0x137/0x1d0
>>          vfs_write+0x344/0x4d0
>>          ksys_write+0x5c/0xd0
>>          do_syscall_64+0x34/0x80
>>          entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>    #012other info that might help us debug this:
>>    Chain exists of:#012  cpu_hotplug_lock --> cgroup_threadgroup_rwsem
>> --> freezer_mutex
>>    Possible unsafe locking scenario:
>>          CPU0                    CPU1
>>          ----                    ----
>>     lock(freezer_mutex);
>>                                  lock(cgroup_threadgroup_rwsem);
>>                                  lock(freezer_mutex);
>>     lock(cpu_hotplug_lock);
>>    #012 *** DEADLOCK ***
> Thanks for your report.
>
> Change locking order if it is impossible to update freezer_active in atomic manner.
>
> Only for thoughts.

Sure, I will test this.

Thanks


>
> Hillf
> +++ linux-6.1.3/kernel/cgroup/legacy_freezer.c
> @@ -350,7 +350,7 @@ static void freezer_apply_state(struct f
>   
>   	if (freeze) {
>   		if (!(freezer->state & CGROUP_FREEZING))
> -			static_branch_inc(&freezer_active);
> +			static_branch_inc_cpuslocked(&freezer_active);
>   		freezer->state |= state;
>   		freeze_cgroup(freezer);
>   	} else {
> @@ -361,7 +361,7 @@ static void freezer_apply_state(struct f
>   		if (!(freezer->state & CGROUP_FREEZING)) {
>   			freezer->state &= ~CGROUP_FROZEN;
>   			if (was_freezing)
> -				static_branch_dec(&freezer_active);
> +				static_branch_dec_cpuslocked(&freezer_active);
>   			unfreeze_cgroup(freezer);
>   		}
>   	}
> @@ -379,6 +379,7 @@ static void freezer_change_state(struct
>   {
>   	struct cgroup_subsys_state *pos;
>   
> +	cpus_read_lock();
>   	/*
>   	 * Update all its descendants in pre-order traversal.  Each
>   	 * descendant will try to inherit its parent's FREEZING state as
> @@ -407,6 +408,7 @@ static void freezer_change_state(struct
>   	}
>   	rcu_read_unlock();
>   	mutex_unlock(&freezer_mutex);
> +	cpus_read_unlock();
>   }
>   
>   static ssize_t freezer_write(struct kernfs_open_file *of,
>
-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org/xiubli-qyM6JfAXOaQ@public.gmane.org
Slack: @Xiubo Li

