From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 1/2] cpuset: Fix cpuset_cpus_allowed() to not filter
 offline CPUs
Date: Wed, 1 Feb 2023 22:34:00 -0500
Message-ID: <773e2f22-211e-163f-64bb-15ae29ad161b@redhat.com>
References: <20230131221719.3176-1-will@kernel.org>
 <20230131221719.3176-2-will@kernel.org>
 <6b068916-5e1b-a943-1aad-554964d8b746@redhat.com>
 <Y9otWX+MGOLDKU6t@hirez.programming.kicks-ass.net>
 <83e53632-27ed-8dde-84f4-68c6776d6da8@redhat.com>
 <a892d340-ea99-1562-0e70-176f02f195c2@redhat.com>
 <Y9rVVldS19oyIZ+g@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675308851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J25aygLZYRtVKk3o+FCXZY8yPzqAyLq7HmtB3PexRQI=;
        b=feZbXbqU8p2PR/AjNHlRI51GOXOZaUK8hpQQIW99HVwYKOk+Dqu/6wlRH9Bbn7t95ruKw0
        hD6xasd0h0SnL/Pv6Q+M5KLrsjiTRZvgGbt2cJzV0juLUk4l2/cksCMmEqi0KPMGlX8eZX
        fW6K9Jr/RA9kcr2cYXCZcTx+qBg4cuA=
Content-Language: en-US
In-Reply-To: <Y9rVVldS19oyIZ+g@hirez.programming.kicks-ass.net>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org, kernel-team@android.com, Zefan Li <lizefan.x@bytedance.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org

On 2/1/23 16:10, Peter Zijlstra wrote:
> On Wed, Feb 01, 2023 at 01:46:11PM -0500, Waiman Long wrote:
>
>> Note that using cpus_allowed directly in cgroup v2 may not be right because
>> cpus_allowed may have no relationship to effective_cpus at all in some
>> cases, e.g.
>>
>>     root
>>      |
>>      V
>>      A (cpus_allowed = 1-4, effective_cpus = 1-4)
>>      |
>>      V
>>      B (cpus_allowed = 5-8, effective_cpus = 1-4)
>>
>> In the case of cpuset B, passing back cpus 5-8 as the allowed_cpus is wrong.
> I think my patch as written does the right thing here. Since the
> intersection of (1-4) and (5-8) is empty it will move up the hierarchy
> and we'll end up with (1-4) from the cgroup side of things.
>
> So the purpose of __cs_cpus_allowed() is to override the cpus_allowed of
> the root set and force it to cpu_possible_mask.
>
> Then cs_cpus_allowed() computes the intersection of cs->cpus_allowed and
> all it's parents. This will, in the case of B above, result in the empty
> mask.
>
> Then cpuset_cpus_allowed() has a loop that starts with
> task_cpu_possible_mask(), intersects that with cs_cpus_allowed() and if
> the intersection of that and cpu_online_mask is empty, moves up the
> hierarchy. Given cs_cpus_allowed(B) is the empty mask, we'll move to A.
>
> Note that since we force the mask of root to cpu_possible_mask,
> cs_cpus_allowed(root) will be a no-op and if we guarantee (in arch code)
> that cpu_online_mask always has a non-empty intersection with
> task_cpu_possible_mask(), this loop is guaranteed to terminate with a
> viable mask.

I will take a closer look at that tomorrow. I will be more comfortable 
ack'ing that if this is specific to v1 cpuset instead of applying this 
in both v1 and v2 since it is only v1 that is problematic.

Cheers,
Longman

