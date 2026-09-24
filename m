Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E468D30E0CC;
	Thu, 24 Sep 2026 06:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790231414; cv=none; b=QBgFGI3YXa87yFuAwxypZGLH01FEjcR+zDs1hRvoU3azwkveJ+4lXO2Mtehbsyu8RWic5HHsv/1lw88YJ5ieWDZyqT9UR3JQygMW33L+DRre5ayU6S8GuG+qf8QksPLCH48XW1gpT+YuKnBzB7BHGfC8SbtIjAryp+Y1jo9xbgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790231414; c=relaxed/simple;
	bh=t+tIvd7uqEf1f6LwP+9o2kdH7x86lDHMcSrJONs98Dc=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=U3A2y7Wt8QLMkgUL2EmoggE5eHH+X4DB4sm7mQdT1a7luRnzsuZJm//6hdkz3A52bRD7ddG/Gbne/qBVXvjLnxNLpzhO06G7cDamxd2kUTDxKYK/BA8renwWsQLFGJNzsJeBwrekODTjCuBF4iSYm/3HxhUQKkJcXhTBNWUPoY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cTJAjCpy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cTJAjCpy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 419561F000FF;
	Thu, 24 Sep 2026 06:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790231412;
	bh=uvkvGa8eLCS8bv228xMX5YNhuFyAcnvMiHTYL/NBW6I=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=cTJAjCpyWJ/dVAXE/xBtLaQo+vz+GHMB1rf0XnzQmgaF5DQC/RFWKFgX9Hh6shxJi
	 u1ALVOVScAx5RnWwDXvvshuu8pz27FOFpsyd0HGewMbrSrWyKwh0Lx63IcJk1QmDwI
	 snsFhCY9vsdGkc35y37l8U1S3kYgHnSuRG9LHLYXLA6VWvFmQlw+lfxq5ZGMfP5iX+
	 vDe//fG8ZOrcaNKsEsLPwheljlgScu0Tg5vsry+HDulRaFLZz8o3a/+8aIxOKMt64K
	 TRSBAfWQQmSH/8IlZjMRjHzuliMXencO6KW7sWNjeM0v15lYAIl0TujThM4JASUrk4
	 iopeAm1UtPrPQ==
Content-Type: multipart/mixed; boundary="===============5958733685988634967=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <ba40303966f4ff1232d01ad0b481ed69c9ed30d6beec4fbba43e5836ed8bc975@mail.kernel.org>
In-Reply-To: <20260924054549.2271705-3-cui.tao@linux.dev>
References: <20260924054549.2271705-3-cui.tao@linux.dev>
Subject: Re: [RFC PATCH v7 2/4] selftests/bpf: add iocost cost model test
From: bot+bpf-ci@kernel.org
To: cui.tao@linux.dev,tj@kernel.org,josef@toxicopanda.com,axboe@kernel.dk
Cc: cgroups@vger.kernel.org,linux-block@vger.kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,andrii@kernel.org,eddyz87@gmail.com,ast@kernel.org,daniel@iogearbox.net,linux-kselftest@vger.kernel.org,cui.tao@linux.dev,cuitao@kylinos.cn,ameryhung@gmail.com,alexei.starovoitov@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Thu, 24 Sep 2026 06:30:10 +0000 (UTC)

