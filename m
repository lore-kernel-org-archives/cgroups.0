From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v11 7/8] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Sun, 12 Jun 2022 23:02:38 -0400
Message-ID: <404171dc-0da3-21f2-5003-9718f875e967@redhat.com>
References: <20220510153413.400020-1-longman@redhat.com>
 <20220510153413.400020-8-longman@redhat.com>
 <YqYnQ4U4t6j/3UaL@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655089361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F58ZoXbX4GWpAIzK3fVF2XxLcUUEcOzj0SgrznA2bos=;
        b=hYZ0phYLBQeGWDqxD6LlwVWCI3pID3mtHXunmHaCXgoXE8hH+4BkR60rlTzLq3+w1JeLcR
        vp/M2E8JIAtD60igHCe5nJ6ezNYEbgnpHufxcgxnKKyoG//LFStMqc0W8eTKh7TKYUZKn9
        m5ywG3irqcw4zSBGD98hXmz7Qm+MNxw=
Content-Language: en-US
In-Reply-To: <YqYnQ4U4t6j/3UaL@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>

On 6/12/22 13:49, Tejun Heo wrote:
> Hello,
>
> On Tue, May 10, 2022 at 11:34:12AM -0400, Waiman Long wrote:
>> +	External events like hotplug or changes to "cpuset.cpus" can
>> +	cause a valid partition root to become invalid and vice versa.
>> +	Note that a task cannot be moved to a cgroup with empty
>> +	"cpuset.cpus.effective".
>> +
>> +	For a valid partition root or an invalid partition root with
>> +	the exclusivity rule enabled, changes made to "cpuset.cpus"
>> +	that violate the exclusivity rule will not be allowed.
> My memory is failing but this is the same thing that we were discussing
> before, right? The point was that the different behaviors re. system events
> and config actions seemed unncessary and IIRC Michal was of the same opinion
> (please correct me if I'm misremembering).

That is the behavior enforced by setting the CPU_EXCLUSIVE bit in cgroup 
v1. I haven't explicitly change it to make it different in cgroup v2. 
The major reason is that I don't want change to one cpuset to affect a 
sibling partition as it may make the code more complicate to validate if 
a partition is valid.

>
>> +	A valid non-root parent partition may distribute out all its CPUs
>> +	to its child partitions when there is no task associated with it.
> I'm probably forgetting something. Was this necessary because of threaded
> cgroup support because otherwise the above condition is superflous?

The top cpuset cannot have empty cpus.effective whereas the non-root 
partition roots can. Maybe I should reword it to make it more clear.

Thanks,
Longman

