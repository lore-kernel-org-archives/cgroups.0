From: Quentin Perret <quentin.perret@arm.com>
Subject: Re: [PATCH v4 1/5] sched/topology: Add check to backup comment about
 hotplug lock
Date: Thu, 14 Jun 2018 15:18:19 +0100
Message-ID: <20180614141818.GN17720@e108498-lin.cambridge.arm.com>
References: <20180613121711.5018-1-juri.lelli@redhat.com>
 <20180613121711.5018-2-juri.lelli@redhat.com>
 <20180614093324.7ea45448@gandalf.local.home>
 <20180614134234.GC12032@localhost.localdomain>
 <20180614094747.390357ec@gandalf.local.home>
 <20180614135040.GE12032@localhost.localdomain>
 <20180614135800.GM17720@e108498-lin.cambridge.arm.com>
 <20180614141118.GG12032@localhost.localdomain>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180614141118.GG12032@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juri Lelli <juri.lelli@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org

On Thursday 14 Jun 2018 at 16:11:18 (+0200), Juri Lelli wrote:
> On 14/06/18 14:58, Quentin Perret wrote:
> 
> [...]
> 
> > Hmm not sure if this can help but I think that rebuild_sched_domains()
> > does _not_ take the hotplug lock before calling partition_sched_domains()
> > when CONFIG_CPUSETS=n. But it does take it for CONFIG_CPUSETS=y.
> 
> Did you mean cpuset_mutex?

Nope, I really meant the cpu_hotplug_lock !

With CONFIG_CPUSETS=n, rebuild_sched_domains() calls
partition_sched_domains() directly:

https://elixir.bootlin.com/linux/latest/source/include/linux/cpuset.h#L255

But with CONFIG_CPUSETS=y, rebuild_sched_domains() calls,
rebuild_sched_domains_locked(), which calls get_online_cpus() which
calls cpus_read_lock(), which does percpu_down_read(&cpu_hotplug_lock).
And all that happens before calling partition_sched_domains().

So yeah, the point I was trying to make is that there is an inconsistency
here, maybe for a good reason ? Maybe related to the issue you're seeing ?

Thanks,
Quentin
