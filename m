From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v2 0/4] cgroup/cpuset: Miscellaneous updates
Date: Tue, 28 Mar 2023 21:15:18 -0400
Message-ID: <656e9f38-4204-6e3b-f0e8-b03727a5334d@redhat.com>
References: <20230317151508.1225282-1-longman@redhat.com>
 <20230328134000.GA1333@willie-the-truck>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680052523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dKxuuTqWwWNukmjM2t0MLHI1t4BmxOvyVmCaNcAexzc=;
        b=f/BRJM3wQqCRnh2fbjd0sn2f0Zg4P8ftAaTLSSqaS+RQNIaism1AI+ZBDBugbOqK0HWLxj
        CkH1JKgwpbQXbs7Fg/2/IQaVhqPEEqkNdbAcDLI/djFYeS9v6fOrmVSvC1INnQ+6YDyWiP
        S5PMfBj6OA0c/1TamlRkpuKg8DLO/Is=
Content-Language: en-US
In-Reply-To: <20230328134000.GA1333@willie-the-truck>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Will Deacon <will@kernel.org>, Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Juri Lelli <juri.lelli@redhat.com>

On 3/28/23 09:40, Will Deacon wrote:
> Hi Waiman,
>
> On Fri, Mar 17, 2023 at 11:15:04AM -0400, Waiman Long wrote:
>>   v2:
>>    - Add a new patch 1 that fixes a bug introduced by recent v6.2 commit
>>      7a2127e66a00 ("cpuset: Call set_cpus_allowed_ptr() with appropriate
>>      mask for task").
>>    - Make a small twist and additional comment to patch 2 ("cgroup/cpuset:
>>      Skip task update if hotplug doesn't affect current cpuset") as
>>      suggested by Michal.
>>    - Remove v1 patches 3/4 for now for further discussion.
>>
>> This patch series includes miscellaneous update to the cpuset and its
>> testing code.
> FWIW, this series also passes my asymmetric 32-bit tests.

Thanks Will!

Tejun, do you have time to take a look at this series, especially the 
first patch which is a fix that may need to go to stable?

Cheers,
Longman

