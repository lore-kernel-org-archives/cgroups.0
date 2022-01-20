From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [Question] set_cpus_allowed_ptr() call failed at cpuset_attach()
Date: Thu, 20 Jan 2022 15:02:22 +0100
Message-ID: <20220120140222.GA27269@blackbody.suse.cz>
References: <09ce5796-798e-83d0-f1a6-ba38a787bfc5@huawei.com>
 <4415cd09-6de3-bb2d-386d-8beb4927fb46@huawei.com>
 <20220119130221.GA31037@blackbody.suse.cz>
 <ff49c096-39d9-4215-5b4f-8af2fd7c0c91@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1642687347; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=34TJNw4/W0xTbQedpBACNYP+v/nLFuErBI3QihUnxYA=;
        b=CL2oL11sIm6GsYpC/7RLyX/oK2+E++LeDUyG+w8aimfmvFN6411HJqUB2WRcuTyJVAjkQh
        Nuxrm3IhXZ3K+bzZEQCv/flg8IbeBiSFtwzGpSrZ+Lk9BDV/DNcT/gBPsDHRFPQK0v6FFF
        08CISQRfePNNd5sCb043RitIMLq9p1g=
Content-Disposition: inline
In-Reply-To: <ff49c096-39d9-4215-5b4f-8af2fd7c0c91@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhang Qiao <zhangqiao22@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, lizefan.x@bytedance.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Jan 20, 2022 at 03:14:22PM +0800, Zhang Qiao <zhangqiao22@huawei.com> wrote:
> i think the troublesome scenario as follows:
>      cpuset_can_attach
>        down_read(cpuset_rwsem)
>          // check all migratees
>        up_read(cpuset_rwsem)
>                                        			[ _cpu_down / cpuhp_setup_state ]
>      cpuset_attach
>       	down_write(cpuset_rwsem)
> 	guarantee_online_cpus() // (load cpus_attach)
> 	     						sched_cpu_deactivate
> 							  set_cpu_active(cpu, false)  // will change cpu_active_mask
>         set_cpus_allowed_ptr(cpus_attach)
> 	   __set_cpus_allowed_ptr_locked()
> 	     // (if the intersection of cpus_attach and
> 	      cpu_active_mask is empty, will return -EINVAL)
>        up_write(cpuset_rwsem)
> 	                                     		schedule_work
>         	                               		...
>                 	                       		cpuset_hotplug_update_tasks
>                         	                	 down_write(cpuset_rwsem)
> 	                                	         up_write(cpuset_rwsem)
> 		                                       ... flush_work
>         		                               [ _cpu_down / cpu_up_down_serialize_trainwrecks ]

Thanks, a locking loophole indeed.

FTR, meanwhile I noticed: a) cpuset_fork() looks buggy when
CLONE_INTO_CGROUP (and dst.cpus != src.cpus), b) it'd be affected with
similar hotplug race.

Michal
