Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1C954763;
	Wed, 12 Aug 2026 02:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786500374; cv=none; b=XnuSXKm0ufzIDn+A3L3QajIL0VfcWqNdvcWsA4vkXB0f8gds4HNcSfuVe3Qd/mOABDRnm5DVwdlp1OktkmjS17zj4e3FnoRcEYyk2KaLYgUd+KKOeNlZWKxBNXeqrzH0/fc/zWuoQcL7sI/5HTDTVrY9P+iDyeE5uBFr3DhlzAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786500374; c=relaxed/simple;
	bh=bQ9eKKflkB8WHIrhnHydxjFUq4Lsv9Fdg6eVoi8X3m4=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=N7JG2PoNyYmCFLcbUdPUk7SdqCFcjRiKHsPyGxAY9+pgmP/nvaMlG0bLJKx/R4ePyaLlZrb0W+JLsVdNvNWJzxUsbSM07+ERaYMS55EKPfv9ootirNkzlWba5jooTpPVWTMsf+85eUnsjOcz1pgT3o0jQ9MgKbO1ceCqFkElMT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ytMh5R8R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ytMh5R8R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259911F000E9;
	Wed, 12 Aug 2026 02:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786500372;
	bh=EuelHEjJwc9WOENkCsuVs9GnBflpggl6MKv0gvmcy5Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ytMh5R8RKS0Eyyxbln39Zr/MQTyJI1Sn1ybd78YJEJiwHH+BeU+ppp/q0pg5Yme2s
	 8HCjorE6Fg7DBQTsA2VjYhRAABfx3LnbJL4L8yGz2geb4s4N+gd2IPyeRDoJoSqDEn
	 UlpMNuRaqIKiRl6Zv3XBSZ3vLQggw1ku8tnxovdk=
Date: Tue, 11 Aug 2026 19:06:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Shuah Khan <shuah@kernel.org>, Anshuman
 Khandual <anshuman.khandual@arm.com>, Tejun Heo <tj@kernel.org>,
 =?ISO-8859-1?Q?"Michal_Koutn=FD"?= <mkoutny@suse.com>, Chengming Zhou
 <chengming.zhou@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2] selftests/cgroup: test_zswap: skip
 test_no_kmem_bypass if debugfs is unavailable
Message-Id: <20260811190611.c72f19ada3912791a81a7a90@linux-foundation.org>
In-Reply-To: <20260811051434.3805648-1-wfelipe@google.com>
References: <20260811051434.3805648-1-wfelipe@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 11 Aug 2026 05:14:11 +0000 Wilson Felipe Pereira <wfelipe@google.com> wrote:

> test_no_kmem_bypass() needs to read
> /sys/kernel/debug/zswap/stored_pages via get_zswap_stored_pages() to
> verify that compressed pages are charged to the memcg.
> 
> When running in an environment where debugfs is not mounted or
> CONFIG_DEBUG_FS is disabled, get_zswap_stored_pages() fails, causing the
> loop to terminate early and report a false negative (KSFT_FAIL).
> 
> Selftests should not fail if debugfs is unavailable, and it should print
> a message when it is skipped.
> 
> While I'm here, also add a warning message if the test is being skipped
> due to totalram size and make the check for totalram more readable.
> 
> ...
>
> --- a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
> +++ b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
>
> ...
>
> @@ -570,8 +571,16 @@ static int test_no_kmem_bypass(const char *root)
>  	/* Read sys info and compute test values accordingly */
>  	if (sysinfo(&sys_info) != 0)
>  		return KSFT_FAIL;
> -	if (sys_info.totalram > 5000000000)
> +	if (sys_info.totalram > GB(4)) {
> +		ksft_print_msg(
> +			"requires less than 4GB total ram, sys_info.totalram: %.1fGB\n",
> +			(double)sys_info.totalram / GB(1));
>  		return KSFT_SKIP;
> +	}
> +	if (access(PATH_ZSWAP_STORED_PAGES, R_OK)) {
> +		ksft_print_msg("mount debugfs at /sys/kernel/debug\n");

Super nittynit: "mount debugfs at /sys/kernel/debug" sounds like a
progress message.  "I just mounted debugfs at ...".  I think the below is
more clear?

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -578,7 +578,7 @@ static int test_no_kmem_bypass(const cha
 		return KSFT_SKIP;
 	}
 	if (access(PATH_ZSWAP_STORED_PAGES, R_OK)) {
-		ksft_print_msg("mount debugfs at /sys/kernel/debug\n");
+		ksft_print_msg("debugfs not mounted at /sys/kernel/debug\n");
 		return KSFT_SKIP;
 	}
 	values = mmap(0, sizeof(struct no_kmem_bypass_child_args), PROT_READ |
_

