From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v8 3/6] cpuset: Add cpuset.sched.load_balance flag to v2
Date: Thu, 24 May 2018 14:55:25 -0400
Message-ID: <9f547771-54e8-118e-80f7-48f99c7b0a12@redhat.com>
References: <1526590545-3350-1-git-send-email-longman@redhat.com>
 <1526590545-3350-4-git-send-email-longman@redhat.com>
 <20180524154341.GJ12198@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180524154341.GJ12198@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>

On 05/24/2018 11:43 AM, Peter Zijlstra wrote:
> On Thu, May 17, 2018 at 04:55:42PM -0400, Waiman Long wrote:
>> The sched.load_balance flag is needed to enable CPU isolation similar to
>> what can be done with the "isolcpus" kernel boot parameter. Its value
>> can only be changed in a scheduling domain with no child cpusets. On
>> a non-scheduling domain cpuset, the value of sched.load_balance is
>> inherited from its parent.
>>
>> This flag is set by the parent and is not delegatable.
>>
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>  Documentation/cgroup-v2.txt | 24 ++++++++++++++++++++
>>  kernel/cgroup/cpuset.c      | 53 +++++++++++++++++++++++++++++++++++++++++----
>>  2 files changed, 73 insertions(+), 4 deletions(-)
>>
>> diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
>> index 54d9e22..071b634d 100644
>> --- a/Documentation/cgroup-v2.txt
>> +++ b/Documentation/cgroup-v2.txt
>> @@ -1536,6 +1536,30 @@ Cpuset Interface Files
>>  	CPUs of the parent cgroup. Once it is set, this flag cannot be
>>  	cleared if there are any child cgroups with cpuset enabled.
>>  
>> +	A parent cgroup cannot distribute all its CPUs to child
>> +	scheduling domain cgroups unless its load balancing flag is
>> +	turned off.
>> +
>> +  cpuset.sched.load_balance
>> +	A read-write single value file which exists on non-root
>> +	cpuset-enabled cgroups.  It is a binary value flag that accepts
>> +	either "0" (off) or a non-zero value (on).  This flag is set
>> +	by the parent and is not delegatable.
>> +
>> +	When it is on, tasks within this cpuset will be load-balanced
>> +	by the kernel scheduler.  Tasks will be moved from CPUs with
>> +	high load to other CPUs within the same cpuset with less load
>> +	periodically.
>> +
>> +	When it is off, there will be no load balancing among CPUs on
>> +	this cgroup.  Tasks will stay in the CPUs they are running on
>> +	and will not be moved to other CPUs.
>> +
>> +	The initial value of this flag is "1".	This flag is then
>> +	inherited by child cgroups with cpuset enabled.  Its state
>> +	can only be changed on a scheduling domain cgroup with no
>> +	cpuset-enabled children.
> I'm confused... why exactly do we have both domain and load_balance ?

The domain is for partitioning the CPUs only. It doesn't change the load
balancing state. So the load_balance flag is still need to turn on and
off load balancing.

Cheers,
Longman

