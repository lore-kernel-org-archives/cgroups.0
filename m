From: Preeti U Murthy <preeti-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] cpusets: Make cpus_allowed and mems_allowed masks hotplug
 invariant
Date: Thu, 09 Oct 2014 13:50:52 +0530
Message-ID: <54364564.3090305@linux.vnet.ibm.com>
References: <20141008070739.1170.33313.stgit@preeti.in.ibm.com> <20141008080706.GC10832@worktop.programming.kicks-ass.net> <543505EF.7070804@linux.vnet.ibm.com> <20141008101828.GG10832@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141008101828.GG10832-IIpfhp3q70z/8w/KjCw3T+5/BudmfyzbbVWyRVo5IupeoWH0uzbU5w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: svaidy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 10/08/2014 03:48 PM, Peter Zijlstra wrote:
> On Wed, Oct 08, 2014 at 03:07:51PM +0530, Preeti U Murthy wrote:
> 
>>> I still completely hate all that.. It basically makes cpusets useless,
>>> they no longer guarantee anything, it makes then an optional placement
>>> hint instead.
>>
>> Why do you say they don't guarantee anything? We ensure that we always
>> run on the cpus in our cpuset which are online. We do not run in any
>> arbitrary cpuset. We also do not wait unreasonably on an offline cpu to
>> come back. What we are doing is ensuring that if the resources that we
>> began with are available we use them. Why is this not a logical thing to
>> expect?
> 
> Because if you randomly hotplug cpus your tasks can randomly flip
> between sets.
> 
> Therefore there is no strict containment and no guarantees.
> 
>>> You also break long standing behaviour.
>>
>> Which is? As I understand cpusets are meant to ensure a dedicated set of
>> resources to some tasks. We cannot scheduler the tasks anywhere outside
>> this set as long as they are available. And when they are not, currently
>> we move them to their parents,
> 
> No currently we hard break affinity and never look back. That move to
> parent and back crap is all new fangled stuff, and broken because of the
> above argument.
> 
>> but you had also suggested killing the
>> task. Maybe this can be debated. But what behavior are we changing by
>> ensuring that we retain our original configuration at all times?
> 
> See above, by pretending hotplug is a sane operation you loose all
> guarantees.

Ok I see the point. The kernel must not be bothered about keeping
cpusets and hotplug operations consistent when both of these are user
initiated actions specifying affinity with the former and breaking the
same with the latter.

> 
>>> Also, power is insane if it needs/uses hotplug for operational crap
>>> like that.
>>
>> SMT 8 on Power8 can help/hinder workloads. Hence we dynamically switch
>> the modes at runtime.
> 
> That's just a horrible piece of crap hack and you deserve any and all
> pain you get from doing it.
> 
> Randomly removing/adding cpus like that is horrible and makes a mockery
> of all the affinity interfaces we have.

We observed this on ubuntu kernel, in which systemd explicitly mounts
cgroup controllers under a child cgroup identified by the user pid.
Since we had not observed this additional cgroup being added under the
hood, it came as a surprise to us that cgroup/cpuset handling in the
kernel should indeed kick in.

At best we expect hotplug to be handled well if the users have not
explicitly configured cpusets, hence implicitly specifying that task
affinity is for all online cpus. This is indeed the case today, so that
is good.

However what remains to be answered is that the V2 of cgroup design -
the default hierarchy, tracks hotplug operations for children cgroups as
well. Tejun, Li, will not the concerns that Peter raised above hold for
the default hierarchy as well?

Regards
Preeti U Murthy
> 
