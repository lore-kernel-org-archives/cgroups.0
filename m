Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793992226;
	b=nGr14YcPX5l9X1Nmp8PddSCqTx3SD9M6satZIl+SOPhWnsYLChZRNXZpF137T3ABmIj+
	 2slSdWNZcN/2TYEabZG61Dt06l1XHBsVrxGlFAi++qS+7b/ZmU4kqZeNZbvwgLIu0WXyx
	 voTOcutTTszZlUrrwT9ciSnsqfjHSpDADkwNuVwjcD8RtEnYNLFQCCf1cUA+UQHY7WT53
	 Pw+4eDAMZubRliCKPA/xvpExAn0MydTZPZzo8o+ERlT9/RlR3SSdn4+QA6Lo+f4Ey1VJk
	 ABcw8fNl/LrFR66zAhflhE289GSVFzSJcf8lxWPQZxK8eO7SATkLJ9m9D7mlUWUKQsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793992226;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=TibEcO9CNVSZ8+bVlmwBX3YZ8Clr0IvZkR0Oo11qWYo=;
	b=xdtIVd83tEOykUKmc7DAFQxlKgkRYohhANsSexrKrCrwvCJ/W6GTPXAzHdjqSpSQB44C
	 7EE2cq9erR2gIz4wF3lPTMHkSaZtUWZxXdYB47yOiAufUVuFvjppiJ7+ydrWBarJ3NK8E
	 dm3Qso76HHWXYaTXY+xIey9ZMcGevjU6ZlByu1X7/4miP8jybkEoFSfsDeh279VjsiSST
	 i4czFZrwoBL7ulvLY/S21G+q96SIll6pKOpXZoCG53biA4p5y4J0SoEkowztIon6hdXZV
	 y6UMfYFBVyxfozEhYh53/NkfvV1+2vnoH5Vir8tkevJE9gaUwPjEa/RrLZ8IlwAmZgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=eNDe0Xm0;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978FD606A326
	for <cgroups@vger.kernel.org>; Fri,  6 Nov 2026 19:10:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 978FD606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=eNDe0Xm0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793992224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TibEcO9CNVSZ8+bVlmwBX3YZ8Clr0IvZkR0Oo11qWYo=;
	b=eNDe0Xm0FnjLTQv3VytifUqLpCDe5JrG9oFKRCACZBksnvnTlzH8YGa9H1LyntpNnqicBs
	trHfPlNYoYkEmr3X42OEv3Hxbl08Rv8onM5DQvw7kDEIrQunGttRSsDkSnTzndHX1L6HVw
	GX72MkOpmIHLLtOGkDHovnxr3ulT69o=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-499-DvM7aMjlMhGrBWybGLF7_w-1; Fri,
 06 Nov 2026 14:10:21 -0500
X-MC-Unique: DvM7aMjlMhGrBWybGLF7_w-1
X-Mimecast-MFC-AGG-ID: DvM7aMjlMhGrBWybGLF7_w_1793992219
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7CC371956060;
	Fri,  6 Nov 2026 19:10:18 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1BCED1848D42;
	Fri,  6 Nov 2026 19:10:15 +0000 (UTC)
Message-ID: <fa9fa51a-6db3-4c2b-be06-6ba423108890@redhat.com>
Date: Fri, 6 Nov 2026 14:10:15 -0500
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
Subject: Re: [PATCH v2 1/4] cgroup/cpuset: Reset partition data when an
 invalid partition stays invalid
To: Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: Chen Ridong <chenridong@huawei.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Sashiko <sashiko-bot@kernel.org>, Guopeng Zhang <zhangguopeng@kylinos.cn>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261106105538.2915492-1-ridong.chen@linux.dev>
 <20261106105538.2915492-2-ridong.chen@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20261106105538.2915492-2-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On 11/6/26 5:55 AM, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
