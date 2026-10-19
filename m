Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792425536;
	b=lOks7QAuliNh6xxYuBFARzbmo2oZDmL+Peexsvx12eBblDQSzs4PFk2jkRw7mAltecKa
	 pJSTql6puUl1xMuBjcB5OqHL/q2Ex27aoGmpZe04DGq2weuZ/Evr0peUzqnqq9V0fXkqW
	 IUeRfbIWm5iQgNy76VpQuhV3wgZ4NgrcfxDTKg7h83wD2l56DzAgQsSPJgRBDJx7oaCPi
	 W1Ujk/4rZc1lu1WaPYushgZKXBX2qBCA0zzWkGNWXgnRn3/obBeIk5ebZX/61oPoQBsUh
	 E8S7gAGq2l+TJ7gWgthJrW4xnk+nEi5o5Nl+mnEI54YBPUGCGVyoZz2xvIutR8xzKlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792425536;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=xiJEIKtkd3LoHb9/mGUKK1tAHph0ZPZhpBeMubfOR5Y=;
	b=1H+XdIVvLSnn/h82sw+LrBY8f6CV+RlgeG4O8TpkLEapEDF9YWGVzZV8tjC+jBlUfuwD
	 Ky9nZyHXUac98Z/L1td3IVRXxY9WLcukAMtD+siRHXzflPsEvB4Ef6FYQowpVz0Q9oPYC
	 z+p+62jdz6+/CecmV65pAfe1LGl+55TUu2SiBq8Y85ziZWkxl3C8nv4SRTLy74/vvJpRj
	 Bp+VgBgk0NyAYgw+80bOqzr84dMRnhWKzkV82ev83YPYPwydKVg54Gz52kN9BmbbDmUqB
	 YztVy4piu3t+O74itUOz+u+WjFscaOSISCUmGu6l7ugPA82WMzYkJiRqJBHSpQJwK6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=L16HOo2W;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE6F606AAC2
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 15:58:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DEE6F606AAC2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=L16HOo2W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792425534;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xiJEIKtkd3LoHb9/mGUKK1tAHph0ZPZhpBeMubfOR5Y=;
	b=L16HOo2WTNL+XzQbzG9a/PXl7B9gS7z28AWoPQXtNZuhaFXqyVpy2HfFcDqqgFz+gxw/mk
	i92JAXe93eH76UCsMFo4luikK0OG5mSUbQyNpwDVEkpqBo+poKD6aB0xzfDRuR9UcPJuAt
	mTAofcKaV43C0XvuYaKDRbnyPlnt8bI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-607-1evXegoyMFasyfG_YYbubw-1; Mon,
 19 Oct 2026 15:58:50 +0000
X-MC-Unique: 1evXegoyMFasyfG_YYbubw-1
X-Mimecast-MFC-AGG-ID: 1evXegoyMFasyfG_YYbubw_1792425528
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 382111955F11;
	Mon, 19 Oct 2026 15:58:47 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 07C4A195608B;
	Mon, 19 Oct 2026 15:58:44 +0000 (UTC)
Message-ID: <32462fc4-8a28-47f2-a32a-aaaaa9a501d7@redhat.com>
Date: Mon, 19 Oct 2026 11:58:44 -0400
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
Subject: Re: [PATCH-next v3 6/9] cgroup/cpuset: Don't allow a child root
 partition under an isolated parent
To: Guopeng Zhang <guopeng.zhang@linux.dev>,
 Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Hui Peng <benquike@gmail.com>
References: <20261014140548.575122-1-longman@redhat.com>
 <20261014140548.575122-7-longman@redhat.com>
 <497db854-17ba-47ae-a9e0-8f1dacb0b205@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <497db854-17ba-47ae-a9e0-8f1dacb0b205@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On 10/15/26 11:30 PM, Guopeng Zhang wrote:
