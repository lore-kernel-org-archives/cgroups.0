Received: from mta1.migadu.com (out-150.mta1.migadu.com [95.215.58.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8488C38A71F
	for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 09:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787908912; cv=none; b=qjATtnlNvxU1MDIDd0As/ZNGpFujZBithXNxztYPBc8I1/fk6QcxzkdZRr6z6VMGd05xKd28TwB36Dr4W95J8eyj36LLKjGb50N6alhSN1S3IccVA/N4LJbxjApSQVz34ZrYv2TNcJc5LR521f4okkjjew7QR2uUivG+KY0pg7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787908912; c=relaxed/simple;
	bh=FLizrfmXKW0B2Vn5qj26jcrkvqp42BEh+s/jgYC0SXo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o+igRGgJ1Fs2PLRJDmMORhPv1/o2FmzCfU4+pKN4KiX1omq10zOH0aWWhDgDxV3o/IEPA7zjtT/noJq733YPA80Gt1XnxvsjWpnbUQS3EmwJsm41Fon/BciBP5EM1Do/eRXMbvC+vj2r03zVVfiZ+XV8+8RYJSf7icDzGfQCf3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ExAXqi60; arc=none smtp.client-ip=95.215.58.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ExAXqi60"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=FLizrfmXKW0B2Vn5qj26jcrkvqp42BEh+s/jgYC0SXo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787908908; v=1; x=1788513708;
 b=ExAXqi60ls9j32y/PgcTn3lQkxTKJy9wvpm9wm9D8PoNDEM5TR5OCu+dLchR6HCx2N7ZDbdX
 YGm68q0KrUj6XrIDkk6H4T+z9gEXua7OsqzDzAgZLi9XHR543nliILwK7l2d5QkjIf9Ys4lkLR4
 E/c5QGwtbQCOZmyIdnLryvdU=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b61188d0205eae6d;
	Fri, 28 Aug 2026 09:21:48 +0000
X-Mizu-Trace-ID: b61188d0205eae6d
X-Migadu-Flow: FLOW_OUT
Message-ID: <dc5ce72e-b835-4ae2-b4c9-e96dc6d48eba@linux.dev>
Date: Fri, 28 Aug 2026 17:21:40 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] general protection fault in cpuset_cpus_allowed
To: Farhad Alemi <farhad.alemi@berkeley.edu>, Waiman Long
 <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
Cc: falemi@asu.edu, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CA+0ovChh3VjsKN1g+ZGjwwY2fGTpP7uD+aCCByLj5Qbymw=bfQ@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CA+0ovChh3VjsKN1g+ZGjwwY2fGTpP7uD+aCCByLj5Qbymw=bfQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/28/2026 1:43 PM, Farhad Alemi wrote:
> Hello,
> 
> As part of the kernel research at ASU's SEFCOM
> lab, we hit the crash below. Crash reports can be found here:
> 
>    https://github.com/farhad-alemi/public_bug_reports/tree/main/166-general-protection-fault-in-cpuset-cpus-allowed/
> 
>    Oops: general protection fault, probably for non-canonical address
> 0xdffffc000000001d: 0000 [#1] SMP KASAN NOPTI
>    KASAN: null-ptr-deref in range [0x00000000000000e8-0x00000000000000ef]
>    RIP: 0010:bitmap_intersects include/linux/bitmap.h:440 [inline]
>    RIP: 0010:cpumask_intersects include/linux/cpumask.h:822 [inline]
>    RIP: 0010:guarantee_active_cpus kernel/cgroup/cpuset.c:481 [inline]
>    RIP: 0010:__cpuset_cpus_allowed_locked kernel/cgroup/cpuset.c:4022 [inline]
>    RIP: 0010:cpuset_cpus_allowed+0x14a/0x2f0 kernel/cgroup/cpuset.c:4071
>    Call Trace:
>     cpuset_cpus_allowed+0x14a/0x2f0 kernel/cgroup/cpuset.c:4071
>     __sched_setaffinity+0x98/0x3c0 kernel/sched/syscalls.c:1149
>     sched_setaffinity+0x341/0x4a0 kernel/sched/syscalls.c:1237
>     __x64_sys_sched_setaffinity+0x106/0x170 kernel/sched/syscalls.c:1262
> 
> A second capture reaches the identical fault -- same address, same KASAN range,
> same RIP -- through cpuset_fork <- cgroup_post_fork <- copy_process <-
> kernel_clone <- clone3, with the crashing task being systemd at PID 1.
> 
> Our reproducer.c is available upon request.
> 

Thank you for the report.

Could you please share the reproducer.c with us?

> Happy to test a patch if that would help.
> 
> Regards,

-- 
Best regards
Ridong

