From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] cpuset: Fix cpuset_cpus_allowed() to not filter
 offline CPUs
Date: Fri, 3 Feb 2023 10:13:10 -0500
Message-ID: <d626998b-4cb0-dd8f-fd97-21715bf2eb0b@redhat.com>
References: <20230131221719.3176-1-will@kernel.org>
 <20230131221719.3176-2-will@kernel.org>
 <6b068916-5e1b-a943-1aad-554964d8b746@redhat.com>
 <Y9otWX+MGOLDKU6t@hirez.programming.kicks-ass.net>
 <83e53632-27ed-8dde-84f4-68c6776d6da8@redhat.com>
 <a892d340-ea99-1562-0e70-176f02f195c2@redhat.com>
 <Y9rVVldS19oyIZ+g@hirez.programming.kicks-ass.net>
 <773e2f22-211e-163f-64bb-15ae29ad161b@redhat.com>
 <20230203115045.GB5927@willie-the-truck>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675437194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iG2sYT3v2a3Wr18XBz4fLFtpFFFcjqNhgLajuLkz3OI=;
        b=NcgJXrMIQYy9GUuIrEaryuv+Qn0ImTnTCmJUr9tHqUsSfE+PCDgW5VKsf22mm1ZDSn9nvp
        s5QWHneM11HUGM8pQi6hMlBtRox7o41xy8vpDchh7PUjLuJDxDx699gzs95mIRBUd4HvCm
        sHjItRKoxgaYCpoLuKouDtJbE89NRGc=
Content-Language: en-US
In-Reply-To: <20230203115045.GB5927@willie-the-truck>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2/3/23 06:50, Will Deacon wrote:
> On Wed, Feb 01, 2023 at 10:34:00PM -0500, Waiman Long wrote:
>> On 2/1/23 16:10, Peter Zijlstra wrote:
>>> On Wed, Feb 01, 2023 at 01:46:11PM -0500, Waiman Long wrote:
>>>
>>>> Note that using cpus_allowed directly in cgroup v2 may not be right because
>>>> cpus_allowed may have no relationship to effective_cpus at all in some
>>>> cases, e.g.
>>>>
>>>>      root
>>>>       |
>>>>       V
>>>>       A (cpus_allowed = 1-4, effective_cpus = 1-4)
>>>>       |
>>>>       V
>>>>       B (cpus_allowed = 5-8, effective_cpus = 1-4)
>>>>
>>>> In the case of cpuset B, passing back cpus 5-8 as the allowed_cpus is wrong.
>>> I think my patch as written does the right thing here. Since the
>>> intersection of (1-4) and (5-8) is empty it will move up the hierarchy
>>> and we'll end up with (1-4) from the cgroup side of things.
>>>
>>> So the purpose of __cs_cpus_allowed() is to override the cpus_allowed of
>>> the root set and force it to cpu_possible_mask.
>>>
>>> Then cs_cpus_allowed() computes the intersection of cs->cpus_allowed and
>>> all it's parents. This will, in the case of B above, result in the empty
>>> mask.
>>>
>>> Then cpuset_cpus_allowed() has a loop that starts with
>>> task_cpu_possible_mask(), intersects that with cs_cpus_allowed() and if
>>> the intersection of that and cpu_online_mask is empty, moves up the
>>> hierarchy. Given cs_cpus_allowed(B) is the empty mask, we'll move to A.
>>>
>>> Note that since we force the mask of root to cpu_possible_mask,
>>> cs_cpus_allowed(root) will be a no-op and if we guarantee (in arch code)
>>> that cpu_online_mask always has a non-empty intersection with
>>> task_cpu_possible_mask(), this loop is guaranteed to terminate with a
>>> viable mask.
>> I will take a closer look at that tomorrow. I will be more comfortable
>> ack'ing that if this is specific to v1 cpuset instead of applying this in
>> both v1 and v2 since it is only v1 that is problematic.
> fwiw, the regression I'm seeing is with cgroup2. I haven't tried v1.

I think I know where the problem is. It is due to the fact the cpuset 
hotplug code doesn't update cpumasks of the tasks in the top cpuset 
(root) at all when there is a cpu offline or online event. It is 
probably because for some of the tasks in the top cpuset, especially the 
percpu kthread, changing their cpumasks can be catastrophic. The hotplug 
code does update the cpumasks of the tasks that are not in the top 
cpuset. This problem is irrespective of whether v1 or v2 is in use.

The partition code does try to update the cpumasks of the tasks in the 
top cpuset, but skip the percpu kthreads. My testing show that is 
probably OK. For safety, I agree that is better to extend the allowed 
cpu list to all the possible cpus (including offline ones) for now until 
more testings are done to find a safe way to do that. That special case 
should apply only to tasks in the top cpuset. For the rests, the current 
code should be OK and is less risky than adopting code in this patch.

Cheers,
Longman

