From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH v5 0/5] sched/deadline: fix cpusets bandwidth accounting
Date: Tue, 25 Sep 2018 10:14:48 +0200
Message-ID: <20180925081448.GA4287@localhost.localdomain>
References: <20180903142801.20046-1-juri.lelli@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180903142801.20046-1-juri.lelli@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peterz@infradead.org, mingo@redhat.com, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org

Hi,

On 03/09/18 16:27, Juri Lelli wrote:
> Hi,
> 
> v5 of a series of patches, originally authored by Mathieu, with the intent
> of fixing a long standing issue of SCHED_DEADLINE bandwidth accounting.
> As originally reported by Steve [1], when hotplug and/or (certain)
> cpuset reconfiguration operations take place, DEADLINE bandwidth
> accounting information is lost since root domains are destroyed and
> recreated.
> 
> Mathieu's approach is based on restoring bandwidth accounting info on
> the newly created root domains by iterating through the (DEADLINE) tasks
> belonging to the configured cpuset(s).
> 
> Main problem of v4 was caused by the trylocking of cpuset_mutex. As
> noticed by Steve [2], if multiple tasks are created at they same time
> only the first gets to grab the mutex, the other get -EBUSY and need to
> retry. Not really nice. So, in v5 I'm proposing to use callback_lock
> instead of cpuset_mutex, which AFAIU should be enough to grant read-only
> safe access to cpusets.
> 
> 01/05 has been dropped because it wasn't really adding much and was
> only causing false positives.
> 
> 05/05 is still too much DEADLINE specific I guess, but let's first agree
> on foundations patches.
> 
> Set also available at
> 
>  https://github.com/jlelli/linux.git fixes/deadline/root-domain-accounting-v5

Gentle ping about this.

Best,

- Juri
