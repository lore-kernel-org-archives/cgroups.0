Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591219;
	b=ofg6s40OepyiKMkhri9auu+jT1fX4RJCBVjcG/lMrONeREH7AwPJ0m/3Wqs6ULkBGr/a
	 G6SSRrbmk7/5/oOcykfimBjR2FeqIBY9liEq5Ifc1M5xWz7nezJDYf7u1AVh5S7VhpTCT
	 KBOmTbImeBwVbvXYrzgwJh448/EVYWDMlwzdIdGAUGkUrrmxqZ6r+R5HFgd8GDMkrUc1U
	 HEKSd/XcrfzTJ2y63CgCd4zx9/KTCKo+32gOY4hQxGAmeXpevLKQkYGH3zVtD7sJT4rZu
	 3lu0+j2HOLAatFppUW427r4T2IzPd61q6JHJwlPmDxtUi9vmZ0EtdadU+0zfqRQB86A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591219;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=b8xUdlTrVJr8iWSKlRDFOvStv40KWS4yRp1fHWJ2LrY=;
	b=VMLUUkPZFFgLzy3PUAJVRNUtWEfLMCzqQoYNqynXjVTMqhcCmDyglUoRtexd6NuPIQh3
	 EN3+Cf53WEXMOYRQKFsC99K+4nrRZQhf+bFKUZeSO2UENZmmHwK7bQBkGbK3Nc4K79M81
	 NaMxAp80Sz7IC/PG7EGkJap1akA2aWh35o6c3HSQzssZn4ZWiLWYwsJoDgwfG2EYEMU1c
	 rxuNaYOK8QbX/zKkQOzCdKn3T3BdZGqLbxTMWqeoiCOTJ/xSHzYMRXUHde+N0UM1mth+t
	 49MEQ+jAKumSAeNALcT2SxJ0W8PIFw4kGKIEYd/dw7RKE5yctVGH5a96BSorgJQS8SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="jLXwe9m/";
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723F0607587E
	for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 17:33:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 723F0607587E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=jLXwe9m/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794591217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b8xUdlTrVJr8iWSKlRDFOvStv40KWS4yRp1fHWJ2LrY=;
	b=jLXwe9m/Pd8MtZ+ITAl16OPKVmein6Gct0O0rA4qCJWJ//aK41ISW4elF/I98af72LHM6Q
	DK9R61sH2pEJeBSdev6bHVffq3EqvEpmOJh9BPeobi+MO38HT4Nyu5Crfw9vUx4t6NwyDB
	7G84IV6UXx6OFU/PcbSJs/LQHGubBAA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-414-rMtnh44bMoyNRQ_zKEvztQ-1; Fri,
 13 Nov 2026 12:33:32 -0500
X-MC-Unique: rMtnh44bMoyNRQ_zKEvztQ-1
X-Mimecast-MFC-AGG-ID: rMtnh44bMoyNRQ_zKEvztQ_1794591209
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1FCCD1800349;
	Fri, 13 Nov 2026 17:33:28 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DCCCE1800559;
	Fri, 13 Nov 2026 17:33:22 +0000 (UTC)
Message-ID: <638e3138-1dfe-42a0-97bf-2acb32970fa3@redhat.com>
Date: Fri, 13 Nov 2026 12:33:21 -0500
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 18/29] sched/deadline: Move a task's bandwidth only
 where room was made
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: juri.lelli@redhat.com, peterz@infradead.org, mingo@redhat.com,
 vincent.guittot@linaro.org, linux-kernel@vger.kernel.org, tglx@kernel.org,
 will@kernel.org, boqun@kernel.org, dietmar.eggemann@arm.com,
 rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
 vschneid@redhat.com, kprateek.nayak@amd.com, luca.abeni@santannapisa.it,
 mathieu.poirier@linaro.org, ridong.chen@linux.dev, tj@kernel.org,
 hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
 bigeasy@linutronix.de, clrkwllms@kernel.org, parri.andrea@gmail.com,
 m.szyprowski@samsung.com, kayracizmeci@gmail.com, weihengqiuu@gmail.com,
 cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
 <20261108185406.1549770-19-mathieu.desnoyers@efficios.com>
 <bcb60245-abfb-4e3a-aa4e-f134ed310381@redhat.com>
 <20261113135110.160083-1-mathieu.desnoyers@efficios.com>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20261113135110.160083-1-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On 11/13/26 8:51 AM, Mathieu Desnoyers wrote:
