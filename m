From: Preeti U Murthy <preeti-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] cpusets: Make cpus_allowed and mems_allowed masks hotplug
 invariant
Date: Thu, 09 Oct 2014 10:42:02 +0530
Message-ID: <54361922.8070808@linux.vnet.ibm.com>
References: <CAC4Lta2AS6M5upg8n9Qu5+1pqCMF3j8_cYuLAS1DH9C_BQP0PA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAC4Lta2AS6M5upg8n9Qu5+1pqCMF3j8_cYuLAS1DH9C_BQP0PA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Raghavendra KT <raghavendra.kt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: svaidy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paul McKenney <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Raghu,

On 10/08/2014 08:24 PM, Raghavendra KT wrote:
> On Wed, Oct 8, 2014 at 12:37 PM, Preeti U Murthy
> <preeti-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
>> There are two masks associated with cpusets. The cpus/mems_allowed
>> and effective_cpus/mems. On the legacy hierarchy both these masks
>> are consistent with each other. This is the intersection of their
>> value and the currently active cpus. This means that we destroy the
>> original values set in these masks on each cpu/mem hot unplug operation.
>>         As a consequence when we hot plug back the cpus/mems, the tasks
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
> 
> Hi Preeti,
> 
> I may be missing some thing here could you please explain when do we get
> tasks move out of a cpuset after this patch and why it is even necessary?

On the legacy hierarchy the tasks are moved to their parents cpusets if
the cpuset to which they were initially bound becomes empty. What the
patch does has nothing to do with moving tasks when the cpuset to which
they are bound becomes empty.The point 2 above was mentioned to merely
state that this part of the behavior is not really changed with the
patch. The patch merely ensures that the original cpuset configuration
is not messed with during hotplug operations.

> 
> IIUC, with default hierarchy we should never hit a case where we have empty
> effective cpuset and hence remove_tasks_in_empty_cpuset should never happen. no?
> 
> if my assumption is correct then we should remove
> remove_tasks_in_empty_cpuset itself...

remove_tasks_in_empty_cpuset() is called on the legacy hierarchy when
the cpuset becomes empty, hence we require it. But you are right its not
called on the default hierarchy.

Regards
Preeti U Murthy
> 
