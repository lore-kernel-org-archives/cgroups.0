From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Documentation: Clarify usage of memory limits
Date: Thu, 1 Jun 2023 20:09:42 -0400
Message-ID: <f0cf5dd9-47fa-742d-a23c-42602dc3b89e@redhat.com>
References: <20230601183820.3839891-1-schatzberg.dan@gmail.com>
 <e6ae97f4-cdae-e655-d118-a11b3d679fd6@redhat.com>
 <20230601195345.GB157732@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685664588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IQBTL4KWFtPVFbs25Ot9x0LJbTVOUU336wX1+2B8Rjk=;
        b=SupiPRc9oKFa+Gk1jUVkI+qcMzcrPPHZ8VbEQ3wWUX0z4XxvSZoOzdASX12bLcVyFn6jo3
        b0551IFjvfk5LrOtKuTyGshq3A8FX87Vb/KKvSTP1VWivXu6n82r+Q5fZislQ58InGqOdH
        yVwwTyHQdV0XRE9w+Yc8GTTIMu63lgg=
Content-Language: en-US
In-Reply-To: <20230601195345.GB157732-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 6/1/23 15:53, Johannes Weiner wrote:
> On Thu, Jun 01, 2023 at 03:15:28PM -0400, Waiman Long wrote:
>> On 6/1/23 14:38, Dan Schatzberg wrote:
>>> The existing documentation refers to memory.high as the "main mechanism
>>> to control memory usage." This seems incorrect to me - memory.high can
>>> result in reclaim pressure which simply leads to stalls unless some
>>> external component observes and actions on it (e.g. systemd-oomd can be
>>> used for this purpose). While this is feasible, users are unaware of
>>> this interaction and are led to believe that memory.high alone is an
>>> effective mechanism for limiting memory.
>>>
>>> The documentation should recommend the use of memory.max as the
>>> effective way to enforce memory limits - it triggers reclaim and results
>>> in OOM kills by itself.
>> That is not how my understanding of memory.high works. When memory usage
>> goes past memory.high, memory reclaim will be initiated to reclaim the
>> memory back. Stall happens when memory.usage keep increasing like by
>> consuming memory faster than what memory reclaim can recover. When
>> memory.max is reached, OOM killer will then kill off the tasks.
> This was the initial plan indeed: Slow down the workload and thus slow
> the growth; hope that the workload recovers with voluntary frees; set
> memory.max as a safety if it keeps going beyond.
>
> This never panned out. Once workloads are stuck, they might not back
> down on their own. By increasingly slowing growth, it becomes harder
> and harder for them to reach the memory.max intervention point.
>
> It's a very brittle configuration strategy. Unless you very carefully
> calibrate memory.high and memory.max together with awareness of the
> throttling algorithm, workloads that hit memory.high will just go to
> sleep indefinitely. They require outside intervention that either
> adjusts limits or implements kill policies based on observed sleeps
> (they're reported as pressure via psi).
>
> So the common usecases today end up being that memory.max is for
> enforcing kernel OOM kills, and memory.high is a tool to implement
> userspace OOM killing policies.
>
> Dan is right to point out the additional expectations for userspace
> management when memory.high is in used. And memory.max is still the
> primary, works-out-of-the-box method of memory containment.

Thanks for clarification. I have to reset my false assumption.

Cheers,
Longman

