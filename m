Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AE02701B6
	for <cgroups@vger.kernel.org>; Sun, 27 Sep 2026 01:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790473526; cv=none; b=Qo68VedgVdc8zlZ5OC7eoeDKAK5T0F9d7pzjtKPwhDD8VeVUptfmj6DI/37pQagHHdGHYN2FUMq0oUbb80x+guJr1je7dL8dEPHQWtWtWecCa0UElEVFoMgpjhzOCN3xH1BR3gBwVc6P6NuVW0YRQAnZqRfRaMUnqamwwW0lTKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790473526; c=relaxed/simple;
	bh=ZmshJRVNGhiDD241iabHMvHEahKSg7LVi7ZdIgOie5M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CqpLHwAFrHkIkvMdHdHXvvRPHRe1W5/A0y2K1WpYvDou3FGnMgJKGeth4vq7cTf/Gl6GF4ZUJKKa+z4vIUHlNQ7q0uVJAAL+gPWOFxUqP6lYbr0ibbDABWn32hFNS50VTkeukiMIM2810jl3cSDx3RINeTIuV8YcuWaQyUOskGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cabk/nVq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cabk/nVq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790473523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XUoH5rgAH1n+by9vaKnGPJrkH26uAPsRf2XvFcpnSDw=;
	b=Cabk/nVqsN/+tLGG77U2gAqJ4y0OujBIdsdodMyXDE0lrC5dtZy/7zWiInicLXHZs0Z2a7
	6Wtbdq5DQpCM/I8yuZpPbCPxbF3b5yW6v5Mbo6n3E3Mrm4EWU7J5pkXbIezbi3knyiyUR1
	tHeFcwH/alKKteYI3522jKaPRbuucHA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-277-tMlZC61VNVufI_UeeYlH9w-1; Sat,
 26 Sep 2026 21:45:16 -0400
X-MC-Unique: tMlZC61VNVufI_UeeYlH9w-1
X-Mimecast-MFC-AGG-ID: tMlZC61VNVufI_UeeYlH9w_1790473515
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7A1CD1955F7A;
	Sun, 27 Sep 2026 01:45:14 +0000 (UTC)
Received: from [100.91.18.181] (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D528C180034F;
	Sun, 27 Sep 2026 01:45:11 +0000 (UTC)
Message-ID: <b5926447-1b52-4a8b-86d8-8adf40ca5f3f@redhat.com>
Date: Sat, 26 Sep 2026 21:45:10 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] cgroup/cpuset: prevent activating local partition
 over remote one
To: Hui Peng <benquike@gmail.com>, Ridong Chen <ridong.chen@linux.dev>,
 Guopeng Zhang <guopeng.zhang@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
Cc: Shuah Khan <shuah@kernel.org>, Chen Ridong <chenridong@huawei.com>,
 cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260924042729.1908863-1-benquike@gmail.com>
 <20260924042729.1908863-3-benquike@gmail.com>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260924042729.1908863-3-benquike@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On 9/24/26 12:27 AM, Hui Peng wrote:
> Commit 6da580ec656a ("cgroup/cpuset: Don't allow creation of local
> partition over a remote one") added a check in update_prstate() to reject
> creating a top-level local partition whose cs->exclusive_cpus intersects
> subpartitions_cpus.
>
> However, if a top-level cgroup A1 has a child A1/A2 enabled as a remote
> partition on a subset of its exclusive CPUs (X2-3 on A1, CX2-3:P2 on
> A1/A2), and A1 is then set to "root" (P1, becoming "root invalid" via
> update_prstate() because its exclusive CPUs intersect subpartitions_cpus)
> followed by expanding its CPUs to include additional non-remote CPUs
> (CX1-3), update_cpumask() / update_exclusive_cpumask() calls
> validate_partition() without going through update_prstate(). Because
> validate_partition() does not check trialcs->exclusive_cpus against
> subpartitions_cpus, A1 transitions from "root invalid" to a valid local
> partition over the existing remote partition A1/A2 and triggers:
>
>    WARNING: kernel/cgroup/cpuset.c:1943 at update_parent_effective_cpumask+0x189b/0x1fd0
>
> Check trialcs->exclusive_cpus against subpartitions_cpus in
> validate_partition() when !is_partition_valid(cs), and add a regression
> test case to tools/testing/selftests/cgroup/test_cpuset_prs.sh.
>
> Tested in QEMU on Linux 7.3.0-rc3 using
> tools/testing/selftests/cgroup/test_cpuset_prs.sh.
>
> Fixes: 6da580ec656a ("cgroup/cpuset: Don't allow creation of local partition over a remote one")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Hui Peng <benquike@gmail.com>
> ---
>   kernel/cgroup/cpuset.c                            | 4 ++++
>   tools/testing/selftests/cgroup/test_cpuset_prs.sh | 2 ++
>   2 files changed, 6 insertions(+)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 7381fa8502e7..7c5b4a8f1f3a 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2415,6 +2415,10 @@ static enum prs_errcode validate_partition(struct cpuset *cs, struct cpuset *tri
>   	if (cpumask_empty(trialcs->effective_xcpus))
>   		return PERR_INVCPUS;
>   
> +	if ((parent == &top_cpuset) && !is_partition_valid(cs) &&
> +	    cpumask_intersects(trialcs->exclusive_cpus, subpartitions_cpus))
> +		return PERR_REMOTE;
> +
>   	if (prstate_housekeeping_conflict(trialcs->partition_root_state,
>   					  trialcs->effective_xcpus))
>   		return PERR_HKEEPING;
The code change looks good to me.
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index b732078bf319..4a451350ad84 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -321,6 +321,8 @@ TEST_MATRIX=(
>   	" C1-3:P2  X4:P2    .      .      .    X3:P2    .      .     0 A1:1-2|XA1:1-3|A2:3:XA2:3 A1:P2|A2:P2 1-3"
>   	" C0-3:P2    .      .    C4-6   C0-4     .      .      .     0 A1:0-4|B1:5-6 A1:P2|B1:P0"
>   	" C0-3:P2    .      .    C4-6 C0-4:C0-3  .      .      .     0 A1:0-3|B1:4-6 A1:P2|B1:P0 0-3"
> +	"   X2-3  CX2-3:P2  .      .  P1:CX1-3   .      .      .     0 A1:1|A2:2-3|XA2:2-3 \
> +								       A1:P-1|A2:P2 2-3"
>   

This test case is problematic as it fails on my test system because of a 
bug in the SCHED_DEADLINE task shrink test in validate_change() that can 
be triggered if there are deadline tasks in the system which will fail 
the test. I am going to post a patch to fix that bug. Can you take out 
this test case from this patch as I don't want this test to be 
backported to stable releases? You can send this out as a separate 
testing patch if you want to.

Cheers,
Longman

>   	# Local partition invalidation tests
>   	" C0-3:X1-3:P2 C1-3:X2-3:P2 C2-3:X3:P2 \