> Hi Waiman,
>
> On 2026-11-12 23:37, Waiman Long wrote:
>> For cpuset v2, it is not possible for a cpuset to span two root domains.
>> I believe it is not possible for v1 too, though I am not 100% sure.
>> Please let me know if you are aware of a way to do that.
> It happens with isolcpus="domain". The CPUs it isolates stay in the
> effective CPUs of the top cpuset, and of any cpuset that is not a
> partition root. They are in the default root domain. The other CPUs
> are in another root domain.
>
> The message should have named isolcpus. The planned next version does.
Right, top_cpuset is the exception here. Boot isolated CPUs are not 
allowed in a root partition. They are only allowed in isolated 
partitions. So root partition other than the top one cannot span more 
than one root domain.
>
> This is on tip sched/urgent (v7.4-rc1 based), in a 5-CPU guest booted
> with isolcpus=domain,1,2. A is a plain cgroup v2 cpuset:
>
>    # cat /sys/devices/system/cpu/isolated
>    1-2
>    # echo 0-4 > A/cpuset.cpus
>    # cat A/cpuset.cpus.effective
>    0-4
>    # cat A/cpuset.cpus.partition
>    member
>
> Two tasks in A call sched_setattr(SCHED_DEADLINE). Task 95 is pinned to
> CPUs 0,3,4 and asks for 10%. Task 98 is pinned to CPUs 1,2 and asks for
> 20%. Both are admitted. /sys/kernel/debug/sched/debug gives total_bw of
> the root domain of each CPU. "Before" is the fair servers alone:
>
>    CPU     before    with the two tasks
>    0,3,4   157284    262141   (+10%)
>    1,2     104856    314571   (+20%)
>
> So the two tasks are in the same cpuset and are counted in two root
> domains. Then task 95 is given CPU 1 alone:
>
>    # taskset -p 2 95
>    taskset: can't set pid 95's affinity: Device or resource busy
>    # echo -1 > /proc/sys/kernel/sched_rt_runtime_us
>    # taskset -p 2 95
>    pid 95's new affinity mask: 2
>
> After that, total_bw is 157284 for CPUs 0,3,4 and still 314571 for
> CPUs 1,2. The 10% of task 95 is counted nowhere. That is the case the
> patch fixes.
>
> I did not test cgroup v1.
>
> The planned next version has a new cpuset patch for the same
> configuration. A deadline task in such a cpuset can also change root
> domain when its cpuset loses CPUs. The patch refuses that:
> - a write to cpuset.cpus fails with EBUSY if it leaves a deadline task
>    no CPU in the root domain that counts it;
> - cpuset makes a partition root invalid if it would do the same.

We already have pending cpuset patch that will disallow taking the last 
housekeeping CPU from the top_cpuset partition.  The partition will be 
disabled in that patch if users attempt to do so. So it is effectively 
changing the root domain to that of the parent cpuset.

As said above, a partition below the top_cpuset cannot span more than 
one root domain. Are you referring to the case that shrinking the cpuset 
CPU count to reduce the total DL bandwidth will fail with EBUSY when it 
is less than what the existing DL tasks require?

Thanks,
Longman
>
> My reply to Juri on patch 20 describes it with two related patches:
> https://lore.kernel.org/all/e21aaf40-b929-444c-b707-3200e21d7301@efficios.com/
>
> I would like your opinion on these two refusals before I post the
> patch.
>
> Thanks,
>
> Mathieu

