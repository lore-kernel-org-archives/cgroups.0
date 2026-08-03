Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 718F62C0268;
	Mon,  3 Aug 2026 05:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785735248; cv=none; b=FN21EgzGSki//AUXWXnDbZju6+OyHZl4En1LKg+4ANziSU09OyNaXQLcJjtyJvTool3ba9v8lBUyZsXglhWudo+9hJ3T+dm/kSplZVjp4UilWzJ7OFTyFE+smr23BQI32LS6X+UdVZUuD6pN7NRL1BOTOhYuGYPhO9/Luu24gTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785735248; c=relaxed/simple;
	bh=OwvH7HKnExVk5bb7qHumfOLl0QVPjZFJ5VQ9gIp1z5k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lBfOk0almF//SEs3CU2OsDspSQkz8Uk3iVb+nhoN4rszARge4z9C2XyRhN4R9HtDmGekVzE2xXTpryoYi5yaejSYW/pZKtGtk7en8z62DSeuMdJhu+XBQjMgPCC9p5LOV6K2m22T3wNNYjOvz9rknr9ASjBDXdymiRE8pH+IqQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VxNAtEJW; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VxNAtEJW"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3F694143D;
	Sun,  2 Aug 2026 22:34:00 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 89BAC3F66F;
	Sun,  2 Aug 2026 22:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785735244; bh=OwvH7HKnExVk5bb7qHumfOLl0QVPjZFJ5VQ9gIp1z5k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VxNAtEJWUmeEkUu0EcMEiqUWEttW+gczS/NRlAcK6sWKaWYF9ykm3T/BhVjzcpbBj
	 NjCaqMnPz+IoO4jJhnysZOTs0UuPEcAdOjYiDA3VpgoqFQ6DsE1IceoFpn0jBQBwDO
	 PythhqLRSOxyedcYTeQgQGxcgk4meMgDYf02n8F8=
Date: Mon, 3 Aug 2026 11:04:00 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/cgroup: test_zswap: skip test_no_kmem_bypass
 if debugfs is unavailable
Message-ID: <47ho7uhwnbtjmqrdr5hzxuy2dcfb2dal7so6ztt7obmqepeuri@e7bc5dfit4tm>
References: <20260801041255.752039-1-wfelipe@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260801041255.752039-1-wfelipe@google.com>

On Sat, Aug 01, 2026 at 04:12:46AM +0000, Wilson Felipe Pereira wrote:
> test_no_kmem_bypass() needs to read
> /sys/kernel/debug/zswap/stored_pages via get_zswap_stored_pages() to
> verify that compressed pages are charged to the memcg.
> 
> When running in an environment where debugfs is not mounted or
> CONFIG_DEBUG_FS is disabled, get_zswap_stored_pages() fails, causing the
> loop to terminate early and report a false negative (KSFT_FAIL).
> 
> Selftests should not fail when if debugfs is unavailable, and it
> should print a message when it is skipped.

Agreed.

> 
> Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
> ---
>  tools/testing/selftests/cgroup/test_zswap.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
> index 49b36ee791606..c4f7b66f1b206 100644
> --- a/tools/testing/selftests/cgroup/test_zswap.c
> +++ b/tools/testing/selftests/cgroup/test_zswap.c
> @@ -566,12 +566,19 @@ static int test_no_kmem_bypass(const char *root)
>  	int child_status;
>  	char *test_group = NULL;
>  	pid_t child_pid;
> +	size_t stored_pages;
>  
>  	/* Read sys info and compute test values accordingly */
>  	if (sysinfo(&sys_info) != 0)
>  		return KSFT_FAIL;
> -	if (sys_info.totalram > 5000000000)
> +	if (sys_info.totalram > 5000000000) {
> +		ksft_print_msg("requires less than 5000000000 total ram\n");

Agreed - should not silently just skip the test.

>  		return KSFT_SKIP;
> +	}
> +	if (get_zswap_stored_pages(&stored_pages)) {
> +		ksft_print_msg("debugfs at /sys/kernel/debug is required\n");

Could the error message here match that in gup_test.c for consistency
and probably later on these could be factored out in a macro constant

ksft_print_msg("mount debugfs at /sys/kernel/debug\n");

> +		return KSFT_SKIP;
> +	}
>  	values = mmap(0, sizeof(struct no_kmem_bypass_child_args), PROT_READ |
>  			PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
>  	if (values == MAP_FAILED)
> @@ -604,7 +611,6 @@ static int test_no_kmem_bypass(const char *root)
>  	/* Try to wakeup kswapd and let it push child memory to zswap */
>  	set_min_free_kb(min_free_kb_high);
>  	for (int i = 0; i < 20; i++) {
> -		size_t stored_pages;
>  		char *trigger_allocation = malloc(trigger_allocation_size);
>  
>  		if (!trigger_allocation)
> -- 
> 2.55.0.508.g3f0d502094-goog
> 

Otherwise LGTM.

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
