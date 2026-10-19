Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792423258;
	b=FHtgj6RFQRJbbD7bfHzb8RwZpGeoTBoMUGAZT8JZ2c5SWw6or7IKK73+TIjqywiWKvOc
	 zzYITCPSPPriycNWKITqMx1dWCKkhPUbAojgT0BcOUA+3uKSWTYwZL170dLwMUwKA/HJA
	 VhJ/zpl6Piqzp9NpNxG3TWqZ5F6/c85NXI4Nr6FdoZO3SbLz3n3zLQ8M+u4Sk+0Chon0W
	 1Feu6zJt+uKuVFZ6RCcF61uUd30Kn9U1CqPuCWqkGG6y8cUpwuCPLMPU+TUxZR3QtUaAL
	 H0QPzrA6OhOQjVo1rOEE6NNjD/Y0ewYJf4BWkcdqV/9S9ghI0VxEbLncuNXsqrhVTow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792423258;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=NDxpkGNoz7BmnUqvvkIeuzCaJB7Pz7RiPfeGG6dFS7k=;
	b=xGkQO+srUqfe7uFppsEkZG/BBADtT3HagURaaoAD90GDrRcFZhsd6YE0UfQMvMR5ncGe
	 bsBFV8+iw8MQPLrUfDoqbB2xdref/Y/oF2uM48k1tkzyf+TpX5cXzFPFCo41vp7D4hLZ0
	 mZuNuyaWAcXotWya3XXP09XUsP75cCUvJnfadVP4wpkulANiXhKcSUiFW7Oo6scBjsxlv
	 wJ1EhMVwNRvkiB+gi67yre1vYpkAQpVrLxd87isHyvklN6AC3LYe0UTmBgRULUxKpj641
	 rz+1YRirnBWtXe3ZWaM9mqg0T5jldNVrCdTGqFULtWa+2vdq3Y+XEmB1zN8dQyq9DMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=alYEaMPE;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FCF60A7E68
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 15:20:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31FCF60A7E68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=alYEaMPE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792423257;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NDxpkGNoz7BmnUqvvkIeuzCaJB7Pz7RiPfeGG6dFS7k=;
	b=alYEaMPEIfX1ytILOb66GNUkBmJDHU1X5PiHqxT8V6wV2zGwNlbnp/e9OEH9poeAnQS7zC
	0jf3KC6iwm202fU7yFuV/ur2Ew8kg5FuSbsQFp0C/RkBvopmVZzg+IEOef8MkKix3gltHl
	ArjAkbH3OHF4frPvsGXEXGB3S2mNVfI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-355-wbqslNhsODGZaDT2JDQoaw-1; Mon,
 19 Oct 2026 15:20:45 +0000
X-MC-Unique: wbqslNhsODGZaDT2JDQoaw-1
X-Mimecast-MFC-AGG-ID: wbqslNhsODGZaDT2JDQoaw_1792423243
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D943F180061F;
	Mon, 19 Oct 2026 15:20:42 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6854B180057F;
	Mon, 19 Oct 2026 15:20:40 +0000 (UTC)
Message-ID: <c27e9477-656e-4fd5-bf6d-a59b426d70eb@redhat.com>
Date: Mon, 19 Oct 2026 11:20:39 -0400
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
Subject: Re: [PATCH-next v3 1/9] cgroup/cpuset: Fix a missing isolated_cpus
 update in update_cpumasks_hier()
To: Guopeng Zhang <guopeng.zhang@linux.dev>,
 Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Hui Peng <benquike@gmail.com>
References: <20261014140548.575122-1-longman@redhat.com>
 <20261014140548.575122-2-longman@redhat.com>
 <0bd7f6ff-3675-4447-a62a-a2047241e3e6@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <0bd7f6ff-3675-4447-a62a-a2047241e3e6@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On 10/15/26 9:02 AM, Guopeng Zhang wrote:
