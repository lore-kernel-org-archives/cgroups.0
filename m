From: Zhang Qiao <zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [Question] set_cpus_allowed_ptr() call failed at cpuset_attach()
Date: Fri, 21 Jan 2022 16:33:00 +0800
Message-ID: <f4552bb3-a119-5144-778f-f5c6dc16397f@huawei.com>
References: <09ce5796-798e-83d0-f1a6-ba38a787bfc5@huawei.com>
 <4415cd09-6de3-bb2d-386d-8beb4927fb46@huawei.com>
 <20220119130221.GA31037@blackbody.suse.cz>
 <ff49c096-39d9-4215-5b4f-8af2fd7c0c91@huawei.com>
 <20220120140222.GA27269@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220120140222.GA27269-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



在 2022/1/20 22:02, Michal Koutný 写道:
> On Thu, Jan 20, 2022 at 03:14:22PM +0800, Zhang Qiao <zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>> i think the troublesome scenario as follows:
>>      cpuset_can_attach
>>        down_read(cpuset_rwsem)
>>          // check all migratees
>>        up_read(cpuset_rwsem)
>>                                        			[ _cpu_down / cpuhp_setup_state ]
>>      cpuset_attach
>>       	down_write(cpuset_rwsem)
>> 	guarantee_online_cpus() // (load cpus_attach)
>> 	     						sched_cpu_deactivate
>> 							  set_cpu_active(cpu, false)  // will change cpu_active_mask
>>         set_cpus_allowed_ptr(cpus_attach)
>> 	   __set_cpus_allowed_ptr_locked()
>> 	     // (if the intersection of cpus_attach and
>> 	      cpu_active_mask is empty, will return -EINVAL)
>>        up_write(cpuset_rwsem)
>> 	                                     		schedule_work
>>         	                               		...
>>                 	                       		cpuset_hotplug_update_tasks
>>                         	                	 down_write(cpuset_rwsem)
>> 	                                	         up_write(cpuset_rwsem)
>> 		                                       ... flush_work
>>         		                               [ _cpu_down / cpu_up_down_serialize_trainwrecks ]
> 
> Thanks, a locking loophole indeed.
> 
> FTR, meanwhile I noticed: a) cpuset_fork() looks buggy when
> CLONE_INTO_CGROUP (and dst.cpus != src.cpus), b) it'd be affected with
> similar hotplug race.

Yes, it shouldn't set the current task's cpumak to the child process at cpuset_fork().

Regards,
Qiao
.
> 
> Michal
> .
> 
