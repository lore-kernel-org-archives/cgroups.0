Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7BD48EC7A;
	Thu, 10 Sep 2026 13:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789047976; cv=none; b=VVX+nOqmkSJ+PSkNwKNvHkaX5y5IlZ6GjP5g7pB/H1Puyb3ScFveX3i92aqPFU2X8OEPp2xdW7MY93iosAFD8xLUEopB/GGVHTC6xPaimHn01TkOKOs95G36m0EhMM8T7J3xCVU/6lHMEODUQSBA6pG5N7HODva37KeXZ2C/u7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789047976; c=relaxed/simple;
	bh=hoPUdoHpfxf391of+pK/LWIVNo4nsjGbHGMPacKzmgY=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=f/PnQmbNZX+aVFb+WwNOJXTbV/2NNf4uBil4s6eHl5On4leWYi9ImTLaals8/68xLH8jA5hCFW0ABqQZPsPviSc0cB/zSaDMHYAoClSIvUVIEHUTioHT4z2mJgSmmWYzVQCkHcgtCBxluKVPhxH4iIbU5jZrjIzhJeNrdRwguAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o2o5jaQc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o2o5jaQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A25F1F00898;
	Thu, 10 Sep 2026 13:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789047975;
	bh=ZyekFsQ0nxrR4L9N8Ghb6GAkJVnZqSRvKNPOeJH2phA=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=o2o5jaQcCOJsfj+q6kQoCNaKUsipIXe18mMhVaqT7OnTX5ibFzInK/1n+fkSHWaZj
	 M1bMfvQMWtRHiJE7yoBgvssFHDVQf5BbanNqoAKqFyYjKB/XSWw1Z6maBliCt2xaGO
	 H2dwYjcngCG2gs9IO9piMiZiUQcjnTe/v0zVqs1MGXl1Vstl3gNRLMEhKa8HleIPFZ
	 AktuLWjbai3CvbORhWMAxBMRzEMd9eKEVu8OY0tDssStEIIlmd28jmdBdPdi9MNtMl
	 CNY3kVvwe/PHI5edkQTw7ixEdfy4AKUXzsRS+RnBK1Lf6FJ4vCoH1McLSIi9QezUc9
	 UMoXd0hJ++WGA==
Content-Type: multipart/mixed; boundary="===============7357494171922306859=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <cf5adc448dc541413def8b6dc4b160345a2f19b5488ce5555f0851256ccfbadc@mail.kernel.org>
In-Reply-To: <20260910125817.223354-3-cui.tao@linux.dev>
References: <20260910125817.223354-3-cui.tao@linux.dev>
Subject: Re: [RFC PATCH v2 2/5] selftests/bpf: add iocost cost model test
From: bot+bpf-ci@kernel.org
To: cui.tao@linux.dev,tj@kernel.org,josef@toxicopanda.com,axboe@kernel.dk
Cc: cgroups@vger.kernel.org,linux-block@vger.kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,andrii@kernel.org,ast@kernel.org,daniel@iogearbox.net,linux-kselftest@vger.kernel.org,cui.tao@linux.dev,cuitao@kylinos.cn,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Thu, 10 Sep 2026 13:46:14 +0000 (UTC)

--===============7357494171922306859==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
> index 2f79688dcf7c..67a630cb5614 100644
> --- a/tools/testing/selftests/bpf/config
> +++ b/tools/testing/selftests/bpf/config
> @@ -138,3 +138,5 @@ CONFIG_SMC_HS_CTRL_BPF=y
>  CONFIG_DIBS=y
>  CONFIG_DIBS_LO=y
>  CONFIG_PM_WAKELOCKS=y
> +CONFIG_BLK_CGROUP_IOCOST=y
> +CONFIG_BLK_CGROUP_IOCOST_BPF=y
> diff --git a/tools/testing/selftests/bpf/prog_tests/iocost_model.c b/tools/testing/selftests/bpf/prog_tests/iocost_model.c
> new file mode 100644
> index 000000000000..e9344b13fba9
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/iocost_model.c
> @@ -0,0 +1,193 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +#include <fcntl.h>
> +#include <unistd.h>
> +#include "iocost_model.skel.h"
> +#include "iocost_ms.skel.h"

Does this commit build?  The new test includes iocost_ms.skel.h and
calls iocost_ms__open_and_load(), iocost_ms__attach(), and
iocost_ms__destroy() in serial_test_iocost_model_streams() below, but
this commit adds only progs/iocost_model.c under the progs directory.
progs/iocost_ms.c is added two commits later by b33a817eec7c.

