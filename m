From: Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH v9 0/8] sched/deadline: fix cpusets bandwidth accounting
Date: Wed, 24 Jul 2019 10:45:44 +0200
Message-ID: <bbc98035-f960-f06a-66fc-24509ea51a5c@arm.com>
References: <20190719140000.31694-1-juri.lelli@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190719140000.31694-1-juri.lelli@redhat.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Juri Lelli <juri.lelli@redhat.com>, peterz@infradead.org, mingo@redhat.com, rostedt@goodmis.org, tj@kernel.org
Cc: linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, longman@redhat.com, cgroups@vger.kernel.org

On 7/19/19 3:59 PM, Juri Lelli wrote:
> Hi,
> 
> v9 of a series of patches, originally authored by Mathieu, with the intent
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
> Apart from the usual rebase on top of cgroup/for-next, this version
> 
>  - make cpuset_{can,cancel}_attach grab cpuset_rwsem for write (5/8 - Peter)
>  - moves v8 8/8 to 7/8 for bisectability (Peter)
>  - adds comment in changelog regarding normalize_rt_tasks() (8/8 - Peter)
> 
> Set also available at
> 
>  https://github.com/jlelli/linux.git fixes/deadline/root-domain-accounting-v9

Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>

Test description:

Juno-r0 (Arm64 big/Little [L b b L L L]) with 6 DL tasks
(12000/100000/100000).

Rt-app runs DL workload for 10min.

After rt-app launched, start CPU hotplug stress test (random CPU hp
in/out except for CPU1 (CPU orig capacity 1024 (big)) during the entire
rt-app run.

Tests ran with 1 and 2 (exclusive cpusets ([0,3-5], [1-2])) root domains.
