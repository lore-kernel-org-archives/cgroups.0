Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852E48834;
	Tue, 18 Aug 2026 01:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787016530; cv=none; b=f+W9rhZBeZA2Mp7lV9aOtDmGY7NB6WQMyY4FHl02iyRG08iy6W0KVNIPB0PvJvbNlPF1J54C7FOIMgfthYuAMPLGtRFfnRaUcxE7q0U+tu3ATJmEHOA3Uudt3O6QF4siMSYr2eKp+JfGf7yFrPkvjZI0K0G1JFzUbOd+G6Is/FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787016530; c=relaxed/simple;
	bh=og5xkeICHTXYTm7Wwls2dvjb5/fe9gky8XSFG+OTibs=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=STHSyfhG/c9DIqcRimbpkKlSF0hkk6UbvArO5Fc1mMOMqIPntKKqrVqHJvpSFn4l/XlDPdaBmTDBeXdonamuDSnRtQJxrL/y5TxfmR8guF/dQDfEZmRe+tg/zmw+DnnWlBmzCG0QouIfAWgeHJ1oWM07pXt0wyHqlrzObKAK3Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HHf9Dbme; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HHf9Dbme"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4A21F000E9;
	Tue, 18 Aug 2026 01:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787016529;
	bh=fBoCeUoxD98xjMKeJ6JPNt69lnp6W0TuVpy5iPOOoOA=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=HHf9DbmeCAQBVHVfHXTsbrBFrX559HoBW0tgOqX46ZuckjIPKImVmY7AtIdyxpqZF
	 s7Un6GfPcaT/VL0UoIKNpFKyBXy3b2O5V555Efx4Isv2T/nnBGFNHSGrbEmCrGr4xZ
	 j6FwKxK/ADJrAgHLbKgtwZ6I+VidUk8lAjvwRC7ZsOUnupHcMcZg4DM/C0v8Y8G02u
	 dKbcBFUmyXd9LJlitx9Dpg2a3Oday3Q6QWOFa279fCf3paYjze8OskAdijsv2Oew6X
	 tcOO245SvACJ9zeYjib7fp7wfxg3N9YhuL09M+vXoUVVHS0ob8hlutmWB2MZyLXY2b
	 BRtkhrmCsmrrQ==
Content-Type: multipart/mixed; boundary="===============2544612169039222862=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <a075bb6f6a05290bd2d0a9caafe7d612b836031676de3ac8f03b232bb5a4ecb5@mail.kernel.org>
In-Reply-To: <20260818002450.3071325-3-ziyang.meme@gmail.com>
References: <20260818002450.3071325-3-ziyang.meme@gmail.com>
Subject: Re: [PATCH v2 2/2] selftests/bpf: add cgroup_iter_cpu test for cpu cgroup kfuncs
From: bot+bpf-ci@kernel.org
To: ziyang.meme@gmail.com,tj@kernel.org,hannes@cmpxchg.org,mkoutny@suse.com,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,shuah@kernel.org,kernel-team@meta.com
Cc: mingo@redhat.com,peterz@infradead.org,vincent.guittot@linaro.org,bsegall@google.com,dietmar.eggemann@arm.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,roman.gushchin@linux.dev,shakeel.butt@linux.dev,inwardvessel@gmail.com,ziyang.meme@gmail.com,bpf@vger.kernel.org,cgroups@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-kernel@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Tue, 18 Aug 2026 01:28:47 +0000 (UTC)

--===============2544612169039222862==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> commit 0dbd10c9717fb724b55b28346bbbbe9e5e570bc6
> Author: Ziyang Men <ziyang.meme@gmail.com>
> Date:   Mon Aug 17 17:24:50 2026 -0700
>
>     selftests/bpf: add cgroup_iter_cpu test for cpu cgroup kfuncs
>
>     Add cgroup_iter_cpu, a selftest for the CPU controller BPF kfuncs.
>
>     The userspace side runs a CPU hog in a test cgroup with cpu.max settled
>     then:
>
>       - checks the CPU-time and throttling counters are nonzero,
>       - compares whether all values the program read are same as those
>         reading from cgroup file.
>
>     Enable CONFIG_CGROUP_SCHED, CONFIG_FAIR_GROUP_SCHED and
>     CONFIG_CFS_BANDWIDTH in the selftest config.
>
>     Tested on VM with v7.2-rc5.
>
>     Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
>     Assisted-by: Claude:claude-opus-5
>     Signed-off-by: Ziyang Men <ziyang.meme@gmail.com>

