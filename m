From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v10 7/8] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Wed, 4 May 2022 12:02:19 -0400
Message-ID: <379138a0-1721-d6fa-4d1d-cb8d79f28474@redhat.com>
References: <20220503162149.1764245-1-longman@redhat.com>
 <20220503162149.1764245-8-longman@redhat.com>
 <20220504112552.GA15266@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651680144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kx7MkkZT+Yq+fM3GfswobHpHpBTfL9nTvycJqnYKSP8=;
        b=g64HKG3q7K9kl0OdgE3bVx0t56mL25HfPcdeYHdrnZG95Gt95xSWwL3EWg2VMMvjGH/6IU
        G/YZ2Xg/1Apbh17i2zs+e3ofB+tM9ShMxCQaqEtlrEw5zbFUbGp24Fird2Rk7fP1pdF7sz
        eelDZJqopjQ7GRxGKAZBsAJ5ITqW7RY=
Content-Language: en-US
In-Reply-To: <20220504112552.GA15266@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>

On 5/4/22 07:25, Michal Koutný wrote:
> Hello.
>
> On Tue, May 03, 2022 at 12:21:48PM -0400, Waiman Long <longman@redhat.com> wrote:
>>   Documentation/admin-guide/cgroup-v2.rst | 145 +++++++++++++-----------
>>   1 file changed, 79 insertions(+), 66 deletions(-)
> A note across various lines -- it seems your new text accidentally mixes
> both spaces and tabs for indentation.

You are right. I will fix that.

>
>> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
>> index 69d7a6983f78..94e1e3771830 100644
>> --- a/Documentation/admin-guide/cgroup-v2.rst
>> +++ b/Documentation/admin-guide/cgroup-v2.rst
>> [...]
>> +	The value shown in "cpuset.cpus.effective" of a partition root is
>> +	the CPUs that the parent partition root can dedicate to the new
>> +	partition root.  They are subtracted from "cpuset.cpus.effective"
>> +	of the parent and may be different from "cpuset.cpus"
> I find this paragraph a bit hard to comprehend (I read it as it talks
> about three levels of cgroups (parent, child, grandparent). It is
> correct but I'd suggect following formulation (where I additionally
> simplifed it by talking about "available" cpus):
>
>> The value shown in "cpuset.cpus.effective" of a partition root is
>> the CPUs that the partition root can dedicate to a potential new child
>> partition root. The new child subtracts available CPUs from its parent
>> "cpuset.cpus.effective".


Thanks for the suggestion, will modify the text as suggested.


>
>> +	For a partition root to become valid, the following conditions
>> +	must be met.
>> +
>> +	1) The "cpuset.cpus" is exclusive, i.e. they are not shared by
>> +	   any of its siblings (exclusivity rule).
>> +	2) The parent cgroup is a valid partition root.
>> +	3) The "cpuset.cpus" is not empty and must contain at least
>> +	   one of the CPUs from parent's "cpuset.cpus", i.e. they overlap.
>> +        4) The "cpuset.cpus.effective" must be a subset of "cpuset.cpus"
>> +           and cannot be empty unless there is no task associated with
>> +           this partition.
> This sounds good to me.
>
>> +        Care must be taken to change a valid partition root to "member"
>> +        as all its child partitions, if present, will become invalid.
> This does not talk about recovering. Is it intentional? (I.e. to left
> implementation defined)

This new patch series does have the ability to recover now.  I am just 
not emphasizing the recovery aspect of it in the doc file. I will add a 
sentence about it.

>
> Except the remarks above, I find the concepts described here good. I'll
> reply to implementation separately & later.

Thanks,
Longman

