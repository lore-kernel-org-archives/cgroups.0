From: Vaibhav Jain <vaibhav@linux.ibm.com>
Subject: Re: [PATCH] memcg: provide reclaim stats via 'memory.reclaim'
Date: Thu, 19 May 2022 15:26:52 +0530
Message-ID: <8735h5hml7.fsf@vajain21.in.ibm.com>
References: <20220518223815.809858-1-vaibhav@linux.ibm.com>
 <xr937d6ic5qk.fsf@gthelen2.svl.corp.google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=cKPPLtUhn1Zdq9Oika82pAtq/kD+uaRcTWRlgTUcvuE=;
 b=ZpDHUadAU6pwtWhT2zKhV4nm6iGq0zAoMYSHrl73AwJTteBFxmJJYaILbI9rtcLcWqBU
 bIAl6pQAVHsaKYFmRmwUu9fE7CP0+GSveQRjj39PiBoxvCR1+0YgwHNZYmTD1OrmOzu5
 O2bNplUCc/SwPgB9ggkYMmrICTV+wBkadCYbWkQYDDxHnq7qqWwY4AMOITe+Xd6PXgOZ
 dglAMLKOzl+eiR9Yhkl6ElvIDu5EZNIRK53EpzHNSsEi3roZHlWTIHE1itLeFHlP8k32
 7KyPMKAc0asMSl2i8NUw3UlZa0z9aBgClpna8ftcc8bIQhbJwshLs7nrlHqz7dmgSjsN 5A== 
In-Reply-To: <xr937d6ic5qk.fsf@gthelen2.svl.corp.google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Thelen <gthelen@google.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, Shakeel Butt <shakeelb@google.com>, Yosry Ahmed <yosryahmed@google.com>

Hi,

Thanks for looking into this patch,

Greg Thelen <gthelen@google.com> writes:

> Vaibhav Jain <vaibhav@linux.ibm.com> wrote:
>
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
>>
>> With the patch following command flow is expected:
>>
>>  # echo "1M" > memory.reclaim
>>
>>  # cat memory.reclaim
>>    scanned 76
>>    reclaimed 32
>
> I certainly appreciate the ability for shell scripts to demonstrate
> cgroup operations with textual interfaces, but such interface seem like
> they are optimized for ease of use by developers.
>
Agree that directly exposing nr_scanned/reclaimed might not be a useful
for users and certainly looks like a dev interface

> I wonder if for runtime production use an ioctl or netlink interface has
> been considered for cgroup? I don't think there are any yet, but such
> approaches seem like a more straightforward ways to get nontrivial
> input/outputs from a single call (e.g. like this proposal). And they
> have the benefit of not requiring ascii serialization/parsing overhead.

I think to a large degree eBPF and existing static tracepoints in vmscan
can provide access to these metrics as Shakeel Bhat pointed to earlier.

<snip>

-- 
Cheers
~ Vaibhav
