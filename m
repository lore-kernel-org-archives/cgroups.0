Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754DD374731;
	Thu, 13 Aug 2026 20:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786652640; cv=none; b=g8Q9Uf1jeHsCfSsiUhyEoeZbmrWR4EIc4ndMyvCjD/iNC65+tSqN6tXbgHbaGRYDkDeu5E4FLiMnS4VsDEp40gI86JVjZCQ8EJU4JZO8bqsKZWTwUMVz3udhJTpsXpyMs5uHeEQQvue+3YP8IDhxqXwYGVxD9iQ7tR/fT2VS6Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786652640; c=relaxed/simple;
	bh=T5wAEzJv4iF1/SGKTvp5KP2qRQHsCm/z6niOhLL5f/U=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=oOXkXMd4QRBftozdmcAwN6Bgv3weVCRHgcjn7vrdiHAItwFvHlM2/DILrBbrGLlZUp+HPKTCIv+bcvhl1G4cGvZy1Ef9pV74f7ZfPqy8Mnt51cyO18N4mM3tGsUBYdbwg7B8tW7kzTMZJFXddZ2yNLpyqWrlA8gAdjJl5aPJhm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QTLojp5h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QTLojp5h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544171F000E9;
	Thu, 13 Aug 2026 20:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786652639;
	bh=M14rrKfhDsQztqpTGHq4c1dYRfUU9YM2XR8j0uQKwg4=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=QTLojp5hk2vqjR5FsoYu1GgtW4tEy1toa7tRDRMOxawYVEnUanoBXMWzzQJfQkLzs
	 /9ZGXHUk21tuXnfCFluFBAI1pC/a34rfaqhegRNBqRrxRiWRCJlFMr2dZVypFaERIA
	 UKtQ8rGUdUcomBDzfdvm3qmnp6Rggg2klOq10LWCaW9xBlVtQUyfq54E6fn6njfDfm
	 /k17EwEyMIQXM0JHERiz3MK0XUKa7MItVoa8LszaRSjlIFuL26Ffo9HCERdhrSIjkD
	 1MLx/Mpe7Cd2Wn9w+4koU/tXjuL1By4xa1RF3NMCux7h2zmHn4tacbj051Vj/w0EXu
	 1l9a7TesvCeyA==
Content-Type: multipart/mixed; boundary="===============2688683995907960340=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <da2e8c67481a53545b3170ad5ca0f8a0f05c40e08a3a158a20e58c828d627fd5@mail.kernel.org>
In-Reply-To: <20260813185846.1216892-3-ziyang.meme@gmail.com>
References: <20260813185846.1216892-3-ziyang.meme@gmail.com>
Subject: Re: [PATCH 2/2] selftests/bpf: add cgroup_iter_cpu test for cpu cgroup kfuncs
From: bot+bpf-ci@kernel.org
To: ziyang.meme@gmail.com,tj@kernel.org,hannes@cmpxchg.org,mkoutny@suse.com,mingo@redhat.com,peterz@infradead.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com
Cc: bsegall@google.com,juri.lelli@redhat.com,vincent.guittot@linaro.org,dietmar.eggemann@arm.com,rostedt@goodmis.org,mgorman@suse.de,vschneid@redhat.com,kprateek.nayak@amd.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,shuah@kernel.org,roman.gushchin@linux.dev,shakeel.butt@linux.dev,inwardvessel@gmail.com,mykolal@meta.com,ziyang.meme@gmail.com,kernel-team@meta.com,bpf@vger.kernel.org,cgroups@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-kernel@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Thu, 13 Aug 2026 20:23:57 +0000 (UTC)

--===============2688683995907960340==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> The userspace side runs a CPU hog in a test cgroup with cpu.max settled
> then:
>   - checks the CPU-time and throttling counters are nonzero,
>   - compares whether all values the program read are same as those
>     reading from cgroup file.

This isn't a bug, but could these two sentences be reworded? The phrase
"with cpu.max settled" is a bit unclear (the test writes a quota to
cpu.max), and "compares whether all values the program read are same as
those reading from cgroup file" has an article/verb agreement issue.
Perhaps "with a quota set in cpu.max" and "compares the values the program
read against those read from the cgroup files"?

Also, the test has to wait for cpu.stat to stop moving before it can
compare the two sources - would it be worth mentioning that retry loop
since it's the least obvious part of the test?

> CONFIG_CGROUP_SCHED, CONFIG_FAIR_GROUP_SCHED and CONFIG_CFS_BANDWIDTH
> are added to the test config.
>
> Tests passed on v7.2-rc5.
>
> Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Ziyang Men <ziyang.meme@gmail.com>

> diff --git a/tools/testing/selftests/bpf/cgroup_iter_cpu.h b/tools/testing/selftests/bpf/cgroup_iter_cpu.h
> new file mode 100644
> index 0000000000000..74599a5c0e4d9
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/cgroup_iter_cpu.h
> @@ -0,0 +1,22 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (c) 2025 Meta Platforms, Inc. and affiliates. */
> +#ifndef __CGROUP_ITER_CPU_H

This isn't a bug, but the copyright line here matches cgroup_iter_memcg.h
exactly - is the Meta Platforms attribution (and the 2025 year) the
intended one for these new files, or did it come along with the template?
The same line appears in all three new files (cgroup_iter_cpu.h,
prog_tests/cgroup_iter_cpu.c, progs/cgroup_iter_cpu.c), but the assigned
entity doesn't match the Signed-off-by address, and the year predates the
commit date (Aug 2026).

