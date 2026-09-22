Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795D84B95B3
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 20:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790108516; cv=none; b=TPEIdKq+3uIKYdHMB+XU/8KEeCzhLfiQF9H1nBN5TdeNuF9dezepDZipxvjqqrm+K+utD1p/H6WXd+ULsB3e016cPVcvijT+p+AQXdS7tGdOB48l9cDn8BUD7WwVwEHxwn2Zv1Pg9vbGYo90KSkzgpuIRtPd3BH9ZxUcSM0VPNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790108516; c=relaxed/simple;
	bh=qf7Jhvlpto+YQaPLd8xjFzZPBrjOJul/qhE2Z1fkH1w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B2EF1HbOX+PslVndiN2LIGlBaKdlCwMO2tvVrK5tCIda7rTHNQINYQuZBEepvzfQ0Mly2In0vhMG45bt1WKZwlDsaFcfmFVHzXZKdaqL7hZN4iT8cF79VBQsS5jzqOHn9PaDcECvq25UufYCHNBzJz8GgOT5/DtQul4GVDjg++I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dq/814UV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dq/814UV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790108499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lmFVZilOMn/yRZfsmK1Eg1J9bzLw2lur3L0aHYwLcTo=;
	b=Dq/814UVcbi7VCfhsMRRqFufronxvMcAoOVNlhzH3YY9iHSVlWLTFla6C9BxlXIa0W84nD
	AhiH1Z8fOf9KmgoYf6aUjPuMYXyGxCS5zHDya8BFpP8GH8HyKRLS1t0wVthpr0gkCiRWFJ
	daKCnWUBgwZRaTW0wNMQ5eNpRL9+ZPw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-623-r7jBYWoeMJKo6n2PqoYroA-1; Tue,
 22 Sep 2026 16:21:36 -0400
X-MC-Unique: r7jBYWoeMJKo6n2PqoYroA-1
X-Mimecast-MFC-AGG-ID: r7jBYWoeMJKo6n2PqoYroA_1790108494
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 552B119772F3;
	Tue, 22 Sep 2026 20:21:34 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 35FA1300106D;
	Tue, 22 Sep 2026 20:21:32 +0000 (UTC)
Message-ID: <d95e0c38-87f4-4ff7-bdb9-e76da31547b8@redhat.com>
Date: Tue, 22 Sep 2026 16:21:31 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] cgroup/cpuset: prevent activating local partition
 over remote one
To: Hui Peng <benquike@gmail.com>, Guopeng Zhang <guopeng.zhang@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Ridong Chen <ridong.chen@linux.dev>
Cc: Michal Koutny <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>,
 cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <aa90bb73-c2af-4d13-8f2a-0435aa528058@linux.dev>
 <20260920181449.3122336-1-benquike@gmail.com>
 <20260920181449.3122336-2-benquike@gmail.com>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260920181449.3122336-2-benquike@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On 9/20/26 2:14 PM, Hui Peng wrote:
> Commit 6da580ec656a ("cgroup/cpuset: Don't allow creation of local
> partition over a remote one") added a check in update_prstate() to reject
> creating a top-level local partition whose cs->exclusive_cpus intersects
> subpartitions_cpus.
>
> However, if a top-level cgroup A1 is first set to "root" with all CPUs
> (CX0-7:P1, becoming "root invalid" because no CPUs would remain in
> top_cpuset), has a child A1/A2 enabled as a remote partition on a subset
> of those exclusive CPUs (CX2-3:P2), and A1 is then updated to a valid CPU
> subset (CX1-3), update_exclusive_cpumask() / update_cpumask() calls
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
> Changes in v3:
> - Split the validate_partition() fix (Fixes: 6da580ec656a) and the
>    cpus_excl_conflict() fix (Fixes: 2a3602030d80) into separate patches.
>
>   kernel/cgroup/cpuset.c                        | 4 ++++
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
This additional check looks good.
>   	if (prstate_housekeeping_conflict(trialcs->partition_root_state,
>   					  trialcs->effective_xcpus))
>   		return PERR_HKEEPING;
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index b732078bf319..f4d1822d4e21 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -321,6 +321,8 @@ TEST_MATRIX=(
>   	" C1-3:P2  X4:P2    .      .      .    X3:P2    .      .     0 A1:1-2|XA1:1-3|A2:3:XA2:3 A1:P2|A2:P2 1-3"
>   	" C0-3:P2    .      .    C4-6   C0-4     .      .      .     0 A1:0-4|B1:5-6 A1:P2|B1:P0"
>   	" C0-3:P2    .      .    C4-6 C0-4:C0-3  .      .      .     0 A1:0-3|B1:4-6 A1:P2|B1:P0 0-3"
> +	" CX0-7:P1 CX2-3:P2 .      .    CX1-3    .      .      .     0 A1:1|A2:2-3|XA2:2-3 \
> +								       A1:P-1|A2:P2 2-3"

This test will not work because you are assuming the test system only 
have 8 CPUs. That may not be the case and 2 local partitions may be 
created instead.

Cheers,
Longman

>   
>   	# Local partition invalidation tests
>   	" C0-3:X1-3:P2 C1-3:X2-3:P2 C2-3:X3:P2 \

