Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876F83E49EF;
	Mon, 17 Aug 2026 22:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787006473; cv=none; b=bX7A/rn17OzE7fmJZD+E9MTk6W2nmaQ1qJVh22eja6j8MiLUY4Uj5mytoGSCG1+3xlHpEJe6IC1e8eYEDnZMntdKIsUUy0R1rxtDP1Ud07Hlfq6yRc5HhFJV/qEN4znxkqw7iHS8NdTB5uR7lcfabb8SfJPNDGHafiKJo5rUITc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787006473; c=relaxed/simple;
	bh=pJhiTi2WjG+UwckurB0y6S62giZKo3H/muZ+iww0i3Q=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=PbSA8ZhpakwHl3s9X6jOJd/o/Z+uwY5w5kK70YX5Y5F93g4tieE6ZRb6FWHdJo2V5UGVnIpEYgrwF/yb+vnz9kRPShvxlUIE6VtSeFf3r5vRlRwsCibZT7rqJ09gkgfCHC9bO0o3/WFw7ul+NCTusbMqqnfTgm8qo9pIZ7XfM+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NfcIO7g2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NfcIO7g2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12BBE1F000E9;
	Mon, 17 Aug 2026 22:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787006472;
	bh=3Eukp0DI+aP2WotmUqNNQK3rVO2jtU0r+TlvTtkTbnE=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=NfcIO7g2iCSJIPnBANpljDSsRvfLX90+Zz3WJHVGhn/mF3fY6cGux6V0laxj1VOru
	 GsHIw0CUG0rkAcAfKfTFfr+7k9hYKD7oSWEQHzioIIh4IYkWbslKdF61929gqjamty
	 PLz7bOSA5TIJhvbFNfe/aRAmm5VX+B+4i3BjZIsLhH3yFO23Q1NJjqEXVKqVqW/wTF
	 RMabw2E4wUutPvUKzoYBJrFoSujabbrr1Vt74aSQ23PuBdt8MgrGEr7XZQScMxbA+z
	 lhX2OMwJLfk857BNQgQr1npX9qME2Zp6OUJTrZ5bNmQqYYlp9SWytlZ2PqJ1C62bnZ
	 p2BMV0HfD8LeQ==
Content-Type: multipart/mixed; boundary="===============5757239092342700876=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <a975eb66494d30339381bd1f15673053ef5e0fa5a96f11e1486f35d20c6fa0ae@mail.kernel.org>
In-Reply-To: <20260817214205.723267-3-ziyang.meme@gmail.com>
References: <20260817214205.723267-3-ziyang.meme@gmail.com>
Subject: Re: [PATCH v2 2/2] selftests/bpf: add test for blkcg io.stat BPF kfuncs
From: bot+bpf-ci@kernel.org
To: ziyang.meme@gmail.com,kernel-team@meta.com,axboe@kernel.dk,tj@kernel.org,josef@toxicpanda.com,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com
Cc: martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,shuah@kernel.org,hannes@cmpxchg.org,mkoutny@suse.com,roman.gushchin@linux.dev,shakeel.butt@linux.dev,inwardvessel@gmail.com,mykolal@meta.com,ziyang.meme@gmail.com,linux-block@vger.kernel.org,bpf@vger.kernel.org,cgroups@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-kernel@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Mon, 17 Aug 2026 22:41:11 +0000 (UTC)

--===============5757239092342700876==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/cgroup_iter_io.h b/tools/testing/selftests/bpf/cgroup_iter_io.h
> new file mode 100644
> index 000000000000..f4bbaaccdf71
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/cgroup_iter_io.h

[ ... ]

> diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
> index ea7044f30adc..270e6bf9194d 100644
> --- a/tools/testing/selftests/bpf/config
> +++ b/tools/testing/selftests/bpf/config

[ ... ]

> diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_io.c b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_io.c
> new file mode 100644
> index 000000000000..5d27e5d28379
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_io.c
> @@ -0,0 +1,277 @@

[ ... ]

> +/* Set up a loop device for cgroup-charged I/O. */
> +static int loop_setup(char *loop_path, size_t sz, int *ctl_fd, int *loop_fd,
> +		      int *back_fd)
> +{
> +	char back_path[] = "/tmp/cgroup_iter_io.XXXXXX";
> +	int nr;
> +
> +	*ctl_fd = *loop_fd = *back_fd = -1;
> +
> +	*ctl_fd = open("/dev/loop-control", O_RDWR | O_CLOEXEC);
> +	if (*ctl_fd < 0)
> +		return -1;
> +
> +	nr = ioctl(*ctl_fd, LOOP_CTL_GET_FREE);
> +	if (nr < 0)
> +		goto err;
> +	snprintf(loop_path, sz, "/dev/loop%d", nr);
> +
> +	*back_fd = mkstemp(back_path);
> +	if (*back_fd < 0)
> +		goto err;
> +	unlink(back_path);
> +	if (ftruncate(*back_fd, (off_t)IO_SIZE * 4))
> +		goto err;
> +
> +	*loop_fd = open(loop_path, O_RDWR | O_CLOEXEC);
> +	if (*loop_fd < 0)
> +		goto err;
> +	if (ioctl(*loop_fd, LOOP_SET_FD, *back_fd))
> +		goto err;
> +
> +	return 0;
> +err:
> +	if (*loop_fd >= 0)
> +		close(*loop_fd);
> +	if (*back_fd >= 0)
> +		close(*back_fd);
> +	close(*ctl_fd);
> +	*ctl_fd = *loop_fd = *back_fd = -1;
> +	return -1;
> +}

Does the err: cleanup path leak the loop device?

LOOP_CTL_GET_FREE can allocate a new loop device when no unbound device
exists, and nr is stored. Every failure after that point (mkstemp,
ftruncate, open(/dev/loopN), LOOP_SET_FD) leaves that device behind.

