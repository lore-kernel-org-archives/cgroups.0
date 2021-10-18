From: Pratik Sampat <psampat@linux.ibm.com>
Subject: Re: [RFC 0/5] kernel: Introduce CPU Namespace
Date: Mon, 18 Oct 2021 20:59:16 +0530
Message-ID: <b5f8505c-38d5-af6f-0de7-4f9df7ae9b9b@linux.ibm.com>
References: <20211009151243.8825-1-psampat@linux.ibm.com>
 <20211011101124.d5mm7skqfhe5g35h@wittgenstein>
 <a0f9ed06-1e5d-d3d0-21a5-710c8e27749c@linux.ibm.com>
 <YWirxCjschoRJQ14@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=rcJecVSV9JJG4iazj3f+iELtHVS0LVi684kZY28slOs=;
 b=mqH+feqf8Hb96BFOXyA67/YgYynP5NHv/Yz0TI8SovXpfs7dbpTqX5yYEPiyXPogaT0P
 XIOBrQIcRvyWtdt2hjI3WyYToW9m/suJxgrLX/uzoagEE8vvUh+rHqt+mMvlQ/xlbHtW
 +JoWWWm1rfgNOrYLz/V1QrddYcGU2oqmzltViA2wX9I1mMRYf6VcbrpoS7lSb9gEVo2k
 uoSRPOt/of8eYkRH7LDSDMWZA8vpRsfPMw0zk+Nl+rIeKederxDTHVeaRwLCldWIqQSl
 AQ2oSBa9SuSV5gyqXJL0b443IhkTH0lo70MC3WqoRL/Sh4qWWxR3JAq4Xa20Mr7zv8Uh +g== 
Content-Language: en-US
In-Reply-To: <YWirxCjschoRJQ14@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Christian Brauner <christian.brauner@ubuntu.com>, bristot@redhat.com, christian@brauner.io, ebiederm@xmission.com, lizefan.x@bytedance.com, hannes@cmpxchg.org, mingo@kernel.org, juri.lelli@redhat.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, containers@lists.linux.dev, containers@lists.linux-foundation.org, pratik.r.sampat@gmail.com



On 15/10/21 3:44 am, Tejun Heo wrote:
> Hello,
>
> On Tue, Oct 12, 2021 at 02:12:18PM +0530, Pratik Sampat wrote:
>>>> The control and the display interface is fairly disjoint with each
>>>> other. Restrictions can be set through control interfaces like cgroups,
>>> A task wouldn't really opt-in to cpu isolation with CLONE_NEWCPU it
>>> would only affect resource reporting. So it would be one half of the
>>> semantics of a namespace.
>>>
>> I completely agree with you on this, fundamentally a namespace should
>> isolate both the resource as well as the reporting. As you mentioned
>> too, cgroups handles the resource isolation while this namespace
>> handles the reporting and this seems to break the semantics of what a
>> namespace should really be.
>>
>> The CPU resource is unique in that sense, at least in this context,
>> which makes it tricky to design a interface that presents coherent
>> information.
> It's only unique in the context that you're trying to place CPU distribution
> into the namespace framework when the resource in question isn't distributed
> that way. All of the three major local resources - CPU, memory and IO - are
> in the same boat. Computing resources, the physical ones, don't render
> themselves naturally to accounting and ditributing by segmenting _name_
> spaces which ultimately just shows and hides names. This direction is a
> dead-end.
>
>> I too think that having a brand new interface all together and teaching
>> userspace about it is much cleaner approach.
>> On the same lines, if were to do that, we could also add more useful
>> metrics in that interface like ballpark number of threads to saturate
>> usage as well as gather more such metrics as suggested by Tejun Heo.
>>
>> My only concern for this would be that if today applications aren't
>> modifying their code to read the existing cgroup interface and would
>> rather resort to using userspace side-channel solutions like LXCFS or
>> wrapping them up in kata containers, would it now be compelling enough
>> to introduce yet another interface?
> While I'm sympathetic to compatibility argument, identifying available
> resources was never well-define with the existing interfaces. Most of the
> available information is what hardware is available but there's no
> consistent way of knowing what the software environment is like. Is the
> application the only one on the system? How much memory should be set aside
> for system management, monitoring and other administrative operations?
>
> In practice, the numbers that are available can serve as the starting points
> on top of which application and environment specific knoweldge has to be
> applied to actually determine deployable configurations, which in turn would
> go through iterative adjustments unless the workload is self-sizing.
>
> Given such variability in requirements, I'm not sure what numbers should be
> baked into the "namespaced" system metrics. Some numbers, e.g., number of
> CPUs can may be mapped from cpuset configuration but even that requires
> quite a bit of assumptions about how cpuset is configured and the
> expectations the applications would have while other numbers - e.g.
> available memory - is a total non-starter.
>
> If we try to fake these numbers for containers, what's likely to happen is
> that the service owners would end up tuning workload size against whatever
> number the kernel is showing factoring in all the environmental factors
> knowingly or just through iterations. And that's not *really* an interface
> which provides compatibility. We're just piping new numbers which don't
> really mean what they used to mean and whose meanings can change depending
> on configuration through existing interfaces and letting users figure out
> what to do with the new numbers.
>
> To achieve compatibility where applications don't need to be changed, I
> don't think there is a solution which doesn't involve going through
> userspace. For other cases and long term, the right direction is providing
> well-defined resource metrics that applications can make sense of and use to
> size themselves dynamically.

