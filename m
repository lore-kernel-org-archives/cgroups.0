From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v11 0/8] cgroup/cpuset: cpu partition code enhancements
Date: Fri, 20 May 2022 12:46:52 -0400
Message-ID: <75d31caf-2d26-9fcc-13fb-e8be2f2ad8e5@redhat.com>
References: <20220510153413.400020-1-longman@redhat.com>
 <Yoe7FOkZpUwwTTQW@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653065218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ojbIKgxOqxnHAzNXDbRdq8vthjOu4oruqFZ3uDQUp9g=;
        b=bd6BnebELhQpRnejDmUjRhKVg+DYcDGmhN7ZXazytbUslFm0egTO0TFWk+UTx+ehEb8blU
        wDQ6Sws4oTAnpANk0gqwb+/jD0IXthItYR6N5r5FAJ1Xy7HO37eZjuW+a6TCCe/1g2XOk3
        gF/hNdndywYKurFqO0YtCQQjncFVS7A=
Content-Language: en-US
In-Reply-To: <Yoe7FOkZpUwwTTQW@linutronix.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>

On 5/20/22 12:00, Sebastian Andrzej Siewior wrote:
> On 2022-05-10 11:34:05 [-0400], Waiman Long wrote:
>> v11:
>>   - Fix incorrect spacing in patch 7 and include documentation suggestions
>>     by Michal.
>>   - Move partition_is_populated() check to the last one in list of
>>     conditions to be checked.
> If I follow this correctly, then this is the latest version of the
> isolcpus= replacement with cgroup's cpusets, correct?
>
> Sebastian

It is just the beginning, there is still a lot of work to do before 
isolcpus= can be completely replaced.

Cheers,
Longman

