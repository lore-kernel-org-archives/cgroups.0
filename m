From: Vaibhav Jain <vaibhav@linux.ibm.com>
Subject: Re: [PATCH] memcg: provide reclaim stats via 'memory.reclaim'
Date: Fri, 20 May 2022 10:45:43 +0530
Message-ID: <87zgjcg4xs.fsf@vajain21.in.ibm.com>
References: <20220518223815.809858-1-vaibhav@linux.ibm.com>
 <YoYj4sLJfGke5IGT@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=JJh4foNOJwG8ay+rF9OREYoAAGUcy1t9u8UYkcLppDI=;
 b=ELKkv1yz+L8SWhSgdtOrbEXtZvOD+cENx24BoptdFKJngLJFqAFk4gTXTNJ6tG6EB0yF
 JiGrfsBf6gJRSVo7Sb1bkQ6AA1pAL/oR4vJgpke7pfbmhCC/IKyTRKSr4Q4nMWe/kgav
 AIkMzmFjMhAr3rpEbF+raurSOIPtWvkV5AvXlTlmSrLKtmWPUDLhr87OYLEou6LuhXqq
 A5ltkwBf131kfTnPReceOVT54PMoIJCJQejCoP6dewY4M8lJ8otOYiRATJaw/68W5uz+
 RUDj2K+tBQMdhkp8xdt8a93uCsBYzSc48p+lnt+bei2JmuVKNjFB8+u5c0Q3PngIdWYK ng== 
In-Reply-To: <YoYj4sLJfGke5IGT@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, Shakeel Butt <shakeelb@google.com>, Yosry Ahmed <yosryahmed@google.com>


Thanks for looking into this patch Michal,

Michal Hocko <mhocko@suse.com> writes:

> On Thu 19-05-22 04:08:15, Vaibhav Jain wrote:
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
> Why cannot you use memory.stat? Sure it would require to iterate over
> the reclaimed hierarchy but the information about scanned and reclaimed
> pages as well as other potentially useful stats is there.

Agree that "memory.stat" is more suitable for scanned/reclaimed stats as
it already is exposing bunch of other stats.

The discussion on this patch however seems to have split into two parts:

1. Is it a good idea to expose nr_scanned/nr_reclaimed to users-space
and if yes how ?

IMHO, I think it will be better to expose this info via 'memory.stat' as it
can be useful insight into the reclaim efficiency  and vmpressure.


2. Will it be useful to provide feedback to userspace when it writes to
'memory.reclaim' on how much memory has been reclaimed ?

IMHO, this will be a useful feeback to userspace to better adjust future
proactive reclaim requests via 'memory.reclaim'


-- 
> Michal Hocko
> SUSE Labs
>

-- 
Cheers
~ Vaibhav