I agree that major local resources like CPUs and memory cannot to be
distributed cleanly in a namespace semantic.
Thus the memory resource like CPU too does face similar coherency
issues where /proc/meminfo can be different from what the restrictions
are.

While a CPU namespace maybe not be the preferred way of solving
this problem, the prototype RFC is rather for understanding related
problems with this as well as other potential directions that we could
explore for solving this problem.

Also, I agree with your point about variability of requirements. If the
interface we give even though it is in conjunction with the limits set,
if the applications have to derive metrics from this or from other
kernel information regardless; then the interface would not be useful.
If the solution to this problem lies in userspace, then I'm all for it
as well. However, the intention is to probe if this could potentially be
solved in cleanly in the kernel.

>> While I concur with Tejun Heo's comment the mail thread and overloading
>> existing interfaces of sys and proc which were originally designed for
>> system wide resources, may not be a great idea:
>>
>>> There is a fundamental problem with trying to represent a resource shared
>>> environment controlled with cgroup using system-wide interfaces including
>>> procfs
>> A fundamental question we probably need to ascertain could be -
>> Today, is it incorrect for applications to look at the sys and procfs to
>> get resource information, regardless of their runtime environment?
> Well, it's incomplete even without containerization. Containerization just
> amplifies the shortcomings. All of these problems existed well before
> cgroups / namespaces. How would you know how much resource you can consume
> on a system just looking at hardware resources without implicit knowledge of
> what else is on the system? It's just that we are now more likely to load
> systems dynamically with containerization.

Yes, these shortcomings exist even without containerization, on a
dynamically loaded multi-tenant system it becomes very difficult to
determine what is the maximum amount resource that can be requested
before we hurt our own performance.
cgroups and namespace mechanics help containers give some structure to
the maximum amount of resources that they can consume. However,
applications are unable to leverage that in some cases especially if
they are more inclined to look at a more traditional system wide
interface like sys and proc.

>> Also, if an application were to only be able to view the resources
>> based on the restrictions set regardless of the interface - would there
>> be a disadvantage for them if they could only see an overloaded context
>> sensitive view rather than the whole system view?
> Can you elaborate further? I have a hard time understanding what's being
> asked.

The question that I have essentially tries to understand the
implications of overloading existing interface's definitions to be
context sensitive.
The way that the prototype works today is that it does not interfere
with the information when the system boots or even when it is run in a
new namespace.
The effects are only observed when restrictions are applied to it.
Therefore, what would potentially break if interfaces like these are
made to divulge information based on restrictions rather than the whole
system view?

Thanks
Pratik

