From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH v7 1/7] sched/topology: Adding function
 partition_sched_domains_locked()
Date: Fri, 5 Apr 2019 14:52:45 +0200
Message-ID: <20190405125245.GB5453@localhost.localdomain>
References: <20190403084650.4414-1-juri.lelli@redhat.com>
 <20190403084650.4414-2-juri.lelli@redhat.com>
 <20190405120434.GS12232@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190405120434.GS12232@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, rostedt@goodmis.org, tj@kernel.org, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org

Hi,

On 05/04/19 14:04, Peter Zijlstra wrote:
> On Wed, Apr 03, 2019 at 10:46:44AM +0200, Juri Lelli wrote:
> > +/*
> > + * Call with hotplug lock held
> 
> Is that spelled like:
> 
> 	lockdep_assert_cpus_held();
> 
> ?

Indeed, but I had that in previous versions and we removed that in v5
because it can lead to false positives [1,2]. IIRC, problem has to do
with hotplug and the fact that rebuilding from hotplug runs the
callbacks on the newly onlined CPU, not the task that acquired the lock.

Best,

- Juri

1 - https://lore.kernel.org/lkml/20180903142801.20046-1-juri.lelli@redhat.com/
2 - https://lore.kernel.org/lkml/20180613121711.5018-2-juri.lelli@redhat.com/