>
> 在 2026/10/14 22:05, Waiman Long 写道:
>> It is found that when a local isolated partition is being invalidated
>> because its root partition parent is no longer valid, the isolated_cpus
>> cpumask may not be properly updated. If the parent was previously
>> an isolated partition, its invalidation should have properly updated
>> isolated_cpus before and no action will be needed.
>>
>> Fix that by calling isolated_cpus_update() in this invalidation case
>> to update isolated_cpus. A test case in test_cpuset_prs.sh is modified
>> to test that.
>>
>> Fixes: 11e5f407b64a ("cgroup/cpuset: Keep track of CPUs in isolated partitions")
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   kernel/cgroup/cpuset.c                        | 19 ++++++++++++++-----
>>   .../selftests/cgroup/test_cpuset_prs.sh       |  4 ++--
>>   2 files changed, 16 insertions(+), 7 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 0ebba2d646c3..6b5c870e5607 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -2229,7 +2229,9 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
>>   		 * cpuset if the parent's effective_cpus changes.
>>   		 */
>>   		if ((cp != cs) && old_prs) {
>> -			switch (parent->partition_root_state) {
>> +			int parent_prs = parent->partition_root_state;
>> +
>> +			switch (parent_prs) {
>>   			case PRS_ROOT:
>>   			case PRS_ISOLATED:
>>   				update_parent = true;
>> @@ -2238,11 +2240,18 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
>>   			default:
>>   				/*
>>   				 * When parent is not a partition root or is
>> -				 * invalid, child partition roots become
>> -				 * invalid too.
>> +				 * invalid, child partition roots become invalid
>> +				 * too. For an isolated partition with root
>> +				 * partition parent, isolated_cpus_updated()
>> +				 * is called to update isolated_cpus.
>>   				 */
>> -				if (is_partition_valid(cp))
>> -					new_prs = -cp->partition_root_state;
>> +				if (is_partition_valid(cp)) {
>> +					new_prs = -old_prs;
>> +					if ((old_prs == PRS_ISOLATED) &&
>> +					    (parent_prs == -PRS_ROOT))
>> +						isolated_cpus_update(old_prs, new_prs,
>> +								     cp->effective_xcpus);
>> +				}
> I tested switching a parent partition from root to member and found that
> CPUs can remain listed in cpuset.cpus.isolated. CPUs 0-15 are online, with
> nohz_full=2-15 and no isolcpus:
>
>      # cd /sys/fs/cgroup
>      # echo +cpuset > cgroup.subtree_control
>      # mkdir A
>      # echo 1-2 > A/cpuset.cpus
>      # echo root > A/cpuset.cpus.partition
>      # echo +cpuset > A/cgroup.subtree_control
>      # mkdir A/C
>      # echo 2 > A/C/cpuset.cpus
>      # echo isolated > A/C/cpuset.cpus.partition
>      # cat cpuset.cpus.isolated
>      2
>      # echo member > A/cpuset.cpus.partition
>      # cat A/C/cpuset.cpus.partition
>      isolated invalid (Parent is not a partition root)
>      # cat cpuset.cpus.isolated
>      2
>
> A is now a member and C is invalid, so cpuset.cpus.isolated should be
> empty here, but CPU 2 remains.

Yes, this patch isn't quite correct and can't catch some corner cases. I 
have a new version that should work much better and I can't reproduce 
your test case with the new patch. I will send out a v4 soon.

Cheers,
Longman

> Thanks,
> Guopeng>  				WRITE_ONCE(cp->prs_err,
>>   					   is_partition_invalid(parent)
>>   					   ? PERR_INVPARENT : PERR_NOTPART);
>> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>> index 7efd5e645767..874a8a161236 100755
>> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>> @@ -292,9 +292,9 @@ TEST_MATRIX=(
>>   								       A1:P0|A2:P2|A3:P1 2-4|2-3"
>>   	"   C0-4    C1-4  C2-4     .    X2-4  X2-4:P2 X3-4:P1   .    0 A1:0-1|A2:2|A3:3-4 \
>>   								       A1:P0|A2:P2|A3:P1 2"
>> -	" C0-4:X2-4 C1-4:X2-4:P2 C2-4:X4:P1 \
>> +	" C0-4:X2-4 C1-4:X2-4:P1 C2-4:X4:P2 \
>>   				   .      .      X5      .      .    0 A1:0-4|A2:1-4|A3:2-4 \
>> -								       A1:P0|A2:P-2|A3:P-1 ."
>> +								       A1:P0|A2:P-1|A3:P-2 ."
>>   	" C0-4:X2-4 C1-4:X2-4:P2 C2-4:X4:P1 \
>>   				   .      .      .      X1      .    0 A1:0-1|A2:2-4|A3:2-4 \
>>   								       A1:P0|A2:P2|A3:P-1 2-4"

