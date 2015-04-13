From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH V2] cpuset: Add knob to make allowed masks hotplug invariant
 on legacy hierarchy
Date: Mon, 13 Apr 2015 13:55:39 +0530
Message-ID: <552B7D83.2030509@linux.vnet.ibm.com>
References: <20150410141118.11284.36206.stgit@preeti.in.ibm.com> <20150411083537.GR27490@worktop.programming.kicks-ass.net> <20150413070117.GX24151@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150413070117.GX24151@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: tj@kernel.org, svaidy@linux.vnet.ibm.com, nacc@linux.vnet.ibm.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, lizefan@huawei.com, anton@samba.org, bharata@linux.vnet.ibm.com, cgroups@vger.kernel.org, paulmck@linux.vnet.ibm.com, mingo@kernel.org, serge@hallyn.com

On 04/13/2015 12:31 PM, Peter Zijlstra wrote:
> On Sat, Apr 11, 2015 at 10:35:37AM +0200, Peter Zijlstra wrote:
>> On Fri, Apr 10, 2015 at 07:41:52PM +0530, Preeti U Murthy wrote:
>>> The cpus_allowed and mems_allowed masks of a cpuset get overwritten
>>> after each hotplug operation on the legacy hierarchy of cgroups so as to
>>> remain in sync with the online mask. But there are use cases which
>>> expect user configured masks to remain unchanged.
>>>
>>> For instance, when hotplugged out CPUs are brought back online, they
>>> remain idle with none of the existing tasks allowed to run on them since
>>> the cpus_allowed mask was overwritten to not include them when they were
>>> offlined.
>>>
>>> We cannot change the legacy hierarchy design now to keep the allowed
>>> masks hotplug invariant since it is a user visible change. It was
>>> suggested instead to add a knob in the root cpuset directory which
>>> allows the user to specify if he wants the user configured masks to be
>>> hotplug invariant [1]. This knob will enforce the choice throughout the
>>> hierarchy. If the knob is set, the allowed maks will not be varied on
>>> hotplug. It is also to to be noted that this knob will appear in the
>>> root cgroup mounted on the legacy hierarchy alone since the default
>>> hierarchy does not overwrite the allowed masks anyway.
>>>
>>> Having said this, there are fair reasons to argue that the kernel is not
>>> responsible for taking care of user configurations in the face of
>>> hotplug. But one of the consequences of the current legacy hierarchy
>>> design, is that CPUs are left out from being used at all on online
>>> operations. The reason for this is not very obvious at first and several
>>> users have raised the issue as a bug. Hence the patch was strongly
>>> called for.
>>>
>>> Moreover the default hierarchy keeps the allowed masks hotplug invariant
>>> too. So the patch is not bringing about a fundamental change in the
>>> design of cgroups.
>>
>> What you've not explained is why you can use this knob but not use the
>> other new mode?
> 
> Urgh, it looks like the new mode is only available through the default
> hierarchy (whatever that is).
> 
> Would it not make sense to make that a mount option and limit the amount
> of semantic variants of cpusets?

Makes sense. I will send out the next version that enforces the desired
behavior through a mount option.

Thank you

Regards
Preeti U Murthy
> 
