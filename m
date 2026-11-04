Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.202
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793798560;
	b=piUYYBJ7dqBtH6H9vH8CubxtTHHP9msfMtHI1mQONzbkbRaTlWTtYOq1tgnPJr2BsvN4
	 wnGQZgj3q68PmwoTNdGMAVzcYpZbn5qemLVdeXT51Qi8kYZRfk+3xO9tVwHSETSgW+SSf
	 IjjUO/vyDSjCQ3tISDDB+DGiTPVZhVOomyJ2707B+6CJzUdsWbf0r/AI43HE1DViOP9hz
	 uPrGEFFyyINpiO75xj1Eru7SzbUPpTxtCcwfwjMoYLmFnpQVLrDYpJEoZa9PR4h6H3SnN
	 AbxtfBUk0cJ8SdmYr0EpRpu+jZhuRvq4XKRlrhZCiej7hNmCNsGH5rJwD+/UyQxy81w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793798560;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Cc:Subject:To:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=YJLp1C61ZMTzYyDI1094DXPw0QeoLZ9TuClqgP3WcCo=;
	b=3QgsyFyt+HO8yavrrhWGPKDYYrB3ZXuiHYT5qPtMRXs9hKd8olWnPHTgC54p37mcLfYq
	 VZCpgKHV+UX+YrImEmxls23h2vLujqQioUwgmzrpE3vfeipiNm9a06pTJYCErgmJXoq41
	 e9dYxknmXLcUQcOk8E8Hc6rt8mm83oNcwvN/Ox+8+woEZ8inCU8S9yxv8SDi0D0wGvdTm
	 gD/lvRGL8gGPUWXdGBj6NLQhlOvJnl9+EZTgqIwMyPlWxeJfHXuYaADxGO5F41L89w4mN
	 y7UyCEwVRY8wYVWI9r/qzJBS0sxK0s/8Vx/reQd6PuG1LMakmnfJy1yKdJbfCA6M51Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xeRQDtml;
	arc=none smtp.remote-ip=91.218.175.202
Received: from mta0.migadu.com (out-202.mta0.migadu.com [91.218.175.202])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C190D606A33A
	for <cgroups@vger.kernel.org>; Wed,  4 Nov 2026 13:22:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C190D606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xeRQDtml
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=jUJDOuWPwhfc5ioY6VwjRsiAmlQlmYoBB1u+kPlxRXw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793798558; v=1; x=1794403358;
 b=xeRQDtmlQWyfLPfmAyq2/c/j715HB5HtOQHH6h5RFPtHbrR8D0QfolUIf44z8+J3bDxFyI3T
 4dnoLaxH7QfmLRz4MGMW7fxYxTjnzAO08EI9+BEsLlRcwLBXJ/ANQ2SMSaQZ6TawAdQf8Na0oeP
 8acjarK+F8KL/3s31DQu6e3A=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9af1b8cea7f251b8;
	Wed, 04 Nov 2026 13:22:37 +0000
X-Mizu-Trace-ID: 9af1b8cea7f251b8
X-Migadu-Flow: FLOW_OUT
Message-ID: <0fd8f5aa-2636-4171-9300-3e04ab98d393@linux.dev>
Date: Wed, 4 Nov 2026 21:22:31 +0800
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
Cc: cui.tao@linux.dev, Chengming Zhou <chengming.zhou@linux.dev>,
 Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/cgroup: test_zswap: use the total RAM in bytes
To: Sasha Levin <sashal@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
 Tejun Heo <tj@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
References: <20261103163919.641249-1-sashal@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20261103163919.641249-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Sasha,

