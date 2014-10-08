From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH] cpusets: Make cpus_allowed and mems_allowed masks hotplug
 invariant
Date: Wed, 08 Oct 2014 15:07:51 +0530
Message-ID: <543505EF.7070804@linux.vnet.ibm.com>
References: <20141008070739.1170.33313.stgit@preeti.in.ibm.com> <20141008080706.GC10832@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141008080706.GC10832@worktop.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: svaidy@linux.vnet.ibm.com, rjw@rjwysocki.net, lizefan@huawei.com, anton@samba.org, tj@kernel.org, paulmck@linux.vnet.ibm.com, mingo@kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Peter,

On 10/08/2014 01:37 PM, Peter Zijlstra wrote:
> On Wed, Oct 08, 2014 at 12:37:40PM +0530, Preeti U Murthy wrote:
>> There are two masks associated with cpusets. The cpus/mems_allowed
>> and effective_cpus/mems. On the legacy hierarchy both these masks
>> are consistent with each other. This is the intersection of their
>> value and the currently active cpus. This means that we destroy the
>> original values set in these masks on each cpu/mem hot unplug operation.
>> 	As a consequence when we hot plug back the cpus/mems, the tasks
>> no longer run on them and performance degrades, inspite of having
>> resources to run on.
>>
>> This effect is not seen in the default hierarchy since the
>> allowed and effective masks are distinctly maintained.
>> allowed masks are never touched once configured and effective masks
>> alone are hotplug variant.
>>
>> This patch replicates the above design even for the legacy hierarchy,
>> so that:
>>
>> 1. Tasks always run on the cpus/memory nodes that they are allowed to run on
>> as long as they are online. The allowed masks are hotplug invariant.
>>
>> 2. When all cpus/memory nodes in a cpuset are hot unplugged out, the tasks
>> are moved to their nearest ancestor which has resources to run on.
>>
>> There were discussions earlier around this issue:
>> https://lkml.org/lkml/2012/5/4/265
>> http://thread.gmane.org/gmane.linux.kernel/1250097/focus=1252133
>>
>> The argument against making the allowed masks hotplug invariant was that
>> hotplug is destructive and hence cpusets cannot expect to regain resources
>> that have gone through a hotplug operation by the user.
>>
>> But on powerpc we do smt mode switch to suit the workload running.
>> We therefore need to keep track of the original cpuset configuration
>> so as to make use of them when they are back online due to a mode switch.
>> Moreover there is no real harm in keeping the allowed masks invariant
>> on hotplug since the effective masks will anyway keep track of the
>> online cpus. In fact there are use cases which need the cpuset's
>> original configuration to be retained. The v2 of cgroup design therefore
>> does not overwrite this configuration.
>>
> 
> I still completely hate all that.. It basically makes cpusets useless,
> they no longer guarantee anything, it makes then an optional placement
> hint instead.

Why do you say they don't guarantee anything? We ensure that we always
run on the cpus in our cpuset which are online. We do not run in any
arbitrary cpuset. We also do not wait unreasonably on an offline cpu to
come back. What we are doing is ensuring that if the resources that we
began with are available we use them. Why is this not a logical thing to
expect?

> 
> You also break long standing behaviour.

Which is? As I understand cpusets are meant to ensure a dedicated set of
resources to some tasks. We cannot scheduler the tasks anywhere outside
this set as long as they are available. And when they are not, currently
we move them to their parents, but you had also suggested killing the
task. Maybe this can be debated. But what behavior are we changing by
ensuring that we retain our original configuration at all times?

> 
> Also, power is insane if it needs/uses hotplug for operational crap
> like that.

SMT 8 on Power8 can help/hinder workloads. Hence we dynamically switch
the modes at runtime.

Regards
Preeti U Murthy
> 
