Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE1D34040B;
	Thu, 20 Aug 2026 22:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787264371; cv=none; b=TuBOQI8+ICkwH3lfPQe89mAo08Ofgyurb5cISulI3zU3yQ+fiURf7cfWbgVb/yocjma+8KNvBL/vch9IpuGPAzgOq8yYcs2xdH9d9J0RU23besUk6+l8piEFn2XMm54B9mPY+wAc09CO+LIXuxAFK35WWHPcghORAmPqcD6+WxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787264371; c=relaxed/simple;
	bh=I+6H28wdo1nhsqtnD++jgAiDv19tJ6ZNiBOZWEnTZtQ=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=UT77iOgyfn9s5JpgkfdL9/RchJJZWeD3F11BD5+OwJC4YgMIhOhhJNV1aFIEewlQaLxGv2J4lkHboTkcPE8jOTGY2evbKlSXL2N6EQSOFb3LJ8vnplWCrZIRZrDtw6yWPHdsbHzPEKIdmHP+WuZv+MAp0HgNoiohRlh87ED4KA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=clrj0en7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="clrj0en7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E5C1F00A3A;
	Thu, 20 Aug 2026 22:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787264369;
	bh=qbZgxhEL1pMRBSA5nrONqaxFR/5jxQ+effSV0hHmPBU=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=clrj0en7j8J7YGXly23xUhcIKzucGTn4adkRcx3g4rMHdWZLfsq7pGcZcK70mCRGd
	 txY6BRZf7GOAOXgDiPgDCwlddVWXMLQYVR9ZCsNDTyHxeHPgtOaa3IKTTMqIj6hN7G
	 CFC9gzfWynulMXy2+GblDK2kh6N/eIrH/GiqQfTV74HUy5zVwTcLf0e6LnvWeu40tL
	 RsNisroGg4qJ6st2F+zJwO9tknCy4ZqyFfOesSUmjaP9HkyB9NYPEfRwPHuceix05H
	 p+vVqNGQU6TyOTjcFgs5gCrYmB+HDG1QBLJJR4eSts052nPp6grksESF8ufmHw8x21
	 IwGwkcIh2XaVQ==
Content-Type: multipart/mixed; boundary="===============4275236877747582368=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <1d50f23d315a83740b14036565ce7aa1a6526a8bc7522540150e8292e0cde744@mail.kernel.org>
In-Reply-To: <20260820211758.3393984-3-ziyang.meme@gmail.com>
References: <20260820211758.3393984-3-ziyang.meme@gmail.com>
Subject: Re: [PATCH v3 2/4] selftests/bpf: add cgroup_iter_cpu test for cpu cgroup kfuncs
From: bot+bpf-ci@kernel.org
To: ziyang.meme@gmail.com,kernel-team@meta.com,axboe@kernel.dk,tj@kernel.org,josef@toxicpanda.com,hannes@cmpxchg.org,mkoutny@suse.com,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,shuah@kernel.org
Cc: mingo@redhat.com,peterz@infradead.org,vincent.guittot@linaro.org,bsegall@google.com,dietmar.eggemann@arm.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,roman.gushchin@linux.dev,shakeel.butt@linux.dev,inwardvessel@gmail.com,mykolal@meta.com,ziyang.meme@gmail.com,linux-block@vger.kernel.org,bpf@vger.kernel.org,cgroups@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-kernel@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Thu, 20 Aug 2026 22:19:28 +0000 (UTC)

--===============4275236877747582368==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
> index ea7044f30adc..482b40dde2f9 100644
> --- a/tools/testing/selftests/bpf/config
> +++ b/tools/testing/selftests/bpf/config
> @@ -11,6 +11,9 @@ CONFIG_BPF_STREAM_PARSER=y
>  CONFIG_BPF_SYSCALL=y
>  # CONFIG_BPF_UNPRIV_DEFAULT_OFF is not set
>  CONFIG_CGROUP_BPF=y
> +CONFIG_CGROUP_SCHED=y
> +CONFIG_FAIR_GROUP_SCHED=y
> +CONFIG_CFS_BANDWIDTH=y
>  CONFIG_CRYPTO_HMAC=y
>  CONFIG_CRYPTO_SHA256=y
>  CONFIG_CRYPTO_USER_API=y

This isn't a bug, but CONFIG_CGROUP_SCHED already appears in all five
config.<arch> fragments (config.x86_64:30, config.aarch64:26,
config.s390x:19, config.ppc64el:17, config.riscv64:17), and
CONFIG_CFS_BANDWIDTH already appears in config.x86_64:24.

Now that they are in the common config, should the per-arch copies be
removed so each option lives in one place?

> diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_cpu.c b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_cpu.c
> new file mode 100644
> index 000000000000..cd7e92ababfb
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_cpu.c

[ ... ]

> @@ -0,0 +1,259 @@
> +void test_cgroup_iter_cpu(void)
> +{

[ ... ]

> +	/*
> +	 * cpu.stat cputime grows on every tick a task in the cgroup runs, so
> +	 * stop them all before comparing
> +	 */
> +	if (test__start_subtest("cgroup_iter_cpu__match")) {
> +		struct cpu_query filev = {};
> +		int i, stable = 0;
> +
> +		kill(hog, SIGSTOP);
> +		waitpid(hog, NULL, WUNTRACED);
> +		if (!ASSERT_OK(join_root_cgroup(), "join_root_cgroup"))
> +			goto cleanup_hog;
> +
> +		/*
> +		 * The period timer keeps adding to nr_periods for a while
> +		 * after the hog stops
> +		 */
> +		for (i = 0; i < 20; i++) {
> +			struct cpu_query before = {}, after = {};
> +
> +			if (!ASSERT_OK(parse_stats(cgroup_fd, &before, have_bw), "cpu.stat") ||
> +			    !ASSERT_OK(read_stats(link), "read stats") ||
> +			    !ASSERT_OK(parse_stats(cgroup_fd, &after, have_bw), "cpu.stat"))
> +				goto cleanup_hog;
> +
> +			if (!memcmp(&before, &after, sizeof(before))) {
> +				filev = before;
> +				stable = 1;
> +				break;
> +			}
> +			usleep(100000);
> +		}

This isn't a bug, but could the 20 iterations and usleep(100000) get names
the way cgroup_iter_memcg.c names MEMCG_STAT_RETRIES /
MEMCG_STAT_RETRY_DELAY_US, so the relationship to the 100ms cpu.max period
is visible?

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/32419919743
--===============4275236877747582368==--