在 2026/11/4 00:39, Sasha Levin 写道:
> test_no_kmem_bypass() uses the totalram field of struct sysinfo as a
> byte count, but it is in units of mem_unit, which can be larger than 1
> on 32-bit architectures. There totalram also can't exceed GB(4), so the
> size check never triggers:
> 
>   test_zswap.c:609:24: warning: result of comparison of constant 4294967296 with expression of type '__kernel_ulong_t' (aka 'unsigned long') is always false [-Wtautological-constant-out-of-range-compare]
> 
> Multiply totalram by mem_unit as an unsigned long long and use that for
> the check and the values derived from it. Nothing changes on 64-bit,
> where mem_unit is 1.
> 
Built test_zswap before and after on next-20261103 and ran both on a 4G
VM, identical results, no change on 64-bit as claimed.

One small thing: could you add a Fixes tag? The issue seems to date
back to a549f9f31561a ("selftests: cgroup: add test_zswap with no kmem
bypass test"), which introduced the sysinfo block, and 6f615890b848
later reshaped it into the current GB(4) comparison with the warning.

Reviewed-by: Tao Cui <cuitao@kylinos.cn>
Tested-by: Tao Cui <cuitao@kylinos.cn>

Thanks,
Tao
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> Found with 32-bit builds of the selftests (gcc 16 and clang 21 with
> -m32, with and without -D_TIME_BITS=64 -D_FILE_OFFSET_BITS=64);
> KernelCI's 32-bit arm builds show the same warnings. The changed files
> build without them now, and the x86_64 builds don't change.
> 
>  tools/testing/selftests/cgroup/test_zswap.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
> index d50acc1b83ac8..223e2eb1329ab 100644
> --- a/tools/testing/selftests/cgroup/test_zswap.c
> +++ b/tools/testing/selftests/cgroup/test_zswap.c
> @@ -597,6 +597,7 @@ static int test_no_kmem_bypass(const char *root)
>  	size_t trigger_allocation_size;
>  	int wait_child_iteration = 0;
>  	long stored_pages_threshold;
> +	unsigned long long totalram;
>  	struct sysinfo sys_info;
>  	int ret = KSFT_FAIL;
>  	int child_status;
> @@ -606,10 +607,11 @@ static int test_no_kmem_bypass(const char *root)
>  	/* Read sys info and compute test values accordingly */
>  	if (sysinfo(&sys_info) != 0)
>  		return KSFT_FAIL;
> -	if (sys_info.totalram > GB(4)) {
> +	totalram = (unsigned long long)sys_info.totalram * sys_info.mem_unit;
> +	if (totalram > GB(4)) {
>  		ksft_print_msg(
> -			"requires less than 4GB total ram, sys_info.totalram: %.1fGB\n",
> -			(double)sys_info.totalram / GB(1));
> +			"requires less than 4GB total ram, total ram: %.1fGB\n",
> +			(double)totalram / GB(1));
>  		return KSFT_SKIP;
>  	}
>  	if (access(PATH_ZSWAP_STORED_PAGES, R_OK)) {
> @@ -622,12 +624,12 @@ static int test_no_kmem_bypass(const char *root)
>  		return KSFT_FAIL;
>  	if (read_min_free_kb(&min_free_kb_original))
>  		return KSFT_FAIL;
> -	min_free_kb_high = sys_info.totalram / 2000;
> -	min_free_kb_low = sys_info.totalram / 500000;
> -	values->target_alloc_bytes = (sys_info.totalram - min_free_kb_high * 1000) +
> -		sys_info.totalram * 5 / 100;
> -	stored_pages_threshold = sys_info.totalram / 5 / page_size;
> -	trigger_allocation_size = sys_info.totalram / 20;
> +	min_free_kb_high = totalram / 2000;
> +	min_free_kb_low = totalram / 500000;
> +	values->target_alloc_bytes = (totalram - min_free_kb_high * 1000) +
> +		totalram * 5 / 100;
> +	stored_pages_threshold = totalram / 5 / page_size;
> +	trigger_allocation_size = totalram / 20;
>  
>  	/* Set up test memcg */
>  	test_group = cg_name(root, "kmem_bypass_test");

