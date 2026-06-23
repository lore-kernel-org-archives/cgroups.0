Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2973C1547C0;
	Tue, 23 Jun 2026 05:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782192745; cv=none; b=qUyDtwr9BgwWxxciN/i7s193kgfHc+3SEeqNzlPGZcAG1r2KDueNdcuNd3Z1MlbeEKwiiawyErvSxhxFqpgn+1Hj+cBZ1sxQ1+DuCPCaChPmuzodHdBvGE7Leh3J1qTPAuHK7OhwqW4VD29xsVp5U+cnyQcHTZSW6nGRNqYYlXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782192745; c=relaxed/simple;
	bh=WjgemQKk8VvtW4p3u+TSCBp7n51QPrPM3uFj0rPy9sc=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DRud2ZmhaqfeF4QQtJiTx5cANYM9TJPNbr58/Wd2PuaEEm5upGq/09McBKFtJ+HLEuESdgHP4w7AC4ojGvP+vQ3vT9lsL99iHSs9XvfU9Urn5XC30o+yh53XGnvvxeV1umlD4DVvVG7FgVoGA28uNjacEuFkMNezWFXTx9qqga4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Pk3sAxNj; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Pk3sAxNj"
Message-ID: <d8bdf9ef-a393-4734-8639-308ac3eaa05c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782192739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T0uys3soVbuibRlNP9S0ARwcaMI6iOsJGPYrN8ZQRpI=;
	b=Pk3sAxNj1QkhNWvYXZ8vXg+ZsJdtuWM1WEK5s9S1eaex4kZGAPHRqk1ZUyxJfoWnHl+rwC
	hhLuVuCGP/z1Sv3sCdh+M/o5zNf//ix6Z7P/PNO6SAcgxpqSSmVvQzkxBqYQohsWqEFlqx
	xaAj60vLA3g/4Df2yjdob0Doy1o15JU=
Date: Tue, 23 Jun 2026 13:32:08 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Cc: cui.tao@linux.dev, cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests/cgroup: Adjust cpu.max quota based on HZ
To: Joe Simmons-Talbott <joest@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
References: <20260622194305.601392-1-joest@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260622194305.601392-1-joest@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


Hi Joe,

One comment on the fallback:

  quota_usec = hz != -1 ? USEC_PER_SEC / hz : 1000;

When HZ can't be determined (no CONFIG_IKCONFIG_PROC, or zcat missing),
the fallback to 1000 is the exact value that fails at low HZ — so this
doesn't actually fix such kernels. A larger fallback (e.g. 10000, the
HZ=100 equivalent) would make the tests robust regardless of whether the
config is exposed.

在 2026/6/23 03:43, Joe Simmons-Talbott 写道:
> For lower HZ values a quota of 1000us is much lower than the amount
> of microseconds per tick which makes the tests test_cpucg_max and
> test_cpugc_max_nested fail. Use the amount of microseconds per tick
> as the quota value.
> 
> Signed-off-by: Joe Simmons-Talbott <joest@redhat.com>
> ---
> changes since v1:
> - Try checking /proc/config.gz to get the actual kernel HZ value and
>   fallback to 1000 if the value cannot be determined.
> 
>  tools/testing/selftests/cgroup/test_cpu.c | 33 +++++++++++++++++++++--
>  1 file changed, 31 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/cgroup/test_cpu.c b/tools/testing/selftests/cgroup/test_cpu.c
> index 7a40d76b9548..65e09555309f 100644
> --- a/tools/testing/selftests/cgroup/test_cpu.c
> +++ b/tools/testing/selftests/cgroup/test_cpu.c
> @@ -639,6 +639,29 @@ test_cpucg_nested_weight_underprovisioned(const char *root)
>  	return run_cpucg_nested_weight_test(root, false);
>  }
>  
> +/*
> + * Best effort attempt to get the kernel's HZ value from the config.
> + * Return the HZ value if found otherwise return -1 to indicate failure.
> + */
> +static long
> +_get_config_hz(void)
> +{
> +	long hz = -1;
> +	FILE *f;
> +	char cmd[256] = "zcat /proc/config.gz 2>/dev/null | grep '^CONFIG_HZ='";
> +
> +	f = popen(cmd, "r");
> +
> +	if (!f)
> +		goto out;
> +
> +	fscanf(f, "CONFIG_HZ=%ld", &hz);
> +
> +out:
> +	pclose(f);
> +	return hz;
> +}
> +
>  /*
>   * This test creates a cgroup with some maximum value within a period, and
>   * verifies that a process in the cgroup is not overscheduled.
> @@ -646,7 +669,8 @@ test_cpucg_nested_weight_underprovisioned(const char *root)
>  static int test_cpucg_max(const char *root)
>  {
>  	int ret = KSFT_FAIL;
> -	long quota_usec = 1000;
> +	long hz = _get_config_hz();
> +	long quota_usec;
>  	long default_period_usec = 100000; /* cpu.max's default period */
>  	long duration_seconds = 1;
>  
> @@ -655,6 +679,8 @@ static int test_cpucg_max(const char *root)
>  	char *cpucg;
>  	char quota_buf[32];
>  
> +	quota_usec = hz != -1 ? USEC_PER_SEC / hz : 1000;
> +
>  	snprintf(quota_buf, sizeof(quota_buf), "%ld", quota_usec);
>  
>  	cpucg = cg_name(root, "cpucg_test");
> @@ -710,7 +736,8 @@ static int test_cpucg_max(const char *root)
>  static int test_cpucg_max_nested(const char *root)
>  {
>  	int ret = KSFT_FAIL;
> -	long quota_usec = 1000;
> +	long quota_usec;
> +	long hz = _get_config_hz();
>  	long default_period_usec = 100000; /* cpu.max's default period */
>  	long duration_seconds = 1;
>  
> @@ -719,6 +746,8 @@ static int test_cpucg_max_nested(const char *root)
>  	char *parent, *child;
>  	char quota_buf[32];
>  
> +	quota_usec = hz != -1 ? USEC_PER_SEC / hz : 1000;
> +
>  	snprintf(quota_buf, sizeof(quota_buf), "%ld", quota_usec);
>  
>  	parent = cg_name(root, "cpucg_parent");