--===============5958733685988634967==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/prog_tests/iocost_model.c b/tools/testing/selftests/bpf/prog_tests/iocost_model.c
> new file mode 100644
> index 000000000000..156c75367af0
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/iocost_model.c
> @@ -0,0 +1,182 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +#include <fcntl.h>
> +#include <sys/sysmacros.h>
> +#include <unistd.h>
> +#include "iocost_model.skel.h"
> +#include "iocost_ms.skel.h"
> +
> +/*

[ ... ]

> +/*
> + * Attach the example model to one device, given as major:minor in
> + * $IOCOST_TEST_DEV: the dev member is written through the struct_ops
> + * map's initial value before load, as hid_bpf_ops does with hid_id,
> + * and loading attaches the model to the device.  Detaching the
> + * struct_ops restores the builtin model.

Is this description accurate?  The comment says "loading attaches the
model to the device", but the code and commit message indicate otherwise.

For non-link SEC(".struct_ops") maps, the kernel only calls .reg from
bpf_struct_ops_map_update_elem(), and libbpf issues that BPF_MAP_UPDATE_ELEM
only from bpf_map__attach_struct_ops().  So the attach happens during
iocost_model__attach(), not during iocost_model__load().

The test itself relies on this distinction.  It calls
iocost_model__load(second) at line 103 while the first model is attached and
expects the load to succeed (line 103, ASSERT_OK(err, "second_load")).  The
-EBUSY failure is expected only from bpf_map__attach_struct_ops() at line
110.  The commit message also says "attaching the struct_ops attaches the
model to the device".

Should the comment say "attaching" rather than "loading"?

> + * Requires root, cgroup v2 and a device with iocost support.
> + */
> +void serial_test_iocost_model(void)
> +{
> +	struct iocost_model *skel, *second;
> +	unsigned int maj, min;
> +	__u64 *ops_dev, *sdev;
> +	int err;
> +	char model[32], *dev;
> +
> +	dev = getenv("IOCOST_TEST_DEV");
> +	if (!dev || geteuid() != 0 || sscanf(dev, "%u:%u", &maj, &min) != 2) {
> +		test__skip();
> +		return;
> +	}

A subsystem pattern flags this as potentially concerning: both
serial_test_iocost_model() and serial_test_iocost_model_streams() call
test__skip() without printing a message.  Three different conditions lead
there: IOCOST_TEST_DEV not set, not running as root, or a malformed
major:minor string.  Since IOCOST_TEST_DEV is never set in CI, these tests
are always skipped, and nothing in the output explains that
IOCOST_TEST_DEV=<maj>:<min> is needed to run them.

Many prog_tests print a short message before test__skip() to explain why
(like "printf(\"%s:SKIP: set IOCOST_TEST_DEV=<maj>:<min>\\n\", __func__);").
test_progs still prints a SKIP status line for the test, so the skip is not
entirely silent, but the message would tell a developer how to opt in.

Also, ioc_bpf_attach() returns -EOPNOTSUPP when the device's queue is not
blk-mq or lacks iocost support.  The tests assert ASSERT_OK(err, "attach")
at lines 84 and 169, so a device without the right support is reported as a
failure rather than a skip.  Is this the intended behavior?

> +
> +	skel = iocost_model__open();

[ ... ]

> diff --git a/tools/testing/selftests/bpf/progs/iocost_model.c b/tools/testing/selftests/bpf/progs/iocost_model.c
> new file mode 100644
> index 000000000000..369818bda1cf
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/iocost_model.c
> @@ -0,0 +1,139 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Example iocost cost model: the builtin linear HDD formula with all
> + * costs doubled, for one device given by the dev member of the
> + * struct_ops.
> + *
> + * The constants mirror what calc_lcoefs() derives from the AUTOP_HDD
> + * defaults (rbps=174019176 rseqiops=41708 rrandiops=370, w-side
> + * analog) in vtime units where 1s == 2^37.  On a rotational device
> + * still on ctrl=auto, a device with this model attached charges
> + * twice the builtin model under the same workload, so the
> + * doubled cost is a direct check that accounting goes through the
> + * BPF path.  On a non-rotational device, or one with user-pinned
> + * coefficients, the ratio to the builtin model is arbitrary.
> + *
> + * A zero cursor means "no previous IO".  The cursor advances for
> + * every priced bio with a non-zero size (READ/WRITE), merged ones
> + * included, truncating to whole sectors like the builtin, so flushes
> + * and discards leave it alone and merged streams do not drift past
> + * the 16MB seek threshold.
> + *
> + * The model implements the full linear formula itself, including
> + * flushes: there is no fallback to the builtin model, a dataless
> + * A dataless WRITE|REQ_PREFLUSH keeps the write base: the op is still
> + * WRITE, so it carries WSEQIO (or WRANDIO after a seek) plus one page.

Two things here: there's a broken sentence ("... a dataless\n * A dataless
WRITE|REQ_PREFLUSH ..."), and the description contradicts what the code
actually does.

Lines 3-4 say the model is "the builtin linear HDD formula with all costs
doubled", and lines 10-11 say it "charges twice the builtin model under the
same workload".  The commit message also describes it as "the full builtin
linear HDD formula at double cost".

However, the builtin linear formula does not price flushes.
calc_vtime_cost_builtin() starts with `if (!bio->bi_iter.bi_size) goto out;`
and returns cost 0, so ioc_rqos_throttle() does not charge a zero-cost bio.
This model instead charges a dataless WRITE|REQ_PREFLUSH as
`2 * (base + 1 * WPAGE)`.

An empty flush bio also has bi_sector == 0 (blkdev_issue_flush() calls
bio_init() with no sector).  The `cur && priced` branch at lines 114-119
therefore measures the "seek" as the absolute cursor position.  So once the
cgroup has done any IO beyond the first 16MB, every fsync-style flush is
priced as WRANDIO: 2 * (360433855 + 3161261) = 727190232 vtime, about 5.3ms
of device time, where the builtin charges 0.

The same header in iocost_ms.c (lines 16-17) says "The model implements the
full builtin linear formula itself, including flush pricing", but the builtin
has no flush pricing, so that is inaccurate too.  On any workload with
flushes (or discards, see below), the "twice the builtin" claim and the
commit message's 1.99x figure do not hold.

Could the header be clarified to state that flushes are priced even though
the builtin charges them nothing, and that because a flush carries sector 0
it is effectively always priced as random IO?

> + */
> +
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>

[ ... ]

> +	if ((opf & IOCOST_REQ_OP_MASK) == REQ_OP_READ) {
> +		base = RSEQIO; coef_page = RPAGE; randio = RRANDIO;
> +	} else if ((opf & IOCOST_REQ_OP_MASK) == REQ_OP_WRITE) {
> +		base = WSEQIO; coef_page = WPAGE; randio = WRANDIO;
> +	} else {
> +		/*
> +		 * a fully owning model must price every op; unknown
> +		 * ops are priced as a single page write
> +		 */
> +		base = 0; coef_page = WPAGE; randio = 0;
> +	}

[ ... ]

> +
> +	cost = 2 * (base + pages * coef_page);
> +	return cost;

Does the comment match the code?  The comment says "unknown ops are priced as
a single page write", but the code prices them per page of bi_size.

pages is computed earlier as `nbytes >> IOC_PAGE_SHIFT` (clamped to at least
1), so the charge is `2 * pages * coef_page`.  For REQ_OP_DISCARD,
REQ_OP_WRITE_ZEROES and REQ_OP_SECURE_ERASE, bi_iter.bi_size is the size of
the range, not a transfer size.  A 1MB write-zeroes bio is 256 pages, which
is about 1.6e9 vtime (~12ms).  Any range of about 85MB or more hits the
VTIME_PER_SEC clamp in calc_vtime_cost(), so each such bio is charged a full
second of device time.  A single page write would be about 6.3e6 vtime
(~46us).

For comparison, calc_vtime_cost_builtin() takes `default: goto out;` for
these ops and returns 0, and ioc_rqos_throttle() then skips the bio with
`if (!abs_cost) return;`.  So these ops are not "twice the builtin" either.

The sibling iocost_ms.c has identical code with the comment "unknown ops are
priced as per-page writes", which matches its code, so the iocost_model.c
comment looks stale.

Since this file is presented as the reference example for the new
iocost_model_ops API, should the comment say per-page pricing, or should
pages be forced to 1 for these ops if a single page was intended?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/35962141400
--===============5958733685988634967==--
