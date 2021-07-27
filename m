From: Waiman Long <llong@redhat.com>
Subject: Re: [PATCH v3 2/9] cgroup/cpuset: Fix a partition bug with hotplug
Date: Tue, 27 Jul 2021 16:16:56 -0400
Message-ID: <2173a00b-504a-1932-877d-d26775e4775c@redhat.com>
References: <20210720141834.10624-1-longman@redhat.com>
 <20210720141834.10624-3-longman@redhat.com>
 <YP8+ajTnvrha+0O6@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627417020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ByUPLbiVuvdvoapeEFXQAcFKJj/8lLrwBdwnV9vgH+s=;
        b=iIPYqXhCxCQ/tI2aYQFlODE1F3UluJwhMLsCtJIL6dxTpUc6duCZErA/0NMrf/FQ9v6VYQ
        kVXxAUsNLVyGRANNgGGwZuA/kcpiszOqAO1LQ4eAMpIY3IBJLke102HomkElsJgcSwK3U4
        9oeGI14kIdPEi0z3L79v7iom4+LBXQw=
In-Reply-To: <YP8+ajTnvrha+0O6@mtj.duckdns.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>

On 7/26/21 6:59 PM, Tejun Heo wrote:
> On Tue, Jul 20, 2021 at 10:18:27AM -0400, Waiman Long wrote:
>> In cpuset_hotplug_workfn(), the detection of whether the cpu list
>> has been changed is done by comparing the effective cpus of the top
>> cpuset with the cpu_active_mask. However, in the rare case that just
>> all the CPUs in the subparts_cpus are offlined, the detection fails
>> and the partition states are not updated correctly. Fix it by forcing
>> the cpus_updated flag to true in this particular case.
>>
>> Fixes: 4b842da276a8 ("cpuset: Make CPU hotplug work with partition")
>> Signed-off-by: Waiman Long <longman@redhat.com>
> Applied to cgroup/for-5.15 w/ a minor update to the comment (I dropped
> "just" before "all". It read weird to me.)
>
> Thanks.
>
Thanks for fixing the wording.

Cheers,
Longman

