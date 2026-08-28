Received: from mta0.migadu.com (out-95.mta0.migadu.com [91.218.175.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072BE3C0A0E
	for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 09:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787910899; cv=none; b=CxdOB5Er81YYfq+CMSzrXhlcwZkHvwREw90eQtc+2NEWoKU2L7PvgQ96x1aLFEo5FYWgf+kHnrsQQNS09cHaKMZUycuLf9uK+R+CTZWaCbxYVCkGkpQHRYIQLmNvy5XejZ/tEAc9ncuU99v4mzuswNa+/fvo9QayneollXvfKDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787910899; c=relaxed/simple;
	bh=S0lneGYxL9DzHlwKdCqeTtc3/fuRv5G/Wt35yLQ2za4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=SB5BH/z2hkc9eqPy5kwLP1Rn3N9v0IotHLeK9oq2fIcaosVaHe8V568672Y3NOmDlcdp9uHOt1ksjQ3VVGMW2LTLJfAL6NWyoQ39UkzzVp5xhQ96UWrnaXjoV6pn2QTdTWL6uozJJw3OcC8hEcW/+ObYPMMzj4gDE2p7xww61SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=B/bXEKpF; arc=none smtp.client-ip=91.218.175.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="B/bXEKpF"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=S0lneGYxL9DzHlwKdCqeTtc3/fuRv5G/Wt35yLQ2za4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787910894; v=1; x=1788515694;
 b=B/bXEKpFTQn5CGkUdAL3HA0tIqle3C2vvi7UAQ6wq8yrQg7jUTCZEEHkyp9wOVvu2cwm1Goi
 vYJYZ21SpZ5k0voJ9oE3y2+sMrAHqGBpc5MFnd+QtazaZFA7hqLYuhFdAN8IJ5b7QFcV6EpEx9b
 z/DeXbtm8DdP17v2b/vHVD4s=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e5c841af57486d4b;
	Fri, 28 Aug 2026 09:54:54 +0000
X-Mizu-Trace-ID: e5c841af57486d4b
X-Migadu-Flow: FLOW_OUT
Message-ID: <15c4ce09-ae6f-477e-a400-6b61fe81b477@linux.dev>
Date: Fri, 28 Aug 2026 17:54:46 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] general protection fault in cpuset_cpus_allowed
From: Ridong Chen <ridong.chen@linux.dev>
To: Farhad Alemi <farhad.alemi@berkeley.edu>, Waiman Long
 <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
Cc: falemi@asu.edu, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CA+0ovChh3VjsKN1g+ZGjwwY2fGTpP7uD+aCCByLj5Qbymw=bfQ@mail.gmail.com>
 <dc5ce72e-b835-4ae2-b4c9-e96dc6d48eba@linux.dev>
In-Reply-To: <dc5ce72e-b835-4ae2-b4c9-e96dc6d48eba@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 8/28/2026 5:21 PM, Ridong Chen wrote:
> 
> 
> On 8/28/2026 1:43 PM, Farhad Alemi wrote:
>> Hello,
>>
>> As part of the kernel research at ASU's SEFCOM
>> lab, we hit the crash below. Crash reports can be found here:
>>
>>    https://github.com/farhad-alemi/public_bug_reports/tree/main/166-general- 
>> protection-fault-in-cpuset-cpus-allowed/
>>
>>    Oops: general protection fault, probably for non-canonical address
>> 0xdffffc000000001d: 0000 [#1] SMP KASAN NOPTI
>>    KASAN: null-ptr-deref in range [0x00000000000000e8-0x00000000000000ef]
>>    RIP: 0010:bitmap_intersects include/linux/bitmap.h:440 [inline]
>>    RIP: 0010:cpumask_intersects include/linux/cpumask.h:822 [inline]
>>    RIP: 0010:guarantee_active_cpus kernel/cgroup/cpuset.c:481 [inline]
>>    RIP: 0010:__cpuset_cpus_allowed_locked kernel/cgroup/cpuset.c:4022 [inline]
>>    RIP: 0010:cpuset_cpus_allowed+0x14a/0x2f0 kernel/cgroup/cpuset.c:4071
>>    Call Trace:
>>     cpuset_cpus_allowed+0x14a/0x2f0 kernel/cgroup/cpuset.c:4071
>>     __sched_setaffinity+0x98/0x3c0 kernel/sched/syscalls.c:1149
>>     sched_setaffinity+0x341/0x4a0 kernel/sched/syscalls.c:1237
>>     __x64_sys_sched_setaffinity+0x106/0x170 kernel/sched/syscalls.c:1262
>>
>> A second capture reaches the identical fault -- same address, same KASAN range,
>> same RIP -- through cpuset_fork <- cgroup_post_fork <- copy_process <-
>> kernel_clone <- clone3, with the crashing task being systemd at PID 1.
>>
>> Our reproducer.c is available upon request.
>>
> 
> Thank you for the report.
> 
> Could you please share the reproducer.c with us?
> 

I suspect this might be caused by cs becoming NULL when cs = parent_cs(top_cpuset).

Having the reproducer would help me debug how this situation could occur.

```
static void guarantee_active_cpus(struct task_struct *tsk,
				  struct cpumask *pmask)
{
...
             while (!cpumask_intersects(cs->effective_cpus, pmask))
                     cs = parent_cs(cs);
...
}
```

>> Happy to test a patch if that would help.
>>
>> Regards,
> 

-- 
Best regards
Ridong

