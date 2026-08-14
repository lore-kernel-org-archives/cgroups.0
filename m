Received: from mta1.migadu.com (out-45.mta1.migadu.com [95.215.58.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A726647424E
	for <cgroups@vger.kernel.org>; Fri, 14 Aug 2026 14:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786718060; cv=none; b=bPQkKwnl5jllmzhYJJ7iljfUmCIi5PZJfbPIg61brSDXrFhXdQWILTBn/gHeRRvyE5JPSy4RttJlkct8jn0CYLfUbRU+bSUbuwUGwI3lWfVKvkeHM4+8j+kDL9eHwSr+kJhbwxh1ur+HQck4nmv5d0x/aPIDLxMAVMyva+gxznU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786718060; c=relaxed/simple;
	bh=N2fSHrh+s4f3l5jITqoZ/7jfazo8j7PveegFmreW3+Y=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=RLlF4XURmLQ1CxWBXZdkESX+fxxlRG4kLXP/o5FuxQi0sf79xSbXfeC1IXyQ76g6mdwv823ZiY+QExLg611kiKTlvUbpPcSRJND1ktt53TDE2Jolxe98wuXQbq3H4aRNSe/tkVKicNBs5pR5XuAcOZ1e1s60eHC/9N6iNmLE+oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VDdr9rZw; arc=none smtp.client-ip=95.215.58.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VDdr9rZw"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=N2fSHrh+s4f3l5jITqoZ/7jfazo8j7PveegFmreW3+Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786718053; v=1; x=1787322853;
 b=VDdr9rZwLRknIcBjVaGjE6ugekSIJMA5V84yLSROhNSwAULt9M5SDtIWvgsyVM3UsGFdfgIi
 QSCxr0PFEwM3lIg+2k0tOyu685wEe/BQIAmqiTyybo0cQmudCNv7v7py4k95Bc/bcCqqqpbXc3u
 qpDub/Pz6AVQhTIcheASAGCc=
X-Envelope-To: cgroups@vger.kernel.org
Received: from [192.168.1.116] (111.162.215.50)
	by smtp.migadu.com with ESMTPS id b1e08f2e3df3c1de;
	Fri, 14 Aug 2026 14:34:03 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <ab235e0f-6823-4db0-ad5f-29926dac65c0@linux.dev>
Date: Fri, 14 Aug 2026 22:33:50 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests/cgroup: remove redundant chown in
 test_cgcore_lesser_ns_open
To: Shaojie Sun <sunshaojie@kylinos.cn>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
References: <20260813090914.690350-1-sunshaojie@kylinos.cn>
 <20260814100002.1007394-1-sunshaojie@kylinos.cn>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260814100002.1007394-1-sunshaojie@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/8/14 18:00, Shaojie Sun 写道:
> test_cgcore_lesser_ns_open runs as root throughout and never changes its
> euid, so chowning the two cgroup.procs files to a non-root uid has no
> effect on the test.
> 
> The ENOENT the test expects comes from the cgroup namespace delegation
> check in cgroup_procs_write_permission(): the source and destination
> cgroups must both be descendants of the namespace root captured at open
> time.  That check does not depend on file ownership.  In addition, the
> permission check only examines the common ancestor's cgroup.procs file
> (the test root here), which the chown calls do not touch.
> 
> Remove the redundant chown calls and the now unused test_euid and
> cg_test_a_procs variables.
> 
> Signed-off-by: Shaojie Sun <sunshaojie@kylinos.cn>
> ---
> Changes in v2:
> - Remove the now unused cg_test_a_procs variable, as suggested by
>   sashiko-bot.
> 
>  tools/testing/selftests/cgroup/test_core.c | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/cgroup/test_core.c b/tools/testing/selftests/cgroup/test_core.c
> index 88ca832d4fc1..5501be9912c0 100644
> --- a/tools/testing/selftests/cgroup/test_core.c
> +++ b/tools/testing/selftests/cgroup/test_core.c
> @@ -795,10 +795,9 @@ static int lesser_ns_open_thread_fn(void *arg)
>  static int test_cgcore_lesser_ns_open(const char *root)
>  {
>  	static char stack[65536];
> -	const uid_t test_euid = 65534;	/* usually nobody, any !root is fine */
>  	int ret = KSFT_FAIL;
>  	char *cg_test_a = NULL, *cg_test_b = NULL;
> -	char *cg_test_a_procs = NULL, *cg_test_b_procs = NULL;
> +	char *cg_test_b_procs = NULL;
>  	int cg_test_b_procs_fd = -1;
>  	struct lesser_ns_open_thread_arg targ = { .fd = -1 };
>  	pid_t pid;
> @@ -813,10 +812,9 @@ static int test_cgcore_lesser_ns_open(const char *root)
>  	if (!cg_test_a || !cg_test_b)
>  		goto cleanup;
>  
> -	cg_test_a_procs = cg_name(cg_test_a, "cgroup.procs");
>  	cg_test_b_procs = cg_name(cg_test_b, "cgroup.procs");
>  
> -	if (!cg_test_a_procs || !cg_test_b_procs)
> +	if (!cg_test_b_procs)
>  		goto cleanup;
>  
>  	if (cg_create(cg_test_a) || cg_create(cg_test_b))
> @@ -825,10 +823,6 @@ static int test_cgcore_lesser_ns_open(const char *root)
>  	if (cg_enter_current(cg_test_b))
>  		goto cleanup;
>  
> -	if (chown(cg_test_a_procs, test_euid, -1) ||
> -	    chown(cg_test_b_procs, test_euid, -1))
> -		goto cleanup;
> -
>  	targ.path = cg_test_b_procs;
>  	pid = clone(lesser_ns_open_thread_fn, stack + sizeof(stack),
>  		    CLONE_NEWCGROUP | CLONE_FILES | CLONE_VM | SIGCHLD,
> @@ -863,7 +857,6 @@ static int test_cgcore_lesser_ns_open(const char *root)
>  	if (cg_test_a)
>  		cg_destroy(cg_test_a);
>  	free(cg_test_b_procs);
> -	free(cg_test_a_procs);
>  	free(cg_test_b);
>  	free(cg_test_a);
>  	return ret;
Reviewed-by: Tao Cui <cuitao@kylinos.cn>

