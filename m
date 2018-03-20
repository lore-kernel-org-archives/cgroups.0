From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v5 1/2] cpuset: Enable cpuset controller in default
 hierarchy
Date: Tue, 20 Mar 2018 16:53:37 -0400
Message-ID: <2b9261b8-6a3a-81d1-9c9a-394524a0d413@redhat.com>
References: <1521148842-15486-1-git-send-email-longman@redhat.com>
 <1521148842-15486-2-git-send-email-longman@redhat.com>
 <20180319155937.GQ2943022@devbig577.frc2.facebook.com>
 <1881c1da-56ec-d76b-b736-fd0919737ec6@redhat.com>
 <20180320201029.GO519464@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180320201029.GO519464@devbig577.frc2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

On 03/20/2018 04:10 PM, Tejun Heo wrote:
> Hello, Waiman.
>
> On Tue, Mar 20, 2018 at 09:51:20AM -0400, Waiman Long wrote:
>>>> +	It lists the onlined CPUs that are actually allowed to be
>>>> +	used by tasks within the current cgroup. It is a subset of
>>>> +	"cpuset.cpus".  Its value will be affected by CPU hotplug
>>>> +	events.
>>> Can we do cpuset.cpus.availble which lists the cpus available to the
>>> cgroup instead of the eventual computed mask for the cgroup?  That'd
>>> be more useful as it doesn't lose the information by and'ing what's
>>> available with the cgroup's mask and it's trivial to determine the
>>> effective from the two masks.
>> I don't get what you want here. cpus is the cpuset's cpus_allowed mask.
>> effective_cpus is the effective_cpus mask. When you say cpus available
>> to the cgroup, do you mean the cpu_online_mask or the list of cpus from
>> the parent? Or do you just want to change the name to cpus.available
>> instead of effective_cpus?
> The available cpus from the parent, where the effective is AND between
> cpuset.available and cpuset.cpus of the cgroup, so that the user can
> see what's available for the cgroup unfiltered by cpuset.cpus.

ASAIK for v2, when cpuset.cpus is empty, cpuset.effective_cpus will show
all the cpus available from the parent. It is a different behavior from
v1. So do we still need a cpuset.cpus_available?

>> Right, I will set CFTYPE_NOT_ON_ROOT to "cpus" and "mems" as we are not
>> supposed to change them in the root. The effective_cpus and
>> effective_mems will be there in the root to show what are available.
> So, we can do that in the future but let's not do that for now.  It's
> the same problem we have for basically everything else and we've
> stayed away from replicating the information in the root cgroup.  This
> might change in the future but if we do that let's do that
> consistently.
That is fine. I will make them all disappears in the root cgroup.

Cheers,
Longman

