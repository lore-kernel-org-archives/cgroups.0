Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.153
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794291861;
	b=1q0XT928hS/9pEkDXtTqV6yOrI9L2aNCPjlr1oOAf9ch98soGcBfDccFylJp1XbCs0zT
	 0GWLpD+qKxZ3dqga5KDFM7T0gJMfsG0b5x7rvv+7RuBaI+7yKsMX61tCMDrB108siCS2T
	 as2c0M7T0jd8sIrW7VLkdGjZZqisKSd9qS/agtZ6RAqSUHEu3Zh2RmfMjTAMefhNYh+aH
	 OqMvwrcn1xWDN7G7nccZXe7TC73lK0lKFn28nYTmNNMoXqhyWCSREy2iQ2ge8tf/JdDxa
	 C1CA1FB+LU8Ntgr0zq7gPiNIxRRe/e+p1SPcfLidhyq64Yh7OPg5pPw+7omPnZBfmVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794291861;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=BL+W2T/2cuMST/SB8p0zoQbSb3TF01znFaP7YILvqJQ=;
	b=WgqBADLQ3ekO0cs+74nhYCkiEW4wL/EG5dkS111O+R+4qJAEn1hyK0eo036b2J9LhJtH
	 i7vuvWzyttqqSze6+aEZEGqIc1p3Ax5DUDYlRG522ETTDm30b9isUKXK7OYWgdBGy5Xdi
	 o96kCeAiQl0iZCgizxQHDCCxys8r2PVtDLeAk5RH0SAgcQzfORFF3XPAOSU26WlnvgQWi
	 pb7BbLn5zJdHqdHvoNNhZp+pNZD5jv6wIItMc9GDmFBGlUoFjDMB2MmHOap6t2HhZB9IS
	 nivTk9fEHESHZ532YMHsfCAGwYwF/k4099o9yChTYk4O9QyGEKRFyA25+A8jmX8kNDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=u7Ozoluy;
	arc=none smtp.remote-ip=91.218.175.153
Received: from mta0.migadu.com (out-153.mta0.migadu.com [91.218.175.153])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAAA606A325
	for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 06:24:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0BAAA606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=u7Ozoluy
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=7ght3jiINuFCMHMQNMsTCNCFy1DQnY7GC46bKdA/Shk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794291855; v=1; x=1794896655;
 b=u7OzoluyaEZu/1fB41vNlYs5mPIqZG1ptnG6WIv3AEo6L3+dk6Da+n/w3jZE5PLCZXFEv+Kk
 Sv2d+NgBbKEGka+cYl5zIBinDqYPZqu8zH5FmTssDGa0X/WGxKGO0/8z79hJhy3Bn8gk7Bs5GcH
 FW0U/UlTP8VqE2Ps92rE9whs=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9578d8396b621a0b;
	Tue, 10 Nov 2026 06:24:15 +0000
X-Mizu-Trace-ID: 9578d8396b621a0b
X-Migadu-Flow: FLOW_OUT
Message-ID: <d7fef280-a076-42c6-a6c6-cf355bbbc29f@linux.dev>
Date: Tue, 10 Nov 2026 14:24:07 +0800
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
Subject: Re: [PATCH v3 3/4] cpuset: settle isolation state when CPUs are given
 back to parent
To: Guopeng Zhang <guopeng.zhang@linux.dev>, Waiman Long
 <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: Chen Ridong <chenridong@huawei.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Sashiko <sashiko-bot@kernel.org>, Guopeng Zhang <zhangguopeng@kylinos.cn>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261107120100.3587595-1-ridong.chen@linux.dev>
 <20261107120100.3587595-4-ridong.chen@linux.dev>
 <c2ab6077-750e-48cb-bfd0-18882c807de5@linux.dev>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <c2ab6077-750e-48cb-bfd0-18882c807de5@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/9/2026 11:20 PM, Guopeng Zhang wrote:
> 
> 
> 在 2026/11/7 20:00, Ridong Chen 写道:
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> partition_xcpus_del() only updates isolated_cpus when the partition that
>> gives back the CPUs has a different state than its parent. CPUs that were
>> further distributed to descendant isolated partitions are not taken into
>> account, so isolated_cpus_release() has to be called afterwards in
>> several places to walk up the ancestors and fix isolated_cpus.
>>
>> Make partition_xcpus_del() always set the isolation state of the given
>> back CPUs to the state of the parent that receives them. As the
>> effective_xcpus of a partition covers the CPUs distributed to its
>> descendants, the isolation state of those CPUs is settled at the same
>> time. Boot-time isolated CPUs are still preserved by isolated_cpu_update().
>>
>> compute_partition_effective_cpumask() invalidates a child partition
>> without going through partition_xcpus_del(), so do the same there: the
>> CPUs of the invalidated child take the isolation state of its parent.
>>
>> As the parent may be shrunk and its effective_xcpus not updated yet,
>> only do so for the CPUs the parent still owns. This is to keep the
>> isolation state correct for now, the in-place invalidation here will be
>> removed later in the partition rework.
>>
>> isolated_cpus_update() assumes the old and new states are different,
>> which no longer holds now that partition_xcpus_del() proceeds regardless
>> of the states. Drop its @old_prs argument and the WARN_ON_ONCE() so that
>> it simply sets the isolation state of the given CPUs, and use it
>> everywhere. The state check in partition_xcpus_add() is dropped as well,
>> as setting the state is a no-op when the states are the same.
>>
>> isolated_cpus_release() is no longer needed and is removed.
>>
> 
> Hi Ridong,
> 
> Would it be worth briefly mentioning in the commit message that this patch also fixes the issue described here?
> 
> https://lore.kernel.org/all/20261105130344.664336-4-guopeng.zhang@linux.dev/
> 
Thanks, Guopeng.

As I replied to Longman, I will add it.

-- 
Best regards
Ridong

