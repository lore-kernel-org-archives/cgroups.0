Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE9E23D28C;
	Fri, 23 Jan 2026 09:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769159949; cv=none; b=HS9SzE6r+ywlAk4xnvIhcWYosUw+1MfB0UQ5JYq/tnNnNthODfOu914zguMXwMlLBMwZZAeP0C7wFHqTDrNcIT9i5C6gxB/yBIQ0JoeLe5aamYXgQqCw3tylPBc0NjaijfaoI72lbkeGqV9aBRZ0hsoyj/pj6wSD9nB3t/DVX3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769159949; c=relaxed/simple;
	bh=H12UDh2LI6aLgmcHOsAxDY/SKGsGeNOCjHscsd4qfzU=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=D2qvkM7n4IPfuDNHSHSY7MZCCesAuSielA1toU3i4OAdt8iRS7vyl+N2fmGzXpFIgWR8cDjXDmjkrpLbiiKRzdU5Sg1DqN7FrNnoEPYv7D4eEbptas0kXUHjzLBd06Rydzrr4dcZHju+Btcwc84XFHnory67Bdx5aQa9EvSGEyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CobmJcP0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CobmJcP0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6A4C4CEF1;
	Fri, 23 Jan 2026 09:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769159948;
	bh=H12UDh2LI6aLgmcHOsAxDY/SKGsGeNOCjHscsd4qfzU=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=CobmJcP0dYaI8MHKuRjINgU6o4ybjdtD/skBYy1WVINmCZGH/jgqb8ez7lXxcnnfL
	 7b8wmFduH+OQHTuBY4MhX5RGK2quSii5I6twltTi2BT6pdkhtMzjTqHTjnSU3i5hoM
	 Sbu5josCT9Tu7c7hqqpqLAUlwxNoOsvaDKGS2iW2EBUXLh+KbDok7zhwMhrKjQ/y4w
	 YfnCEZji+S6hyOBYcFmCEdW9YwU0xujNVeeKEa7W90jUDNPf/p8otTwdTaBHZMlaV4
	 986B1olKGrlwA6B94ODvJGxHRL1WDbV1VQJh5Kr6Vq92MbNIc0xuy28O4vXwAM5xK1
	 DKG8ru1UP/gkA==
Content-Type: multipart/mixed; boundary="===============3584986258708126564=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <9ab6aaa78c0dcba8b563eab2807eccb0c24bd14fa02d7417cff4284204de7d2d@mail.kernel.org>
In-Reply-To: <c44accaaaebfc32be13234f82b501a3852ba3f0f.1769157382.git.zhuhui@kylinos.cn>
References: <c44accaaaebfc32be13234f82b501a3852ba3f0f.1769157382.git.zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH bpf-next v3 09/12] selftests/bpf: Add tests for memcg_bpf_ops
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev,akpm@linux-foundation.org,hannes@cmpxchg.org,mhocko@kernel.org,roman.gushchin@linux.dev,shakeel.butt@linux.dev,muchun.song@linux.dev,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,martin.lau@linux.dev,eddyz87@gmail.com,song@kernel.org,yonghong.song@linux.dev,john.fastabend@gmail.com,kpsingh@kernel.org,sdf@fomichev.me,haoluo@google.com,jolsa@kernel.org,shuah@kernel.org,peterz@infradead.org,ojeda@kernel.org,nathan@kernel.org,kees@kernel.org,tj@kernel.org,jeffxu@chromium.org,mkoutny@suse.com,kernel@jfarr.cc,brauner@kernel.org,rdunlap@infradead.org,brgerst@gmail.com,masahiroy@kernel.org,davem@davemloft.net,kuba@kernel.org,hawk@kernel.org,inwardvessel@gmail.com,willemb@google.com,kerneljasonxing@gmail.com,paul.chaignon@gmail.com,a.s.protopopov@gmail.com,ameryhung@gmail.com,chenridong@huaweicloud.com,lance.yang@linux.dev,jiayuan.chen@linux.dev,linux-kernel@vger.kernel.org,linux-mm@kvack.org,cgroups@vger.kernel.org,bpf@vger.kernel.org,netdev@vger.kernel.org,linux-kselftest@vger.kernel.org
Cc: zhuhui@kylinos.cn,geliang@kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Fri, 23 Jan 2026 09:19:07 +0000 (UTC)

