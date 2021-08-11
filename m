From: Waiman Long <llong@redhat.com>
Subject: Re: [PATCH v4 4/6] cgroup/cpuset: Allow non-top parent partition root
 to distribute out all CPUs
Date: Wed, 11 Aug 2021 14:18:17 -0400
Message-ID: <abfa6f2f-aa13-f18e-5a16-f568082d07bc@redhat.com>
References: <20210811030607.13824-1-longman@redhat.com>
 <20210811030607.13824-5-longman@redhat.com>
 <YRQTTf+bJZ8f3O3+@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628705901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4sdWMe6I8w2i60A4RZfVZLGm7Z1MFMDLriAO19Jv51I=;
        b=OWFDuSJEd6axoR49rdB1w7XTGmrTX1NxmOYalBKZzsEwukaD0xwLLmLPynGodZrpSDiPwU
        kid381Zk2qxgo4/pZO+atYXEEQh3V/c4qYZULqPOQL6mGENBSoB12BMvpO0n9oHKZEGg3d
        MbewhWHGQ1FgdUGSuBz1ZGNCV+fLXJ4=
In-Reply-To: <YRQTTf+bJZ8f3O3+@slm.duckdns.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>

On 8/11/21 2:13 PM, Tejun Heo wrote:
> On Tue, Aug 10, 2021 at 11:06:05PM -0400, Waiman Long wrote:
>> Currently, a parent partition root cannot distribute all its CPUs to
>> child partition roots with no CPUs left. However in some use cases,
>> a management application may want to create a parent partition root as
>> a management unit with no task associated with it and has all its CPUs
>> distributed to various child partition roots dynamically according to
>> their needs. Leaving a cpu in the parent partition root in such a case is
>> now a waste.
>>
>> To accommodate such use cases, a parent partition root can now have
>> all its CPUs distributed to its child partition roots as long as:
>>   1) it is not the top cpuset; and
>>   2) there is no task directly associated with the parent.
>>
>> Once an empty parent partition root is formed, no new task can be moved
>> into it.
> The above are already enforced by cgroup2 core, right? No intermediate
> cgroup with controllers enabled can have processes. From controllers' POV,
> only leaves can have processes.
>
I don't think that is true. A task can reside anywhere in the cgroup 
hierarchy. I have encountered no problem moving tasks around.

Cheers,
Longman