>
> 在 2026/10/14 22:05, Waiman Long 写道:
>> Although it is not typical for real users to create a complicated nested
>> partition hierarchy, it is currently allowed to create nested root and
>> isolated partitions. In addition, disabling or invalidating a partition
>> should always be allowed especially when the cpuset is being deleted.
>>
>> With a nested root and isolated partition hierarchy, it is possible
>> that all active housekeeping CPUs can be exhausted when disabling or
>> invalidating a root partition and returning its CPUs to the isolated
>> parent.
>>
>> One way to avoid this problem is to disallow the creation of a root
>> partition under an isolated parent. It is indeed a new limitation imposed
>> on the existing cpuset partition functionality. However an isolated
>> partition is usually a left node where scheduling and some other kernel
>> noises are disabled. It doesn't make much sense to create a child root
>> partition under an isolated parent and remove some CPUs from the set
>> of isolated CPUs again. Creation of a child isolated partition under a
>> root or isolated parent is still allowed.
>>
>> The cgroup-v2 documentation is also updated to reflect this new
>> limitation. New test cases are added to test_cpuset_prs.sh to verify
>> this new behavior. Some existing test cases are also updated accordingly.
>>
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   Documentation/admin-guide/cgroup-v2.rst           |  4 +++-
>>   kernel/cgroup/cpuset-internal.h                   |  1 +
>>   kernel/cgroup/cpuset.c                            | 13 +++++++++++++
>>   tools/testing/selftests/cgroup/test_cpuset_prs.sh | 14 ++++++++------
>>   4 files changed, 25 insertions(+), 7 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
>> index bd8c80f3bbc9..2c445829e24d 100644
>> --- a/Documentation/admin-guide/cgroup-v2.rst
>> +++ b/Documentation/admin-guide/cgroup-v2.rst
>> @@ -2767,7 +2767,9 @@ Cpuset Interface Files
>>   	be retained, but behaves more like a "member".
>>   
>>   	All possible state transitions among "member", "root" and
>> -	"isolated" are allowed.
>> +	"isolated" are allowed with the exception that a local child
>> +	"root" partition is not allowed to be created under an "isolated"
>> +	parent partition.
>>   
>>   	On read, the "cpuset.cpus.partition" file can show the following
>>   	values.
>> diff --git a/kernel/cgroup/cpuset-internal.h b/kernel/cgroup/cpuset-internal.h
>> index 5da9c91295b0..2e44dc8634dc 100644
>> --- a/kernel/cgroup/cpuset-internal.h
>> +++ b/kernel/cgroup/cpuset-internal.h
>> @@ -35,6 +35,7 @@ enum prs_errcode {
>>   	PERR_HKEEPING,
>>   	PERR_ACCESS,
>>   	PERR_REMOTE,
>> +	PERR_ISOPARENT,
>>   };
>>   
>>   /* bits in struct cpuset flags field */
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 40c004386af0..681701ba46e1 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -60,6 +60,7 @@ static const char * const perr_strings[] = {
>>   	[PERR_HKEEPING]  = "partition config conflicts with housekeeping setup",
>>   	[PERR_ACCESS]    = "Enable partition not permitted",
>>   	[PERR_REMOTE]    = "Have remote partition underneath",
>> +	[PERR_ISOPARENT] = "Root partition is not allowed with isolated parent",
>>   };
>>   
>>   /*
>> @@ -2865,6 +2866,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>>   	int err = PERR_NONE, old_prs = cs->partition_root_state;
>>   	struct cpuset *parent = parent_cs(cs);
>>   	struct tmpmasks tmpmask;
>> +	int parent_prs = parent->partition_root_state;
>>   	bool isolcpus_updated = false;
>>   	bool disable_partition = false;
>>   
>> @@ -2910,6 +2912,14 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>>   			enum partition_cmd cmd = (new_prs == PRS_ROOT)
>>   					       ? partcmd_enable : partcmd_enablei;
>>   
>> +			/*
>> +			 * It is not allowed to create a root partition under
>> +			 * an isolated parent partition.
>> +			 */
>> +			if ((new_prs == PRS_ROOT) && (parent_prs == PRS_ISOLATED)) {
>> +				err = PERR_ISOPARENT;
>> +				goto out;
>> +			}
> I tested the following case. Writing root initially leaves C invalid, but
> updating its cpuset.cpus makes it valid again.
>
> CPUs 0-15 are online, with nohz_full=2-15 and no isolcpus:
>
>      # cd /sys/fs/cgroup
>      # echo +cpuset > cgroup.subtree_control
>      # mkdir A
>      # echo 1-2 > A/cpuset.cpus
>      # echo isolated > A/cpuset.cpus.partition
>      # echo +cpuset > A/cgroup.subtree_control
>      # mkdir A/C
>      # echo 1 > A/C/cpuset.cpus
>      # echo root > A/C/cpuset.cpus.partition
>      # cat A/C/cpuset.cpus.partition
>      root invalid (Root partition is not allowed with isolated parent)
>      # echo 1-2 > A/C/cpuset.cpus
>      # cat A/C/cpuset.cpus.partition
>      root
>
> C becomes a valid root partition.

Thank for finding this bug. Yes, the patch is missing check in some 
places. Will fix in the next version.

Cheers,
Longman

