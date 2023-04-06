From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 1/3] cgroup/cpuset: Make cpuset_fork() handle
 CLONE_INTO_CGROUP properly
Date: Thu, 6 Apr 2023 10:08:31 -0400
Message-ID: <a115f40d-057e-a4a9-474f-fb3dcf04edee@redhat.com>
References: <20230331145045.2251683-1-longman@redhat.com>
 <20230331145045.2251683-2-longman@redhat.com>
 <20230406-vernommen-kurieren-e75f4ee6ea96@brauner>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680790115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KANTDl9cP5Foo4kRIPvE9J1MD539S2x+RsUY14Y5myk=;
        b=GL7D/8C42kG2g7grhmGLPqp0XAvYTq2LLJrAYN6YOUC6DaswCRPKMhvCLIGd0vd+P3kRdZ
        q3NkZN8Ni27tQSIlPgnaLPIg0CzpydtEAOeUmoKRANBeESZTgHSkrWnYvAb2BAERmFqnfQ
        QsZlyIwyo0+Ve5BqnEDfjzYAg2NFmM0=
Content-Language: en-US
In-Reply-To: <20230406-vernommen-kurieren-e75f4ee6ea96@brauner>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christian Brauner <brauner@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, gscrivan@redhat.com

On 4/6/23 05:45, Christian Brauner wrote:
> On Fri, Mar 31, 2023 at 10:50:43AM -0400, Waiman Long wrote:
>> By default, the clone(2) syscall spawn a child process into the same
>> cgroup as its parent. With the use of the CLONE_INTO_CGROUP flag
>> introduced by commit ef2c41cf38a7 ("clone3: allow spawning processes
>> into cgroups"), the child will be spawned into a different cgroup which
>> is somewhat similar to writing the child's tid into "cgroup.threads".
>>
>> The current cpuset_fork() method does not properly handle the
>> CLONE_INTO_CGROUP case where the cpuset of the child may be different
>> from that of its parent.  Update the cpuset_fork() method to treat the
>> CLONE_INTO_CGROUP case similar to cpuset_attach().
>>
>> Since the newly cloned task has not been running yet, its actual
>> memory usage isn't known. So it is not necessary to make change to mm
>> in cpuset_fork().
>>
>> Fixes: ef2c41cf38a7 ("clone3: allow spawning processes into cgroups")
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
> Just two nits. I think this needs a Cc stable and it would be nice if
> you could give Giuseppe a "Reported-by".

The presence of a fixes tag should make this patch picked up by stable. 
Yes, I will cc stable when I need to update the patch next time.

Right, I should have added

Reported-by: Giuseppe Scrivano <gscrivan@redhat.com>

Cheers,
Longman

