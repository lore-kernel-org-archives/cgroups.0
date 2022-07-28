From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 1/2] cgroup/cpuset: Keep current cpus list if cpus
 affinity was explicitly set
Date: Thu, 28 Jul 2022 17:04:19 -0400
Message-ID: <c470d3f7-f0f8-b8e6-4a95-7b334f0a824b@redhat.com>
References: <20220728005815.1715522-1-longman@redhat.com>
 <YuLF+xXaCzwWi2BR@slm.duckdns.org>
 <1ae1cc6c-dca9-4958-6b22-24a5777c5e8d@redhat.com>
 <YuLdX7BYGvo57LNU@slm.duckdns.org>
 <606ed69e-8ad0-45d5-9de7-48739df7f48d@redhat.com>
 <YuL1NijxSEv2xadk@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659042264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PRBCCH+EkIgUpXOLdlJYEsIwuOxdedTFnF9t4CuFePQ=;
        b=GfJP0q1dnCjsYDHjhnofuklOFFJJrNIWqpfIt7XNEkJjbc83xPmgHzrFaczVmprwHQvIFx
        isQb2DgCIOBjA56V+nuhZZkyDklOCJJxOTFPvMJL106TuSdmeL6JmLuvzKzCMTeGIF7QjU
        RNyYtC8SDZFtD/nuzc8ieBSk8UJi02o=
Content-Language: en-US
In-Reply-To: <YuL1NijxSEv2xadk@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 7/28/22 16:44, Tejun Heo wrote:
> Hello,
>
> On Thu, Jul 28, 2022 at 03:21:26PM -0400, Waiman Long wrote:
>> On 7/28/22 15:02, Tejun Heo wrote:
>>> On Thu, Jul 28, 2022 at 02:57:28PM -0400, Waiman Long wrote:
>>>> There can be a counter argument that if a user found out that there is not
>>>> enough cpus in a cpuset to meet its performance target, one can always
>>>> increase the number of cpus in the cpuset. Generalizing this behavior to all
>>>> the tasks irrespective if they have explicitly set cpus affinity before will
>>>> disallow this use case.
>>> This is nasty.
>> That is a nasty example, I know. There may be users depending on the
>> existing behavior even if they don't know it. So I am a bit hesitant to
>> change the default behavior like that. On the other hand, tasks that have
>> explicitly set its cpu affinity certainly don't want to have unexpected
>> change to that.
> Yeah, I hear you. I'm on the same page.
>
>>> The real solution here is separating out what user requested
>>> and the mask that cpuset (or cpu hotplug) needs to apply on top. ie.
>>> remember what the user requested in a separate cpumask and compute the
>>> intersection into p->cpus_maks whenever something changes and apply
>>> fallbacks on that final mask. Multiple parties updating the same variable is
>>> never gonna lead to anything consistent and we're patching up for whatever
>>> the immediate use case seems to need at the moment. That said, I'm not
>>> necessarily against patching it up but if you're interested in delving into
>>> it deeper, that'd be great.
>> I believe the current code is already restricting what cpu affinity that a
>> user can request by limiting to those allowed by the current cpuset. Hotplug
>> is another issue that may need to be addressed. I will update my patch to
>> make it handle hotplug in a more graceful way.
> af
> So, the patch you proposed is making the code remember one special aspect of
> user requested configuration - whether it configured it or not, and trying
> to preserve that particular state as cpuset state changes. It addresses the
> immediate problem but it is a very partial approach. Let's say a task wanna
> be affined to one logical thread of each core and set its mask to 0x5555.
> Now, let's say cpuset got enabled and enforced 0xff and affined the task to
> 0xff. After a while, the cgroup got more cpus allocated and its cpuset now
> has 0xfff. Ideally, what should happen is the task now having the effective
> mask of 0x555. In practice, tho, it either would get 0xf55 or 0x55 depending
> on which way we decide to misbehave.

OK, I see what you want to accomplish. To fully address this issue, we 
will need to have a new cpumask variable in the the task structure which 
will be allocated if sched_setaffinity() is ever called. I can rework my 
patch to use this approach.

Thanks,
Longman

