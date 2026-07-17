Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210F93BD649
	for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 12:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784292743; cv=none; b=WYoWIXKlATL7k95OAe0iEAlT9ZUV4j6jy3O8Wy75HedsPiw0IwD3oa3bwDOCuRp+Cu2GcENDQNiP6aAji5kwqGJs8G+5QKrfeToc3MZ5IpWnQVtMqi9FR/AySwbAY3lrYDYigRq0px+N9q15d4HyX54EmF2poEyBvZJ0raQhB54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784292743; c=relaxed/simple;
	bh=qcXKtC3ZrTU+xH5ESm7ZNlha3v9nqIfUEKtHifH8/90=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ELSVmyexOT0w9I79ZyAkMTF9F9MOanYqnYPrZwPmGP6nMF0LNYsTyXaRdhlwU78+x1ayGBFryhpPzYniuWZrQy+QFQ48E3tUk/IgheshFiF+gtbQLCrWwRB3+rlXrsrQkvtAHOK5o7XxkPR71vhCkh5OK2emda9+PeIgWA7Phyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ARmo0lja; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ARmo0lja"
Message-ID: <274129a4-88cd-49d4-9148-5112a8ac59e3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784292739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hn9QwYS5Hnn8xy3tAU+w/YBUSwnNVbbezxTsE7lXOo8=;
	b=ARmo0ljaLNgAdnffwIhyynWY0D3wjDVVQrVkrVju5/PNwYBhU9d5C0uKaMH0ev5dHFPbOT
	in5qrxINczp8ItAtbgUcCpRpjWL+WJ1/qwVpZuAYfjfZoHMnkhnfrbHr7gzcxG/BfgRgN0
	vjbOny6VFB7rwW3irmRaGlMwuQsXgKA=
Date: Fri, 17 Jul 2026 20:51:58 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Cc: cui.tao@linux.dev, cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/cgroup: Remove redundant cg_enter_current()
 call in test_core
To: guojian <guojian@kylinos.cn>, tj@kernel.org, hannes@cmpxchg.org,
 mkoutny@suse.com, shuah@kernel.org
References: <20260717110606.298368-1-guojian@kylinos.cn>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260717110606.298368-1-guojian@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



在 2026/7/17 19:06, guojian 写道:
> From: Jian Guo <guojian@kylinos.cn>
> 
> The test_cgcore_no_internal_process_constraint_on_threads test has two
> back-to-back cg_enter_current(root) calls in its cleanup path.
> 
> A single cg_enter_current() call atomically migrates the entire thread
> group to the target cgroup even for multi-threaded processes, and this
> test creates no extra threads or child processes that would require a
> second migration attempt. The second call is a harmless no-op once the
> process is already in the root cgroup, but it is redundant and
> inconsistent with the cleanup logic used in all other cgroup core
> selftest cases.
> 
> Remove the duplicate call to clean up the code. No functional change is
> intended.
> 
> Signed-off-by: Jian Guo <guojian@kylinos.cn>
> ---
>  tools/testing/selftests/cgroup/test_core.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/cgroup/test_core.c b/tools/testing/selftests/cgroup/test_core.c
> index 88ca832d4fc1..8e3f9b391e44 100644
> --- a/tools/testing/selftests/cgroup/test_core.c
> +++ b/tools/testing/selftests/cgroup/test_core.c
> @@ -426,7 +426,6 @@ static int test_cgcore_no_internal_process_constraint_on_threads(const char *roo
>  	ret = KSFT_PASS;
>  
>  cleanup:
> -	cg_enter_current(root);
>  	cg_enter_current(root);
>  	if (child)
>  		cg_destroy(child);

Ran test_core on x86_64 (cgroup v2, all controllers available),
12/12 pass, 0 fail, 0 skip — output byte-identical before and
after the patch. Confirms the removed call is a no-op.

Acked-by: Tao Cui <cuitao@kylinos.cn>

Thanks,
Tao