[ ... ]

> diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_cpu.c b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_cpu.c
> new file mode 100644

[ ... ]

> +static int read_stats(struct bpf_link *link)
> +{
> +	int fd, ret = 0;
> +	ssize_t bytes;
> +
> +	fd = bpf_iter_create(bpf_link__fd(link));
> +	if (!ASSERT_OK_FD(fd, "bpf_iter_create"))
> +		return 1;
> +
> +	bytes = read(fd, NULL, 0);
> +	if (!ASSERT_EQ(bytes, 0, "read fd"))
> +		ret = 1;
> +
> +	close(fd);
> +	return ret;
> +}

This isn't a bug, but read_stats() looks identical to the one in
cgroup_iter_memcg.c - would it be worth sharing it (and the comment
explaining the read(fd, NULL, 0) idiom) so the next .data.query-style
iter test can reuse it? The memcg version documents why read(fd, NULL, 0)
is the right way to run the iterator, whereas here a reader is left to
work out why reading zero bytes triggers the program.

[ ... ]

> +/* Parse the "cpu.stat" file into @out. */
> +static int parse_cpu_stat(int cgroup_fd, struct cpu_query *out)

[ ... ]

> +/*
> + * Parse the "cpu.stat.local" file into @out.
> + */
> +static int parse_cpu_stat_local(int cgroup_fd, struct cpu_query *out)

[ ... ]

> +/* Read file value the bpf program reads. */
> +static int parse_stats(int cgroup_fd, struct cpu_query *out, bool have_bw)

[ ... ]

> +/*
> + * Check whether this kernel accounts CFS bandwidth.
> + */
> +static bool cgroup_has_bw_stat(int cgroup_fd)

This isn't a bug, but would it read more consistently to use the
single-line comment form for the one-line banners on
parse_cpu_stat_local()/cgroup_has_bw_stat()? The file uses two different
forms for equally short one-sentence comments: single-line /* ... */ for
read_cgroup_file, parse_cpu_stat and parse_stats, but a three-line block
for parse_cpu_stat_local and cgroup_has_bw_stat.

Also, the parse_stats() comment "Read file value the bpf program reads" is
hard to parse and says nothing about the have_bw parameter, which is the
only thing about that function that isn't obvious from its body. And
"Check whether this kernel accounts CFS bandwidth" describes
cgroup_has_bw_stat() slightly more broadly than it acts, since reading
'nr_periods ' out of cpu.stat also depends on the cpu controller being
enabled for the cgroup, not only on the kernel config.

[ ... ]

> +	if (test__start_subtest("cgroup_iter_cpu__throttling")) {
> +		if (!have_bw) {
> +			test__skip();

A subsystem pattern flags this as potentially concerning: the
cgroup_iter_cpu__throttling subtest skips with a bare test__skip() and
prints nothing, so the log records a skip with no indication of which
prerequisite was absent. have_bw is the conjunction of two quite different
conditions -- wrote_max (the write to cpu.max succeeded) and
cgroup_has_bw_stat() (cpu.stat contains 'nr_periods ', i.e. the kernel was
built with CONFIG_CFS_BANDWIDTH) -- and the skip collapses both into no
output.

Could a printf("%s:SKIP:...", __func__) naming the missing prerequisite be
added before test__skip()? That would make the skip self-describing for
someone reading a CI log who can't tell whether the kernel lacks
CONFIG_CFS_BANDWIDTH, the cpu controller was not delegated, or the cpu.max
write failed for some other reason.

[ ... ]

> diff --git a/tools/testing/selftests/bpf/progs/cgroup_iter_cpu.c b/tools/testing/selftests/bpf/progs/cgroup_iter_cpu.c
> new file mode 100644

[ ... ]

> +	bpf_rcu_read_lock();
> +	css = cgrp->subsys[cpu_cgrp_id];
> +	tg = (struct task_group *)css;
> +	if (tg && bpf_core_field_exists(tg->cfs_bandwidth.nr_periods)) {
> +		cpu_query.nr_periods =
> +			(__u32)BPF_CORE_READ(tg, cfs_bandwidth.nr_periods);
> +		cpu_query.nr_throttled =
> +			(__u32)BPF_CORE_READ(tg, cfs_bandwidth.nr_throttled);
> +		cpu_query.throttled_usec =
> +			BPF_CORE_READ(tg, cfs_bandwidth.throttled_time) / 1000;
> +		cpu_query.nr_bursts =
> +			(__u32)BPF_CORE_READ(tg, cfs_bandwidth.nr_burst);
> +		cpu_query.burst_usec =
> +			BPF_CORE_READ(tg, cfs_bandwidth.burst_time) / 1000;
> +	}
> +	bpf_rcu_read_unlock();

This isn't a bug, but would it read more consistently to fetch the
cpu_cgrp_id index with bpf_core_enum_value(enum cgroup_subsys_id,
cpu_cgrp_id), the way cgroup_iter_memcg.c and profiler.inc.h do? The
struct field chain right below is accessed CO-RE style (with
bpf_core_field_exists and BPF_CORE_READ), but the array index cpu_cgrp_id
is compiled in as a plain enum constant from vmlinux.h with no relocation.
enum cgroup_subsys_id's numbering shifts with the set of enabled
controllers, so the two halves of this access are hardened differently.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/31735302699
--===============2688683995907960340==--
