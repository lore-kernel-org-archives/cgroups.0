Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714860;
	b=cE/767WmUyhUaL7eSVVthFfNTr6RMU4Va2cAiIjj8Q7qoofJKOI/wiaq2DFqLLrGNsyj
	 +7WfQjhwFi/vlfrm9T672ocSevk15kUMmiLk2e1hYGGz8vftzpg7XEba/yhWEePdQ4Ocq
	 4rmAoVRjg1YxOnwmraVx44xTa2dL+bXaDZXzPc6RW4/i45Lrrks8J9imgecEJibM2Ucjn
	 exF/ZlasgoLwz4lfVGx26vGoqwr4ueOlhA2HU5FRuVlePen9qnHG5oOezRoPWniv5QVKW
	 mCBLvrClE4xML+2vH0gCZsPBnS9p7nlX8ERSqrXqrk4Bpy5MKSCq6uKt7uBHmQViovg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714860;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=qxI6uxKuEBsKWE5dZToQWARpMTqM0sfykaf/tV2OkQE=;
	b=iblv5MxGkDRCnV2kr6Q3r+uy4uLsxzxfij5bfQ8b5Zn/D52dePolAtRc0Tn1OKDxpETn
	 6jqTy5CYBwfJOrqlEpbKU4O0ZCfX3zZDQvq4W2VQkvOskg2jA+Q8SeuRz7ajTyhiHAY2u
	 nelnUUik+Don87yLonfeH/Af48joA8baAby1O0n70gDJtB58eJwyIO7oBj+6eHmmjvZJy
	 rDOsMyNGjX//EeHmQEozcWxEguqgGXCaplsJmLutf+mBghhcZ68X8a+d8HjpXSStThSOX
	 PIf8C5u7g2DFRSXM6NT7vVs81pM9bICmXYxeXJMtqDOIqtrAlg7fc61D5r1ZlqfdH9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kvAhsPMv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D020A606A336;
	Tue,  3 Nov 2026 14:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kvAhsPMv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18EF31F0093A;
	Tue,  3 Nov 2026 14:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793714859;
	bh=qxI6uxKuEBsKWE5dZToQWARpMTqM0sfykaf/tV2OkQE=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=kvAhsPMvD47M67OaIC8UcigKRO5xXurkov7sP13ENoG9Bu8aSgSd4XGyHHp+MHDbS
	 rjhyieqt2+LLMMTKTa2+Il1z6oGL8rZ60njQIpEmAmSgFE1U9O94psfATXjDm1SiO6
	 n0vptLQLV1S0wy7d/e0Psm4iNIMRXTyXVT43KLThvIyp6jFhniBDBdo2A4bsdIoGHJ
	 i+6OWJsxSz4S37woEi7UMx51fGMHxnh7Fo0o77QSy3WSfFk/yth/jEO6h5hh8aLa+8
	 EMadLU71WZDBZWr/ZemQM7hENGXMQ7RTvMbxpwUbfORwZSTzJlkD2YHzVISli31o5Z
	 8wvLAtpgk6ehw==
Content-Type: multipart/mixed; boundary="===============0895216361124977455=="
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <cdb4a70a69306fb920d52c3e5511bb1cbac094d4f47b1b89ae56b674853c287d@mail.kernel.org>
In-Reply-To: <20261103132613.1952975-4-cui.tao@linux.dev>
References: <20261103132613.1952975-4-cui.tao@linux.dev>
Subject: Re: [RFC PATCH v12 3/4] selftests/bpf: add iocost cost model test
From: bot+bpf-ci@kernel.org
To: cui.tao@linux.dev,tj@kernel.org,josef@toxicopanda.com,axboe@kernel.dk,alexei.starovoitov@gmail.com
Cc: cgroups@vger.kernel.org,linux-block@vger.kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,andrii@kernel.org,eddyz87@gmail.com,ast@kernel.org,daniel@iogearbox.net,linux-kselftest@vger.kernel.org,cui.tao@linux.dev,cuitao@kylinos.cn,ameryhung@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Tue,  3 Nov 2026 14:07:39 +0000 (UTC)

--===============0895216361124977455==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> selftests/bpf: add iocost cost model test

TL;DR: Selftest cgroup names "iocost_pairing" and "iocost_ms" lack a leading
'/', so the cgroups are likely created outside the work directory and not
removed by cleanup_cgroup_environment(), leaving empty cgroups on the host.

> diff --git a/tools/testing/selftests/bpf/prog_tests/iocost_model.c b/tools/testing/selftests/bpf/prog_tests/iocost_model.c
> new file mode 100644

[ ... ]

> +	/*
> +	 * cgroup_setup_and_join() creates the priced-IO cgroup with the
> +	 * available controllers enabled, so the cgroup has
> +	 * io.weight/io.stat and the iocg activates.
> +	 * cleanup_cgroup_environment() removes it from every exit path
> +	 * below. io.cost.qos and io.cost.model are root-only cgroupfs
> +	 * files: they are written at the hierarchy root and reverted on
> +	 * exit.
> +	 */
> +	cg = cgroup_setup_and_join("iocost_pairing");

[ ... ]

> +		cg = cgroup_setup_and_join("iocost_ms");

Will these cgroups actually be removed by cleanup_cgroup_environment()?

The name has no leading '/', and format_cgroup_path() in cgroup_helpers.c
joins the pieces with no separator:

    #define format_cgroup_path_pid(buf, path, pid) \
        snprintf(buf, sizeof(buf), "%s%s%d%s", CGROUP_MOUNT_PATH, \
        CGROUP_WORK_DIR, pid, path)

So cgroup_setup_and_join("iocost_pairing") ends up doing mkdir on
"/mnt/cgroup-test-work-dir<pid>iocost_pairing".  That is a sibling of the
work directory directly under the cgroup2 root, not a child of it.
join_cgroup(), write_cgroup_file() and read_cgroup_file() build the same
path, so the test itself works.

But __cleanup_cgroup_environment() only walks the work directory:

    format_cgroup_path(cgroup_workdir, "");
    join_cgroup_from_top(CGROUP_MOUNT_PATH);
    nftw(cgroup_workdir, nftwfunc, WALK_FD_LIMIT, FTW_DEPTH | FTW_MOUNT);

so the sibling directory is never visited.  The empty cgroup remains on the
host as /sys/fs/cgroup/cgroup-test-work-dir<pid>iocost_pairing, which also
contradicts the comment above ("cleanup_cgroup_environment() removes it from
every exit path below").  serial_test_iocost_model_streams() has the same
problem with "iocost_ms", including the matching write_cgroup_file() and
read_cost_usage() calls.

Other callers that use a fixed name pass a leading slash, for example
"/skb_cgroup_test" and "/cgroup_iter_memcg_test".  Would "/iocost_pairing"
and "/iocost_ms" at every place they are passed put the cgroups under the
work directory where the existing cleanup removes them?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/41646836440
--===============0895216361124977455==--
