From: Vaibhav Jain <vaibhav@linux.ibm.com>
Subject: Re: [PATCH] memcg: provide reclaim stats via 'memory.reclaim'
Date: Thu, 19 May 2022 14:20:58 +0530
Message-ID: <878rqxhpn1.fsf@vajain21.in.ibm.com>
References: <20220518223815.809858-1-vaibhav@linux.ibm.com>
 <CAJD7tkZSgRs6T60Gv4dZR5xBemxgCB_2s8hz8zB0F_nakN5aTQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=socf21ni5+/NQUYujP3bagP571P0CjAgkZfi4zqTir0=;
 b=rOOUDQo6Z5DXAI+f5cS5iGTGJzMRZyIRzmWkNu71yV7sKQxRXsWTSEcyeyxcYNydQ4b5
 XbwjLz1qisOMWuvioTimZXTepinPvHY9rzzO2sH8ZfkB8pecgk7eh4r1IxxVHBeRgNHz
 OOuOSzQJOEVpj2cp7j3EbX2hD8hTmdnWlgT6dYAExBKmxdRTuZ4yiNIf48B8Ovhbslch
 eZtu7VDXImH7JjzzlX9EsfVgqRx5xzoeqskeAoYC4BW47TIebBulVTczHk5DRO06d/eT
 cRNpeczwkdGwpkpFEEQbAxq13FBds9Fa9/spo7XenH4fp4GPeAOlBsc4dTmkPy8iyLy2 ug== 
In-Reply-To: <CAJD7tkZSgRs6T60Gv4dZR5xBemxgCB_2s8hz8zB0F_nakN5aTQ@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, Shakeel Butt <shakeelb@google.com>

Hi,

Thanks for looking into this patch,

Yosry Ahmed <yosryahmed@google.com> writes:

> On Wed, May 18, 2022 at 3:38 PM Vaibhav Jain <vaibhav@linux.ibm.com> wrote:
>>
>> [1] Provides a way for user-space to trigger proactive reclaim by introducing
>> a write-only memcg file 'memory.reclaim'. However reclaim stats like number
>> of pages scanned and reclaimed is still not directly available to the
>> user-space.
>>
>> This patch proposes to extend [1] to make the memcg file 'memory.reclaim'
>> readable which returns the number of pages scanned / reclaimed during the
>> reclaim process from 'struct vmpressure' associated with each memcg. This should
>> let user-space asses how successful proactive reclaim triggered from memcg
>> 'memory.reclaim' was ?
>
> Isn't this a racy read? struct vmpressure can be changed between the
> write and read by other reclaim operations, right?
Read/write of vmpr stats is always done in context of vmpr->sr_lock
which is also the case for this patch. So not sure how the read is racy
?.

>
> I was actually planning to send a patch that does not updated
> vmpressure for user-controller reclaim, similar to how PSI is handled.
>
Ok, not sure if I am inferring correctly as to how how that would be
useful. Can you please provide some more context.

The primary motivation for this patch was to expose the vmpressure stats
to user space that are available with cgroup-v1 but not with cgroup-v2
AFAIK

> The interface currently returns -EBUSY if the entire amount was not
> reclaimed, so isn't this enough to figure out if it was successful or
> not?
Userspace may very well want to know the amount of memory that was
partially reclaimed even though write to "memory.reclaim" returned
'-EBUSY'. This feedback can be useful info for implementing a retry
loop.

> If not, we can store the scanned / reclaim counts of the last
> memory.reclaim invocation for the sole purpose of memory.reclaim
> reads.
Sure sounds reasonable to me.

> Maybe it is actually more intuitive to users to just read the
> amount of memory read? In a format that is similar to the one written?
>
> i.e
> echo "10M" > memory.reclaim
> cat memory.reclaim
> 9M
>
Agree, I will address that in v2.

<snip>

-- 
Cheers
~ Vaibhav
