From: "Chen, Yu C" <yu.c.chen@intel.com>
Subject: RE: [PATCH] cpuset: fix cpus_allowed mask for offline/online CPUs
Date: Mon, 4 Jan 2016 02:13:25 +0000
Message-ID: <36DF59CE26D8EE47B0655C516E9CE640286AC772@shsmsx102.ccr.corp.intel.com>
References: <2f805346f87680dddfa9253dc9031db3b6ead8ad.1451648318.git.yu.c.chen@intel.com>
 <5689D049.4040500@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5689D049.4040500@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Zefan Li <lizefan@huawei.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Rik van Riel <riel@redhat.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, David Rientjes <rientjes@google.com>, Vishnu Pratap Singh <vishnu.ps@samsung.com>, Pintu Kumar <pintu.k@samsung.com>, Michal Nazarewicz <mina86@mina86.com>, Mel Gorman <mgorman@suse.de>, "Gortmaker, Paul (Wind River)" <paul.gortmaker@windriver.com>, Peter Zijlstra <peterz@infradead.org>, Tim Chen <tim.c.chen@linux.intel.com>, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>

Hi Zefan,

> -----Original Message-----
> From: Zefan Li [mailto:lizefan@huawei.com]
> Sent: Monday, January 04, 2016 9:52 AM
> To: Chen, Yu C; cgroups@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; Vlastimil Babka; Rik van Riel; Joonsoo Kim;
> David Rientjes; Vishnu Pratap Singh; Pintu Kumar; Michal Nazarewicz; Mel
> Gorman; Gortmaker, Paul (Wind River); Peter Zijlstra; Tim Chen; Hugh Dickins;
> Tejun Heo
> Subject: Re: [PATCH] cpuset: fix cpus_allowed mask for offline/online CPUs
> 
> On 2016/1/1 20:09, Chen Yu wrote:
> > Commit be4c9dd7aee5 ("cpuset: enable onlined cpu/node in effective
> > masks") leverages cpuset's cpus_allowed and its parent's
> > effective_cpus to calculate the new_cpus by:
> >
> > cpumask_and(&new_cpus, cs->cpus_allowed,
> > parent_cs(cs)->effective_cpus);
> >
> > However cpus_allowed will also be updated after the CPU is offline, in
> > hotplug_update_tasks_legacy, so when the CPU is online again, it will
> > use the old cpus_allowed mask to calculate the new_cpus, thus new_cpus
> > will get incorrect value after each round of offline/online.
> >
> > This problem is found on ubuntu 15.10 with cpuset mounted:
> >
> > 1. echo 0 > /sys/devices/system/cpu/cpu2/online
> > 2. echo 1 > /sys/devices/system/cpu/cpu2/online
> > 3. cat /sys/fs/cgroup/cpuset/cpuset.cpus
> >     0-3
> > 4. cat /sys/fs/cgroup/cpuset/user.slice/cpuset.cpus
> >     0-1,3
> > 5. taskset -c 2 ls
> >     taskset: failed to set pid 0's affinity: Invalid argument
> >
> 
> This is the expected behavior...In legacy hierachy onlining an offlined cpu
> won't restore cpuset configurations automatically.
[Yu] Ah, I see, we were just a little confused with it before.
 So if we want to online an offlined cpu in legacy hierarchy, we
should not only echo 1 to 'online' sysfs, but also restore the mask manually? 
It seems that we should not rely on /sys/devices/system/cpu/cpu2/online,
if cpuset has been mounted.
> 
> Commit be4c9dd7aee5 changed this behavior, but only for unified hierachy.

thanks,
yu
