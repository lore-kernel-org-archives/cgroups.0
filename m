Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774876;
	b=ig9AAF58b0mTnUBHKtaGCdORuPtpibewmjiZT7Qm8j6vnGbmdE2OjIBjwQLYPWcXDWpj
	 SSQAgg4UrcZnbADj/e2fkkefVxvV4M2A4qmR10hR9/sAi/2eRdLYa+TtA6TjYQKtZxDui
	 nSsZhTEifYzhdBvxSL4kkurVAGbYj09dJsKl97BA/BnoRnuq6bPVC9Ni0JjNwAgp1g1J4
	 Xhr/rqQFdxSCsUK+FkzBQ4g4iogHXQHhNMuf0Y4MLceUdVxGsLEt5SlE9xwKF8HlxPs+N
	 dlv8V8beKqGTnbTlPqkicPyvsRH9EXGi2uWAqHI/ugTlOg/MjY4a7qyqQbQrr6mETdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774876;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=TnZyZp1qu9eI+Zvij25Jc9PeQuns/xKEfEAXbeJwiO4=;
	b=LbPmX3V3jP+l2Nwdvuhx5FNoHjfaqlTxDxew7ti6xD5bogbZIRkBEcNRX6k39nhV5nmr
	 BkQJb18AP2vvei8HDgGdScpUJa/XEzy4/zhXI6m1qX3DFBVsFXNJ58TQsuc8PYimRwRCs
	 OZDwn8HjjnXqjBEQKyTfUpoydF+LBrFWaB8eJ5/U0pyB7UrljnWGRcB6znIYgF3G6AFWp
	 A0kgBnWsxoV2VwpRMAIV2+nMi5l7eyoghOZERH+7ieEIiZKwn3GkZhxyPL13zpX0H9Vre
	 sBBfiEgBQX1+Qhghm8dpaxiuDNm42Qqhky5N++qhTiF9giAqjjNXtIAMAq8JQ4lkqPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=eNZ9qVIM;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85400606A322
	for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 17:01:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 85400606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=eNZ9qVIM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792774874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TnZyZp1qu9eI+Zvij25Jc9PeQuns/xKEfEAXbeJwiO4=;
	b=eNZ9qVIMgnBNMgl5z2973WErm1rh/kIlfuVsRl1SNUYTNHlS4EDWV1l9WSCYNX/eYGT4xD
	/GLQX5Wfg4fnH2wO5PSuINBiYQKT6E8CO7jmCIownE6fezb2pS6+8n1D3TfXKn7M/dbdcu
	cShzdftwdZNeYlTq6cOAiiyvjPvF+Vc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-167-6HhmWn2mPNC9ROcWRyNCvg-1; Fri,
 23 Oct 2026 13:01:09 -0400
X-MC-Unique: 6HhmWn2mPNC9ROcWRyNCvg-1
X-Mimecast-MFC-AGG-ID: 6HhmWn2mPNC9ROcWRyNCvg_1792774867
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D9F491955D7C;
	Fri, 23 Oct 2026 17:01:06 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1F5AA1955F01;
	Fri, 23 Oct 2026 17:01:05 +0000 (UTC)
Message-ID: <1ac81041-b85c-4681-b8f5-c535bfa9318d@redhat.com>
Date: Fri, 23 Oct 2026 13:01:04 -0400
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
Subject: Re: [PATCH-next 3/6] cgroup/cpuset: Fix incorrect effective_cpus bug
 in update_cpumasks_hier()
To: Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Guopeng Zhang <guopeng.zhang@linux.dev>
References: <20261022031643.1351877-1-longman@redhat.com>
 <20261022031643.1351877-4-longman@redhat.com>
 <fda68203-1626-4118-9664-79064aad4548@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <fda68203-1626-4118-9664-79064aad4548@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On 10/23/26 3:07 AM, Ridong Chen wrote:
