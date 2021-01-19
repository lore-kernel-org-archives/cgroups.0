From: Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH 4/6] sched/deadline: Block DL tasks on non-exclusive
 cpuset if bandwitdh control is enable
Date: Tue, 19 Jan 2021 16:37:46 +0100
Message-ID: <f7cad09a-09e3-e150-d505-ac75aece0248@arm.com>
References: <cover.1610463999.git.bristot@redhat.com>
 <7b336c37cc3c38def6de181df8ba8c3148c5cc0c.1610463999.git.bristot@redhat.com>
 <4b37b32b-0e16-ffbc-ca6a-fbee935c0813@arm.com>
 <08dd4e61-5c4a-b010-2149-8f84ced3fb38@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <08dd4e61-5c4a-b010-2149-8f84ced3fb38@redhat.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Daniel Bristot de Oliveira <bristot@redhat.com>, linux-kernel@vger.kernel.org
Cc: Marco Perronet <perronet@mpi-sws.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Valentin Schneider <valentin.schneider@arm.com>, cgroups@vger.kernel.org

On 19/01/2021 10:41, Daniel Bristot de Oliveira wrote:
> On 1/14/21 4:51 PM, Dietmar Eggemann wrote:
>> On 12/01/2021 16:53, Daniel Bristot de Oliveira wrote:

[...]

>> with this patch:
>>
>> cgroupv1:
>>
>> root@juno:/sys/fs/cgroup/cpuset# chrt -d --sched-period 1000000000
>> --sched-runtime 100000000 0 sleep 500 &
>> [1] 1668
>> root@juno:/sys/fs/cgroup/cpuset# PID1=$!
>>
>> root@juno:/sys/fs/cgroup/cpuset# chrt -d --sched-period 1000000000
>> --sched-runtime 100000000 0 sleep 500 &
>> [2] 1669
>> root@juno:/sys/fs/cgroup/cpuset# PID2=$!
>>
>> root@juno:/sys/fs/cgroup/cpuset# mkdir A
>>
>> root@juno:/sys/fs/cgroup/cpuset# echo 0 > ./A/cpuset.mems
>> root@juno:/sys/fs/cgroup/cpuset# echo 0 > ./A/cpuset.cpus
>>
>> root@juno:/sys/fs/cgroup/cpuset# echo $PID2 > ./A/cgroup.procs
>> -bash: echo: write error: Device or resource busy
>>
>> root@juno:/sys/fs/cgroup/cpuset# echo 1 > ./A/cpuset.cpu_exclusive
>>
>> root@juno:/sys/fs/cgroup/cpuset# echo $PID2 > ./A/cgroup.procs
>>
>> root@juno:/sys/fs/cgroup/cpuset# cat /proc/$PID1/status | grep
>> Cpus_allowed_list | awk '{print $2}'
>> 0-5
>> root@juno:/sys/fs/cgroup/cpuset# cat /proc/$PID2/status | grep
>> Cpus_allowed_list | awk '{print $2}'
>> 0
> 
> On CPU v1 we also need to disable the load balance to create a root domain, right?

IMHO, that's not necessary for this example. But yes, if we create 2
exclusive cpusets A and B we want to turn off load-balancing on root
level. It also doesn't hurt doing this in this example. But we end up
with no sched domain since load-balance is disabled at root and A only
contains CPU0.

root@juno:/sys/fs/cgroup/cpuset# echo 0 > cpuset.sched_load_balance

ls /proc/sys/kernel/sched_domain/cpu*/ doesn't show any (sched) domains.

>> cgroupv2:
> 
> Yeah, I see your point. I was seeing a different output because of Fedora
> default's behavior of adding the tasks to the system.slice/user.slice...
> 
> doing:
> 
>> root@juno:/sys/fs/cgroup# echo +cpuset > cgroup.subtree_control
> 
> # echo $$ > cgroup.procs

The current shell should be already in the root cgroup?

root@juno:/sys/fs/cgroup# echo $$
1644
root@juno:/sys/fs/cgroup# cat cgroup.procs | grep $$
1644

[...]