The selftest Makefile derives skeleton generation rules from:

  TRUNNER_BPF_SRCS := $(notdir $(wildcard $(TRUNNER_BPF_PROGS_DIR)/*.c))
  TRUNNER_BPF_SKELS := $(patsubst %.c,$(TRUNNER_OUTPUT)/%.skel.h, ...)

so iocost_ms.skel.h has no generation rule at this commit and make
fails with "No rule to make target '.../iocost_ms.skel.h', needed by
'.../iocost_model.test.o'".  Because prog_tests/*.o files all feed the
single test_progs binary, this breaks the build of the entire bpf
selftest suite.

The multi-stream model and test belong in the later commit, or
progs/iocost_ms.c belongs in this one.  As-is the series is not
bisectable.

[ ... ]

> +static int readback_model(const char *dev, char *model, size_t model_sz)
> +{
> +	char line[256], word[256], *m, *end;
> +	FILE *fp;
> +	int found = 0;
> +
> +	fp = fopen("/sys/fs/cgroup/io.cost.model", "r");
> +	if (!fp)
> +		return -1;
> +	while (fgets(line, sizeof(line), fp)) {
> +		if (sscanf(line, "%255s", word) == 1 && !strcmp(word, dev)) {
> +			found = 1;
> +			break;
> +		}
> +	}
> +	fclose(fp);
> +	if (!found)
> +		return -1;
> +
> +	m = strstr(line, "model=");
> +	if (!m)
> +		return -1;
> +	m += strlen("model=");
> +	end = m;
> +	while (*end && !isspace(*end))
> +		end++;

Does this build?  isspace() is used but <ctype.h> is never included.
The file includes only <test_progs.h>, <fcntl.h> and <unistd.h>.
test_progs.h includes stdio.h, unistd.h, errno.h, string.h, assert.h,
regex.h, stdlib.h, stdarg.h, time.h, signal.h and various linux/ and
sys/ headers, none of which declare isspace() in glibc.

tools/testing/selftests/bpf/Makefile builds userspace objects with
-Wall -Werror, so the implicit declaration is an error (and is an error
by default in GCC 14+ / C23 regardless).  The existing precedent in the
same directory, prog_tests/ctx_rewrite.c, is the only other prog_test
that calls isspace() and it explicitly includes <ctype.h>.

[ ... ]

> +/*
> + * The dev argument must be present in io.cost.qos already, which
> + * means iocost is enabled for it.
> + */
> +static int dev_has_iocost(const char *dev)
> +{
> +	char line[256], word[256];
> +	FILE *fp;
> +	int found = 0;
> +
> +	fp = fopen("/sys/fs/cgroup/io.cost.qos", "r");
> +	if (!fp)
> +		return 0;
> +	while (fgets(line, sizeof(line), fp)) {
> +		if (sscanf(line, "%255s", word) == 1 && !strcmp(word, dev)) {
> +			found = 1;
> +			break;
> +		}
> +	}
> +	fclose(fp);
> +	return found;
> +}

Does this helper match its comment?  The comment asserts that presence
in io.cost.qos "means iocost is enabled", but ioc_qos_prfill() prints
a line for every device that has the iocost policy activated, including
devices with enable=0:

block/blk-iocost.c:ioc_qos_prfill()
  seq_printf(sf, "%s enable=%d ctrl=%s rpct=...", dname, ioc->enabled, ...);

dev_has_iocost() only matches the leading dname and never looks at the
enable= field, so it returns 1 for a device where iocost is present but
disabled.  To match its own comment the helper should parse enable=1.

Relatedly, the commit message states "The runner is skipped unless
$IOCOST_TEST_DEV gives a major:minor of a device with iocost enabled",
but the code does not skip in that case:

> +void serial_test_iocost_model(void)
> +{
> +	struct iocost_model *skel;
> +	char buf[300], *dev;
> +	int err;
> +
> +	dev = getenv("IOCOST_TEST_DEV");
> +	if (!dev || geteuid() != 0) {
> +		test__skip();
> +		return;
> +	}
> +	if (!ASSERT_TRUE(dev_has_iocost(dev), "iocost_mounted"))
> +		return;

ASSERT_TRUE calls test__fail() if the condition is false, so setting
IOCOST_TEST_DEV to a device without iocost, or running where cgroup2 is
not mounted at /sys/fs/cgroup (fopen fails, dev_has_iocost returns 0),
produces a hard test failure rather than a skip.

[ ... ]

> +/*
> + * Write a line to io.cost.model with write(2) and return the errno of
> + * the failed write, or 0 on success.  stdio is not used here on
> + * purpose: the kernel's rejection happens in the write() syscall,
> + * not in the userspace buffer copy, and every write, including
> + * the error paths of the callers below, is checked.
> + */
> +static int write_cost_model(const char *buf)
> +{
> +	int fd, err = 0;
> +	ssize_t n;
> +
> +	fd = open("/sys/fs/cgroup/io.cost.model", O_WRONLY);
> +	if (fd < 0)
> +		return errno;
> +	n = write(fd, buf, strlen(buf));
> +	if (n < 0)
> +		err = errno;
> +	close(fd);
> +	return err;
> +}

[ ... ]

> +	/*
> +	 * negative: binding an unknown model name must be rejected,
> +	 * so a typo cannot silently disable cost model updates
> +	 */
> +	snprintf(buf, sizeof(buf), "%s model=no_such_model\n", dev);
> +	err = write_cost_model(buf);
> +	ASSERT_EQ(err, ENOENT, "unknown_model_rejected");

Can this negative test distinguish the two failure modes?
write_cost_model() returns the open() errno and the write() errno
through the same channel, so its callers cannot tell them apart.  ENOENT
is exactly what open() returns when /sys/fs/cgroup/io.cost.model does
not exist (cgroup2 mounted elsewhere, or the io controller not enabled
in the root cgroup's subtree_control).  The assertion then passes
without the kernel ever having parsed the model name, i.e. it can report
success for the opposite of what it means to prove.

The helper's own comment says it returns "the errno of the failed
write", which does not match the open() path.  Distinguishing the two
(e.g. a separate return code for open failure, or asserting the file is
openable first) would make the negative test meaningful.

> diff --git a/tools/testing/selftests/bpf/progs/iocost_model.c b/tools/testing/selftests/bpf/progs/iocost_model.c
> new file mode 100644
> index 000000000000..f8ad417b3584
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/iocost_model.c
> @@ -0,0 +1,116 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Example iocost cost model: the builtin linear HDD formula with all
> + * costs doubled.
> + *
> + * The constants mirror what calc_lcoefs() derives from the AUTOP_HDD
> + * defaults (rbps=174019176 rseqiops=41708 rrandiops=370, w-side
> + * analog) in vtime units where 1s == 2^37, expressed with the same
> + * round-up divisions so they cannot drift from the kernel.  A device
> + * bound to this model through io.cost.model charges exactly twice the
> + * builtin model under the same workload, which makes it a convenient
> + * way to verify that accounting goes through the BPF path.

Does this claim hold for arbitrary devices?  "A device bound to this
model through io.cost.model charges exactly twice the builtin model
under the same workload" is only true for a rotational device still on
ctrl=auto.

The builtin model reads ioc->params.lcoefs[], which calc_lcoefs()
derives from autop[ioc_autop_idx()] or from user-supplied io.cost.model
coefficients.  ioc_autop_idx() returns AUTOP_HDD only when
blk_queue_rot(disk->queue); otherwise it returns AUTOP_SSD_QD1 or
AUTOP_SSD_DFL, and when ioc->user_cost_model is set it keeps whatever
the user pinned.

This model hardcodes the AUTOP_HDD i_lcoefs (rbps=174019176 etc., from
block/blk-iocost.c), so on the non-rotational $IOCOST_TEST_DEV that
most testers will use, the ratio to the builtin is arbitrary rather than
2x.  The comment should state the rotational/ctrl=auto precondition (or
the code should not claim exactness).

Secondly, "expressed with the same round-up divisions so they cannot
drift from the kernel" overstates the coupling: only the RU() divisions
mirror calc_lcoefs().  RBPS/RSEQIOPS/RRANDIOPS/WBPS/WSEQIOPS/WRANDIOPS,
IOC_PAGE_SIZE, IOC_SECT_TO_PAGE_SHIFT and LCOEF_RANDIO_PAGES are
hardcoded copies of kernel values and will drift silently if the kernel
changes them.

[ ... ]

> +SEC("struct_ops")
> +u64 BPF_PROG(iocost_2x_calc_cost, u64 opf, u64 nbytes, u64 sector,
> +	     struct blkcg *blkcg, u64 model_flags)
> +{
> +	u64 pages, seek_pages = 0, base, coef_page, randio, cost;
> +
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
> +
> +	/*
> +	 * mirror the builtin single per-cgroup cursor: the model keeps
> +	 * its own cursor keyed by the blkcg argument
> +	 */

Does the keying match the builtin?  The comment says this mirrors "the
builtin single per-cgroup cursor", but the builtin cursor is not
per-cgroup - it is per blkg, i.e. per (cgroup, device).  The cursor is
'sector_t cursor;' in struct ioc_gq, and ioc_gq is allocated by
blkg_to_iocg(blkg).

cursor_store is keyed by blkcg->css.cgroup only, so if two devices are
bound to this model the same cgroup shares one cursor between them and
every alternating IO looks random.

> +	{
> +		__u64 *cursor, cur;
> +
> +		cursor = bpf_cgrp_storage_get(&cursor_store,
> +					      blkcg->css.cgroup, NULL,
> +					      BPF_LOCAL_STORAGE_GET_F_CREATE);
> +		if (!cursor)
> +			return 2 * (base + RU(nbytes, IOC_PAGE_SIZE) * coef_page);
> +		cur = *cursor;
> +		seek_pages = sector > cur ? sector - cur : cur - sector;
> +		seek_pages >>= IOC_SECT_TO_PAGE_SHIFT;

Does this handle a freshly created cgroup?  bpf_cgrp_storage_get() with
BPF_LOCAL_STORAGE_GET_F_CREATE returns a zero-filled value
(bpf_selem_alloc() allocates with __GFP_ZERO), so a new entry has
cur == 0, which this code treats as a real cursor position rather than
'no previous IO'.

The builtin only computes a seek distance when the cursor is non-zero:

block/blk-iocost.c:calc_vtime_cost_builtin()
  if (iocg->cursor) {
      seek_pages = abs(bio->bi_iter.bi_sector - iocg->cursor);
      seek_pages >>= IOC_SECT_TO_PAGE_SHIFT;
  }

Without this guard, the first bio of every cgroup landing past sector
32768 is priced with randio (368,221,632) instead of seqio (60,266).

> +		if (seek_pages > LCOEF_RANDIO_PAGES)
> +			base = randio;
> +		if (!(model_flags & IOCOST_COST_F_MERGE))
> +			*cursor = sector + RU(nbytes, 512);
> +	}

Does this cursor update match the builtin?  The cursor is advanced for
every non-merge call, including calls the builtin model never accounts
for.

calc_vtime_cost_builtin() returns cost 0 both for
'!bio->bi_iter.bi_size' and for any op that is not REQ_OP_READ or
REQ_OP_WRITE, and ioc_rqos_throttle() then does 'if (!abs_cost) return;'
before 'iocg->cursor = bio_end_sector(bio);'.  So the builtin leaves the
cursor untouched for flush and discard bios.

This model instead writes 'sector + RU(nbytes, 512)' for them.  A
dataless flush from blkdev_issue_flush() is 'bio_init(&bio, bdev, NULL,
0, REQ_OP_WRITE | REQ_PREFLUSH)': bi_sector == 0 and bi_size == 0.
It matches the REQ_OP_WRITE arm, so this line sets *cursor = 0 + 0 = 0.
REQ_OP_FLUSH hits the 'unknown op' arm and does the same.

The next read/write in that cgroup is then compared against cursor 0, so
seek_pages == sector >> 3 and any sector beyond 32768 (16 MiB into the
device) trips 'seek_pages > LCOEF_RANDIO_PAGES' and is priced with
randio instead of seqio.  With the AUTOP_HDD constants in this file that
is RRANDIO = 368,221,632 instead of RSEQIO = 60,266.  For a 4 KiB read,
roughly 113x instead of the 2x the file comment claims.

On an fsync-heavy workload a flush precedes almost every IO, so a cgroup
bound to this model is throttled orders of magnitude harder than under
the builtin model it is supposed to double.  A large discard has the
mirror-image effect: 'sector + RU(nbytes, 512)' jumps the cursor by the
whole discard length, so the following sequential read looks random.

Matching the builtin requires only advancing the cursor for the ops that
were actually priced (READ/WRITE with nbytes != 0).

> +
> +	pages = RU(nbytes, IOC_PAGE_SIZE);
> +	if (!pages)
> +		pages = 1;	/* dataless flush: one page */

Does the page count match the builtin?  The page count rounds up where
the builtin truncates, so the cost is not 2x for bios that are not a
whole number of 4 KiB pages.

The builtin uses:

block/blk-iocost.c:calc_vtime_cost_builtin()
  u64 pages = max_t(u64, bio_sectors(bio) >> IOC_SECT_TO_PAGE_SHIFT, 1);

which is max(nbytes >> 12, 1) - a truncating shift.  RU(nbytes,
IOC_PAGE_SIZE) is a round-up.  For a 6 KiB bio the builtin charges 1
page and this model charges 2, i.e. 2*(base + 2*coef_page) instead of
2*(base + 1*coef_page).  Bios whose size is not a multiple of 4096 are
routine (writeback of a partial tail, and merged bios on the
ioc_rqos_merge() path).

Note the file comment claims the constants use "the same round-up
divisions so they cannot drift from the kernel" - the page count is the
one division the kernel deliberately does not round up.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/34481298417
--===============7357494171922306859==--