The caller jumps straight to cleanup_cgroup_fd on loop_setup() failure,
bypassing cleanup_loop, so loop_teardown() never runs and the device
remains allocated.

Recording nr and calling ioctl(*ctl_fd, LOOP_CTL_REMOVE, nr) on the err:
path would fix this. Additionally, loop_teardown() ignores the return of
both LOOP_CLR_FD and LOOP_CTL_REMOVE, so a device left in Lo_bound state
also leaks silently.

> +/* Read @dev's io.stat counters. @dev uses kernel dev_t encoding. */
> +static int parse_io_stat(int cgroup_fd, __u64 dev, struct io_query *out)
> +{
> +	unsigned int want_maj = dev >> 20, want_min = dev & ((1U << 20) - 1);
> +	char buf[4096], *line, *saveptr;
> +	int fd, n, ret = -1;
> +
> +	fd = openat(cgroup_fd, "io.stat", O_RDONLY);
> +	if (fd < 0)
> +		return -1;
> +	n = read(fd, buf, sizeof(buf) - 1);
> +	close(fd);
> +	if (n <= 0)
> +		return -1;
> +	buf[n] = '\0';

Will a single 4095-byte read() always capture the complete io.stat output?

io.stat is a seq_file with one line per blkg, and seq_read_iter() copies
with byte granularity, not record boundaries. Two failure modes:

1. If the cgroup's blkg list produces more than 4095 bytes, the loop
device's line may not be in the buffer, and parse_io_stat() returns -1.

2. The cut can land mid-line. A truncated line like "7:0 rbytes=4194304
wbytes=41" satisfies the '< 2' check below and is accepted with the
remaining counters silently zero, producing a bogus counter mismatch
against the kfunc rather than a parse error.

Reading in a loop until read() returns 0, or at least treating a non-
terminated final line as an error, would avoid both.

> +	for (line = strtok_r(buf, "\n", &saveptr); line;
> +	     line = strtok_r(NULL, "\n", &saveptr)) {
> +		unsigned long long rb = 0, wb = 0, ri = 0, wi = 0, db = 0, di = 0;
> +		unsigned int maj, min;
> +
> +		/* Only the device id is required; missing counters stay zero. */
> +		if (sscanf(line,
> +			   "%u:%u rbytes=%llu wbytes=%llu rios=%llu wios=%llu dbytes=%llu dios=%llu",
> +			   &maj, &min, &rb, &wb, &ri, &wi, &db, &di) < 2)
> +			continue;
> +		if (maj != want_maj || min != want_min)
> +			continue;
> +
> +		out->rbytes = rb;
> +		out->wbytes = wb;
> +		out->rios = ri;
> +		out->wios = wi;
> +		out->dbytes = db;
> +		out->dios = di;
> +		ret = 0;
> +		break;
> +	}
> +	return ret;
> +}

Should the partial conversion check be stricter?

Accepting '< 2' and then returning success means a line that matched the
device but whose counters were not parsed is reported as all-zero rather
than an error. The caller immediately uses strict equality checks:

	ASSERT_EQ(q->dbytes, filev.dbytes, "dbytes");

so a parse problem is reported as a counter mismatch against the kfunc,
pointing at the kernel instead of the parser.

This is reachable because blkcg_print_one_stat() emits the device name
unconditionally but gates the counter group with:

	if (rbytes || wbytes || rios || wios)
		seq_printf(s, "rbytes=%llu wbytes=%llu ... dios=%llu", ...);

A cgroup whose only traffic to a device was discard produces "MAJ:MIN "
with no key=value pairs. sscanf() returns 2, parse_io_stat() returns
success with dbytes=dios=0, and the match subtest fails on "dbytes" even
though the kernel is correct.

Requiring all eight conversions (== 8) once maj:min matches would surface
the real problem.

[ ... ]

> +	if (loop_setup(loop_path, sizeof(loop_path), &ctl_fd, &loop_fd, &back_fd)) {
> +		test__skip();	/* needs root + CONFIG_BLK_DEV_LOOP */
> +		goto cleanup_cgroup_fd;
> +	}

A subsystem pattern flags this as potentially concerning:

loop_setup() collapses eight distinct failures into a single -1, and the
caller turns every one of them into a bare test__skip() with no runtime
reason. The source comment says "needs root + CONFIG_BLK_DEV_LOOP", but
the same return value is produced by: open("/dev/loop-control") failing,
LOOP_CTL_GET_FREE failing, mkstemp() failing, ftruncate() failing (ENOSPC
on a small tmpfs /tmp), open("/dev/loopN") failing, and LOOP_SET_FD
failing.

The LOOP_SET_FD case is a genuine race: LOOP_CTL_GET_FREE is not a
reservation, so any concurrent consumer (another test_progs worker under
-j, udev, systemd, losetup) can bind /dev/loopN between GET_FREE and
SET_FD, and SET_FD then returns EBUSY. The result is that the whole test,
including all five subtests exercising the new blkcg kfuncs, silently
reports SKIP. Since nothing is printed, CI shows a green skip and a broken
kfunc goes unnoticed indefinitely.

Could the errno be printed before skipping, and "prerequisite absent"
(ENOENT/ENODEV/EPERM on /dev/loop-control) be distinguished from a real
failure (EBUSY, ENOSPC, ENOMEM)?

[ ... ]

> diff --git a/tools/testing/selftests/bpf/progs/cgroup_iter_io.c b/tools/testing/selftests/bpf/progs/cgroup_iter_io.c
> new file mode 100644
> index 000000000000..2cd538068987
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/cgroup_iter_io.c

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/32073368069
--===============5757239092342700876==--
