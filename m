From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v11 8/8] kselftest/cgroup: Add cpuset v2 partition root
 state test
Date: Sat, 21 May 2022 22:40:13 -0400
Message-ID: <ed130232-144e-9763-2602-7d8a71e41cb6@redhat.com>
References: <20220510153413.400020-1-longman@redhat.com>
 <20220510153413.400020-9-longman@redhat.com>
 <0ede5fe6-89c8-5e63-0c0c-265b57ea5ca6@collabora.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653187219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CUBw8GFTyhDBg8PslsY0hFMfNEXHrEOXs4oed7UJ/6Y=;
        b=XVwdEgAD7aSrRD0jx2QJ+n+ugv548JalGghSxnBiSP7OedU18t7cdF75X8NVu3dtVANxKr
        GCL98/Ru6usZ7z7qZg21IMY9lqTJeGXtRkhq80y6KbhRY+/fGxgIZ+YhdTYCztXRLI+JX+
        aX+dSJCfH4wqQ4dmY4nMGP4nZyydMoc=
Content-Language: en-US
In-Reply-To: <0ede5fe6-89c8-5e63-0c0c-265b57ea5ca6@collabora.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Muhammad Usama Anjum <usama.anjum@collabora.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>

On 5/21/22 06:24, Muhammad Usama Anjum wrote:
> On 5/10/22 8:34 PM, Waiman Long wrote:
>> diff --git a/tools/testing/selftests/cgroup/Makefile b/tools/testing/selftests/cgroup/Makefile
>> index 745fe25fa0b9..01687418b92f 100644
>> --- a/tools/testing/selftests/cgroup/Makefile
>> +++ b/tools/testing/selftests/cgroup/Makefile
>> @@ -1,10 +1,11 @@
>>   # SPDX-License-Identifier: GPL-2.0
>>   CFLAGS += -Wall -pthread
>>   
>> -all:
>> +all: ${HELPER_PROGS}
>>   
>>   TEST_FILES     := with_stress.sh
>> -TEST_PROGS     := test_stress.sh
>> +TEST_PROGS     := test_stress.sh test_cpuset_prs.sh
>> +TEST_GEN_FILES := wait_inotify
> Please add wait_inotify to .gitignore file.
>
>>   TEST_GEN_PROGS = test_memcontrol
>>   TEST_GEN_PROGS += test_kmem
>>   TEST_GEN_PROGS += test_core

Right. Sorry for missing that. Will add it to the next version.

Thanks,
Longman