--===============3584986258708126564==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_ops.c b/tools/testing/selftests/bpf/prog_tests/memcg_ops.c
> new file mode 100644
> index 000000000000..9a8d16296f2d
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/memcg_ops.c

[ ... ]

> +static void real_test_memcg_ops(int read_times)
> +{
> +	int ret;
> +	char data_file1[] = "/tmp/test_data_XXXXXX";
> +	char data_file2[] = "/tmp/test_data_XXXXXX";
> +	char time_file1[] = "/tmp/test_time_XXXXXX";
> +	char time_file2[] = "/tmp/test_time_XXXXXX";
> +	pid_t pid1, pid2;
> +	double time1, time2;

[ ... ]

> +	pid1 = fork();
> +	if (!ASSERT_GE(pid1, 0, "fork"))
> +		goto cleanup;
> +	if (pid1 == 0)
> +		real_test_memcg_ops_child_work(CG_LOW_DIR,
> +					       data_file1,
> +					       time_file1,
> +					       read_times);
> +
> +	pid2 = fork();
> +	if (!ASSERT_GE(pid1, 0, "fork"))
                       ^^^^

Should this check pid2 instead of pid1?  After assigning pid2 = fork(),
checking pid1 means a failed second fork() would go undetected if the
first fork() succeeded.

> +		goto cleanup;
> +	if (pid2 == 0)
> +		real_test_memcg_ops_child_work(CG_HIGH_DIR,
> +					       data_file2,
> +					       time_file2,
> +					       read_times);

[ ... ]

> +void test_memcg_ops_over_high(void)
> +{
> +	int err, map_fd;
> +	struct memcg_ops *skel;
              ^^^^^^^^^^^^^^^

The skel variable is not initialized to NULL here.  If setup_cgroup()
fails early and jumps to the out label, memcg_ops__detach(skel) would
be called with an uninitialized pointer.

Also, the cleanup path calls memcg_ops__detach() but never calls
memcg_ops__destroy().  Would this leak the skeleton object and its
associated BPF resources?

> +	struct bpf_map *map;
> +	size_t bss_sz;
> +	struct memcg_ops__bss *bss_data;
> +	__u32 key = 0;
> +	struct bpf_program *prog = NULL;
> +	struct bpf_link *link = NULL, *link2 = NULL;
> +	DECLARE_LIBBPF_OPTS(bpf_struct_ops_opts, opts);
> +	int high_cgroup_id, low_cgroup_fd = -1;
> +
> +	err = setup_cgroup(&high_cgroup_id, &low_cgroup_fd, NULL);
> +	if (!ASSERT_OK(err, "setup_cgroup"))
> +		goto out;
> +
> +	skel = memcg_ops__open_and_load();

[ ... ]

> +out:
> +	bpf_link__destroy(link);
> +	bpf_link__destroy(link2);
> +	memcg_ops__detach(skel);
> +	close(low_cgroup_fd);
> +	cleanup_cgroup_environment();
> +}

[ ... ]

> +void test_memcg_ops_below_low_over_high(void)
> +{
> +	int err, map_fd;
> +	struct memcg_ops *skel;

Same issue here - skel is not initialized to NULL.

[ ... ]

> +out:
> +	bpf_link__destroy(link);
> +	bpf_link__destroy(link_high);
> +	bpf_link__destroy(link_low);
> +	memcg_ops__detach(skel);

[ ... ]

> +void test_memcg_ops_below_min_over_high(void)
> +{
> +	int err, map_fd;
> +	struct memcg_ops *skel;

Same issue here as well - skel is not initialized to NULL.

[ ... ]

> +out:
> +	bpf_link__destroy(link);
> +	bpf_link__destroy(link_high);
> +	bpf_link__destroy(link_low);
> +	memcg_ops__detach(skel);
> +	close(high_cgroup_fd);
> +	close(low_cgroup_fd);
> +	cleanup_cgroup_environment();
> +}


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21280790825

--===============3584986258708126564==--