>
> When cpuset.cpus or cpuset.cpus.exclusive of a partition root is
> changed, update_cpumask() and update_exclusive_cpumask() copy the new
> effective_xcpus computed for the trial cpuset into the cpuset, and call
> reset_partition_data() only if the partition was valid before and is
> invalid now:
>
> 	if ((old_prs > 0) && !is_partition_valid(cs))
> 		reset_partition_data(cs);
>
> An invalid partition root (old_prs < 0) that stays invalid is not
> covered. Its effective_xcpus is then left with the trial value, which
> is computed from user_xcpus() and so falls back to cpuset.cpus when
> cpuset.cpus.exclusive is cleared. As an invalid partition root does not
> own any exclusive CPUs, and rm_siblings_excl_cpus() treats a non-empty
> effective_xcpus of a sibling without cpuset.cpus.exclusive as owned,
> those CPUs can then no longer be claimed by a sibling:
>
>    # A1: cpuset.cpus=2-3, cpuset.cpus.exclusive=2-3, root, with tasks
>    # offline CPUs 2-3 -> A1 becomes invalid
>    echo > A1/cpuset.cpus.exclusive
>    cat A1/cpuset.cpus.exclusive.effective    # 2-3, expected empty
>    echo 3 > B1/cpuset.cpus.exclusive         # -EINVAL
>
> Reset the partition data whenever the cpuset is a partition root, valid
> or not, and ends up invalid. As effective_xcpus may be cleared by that,
> also force update_cpumasks_hier() to update the subtree, so that the
> effective_xcpus of the descendants doesn't keep the released CPUs. Add
> test cases for it.
>
> Fixes: de9f15e21c55 ("cpuset: use parse_cpulist for setting cpus.exclusive")
> Fixes: c5866c9a007d ("cpuset: refactor CPU mask buffer parsing logic")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/patchset/20261101114206.2434398-1-ridong.chen%40linux.dev?part=15
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>   kernel/cgroup/cpuset.c                            | 10 ++++++++--
>   tools/testing/selftests/cgroup/test_cpuset_prs.sh |  6 ++++++
>   2 files changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 3052413e41e7..cf38e8708ddd 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2607,8 +2607,11 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
>   	spin_lock_irq(&callback_lock);
>   	cpumask_copy(cs->cpus_allowed, trialcs->cpus_allowed);
>   	cpumask_copy(cs->effective_xcpus, trialcs->effective_xcpus);
> -	if ((old_prs > 0) && !is_partition_valid(cs))
> +	if (old_prs && !is_partition_valid(cs)) {
>   		reset_partition_data(cs);
> +		/* effective_xcpus may be cleared, update the subtree too */
> +		force = true;
> +	}
>   	spin_unlock_irq(&callback_lock);
>   
>   	/* effective_cpus/effective_xcpus will be updated here */
> @@ -2672,8 +2675,11 @@ static int update_exclusive_cpumask(struct cpuset *cs, struct cpuset *trialcs,
>   	spin_lock_irq(&callback_lock);
>   	cpumask_copy(cs->exclusive_cpus, trialcs->exclusive_cpus);
>   	cpumask_copy(cs->effective_xcpus, trialcs->effective_xcpus);
> -	if ((old_prs > 0) && !is_partition_valid(cs))
> +	if (old_prs && !is_partition_valid(cs)) {
>   		reset_partition_data(cs);
> +		/* effective_xcpus may be cleared, update the subtree too */
> +		force = true;
> +	}
>   	spin_unlock_irq(&callback_lock);
>   
>   	/*
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index bdca6c471f87..32e1e44fa0b1 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -434,6 +434,12 @@ TEST_MATRIX=(
>   	# cpuset.cpus is allowed, but those extra CPUs are ignored.
>   	"  C2-3:P1   C3:P1  .      .      .     C2-4    .      .     0 A1:|A2:2-3 A1:P1|A2:P1"
>   
> +	# Clearing cpuset.cpus.exclusive of an invalid partition releases its
> +	# exclusive CPUs, including those of its descendants, so a sibling
> +	# can claim them.
> +	" CX2-3:P1    .     .     C3  T:O2=0:O3=0:X  .     .      X3   0 XA1:|XB1:3 A1:P-1"
> +	" CX2-3:P1   X3     .     C3  T:O2=0:O3=0:X  .     .      X3   0 XA1:|XA2:|XB1:3 A1:P-1"
> +
>   	# A child cannot recover until its exclusive CPUs are available again.
>   	" CX1-4:P1 CX3-4:P1 .     .     X1-2     .      .      .     0 A1:1-2|A2:1-2|XA2: A1:P1|A2:P-1"
>   	" CX1-4:P1 CX3-4:P1 .     .  X1-2:X1-4   .      .      .     0 A1:1-2|A2:3-4|XA2:3-4 A1:P1|A2:P1"

LGTM

Reviewed-by: Waiman Long <longman@redhat.com>

