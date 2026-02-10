Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 749422C027A;
	Tue, 10 Feb 2026 07:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770709138; cv=none; b=eyOR0yz6wmjXhqLBtFm7o4Kdmc7vJ7FrDHx6xR44/mOJIa8PKgFT34Cms8bv/1ZuTQBQXIrhUfGPd/IwFoG2IuWu8maZJvbDrx71SA8VhRN3hFzdZOc5hIMy5QjYZRljEDA+zY8VeQEdOvOB35ka06Up1McLysn/Qmm7J9i3JZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770709138; c=relaxed/simple;
	bh=KAnkHeUW/rhbCgg0wxStZiTN11d44jYJ3LRA79jcEOs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j4hRqIOALwcXxsjWkXB22i74JWwQMQuQiysSSO7aIbcq5XHQfytctXOejpV7H6agGaeaNZzeK7rXnfxis48sEBQ3JqIOProE4QhxeumjkDIqUB6xGuB1zwMfPIq/u3V+mGQozru8dIfYaxyBYX49bcnSiPAC073fgethDFsrYz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3F2F9339;
	Mon,  9 Feb 2026 23:38:49 -0800 (PST)
Received: from [10.164.19.61] (unknown [10.164.19.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 46E0D3F740;
	Mon,  9 Feb 2026 23:38:52 -0800 (PST)
Message-ID: <b77dc11e-fe09-4f0c-a912-d05faa01ff1c@arm.com>
Date: Tue, 10 Feb 2026 13:08:49 +0530
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] memcg: use mod_node_page_state to update stats
To: Shakeel Butt <shakeel.butt@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Meta kernel team <kernel-team@meta.com>
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
 <20251110232008.1352063-2-shakeel.butt@linux.dev>
 <1052a452-9ba3-4da7-be47-7d27d27b3d1d@arm.com> <aYAmGc6lu973jRwu@linux.dev>
 <2638bd96-d8cc-4733-a4ce-efdf8f223183@arm.com>
 <51819ca5a15d8928caac720426cd1ce82e89b429@linux.dev>
 <05aec69b-8e73-49ac-aa89-47b371fb6269@arm.com> <aYOuCmjQ5lGm8Mup@linux.dev>
 <4847c300-c7bb-4259-867c-4bbf4d760576@arm.com> <aYQuj6Ot-JS4tXvY@hyeyoo>
 <7df681ae0f8254f09de0b8e258b909eaacafadf4@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <7df681ae0f8254f09de0b8e258b909eaacafadf4@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 05/02/26 11:28 am, Shakeel Butt wrote:
>> On Thu, Feb 05, 2026 at 10:50:06AM +0530, Dev Jain wrote:
>>
>>> On 05/02/26 2:08 am, Shakeel Butt wrote:
>>>  On Mon, Feb 02, 2026 at 02:23:54PM +0530, Dev Jain wrote:
>>>  On 02/02/26 10:24 am, Shakeel Butt wrote:
>>>  Hello Shakeel,
>>>
>>>  We are seeing a regression in micromm/munmap benchmark with this patch, on arm64 -
>>>  the benchmark mmmaps a lot of memory, memsets it, and measures the time taken
>>>  to munmap. Please see below if my understanding of this patch is correct.
>>>
>>>  Thanks for the report. Are you seeing regression in just the benchmark
>>>  or some real workload as well? Also how much regression are you seeing?
>>>  I have a kernel rebot regression report [1] for this patch as well which
>>>  says 2.6% regression and thus it was on the back-burner for now. I will
>>>  take look at this again soon.
>>>
>>>  The munmap regression is ~24%. Haven't observed a regression in any other
>>>  benchmark yet.
>>>  Please share the code/benchmark which shows such regression, also if you can
>>>  share the perf profile, that would be awesome.
>>>  https://gitlab.arm.com/tooling/fastpath/-/blob/main/containers/microbench/micromm.c
>>>  You can run this with
>>>  ./micromm 0 munmap 10
>>>
>>>  Don't have a perf profile, I measured the time taken by above command, with and
>>>  without the patch.
>>>
>>>  Hi Dev, can you please try the following patch?
>>>
>>>  From 40155feca7e7bc846800ab8449735bdb03164d6d Mon Sep 17 00:00:00 2001
>>>  From: Shakeel Butt <shakeel.butt@linux.dev>
>>>  Date: Wed, 4 Feb 2026 08:46:08 -0800
>>>  Subject: [PATCH] vmstat: use preempt disable instead of try_cmpxchg
>>>
>>>  Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
>>>  ---
>>>
>> [...snip...]
>>
>>> Thanks for looking into this.
>>>  
>>>  But this doesn't solve it :( preempt_disable() contains a compiler barrier,
>>>  probably that's why.
>>>
>> I think the reason why it doesn't solve the regression is because of how
>> arm64 implements this_cpu_add_8() and this_cpu_try_cmpxchg_8().
>>
>> On arm64, IIUC both this_cpu_try_cmpxchg_8() and this_cpu_add_8() are
>> implemented using LL/SC instructions or LSE atomics (if supported).
>>
>> See:
>> - this_cpu_add_8()
>>  -> __percpu_add_case_64
>>  (which is generated from PERCPU_OP)
>>
>> - this_cpu_try_cmpxchg_8()
>>  -> __cpu_fallback_try_cmpxchg(..., this_cpu_cmpxchg_8)
>>  -> this_cpu_cmpxchg_8()
>>  -> cmpxchg_relaxed()
>>  -> raw_cmpxchg_relaxed()
>>  -> arch_cmpxchg_relaxed()
>>  -> __cmpxchg_wrapper()
>>  -> __cmpxchg_case_64()
>>  -> __lse_ll_sc_body(_cmpxchg_case_64, ...)
>>
> Oh so it is arm64 specific issue. I tested on x86-64 machine and it solves
> the little regression it had before. So, on arm64 all this_cpu_ops i.e. without
> double underscore, uses LL/SC instructions. 
>
> Need more thought on this. 
>
>>> Also can you confirm whether my analysis of the regression was correct?
>>>  Because if it was, then this diff looks wrong - AFAIU preempt_disable()
>>>  won't stop an irq handler from interrupting the execution, so this
>>>  will introduce a bug for code paths running in irq context.
>>>
>> I was worried about the correctness too, but this_cpu_add() is safe
>> against IRQs and so the stat will be _eventually_ consistent?
>>
>> Ofc it's so confusing! Maybe I'm the one confused.
> Yeah there is no issue with proposed patch as it is making the function
> re-entrant safe.

Ah yes, this_cpu_add() does the addition in one shot without read-modify-write.

I am still puzzled whether the original patch was a bug fix or an optimization.
The patch description says that node stat updation uses irq unsafe interface.
Therefore, we had foo() calling __foo() nested with local_irq_save/restore. But
there were code paths which directly called __foo() - so, your patch fixes a bug right
(in which case we should have a Fixes tag)? The patch ensures that mod_node_page_state
is used, and depending on HAVE_CMPXCHG_LOCAL, either uses irq disabling or
preempt_disable + cmpxchg - making the interface irq safe.

