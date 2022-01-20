From: Zhang Qiao <zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [Question] set_cpus_allowed_ptr() call failed at cpuset_attach()
Date: Thu, 20 Jan 2022 15:14:22 +0800
Message-ID: <ff49c096-39d9-4215-5b4f-8af2fd7c0c91@huawei.com>
References: <09ce5796-798e-83d0-f1a6-ba38a787bfc5@huawei.com>
 <4415cd09-6de3-bb2d-386d-8beb4927fb46@huawei.com>
 <20220119130221.GA31037@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220119130221.GA31037-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

hello

在 2022/1/19 21:02, Michal Koutný 写道:
> On Fri, Jan 14, 2022 at 09:15:06AM +0800, Zhang Qiao <zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>> 	I found the following warning log on qemu. I migrated a task from one cpuset cgroup to
>> another, while I also performed the cpu hotplug operation, and got following calltrace.
> 
> Do you have more information on what hotplug event and what error
> (from set_cpus_allowed_ptr() you observe? (And what's src/dst cpuset wrt
> root/non-root)?
  I ran the LTP testcases and a test scripts that do hotplug on a random cpu at the same time.
  The race condition quickly, and I can't reproduce it so far.
  By reading code about set_cpus_allowed_ptr(), i think __set_cpus_allowed_ptr_locked() will
be failed when new_mask and cpu_active_mask do not intersect, as follows:

 __set_cpus_allowed_ptr_locked():
	....
	const struct cpumask *cpu_valid_mask = cpu_active_mask;
	dest_cpu = cpumask_any_and_distribute(cpu_valid_mask, new_mask);
	if (dest_cpu >= nr_cpu_ids) {
		ret = -EINVAL;
		goto out;
	}
	....
}


> 
>> 	Can we use cpus_read_lock()/cpus_read_unlock() to guarantee that set_cpus_allowed_ptr()
>> doesn't fail, as follows:
> 
> I'm wondering what can be wrong with the current actors:
> 
>     cpuset_can_attach
>       down_read(cpuset_rwsem)
>         // check all migratees
>       up_read(cpuset_rwsem)
>                                       [ _cpu_down / cpuhp_setup_state ]
>                                       schedule_work
>                                       ...
>                                       cpuset_hotplug_update_tasks
>                                         down_write(cpuset_rwsem)
>                                         up_write(cpuset_rwsem)
>                                       ... flush_work
>                                       [ _cpu_down / cpu_up_down_serialize_trainwrecks ]
>     cpuset_attach
>       down_write(cpuset_rwsem)
>         set_cpus_allowed_ptr(allowed_cpus_weird)
>       up_write(cpuset_rwsem)
> 

i think the troublesome scenario as follows:
     cpuset_can_attach
       down_read(cpuset_rwsem)
         // check all migratees
       up_read(cpuset_rwsem)
                                       			[ _cpu_down / cpuhp_setup_state ]
     cpuset_attach
      	down_write(cpuset_rwsem)
	guarantee_online_cpus() // (load cpus_attach)
	     						sched_cpu_deactivate
							  set_cpu_active(cpu, false)  // will change cpu_active_mask
        set_cpus_allowed_ptr(cpus_attach)
	   __set_cpus_allowed_ptr_locked()
	     // (if the intersection of cpus_attach and
	      cpu_active_mask is empty, will return -EINVAL)
       up_write(cpuset_rwsem)
	                                     		schedule_work
        	                               		...
                	                       		cpuset_hotplug_update_tasks
                        	                	 down_write(cpuset_rwsem)
	                                	         up_write(cpuset_rwsem)
		                                       ... flush_work
        		                               [ _cpu_down / cpu_up_down_serialize_trainwrecks ]


Regards,
Qiao

> The statement in cpuset_attach() about cpuset_can_attach() test is not
> so strong since task_can_attach() is mostly a pass for non-deadline
> tasks. Still, the use of cpuset_rwsem above should synchronize (I may be
> mistaken) the changes of cpuset's cpu masks, so I'd be interested about
> the details above to understand why the current approach doesn't work.
> 
> The additional cpus_read_{,un}lock (when reordered wrt cpuset_rwsem)
> may work but your patch should explain why (in what situation).
> 
> My .02€,
> Michal
> .
> 
