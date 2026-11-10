Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.83
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794297420;
	b=2dx/ZKiCyyiH331+hKSGsaL7aOAP+SMHFmlorqOgydNjLkdEJvnK8Vo7kgXAOmKEpPrO
	 DhFxzVfA4Sczwx69U76/2Uoh7No/FEYo8hpiMmKAD5geeuAmNNwSjfVENVq1KWRjNI5l6
	 /spKbZ3UOsCLfoxcGIBUeRIylETRoJYPsDGkBoXSsZCTK2CVXYNiOUai1B2KB0FGkNBtV
	 /d4XcQSrUMr8MRKAVMXwAnUuonNaFr3/uwasck/9POZT8kN4tRr+slXP093kszLkWvSXU
	 cymoEHVGdAeH8Z21x4FGdRTrYG2/eZTLXgU87x56SAh0yjuPJTMmwgjJKNVZKB2WLzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794297420;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=sqVREHa+VsbwVp/tveO7uY5zfTiT+KV2x42NWjx3mjs=;
	b=iAXBoBomf/jRnyribIYQpSGjoGSFTJ5LFgEPxi2okvpyNuvxRpOTrQsy898+rGHJYCnS
	 m51I/LBOyhwbPPdHvb+3NfidsfgSDhM6GFljN8X9c01xzfPd8Bkt/IHcUrG9Aj4O2H769
	 epreWB/Na3J8vUk7wbWVISG+pJUylEihz99w8zRw/udfkzdaFXDVY8eVyA5nBZ0YUJ3le
	 Z6j5sWIwBzNECXlhRDHB9Tyve5fJPosasmfUds24e0yfRUWbzkUaIAdh/iYI1Wgi2Ws8q
	 5CkFnM/qKhRhIg3HvfPNx7dwDi8TlxSqBW13zfWyFhupw/GnnLmFc/NMDjl0Q0r8sFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YMepWfey;
	arc=none smtp.remote-ip=91.218.175.83
Received: from mta0.migadu.com (out-83.mta0.migadu.com [91.218.175.83])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D976606A31C
	for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 07:56:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D976606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YMepWfey
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Tr04FqnwqlKSyNdqCgh3OymEU28rd+8Oit5WxUPF1FA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794297417; v=1; x=1794902217;
 b=YMepWfeyaGQ/zCH1MpxpSZHumIWV/Fsg6URPg3oJelUGYf1ovFrCqP5w7F+CSTz0kI3VpH49
 pFuMy11GGSgrZf0onqMjfuMg5bnC5lDkyteFjXjqEeALnTp780BqdRdcqQoGy6DXznOEDU3hJkJ
 H6k2+6cQBcY7h6JjZ6IlejfU=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6314aabc63771b3e;
	Tue, 10 Nov 2026 07:56:57 +0000
X-Mizu-Trace-ID: 6314aabc63771b3e
X-Migadu-Flow: FLOW_OUT
Message-ID: <6b01f2c6-2cf2-4650-8fdb-821f0222b082@linux.dev>
Date: Tue, 10 Nov 2026 15:56:51 +0800
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
Subject: Re: [PATCH-next v2 1/5] selftests/cgroup: Fix "test_cpuset_prs.sh -v"
 failures
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Guopeng Zhang <guopeng.zhang@linux.dev>
References: <20261109190955.1398611-1-longman@redhat.com>
 <20261109190955.1398611-2-longman@redhat.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261109190955.1398611-2-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/10/2026 3:09 AM, Waiman Long wrote:
> When the -v option is used to run test_cpuset_prs.sh, it activates the
> use of sched-debug to determine the set of isolated CPUs which will
> also consider 1-CPU partition as being isolated though they will not be
> reflected in "cpuset.cpus.isolated". As a result, some of the expected
> isolated CPUs values have 2 different set of values to correspond to
> these two ways of determining isolated CPUs.
> 
> Commit 6e4834ba8986 ("cgroup/cpuset: Fix incorrect CPU accounting with
> parent's effective_xcpus expansion") introduces some new test cases
> which fail when the -v option is used. Update the test cases to make
> them pass with the -v option as well.
> 
> Also remove an obsolete comment in update_parent_effective_cpumask()
> of cpuset.c.
> 
> Reported-by: Tejun Heo <tj@kernel.org>
> Link: https://lore.kernel.org/lkml/886a562b52b1c5094142d547a8336457@kernel.org
> Fixes: 362212853cd0 ("cgroup/cpuset: Fix incorrect CPU accounting with parent's effective_xcpus expansion")
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>   kernel/cgroup/cpuset.c                            |  6 ------
>   tools/testing/selftests/cgroup/test_cpuset_prs.sh | 13 ++++++++-----
>   2 files changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 85e5b529d144..6074327c3477 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2164,12 +2164,6 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>   			else
>   				part_error = PERR_NOTEXCL;
>   		}
> -		/*
> -		 * When both cs and parent remain valid, parent's
> -		 * compute_partition_effective_cpumask() call would have removed
> -		 * cs's effective_xcpus from the parent's effective_cpus. So
> -		 * there is no need to adjust parent's effective_cpus here.
> -		 */
>   	}
>   
>   write_error:
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index 32e1e44fa0b1..2d4744f2d6ac 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -540,16 +540,19 @@ TEST_MATRIX=(
>   
>   	# The extra CPUs gained by a child partition when its parent expands the
>   	# exclusive CPUs have to be taken away from the parent.
> -	" C2-6:X2-5:P1 CX3-6:P1 \
> -	                    .      .    X2-6     .      .      .     0 A1:2|A2:3-6|XA2:3-6 A1:P1|A2:P1 ."
> -	" C2-6:X2-5:P1 CX3-6:P2 \
> -	                    .      .    X2-6     .      .      .     0 A1:2|A2:3-6|XA2:3-6 A1:P1|A2:P2 3-6"
> +	" C2-6:X2-5:P1 CX4-6:P1 \
> +	                    .      .    X2-6     .      .      .     0 A1:2-3|A2:4-6|XA2:4-6 \
> +								       A1:P1|A2:P1 ."
> +	" C2-6:X2-5:P1 CX4-6:P2 \
> +	                    .      .    X2-6     .      .      .     0 A1:2-3|A2:4-6|XA2:4-6 \
> +								       A1:P1|A2:P2 4-6"
>   
>   	# Both expansion and contraction of parent's effective_xcpus will be
>   	# correctly handled in child partition and the child can be invalidated
>   	# if a populated parent could lose all its effective_cpus.
>   	" C2-6:X2-5:P1 CX3,5-6:P2 \
> -	                    .      .    X4-6     .      .      .     0 A1:4|A2:5-6|XA2:5-6 A1:P1|A2:P2 5-6"
> +	                    .      .    X4-6     .      .      .     0 A1:4|A2:5-6|XA2:5-6 \
> +								       A1:P1|A2:P2 4-6|5-6"
>   	" C2-6:X2-5:P1 CX3-6:P2 \
>   	                    .      .   T:X4-6    .      .      .     0 A1:4-6|A2:4-6 A1:P1|A2:P-2 ."
>   

The commit message still refers to commit 6e4834ba8986, which isn't in
next tree. It should be 362212853cd0 ?

I applied the whole series on top of next-20261109 and ran
test_cpuset_prs.sh with and without -v as well as test_cpuset on an
8-CPU VM. All tests passed and there is no warning in dmesg.


Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Tested-by: Ridong Chen <ridong.chen@linux.dev>

-- 
Best regards
Ridong

