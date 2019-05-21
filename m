From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH v2] cpuset: restore sanity to
 cpuset_cpus_allowed_fallback()
Date: Tue, 21 May 2019 16:34:14 +0200
Message-ID: <20190521143414.GJ5307@blackbody.suse.cz>
References: <20190409204003.6428-1-jsavitz@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190409204003.6428-1-jsavitz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Savitz <jsavitz@redhat.com>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>, Waiman Long <longman@redhat.com>, Phil Auld <pauld@redhat.com>, cgroups@vger.kernel.org

On Tue, Apr 09, 2019 at 04:40:03PM -0400, Joel Savitz <jsavitz@redhat.com> wrote:
> 	$ grep Cpus /proc/$$/status
> 	Cpus_allowed:	ff
> 	Cpus_allowed_list:	0-7

(a)
 
> 	$ taskset -p 4 $$
> 	pid 19202's current affinity mask: f
> 	pid 19202's new affinity mask: 4
> 
> 	$ grep Cpus /proc/self/status
> 	Cpus_allowed:	04
> 	Cpus_allowed_list:	2
> 
> 	# echo off > /sys/devices/system/cpu/cpu2/online
> 	$ grep Cpus /proc/$$/status
> 	Cpus_allowed:	0b
> 	Cpus_allowed_list:	0-1,3
I'm confused where this value comes from, I must be missing something.

Joel, is the task in question put into a cpuset with 0xf CPUs only (at
point (a))? Or are the CPUs 4-7 offlined as well?

Thanks,
Michal