>
>
> On 10/22/2026 11:16 AM, Waiman Long wrote:
>> With the introduction of cpuset.cpus.exclusive, the computation of
>> effective_cpus differs depending on if a cpuset is a valid partition
>> root or not.
>>
>> In update_cpumasks_hier(), effective_cpus is computed early
>> to check if the current subtree can be skipped. Later on
>> update_parent_effective_cpumask() may be called which can change the
>> partition state from valid to invalid or vice versa. If the partition
>> state changes, the previously computed effective_cpus may no longer be
>> valid. Fix that by recomputing effective_cpus again when that happens.
>>
>> Also add a new test case into test_cpuset_prs.sh to verify this change.
>>
>> Fixes: e2ffe502ba45 ("cgroup/cpuset: Add cpuset.cpus.exclusive for v2")
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   kernel/cgroup/cpuset.c                            | 10 ++++++++--
>>   tools/testing/selftests/cgroup/test_cpuset_prs.sh |  3 +++
>>   2 files changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index db6e4663f4be..7b9062326f35 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -2316,10 +2316,16 @@ static void update_cpumasks_hier(struct 
>> cpuset *cs, struct tmpmasks *tmp,
>>           if (update_parent) {
>>               update_parent_effective_cpumask(cp, partcmd_update, 
>> NULL, tmp);
>>               /*
>> -             * The cpuset partition_root_state may become
>> -             * invalid. Capture it.
>> +             * Capture current partition_root_state as it may have
>> +             * changed. Recompute effective cpumask if changed.
>>                */
>>               new_prs = cp->partition_root_state;
>> +            if (new_prs != old_prs) {
>> +                if (new_prs > 0)
>> +                    compute_partition_effective_cpumask(cp, 
>> tmp->new_cpus);
>> +                else
>> +                    compute_effective_cpumask(tmp->new_cpus, cp, 
>> parent);
>> +            }
>>           }
>
> If cs is a partition (remote or local), we call 
> compute_partition_effective_cpumask to compute the effective cpumask; 
> otherwise we should call compute_effective_cpumask. Wouldn't it be 
> better to call compute_partition_effective_cpumask whenever cs is a 
> valid partition, so we can eliminate the branch outside?
>
> ```
> static void compute_effective_cpumask(struct cpumask *new_cpus,
>                       struct cpuset *cs, struct cpuset *parent)
> {
>     bool has_cpus;
>
>     if (is_remote_partition (cs) ||
>         (is_partition_valid(cs) && is_partition_valid(parent)))
>         return compute_partition_effective_cpumask(cs, &new_cpus);
>
>     has_cpus = cpumask_and(new_cpus, cs->cpus_allowed, 
> parent->effective_cpus);
>     if (!has_cpus && is_in_v2_mode())
>         cpumask_copy(new_cpus, parent->effective_cpus);
> }
> ```
>
Good point. I will send a separate patch to do the consolidation.

Cheers,
Longman

>> spin_lock_irq(&callback_lock);
>> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh 
>> b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>> index 47791591002f..8595b6b4b7bf 100755
>> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>> @@ -364,6 +364,9 @@ TEST_MATRIX=(
>>       " C1-4:X2-4 C2-4:X3-4:P1 C3-4:X4:P2 \
>>                      .      .      X5      .      .    0 
>> A1:1-4|A2:2-4|A3:3-4 \
>>                                          A1:P0|A2:P-1|A3:P-2 ."
>> +    " C1-5:X3-5:P2 C3-5:X4-5:P2 C4-5:X5:P2 \
>> +                   .    X1-4     .       .      .    0 
>> A1:1-3|A2:4|A3:4 \
>> +                                       A1:P2|A2:P2|A3:P-2 1-4"
>>       " C1-4:X2-4 C1-4:X3-4:P1 C3-4:X4:P2 \
>>                      .      .      .      X1      .    0 
>> A1:1-2|A2:3-4|A3:3-4 \
>>                                          A1:P0|A2:P1|A3:P-2 ."
>

