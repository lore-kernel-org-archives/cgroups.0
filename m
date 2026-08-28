Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB905385D7F
	for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 18:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787940449; cv=none; b=rZRW1oIupksxvJkLvm6pU/mwGyXRcdG8k1GeJ3RtlQaC+sLDZQPgb4brtcwx94IHX47g5Ntfru+8uBYtikpv06wZVWpgXT5vHBghcB2OSJ1lEMR8pvx5SXWgFlrQUVaUychDfEKs7sFPA02Kdyv/7Ic+gTo+tKmCa6yZQi2vfS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787940449; c=relaxed/simple;
	bh=9HiXlTee72FyXhDR3nUVcDMyKk0jF2knT9Os/RF0oVs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HfrrMOl1pNTqWa/vkmjH/qWlZYbHWIFe76O6SyXWO9YOODrq0v67M2VE0exPjDfOSBC6ysXZzztFRCx3kz7Sq2UTIBil42TezDsaYh9Dh5FK8XnyyP8/86llsQIM7YFYRK8cgppMexanpe0ocVbzOSbc1N7ioKJuKEnGmrxfXTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HfK+iasS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HfK+iasS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787940447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NBSZO4UmDJ5N7PlSi5cLifO7pUPh7GKBSxlIMFNI3Fw=;
	b=HfK+iasSWy288gezjMj9j1qlw/pbuxtmyG1X8MWRbWCB+vqBetcszXHQTmxfdjfQB+HJ2d
	Q9KWQwBFbMID/fJesOfjKaK/gJ9GU14xkVqx+8ASnn4+1+oilHnb0FeHK3gQRSjQuXXb2C
	SG3f0sDJ8fqTjIPXPlpjc6wkkbwwk/s=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-368-JlCOODbRPDSJEJNHnh1r8Q-1; Fri,
 28 Aug 2026 14:07:24 -0400
X-MC-Unique: JlCOODbRPDSJEJNHnh1r8Q-1
X-Mimecast-MFC-AGG-ID: JlCOODbRPDSJEJNHnh1r8Q_1787940443
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 43C6A1954128;
	Fri, 28 Aug 2026 18:07:23 +0000 (UTC)
Received: from [100.91.18.181] (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EF49518005B4;
	Fri, 28 Aug 2026 18:07:21 +0000 (UTC)
Message-ID: <e27ad187-7572-4999-b171-f510990d4006@redhat.com>
Date: Fri, 28 Aug 2026 14:07:21 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] general protection fault in cpuset_cpus_allowed
To: Farhad Alemi <farhad.alemi@berkeley.edu>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
Cc: falemi@asu.edu, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CA+0ovChh3VjsKN1g+ZGjwwY2fGTpP7uD+aCCByLj5Qbymw=bfQ@mail.gmail.com>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <CA+0ovChh3VjsKN1g+ZGjwwY2fGTpP7uD+aCCByLj5Qbymw=bfQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On 8/28/26 1:43 AM, Farhad Alemi wrote:
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
> Happy to test a patch if that would help.

This null pointer dereference should only happen if you are racing 
sched_setaffinity() with cpu hotplug operation. Right?

Anyway, I have sent out a patch to hopefully address this bug. Could you 
try out the patch to see if it fixes the problem?

Thanks,
Longman