This isn't a bug, but could the changelog body be split into paragraphs
so it's clearer what state the cgroup is put in and which values are
compared?

The sentence "with cpu.max settled" doesn't say what quota is written
(the test writes "10000 100000"), and "compares whether all values the
program read are same as those reading from cgroup file" is missing
words that would indicate which side is being read from where.

Rewording might help, something like: "runs a CPU hog in a test cgroup
with a cpu.max quota set, then checks that the CPU-time and throttling
counters are nonzero and that every value the BPF program reports
matches the corresponding value read from cpu.stat and cpu.stat.local."

> diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_cpu.c b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_cpu.c
> new file mode 100644
> index 000000000000..cd7e92ababfb

[ ... ]

> +/* Read cgroup file @name into @buf. */
> +static int read_cgroup_file(int cgroup_fd, const char *name, char *buf,
> +			    size_t size)
> +{
> +	ssize_t n;
> +	int fd;
> +
> +	fd = openat(cgroup_fd, name, O_RDONLY);
> +	if (fd < 0)
> +		return -1;
> +	n = read(fd, buf, size - 1);
> +	close(fd);
> +	if (n <= 0)
> +		return -1;
> +	buf[n] = '\0';
> +	return 0;
> +}

This isn't a bug, but since cgroup_helpers.h already has
write_cgroup_file() but no reader, would read_cgroup_file() be better
placed next to it in cgroup_helpers.c so other tests can use it?

It's a generic "read any cgroup file into a buffer" helper with nothing
cpu-specific in it.

> diff --git a/tools/testing/selftests/bpf/progs/cgroup_iter_cpu.c b/tools/testing/selftests/bpf/progs/cgroup_iter_cpu.c
> new file mode 100644
> index 000000000000..22b9bb62d910

[ ... ]

> +	if (tg && bpf_core_field_exists(tg->cfs_rq) &&
> +	    bpf_core_field_exists(struct cfs_rq, throttled_clock_self_time)) {
> +		__u32 mask_bytes = bpf_core_type_size(struct cpumask);
> +		__u32 full_words = mask_bytes / sizeof(__u64);
> +		int *cpu;
> +
> +		if (full_words)
> +			bpf_for_each(bits, cpu,
> +				     (const __u64 *)&__cpu_possible_mask,
> +				     full_words)
> +				throttled_self += read_throttled_self(tg, *cpu);
> +
> +		if (mask_bytes & (sizeof(__u64) - 1)) {
> +			__u32 tail = 0;
> +			const void *src = (const char *)&__cpu_possible_mask +
> +					  full_words * sizeof(__u64);
> +			int bit;
> +
> +			if (!bpf_probe_read_kernel(&tail, sizeof(tail), src))
> +				bpf_for(bit, 0, 32)
> +					if (tail & (1U << bit)) {
> +						__u32 tail_cpu = full_words * 64 + bit;
> +
> +						throttled_self +=
> +							read_throttled_self(tg, tail_cpu);
> +					}
> +		}
> +	}

This isn't a bug, but since struct cpumask is an array of unsigned long,
sizeof() is always a multiple of 8 on 64-bit, so the `mask_bytes &
(sizeof(__u64) - 1)` tail path never fires there - is 32-bit coverage
the intent here, and if so would a comment saying so help?

The `if (full_words)` guard also looks droppable given
bpf_for_each(bits, ..., 0) is already a valid no-op
(verifier_bits_iter.c:zero_words).


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/32085852351
--===============2544612169039222862==--
