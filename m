From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH v4 1/5] sched/topology: Add check to backup comment about
 hotplug lock
Date: Thu, 14 Jun 2018 16:11:18 +0200
Message-ID: <20180614141118.GG12032@localhost.localdomain>
References: <20180613121711.5018-1-juri.lelli@redhat.com>
 <20180613121711.5018-2-juri.lelli@redhat.com>
 <20180614093324.7ea45448@gandalf.local.home>
 <20180614134234.GC12032@localhost.localdomain>
 <20180614094747.390357ec@gandalf.local.home>
 <20180614135040.GE12032@localhost.localdomain>
 <20180614135800.GM17720@e108498-lin.cambridge.arm.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180614135800.GM17720@e108498-lin.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Quentin Perret <quentin.perret@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org

On 14/06/18 14:58, Quentin Perret wrote:

[...]

> Hmm not sure if this can help but I think that rebuild_sched_domains()
> does _not_ take the hotplug lock before calling partition_sched_domains()
> when CONFIG_CPUSETS=n. But it does take it for CONFIG_CPUSETS=y.

Did you mean cpuset_mutex?

cpu_hotplug_lock seems to be the problem here..

Can't seem to follow otherwise. :-(
