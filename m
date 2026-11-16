Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.114
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794812905;
	b=XBbavrefwTt0Llkmct5CQlYg4RIQ4yIQZJCC/zdfjNre/YcCNWPELVrBQqFdMYzd1JSS
	 YyxA/kVhZArb81mgiDWvt+bUIpd4H647kCH8Hi8rC3LlcyeVjVmcXkhJTTVWsauQZ7rtq
	 LMZrJY+PYWxu35rlYbA9IWsbz8PE1D/8iL7EQp2vyw7od1shYTPRk43eJ5zEdaR6TF6s3
	 e5MX7sBPglJNSFrBya7BfIMHVUwsrBRgQkjXGG2OuiqN4ktW7gIbdi53PsWh6NSQ8E0Ym
	 vavcqKWK0Hfy30sZijXIbxMZWxx2MHPX/uTcsbD0oQreLuUbkAl9DRG2xqawJwWgM+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794812905;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=Ku1GaLDZkKaVwDYDZ0Af5dH0wVqeYKJe066PDuuveYg=;
	b=OMQRBYSkhT1U8fRJlGqm1D8LQMyZH7yvOFnfRBsnDF5RmjuJoXnKjw18XaA333rqJgeg
	 EfDe2oIFu+AMNSGsdcQQQ20mdXZ4rJjuYr3pwpBlf7xCwEono3U+3RMtvGPBM4e1B8bQg
	 LIweYSkGiJPUDFezBzOxU1kjXG/rV+sEcpKqpIlRnAUgOgahlXxL634A19YoUHj1wEEvh
	 IuTNdjX2X6sKNF6NI9w/XSgFLbbbKYZSdyZTXdVn9UGtOg49vpSAfDMi/LdPuFpqjM6M/
	 kO6Wmw8zU315ST16FV5Us2ZWRZh5BK0VpYpsbAdCaCj5MjAaf58D5gi4HqEJgnz/iGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=B1KV+0OO;
	arc=none smtp.remote-ip=91.218.175.114
Received: from mta0.migadu.com (out-114.mta0.migadu.com [91.218.175.114])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECFA606A32A
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 07:08:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0ECFA606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=B1KV+0OO
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=6vrI7gFyIbpml94nt7zmiCUdpXp3+pLUaoOSBcJrx1g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794812897; v=1; x=1795417697;
 b=B1KV+0OOVFo2JP5I1KIbCCFTBhiwXJBAdoUaQWGW1pUTW1rl/rODGG7AC2YcJzg6FvoREkSi
 0cEuOcBWjq7mqOVxLKsAydm8II6G2ol/ZRF4fmeobzb8S672znKUaBwm5QhBlzLDSQOgs00Ft7I
 ryZHEyJfRRw7Z4C8UVsq0ziQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 97b20a8296e0957a;
	Mon, 16 Nov 2026 07:08:17 +0000
X-Mizu-Trace-ID: 97b20a8296e0957a
X-Migadu-Flow: FLOW_OUT
Message-ID: <b5d6f382-0e33-4737-8c8f-03f5536249d9@linux.dev>
Date: Mon, 16 Nov 2026 15:08:08 +0800
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
Subject: Re: [PATCH-next v4 5/6] cgroup/cpuset: Handle remote partitions
 before local partitions in cpuset_handle_hotplug()
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>,
 Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Guopeng Zhang <guopeng.zhang@linux.dev>,
 Sashiko <sashiko-bot@kernel.org>
References: <20261116012330.2271010-1-longman@redhat.com>
 <20261116012330.2271010-6-longman@redhat.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261116012330.2271010-6-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/16/2026 9:23 AM, Waiman Long wrote:
> When there is a valid remote partition underneath an invalid local
> partition with subpartitions_cpus cleared because of missing active
> CPUs in the top_cpuset partition, the current iteration logic in
> cpuset_handle_hotplug() will handle the invalid local partition first
> and potentially make the local partition valid. The remote partition
> will be handled later with the potential that both the local and remote
> partitions will be valid with overlapping exclusive CPUs violating the
> cpu exclusivity rule.
> 

Hi Longman,

Patch 5 and Guopeng's patch [1] handle the same case: after hotplug,
top_cpuset has no usable CPU left (no active CPU, or no active boot
domain housekeeping CPU). But they take different approaches:

- Current code: clear subpartitions_cpus and invalidate all the
  partitions.
- [1]: only invalidate the partitions that can give an active
  housekeeping CPU back to top_cpuset.
- Patch 5: invalidate all the local partitions but keep the remote
  ones valid if possible.

I think we should agree on the expected behavior first. My preference
is to keep it simple and invalidate all the partitions as the current
code does. The problem is that in the same hotplug pass, after valid
partition A is invalidated and its CPUs are given back to top_cpuset,
partition B, which was invalid before, may become valid again. B puts
its CPUs back into subpartitions_cpus, so a valid partition visited
after B is not invalidated (patch 1), or B overlaps with a remote
partition underneath it (patch 5). If invalid partitions are not
allowed to become valid again in that pass, both issues go away.
Do we really need to keep some partitions valid in this case?

[1] https://lore.kernel.org/cgroups/20261111134250.16852-2-guopeng.zhang@linux.dev/

-- 
Best regards
Ridong

