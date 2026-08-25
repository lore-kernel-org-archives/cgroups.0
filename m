Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C963732BF4B
	for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 17:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787679227; cv=pass; b=HDaXd3+qTDye1FQ4rmp2hFbV/LTvYguS7TFuPLJvYlI5n84y2QA/4Fdx2dbesrTc2dEnlyl0R/u/hAwaraHt4m/xcJZpm2DPDBStIVtFyWETlodFfyLXeueiKe3oBUOgNzezvcAuwBfIXYVjB/D58ejXhDK6v0cfd+0SWrohhOs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787679227; c=relaxed/simple;
	bh=l1aj7BohNvs2xdJln1gXzXfwjR5L6Cxqg3GYR6oVrYU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i4M+0Ca4xxyFnBwlDtk6BvR/Gdb/AN+TX3K8nl7E/MeAgHrNkew9PK4JxDHzXEsS7RC0aGhcP1YjZlpWPS+se0dAUlbSXwtGbNivA+DU52vLCnwlTVoon5mXnSSPBQLNi5L4luSiNyINb14qMaSe5WFQ/o2vRTM5VewbpYmmSYI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tP70tSGw; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tP70tSGw"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-51c15a5b265so17841cf.0
        for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 10:33:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787679223; cv=none;
        d=google.com; s=arc-20260327;
        b=WdPboCKyA8aKqSuJVxTdYlCUbnSrf6JR/glZTB5koeXns5vWtEXW6CJsQtwfZoblub
         ShYgW+ZhM/ODkwk9/Z6Selt1TmVOwtucmrzASliVPmukwpfOBgdMjs6g2fJwRnIACIMU
         yhZCNFKffSywBNCgW+WXrE7dRRVyzOD0inZMfmeTWr6ufk4mKVtNLM7CkHq62E07JJRY
         FuyEULMYs+joIRzNkLlMmnKTH6spMScR1u629j+xOEqY4SojOo7GOUXiTzFZpRnI7hCd
         2C/4k3j1HAkYf+DJLG218f4/IGy0Gapako0mWL6PpDaWN75gKvwhg9r9JIMQkLUepE2l
         EpGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=miL6j/NyiHkbM2s3B1v3pMNIcwfZ7GHGyvSTdJxNxv4=;
        fh=liDzWQcvGLHOb1uQb5j6ZEP9yMCpTViGB9GxN5h1aHc=;
        b=PiSwMWnZsxtxfSA7Xu2+/pPrearSmNmgUreR6Kq5Ij82yOLpBdQ2abtp60Aum+sctq
         BOMXU9Erc4OoRZPs1k4mHJNMSBhd5KZnUSGOCbxhWRh2Semu3HHEJ9VpIrGFgxpvXdPp
         SJFbc/hVni2IcCIdYjuGTmF0v4on1Y1wZhqvRfxsTzwXTM+P/pslk7cQ1ZDuEjLafG4m
         tkga3wvJSDbOFwT4Msw/6ILYnhQ7fYi7fROYb/WhOKPIonDlASeNK1iS3gj9yvvbylRa
         5nCCpi4k7lvrD1PvuWbIqujvrp9B+dWTUpGplZldNCk9doynIKq5sjRhgdfzC++s6F2l
         Dc7A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787679223; x=1788284023; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=miL6j/NyiHkbM2s3B1v3pMNIcwfZ7GHGyvSTdJxNxv4=;
        b=tP70tSGw/sSWcls/EHp1z8wlLqcstSZ9PU0kum62cczsh6waPI/qiOnkKNpnbj0Hll
         G9u3tO8ZbG587xRcse/nmlG4X9Y6hZ6tNIjIZJ4XTEKcSA0MPtXoIsJyQdKVDNk99BvT
         PcRIe1uYWttD+urG1xbxGnhLcWgyF2ZO0sy6+PSzkWCY0JamDn6mKNPOTML5OJIUUyXb
         SkJ0w5BF7cld/OcQWe3KqBKex9WlTU5dnl9J6HAA4nDLS20zelfIpa0pX/ffIdEQz6Fk
         c6eTFxrIgzNrbUpGp+Zh+NT9fedQ/MkNxztFbqLIutbklF+IsER2uBwShdvBd901AN3U
         c8sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787679223; x=1788284023;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=miL6j/NyiHkbM2s3B1v3pMNIcwfZ7GHGyvSTdJxNxv4=;
        b=EwxREGQWVihlYdyvCwZZN/dcDDy2XTUm959h7myDZH6cGZVS7vO8asIEXBiRV8J3+O
         ATuHmkc6d7PkxTUHrRh3/GSDIKf3eQNyaUUtL0fA1frcV24aJFiN0qXv2ATRQPZUh/5C
         b/gINGrnNa1p7h8kIBjAw0gfVNGcie9mYtndQRrpFh086TyayaxQxwbTm3dFzRMgBhDC
         FAf0O6wM7czmnu11EWSJY/vMEK8Dx/XnAMp7NrstOEABp0HiZPEERkX9l+CbP+2TADw+
         Ljtuc6OLiAChwaNFnkWSX+lwFjcDO9VoFppsTII1ZrZ4g9HKFZeAWchi4f8xYNvevKrV
         WDxA==
X-Forwarded-Encrypted: i=1; AHgh+RoN6wuX3B4KuJTj0E+04/MH0spMmWyowK4oKmnjlOU/pfmqstzSiTDsvw7M5tPZFgGRmJKokUV5@vger.kernel.org
X-Gm-Message-State: AFuF++nBhbQEl6s8wLrpMGmepexhwDPUakpAH9U9+1Vv+jgq453+oJ4G
	bYXY1Psw2PYXYKqlB+YpTOlCPZ/Dhfe1G738rDToEtUNHdRgI4G/CrEedra3DOeSlTEbMv1Y/Vc
	JGvZn70t1kdZzY7L1fGfhb2l+r4tW4+8+q/C7h0dD
X-Gm-Gg: AR+sD120OLzFvQ0wYFLX6aY/1sbCf6LOZJeo+mHsFSF9/9Xi4e2B2mRvmZ3q6BHwMji
	1ijQRRRMWxuBiGs6XHNlB77mfZ7AIsJ/1LV4fHYHZpDPaObpWwWaNDtVBMCiZa/Ch8BqqWHjE4g
	iNgL1XQL4g+dtS9wrdvUhQqY4wNk2tiOCHgj2JUTGZo1z53e03jvNvFnk0DSBaqVJ1d8s1fbWdC
	kfEHtbyl/34Gpr5z9Tv3yK0ISg7VfYjCfPuSVKNW0J3mvPbSU7qhcOm81tsaa+LK/yUuIMDur/t
	iSWw8E4AIbZiKto+nkjPEZy4sCWCoMjEe+uhabGbHm2Wu/7TkQC5zMFXXrldiqoYeMgB6B0oq98
	=
X-Received: by 2002:a05:622a:134b:b0:52e:1e8:21f4 with SMTP id
 d75a77b69052e-52e30914d50mr22535491cf.5.1787679221519; Tue, 25 Aug 2026
 10:33:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260824085913.546741-1-cui.tao@linux.dev>
In-Reply-To: <20260824085913.546741-1-cui.tao@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 25 Aug 2026 10:33:29 -0700
X-Gm-Features: AcwNN1UXMUleJ6BNlw8H69MeT8_dwagfX_OtLaHLXWsiYb32zP_YP4NE_g7CUgk
Message-ID: <CAJuCfpHgYW4WHf3AH1Oj9TAthvCN_aqNW1uxMN2O109wd6Lckw@mail.gmail.com>
Subject: Re: [PATCH v4] selftests/cgroup: add PSI pressure trigger and
 validation tests
To: Tao Cui <cui.tao@linux.dev>
Cc: Michal Koutny <mkoutny@suse.com>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ziyang Men <ziyang.meme@gmail.com>, Tao Cui <cuitao@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 24, 2026 at 1:59=E2=80=AFAM Tao Cui <cui.tao@linux.dev> wrote:
>
> From: Tao Cui <cuitao@kylinos.cn>
>
> The cgroup selftests have no PSI coverage. Add test_psi.c: per-resource
> trigger smoke tests (one trigger per fd, IRQ full-only), a
> cgroup.pressure hide/show toggle test, and a CPU-pressure trigger test
> using over-subscription. Skips when PSI is disabled or a resource is
> absent.
>
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
>
> ---
> Changes since v3 (Suren Baghdasaryan review):
> - Convert to the kselftest harness: each case is a TEST_F(psi, ...)
>   with the cgroup root/PSI availability checks in FIXTURE_SETUP() and
>   the teardown (kill hogs, destroy cgroup) in FIXTURE_TEARDOWN(),
>   which also removes the "ret"/"created" bookkeeping.
> - A trigger that does not fire within the poll timeout is now a FAIL
>   instead of a SKIP: ncpus+1 hogs with a 1usec threshold must stall,
>   so a timeout indicates a real problem.
> - Treat a poll() timeout and a poll() error uniformly via ASSERT.
> - Check sysconf(_SC_NPROCESSORS_ONLN) only for -1 and report
>   strerror(errno); declare variables one per line; for(;;) {}.
> - Make hog_cpu() die with the runner via PR_SET_PDEATHSIG so an
>   interrupted run does not leave orphaned hogs pinning every CPU.
>
> Changes since v2 (Suren Baghdasaryan, Michal Koutny review):
> - Restructure the trigger test into per-resource cases (io, memory, cpu,
>   irq) so a failure points at the specific resource; irq is skipped when
>   /proc/pressure/irq is absent.
> - Spawn the CPU hogs with cg_run_nowait() instead of open-coding fork(),
>   and arm the trigger with a 2s window so unprivileged users can set it.
> - Address the remaining review comments on cleanup and robustness:
>   guard teardown with a "created" flag, use cg_read_strcmp() instead of
>   atoi(), report strerror() on errors, and fix the unused-parameter and
>   sign-compare nits.
>
> Changes since v1 (Michal Koutny, sashiko review):
> - Keep trigger tests smoke-level; switch the firing test from memory to
>   CPU pressure; drop churn_memory().
> - Keep the runner out of the cgroup; add PSI/IRQ skip-guards and a
>   .gitignore entry.
>
> v1: https://lore.kernel.org/all/20260724025826.504586-1-cui.tao@linux.dev=
/
> v2: https://lore.kernel.org/all/20260728083742.2359320-1-cui.tao@linux.de=
v/
> v3: https://lore.kernel.org/all/20260813133723.1663605-1-cui.tao@linux.de=
v/
> ---
>  tools/testing/selftests/cgroup/.gitignore |   1 +
>  tools/testing/selftests/cgroup/Makefile   |   2 +
>  tools/testing/selftests/cgroup/config     |   1 +
>  tools/testing/selftests/cgroup/test_psi.c | 206 ++++++++++++++++++++++
>  4 files changed, 210 insertions(+)
>  create mode 100644 tools/testing/selftests/cgroup/test_psi.c
>
> diff --git a/tools/testing/selftests/cgroup/.gitignore b/tools/testing/se=
lftests/cgroup/.gitignore
> index 952e4448bf07..ce2b907c57ea 100644
> --- a/tools/testing/selftests/cgroup/.gitignore
> +++ b/tools/testing/selftests/cgroup/.gitignore
> @@ -8,5 +8,6 @@ test_kill
>  test_kmem
>  test_memcontrol
>  test_pids
> +test_psi
>  test_zswap
>  wait_inotify
> diff --git a/tools/testing/selftests/cgroup/Makefile b/tools/testing/self=
tests/cgroup/Makefile
> index e01584c2189a..a8c69e37332a 100644
> --- a/tools/testing/selftests/cgroup/Makefile
> +++ b/tools/testing/selftests/cgroup/Makefile
> @@ -16,6 +16,7 @@ TEST_GEN_PROGS +=3D test_kill
>  TEST_GEN_PROGS +=3D test_kmem
>  TEST_GEN_PROGS +=3D test_memcontrol
>  TEST_GEN_PROGS +=3D test_pids
> +TEST_GEN_PROGS +=3D test_psi
>  TEST_GEN_PROGS +=3D test_zswap
>
>  LOCAL_HDRS +=3D $(selfdir)/clone3/clone3_selftests.h $(selfdir)/pidfd/pi=
dfd.h
> @@ -32,4 +33,5 @@ $(OUTPUT)/test_kill: $(LIBCGROUP_O)
>  $(OUTPUT)/test_kmem: $(LIBCGROUP_O)
>  $(OUTPUT)/test_memcontrol: $(LIBCGROUP_O)
>  $(OUTPUT)/test_pids: $(LIBCGROUP_O)
> +$(OUTPUT)/test_psi: $(LIBCGROUP_O)
>  $(OUTPUT)/test_zswap: $(LIBCGROUP_O)
> diff --git a/tools/testing/selftests/cgroup/config b/tools/testing/selfte=
sts/cgroup/config
> index 39f979690dd3..8a3ef479e83d 100644
> --- a/tools/testing/selftests/cgroup/config
> +++ b/tools/testing/selftests/cgroup/config
> @@ -4,3 +4,4 @@ CONFIG_CGROUP_FREEZER=3Dy
>  CONFIG_CGROUP_SCHED=3Dy
>  CONFIG_MEMCG=3Dy
>  CONFIG_PAGE_COUNTER=3Dy
> +CONFIG_PSI=3Dy
> diff --git a/tools/testing/selftests/cgroup/test_psi.c b/tools/testing/se=
lftests/cgroup/test_psi.c
> new file mode 100644
> index 000000000000..d5fab10f4fd4
> --- /dev/null
> +++ b/tools/testing/selftests/cgroup/test_psi.c
> @@ -0,0 +1,206 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define _GNU_SOURCE
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <poll.h>
> +#include <stdbool.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <unistd.h>
> +#include <sys/prctl.h>
> +#include <linux/limits.h>
> +
> +#include "../kselftest_harness.h"
> +#include "cgroup_util.h"
> +
> +#define PSI_POLL_TIMEOUT_MS    5000
> +
> +/* PSI triggers are written with a trailing NUL the kernel parser expect=
s. */
> +static ssize_t write_trigger(int fd, const char *trigger)
> +{
> +       return write(fd, trigger, strlen(trigger) + 1);
> +}
> +
> +static int pressure_open(const char *resource)
> +{
> +       char path[PATH_MAX];
> +       int fd;
> +
> +       snprintf(path, sizeof(path), "/proc/pressure/%s", resource);
> +       fd =3D open(path, O_RDWR);
> +       if (fd < 0)
> +               fprintf(stderr, "open %s: %s\n", path, strerror(errno));

Use ksft_perror() instead please.

> +       return fd;
> +}
> +
> +FIXTURE(psi)
> +{
> +       char root[PATH_MAX];
> +       char *cg;
> +};
> +
> +FIXTURE_SETUP(psi)
> +{
> +       int psi_fd;
> +
> +       self->cg =3D NULL;
> +
> +       if (cg_find_unified_root(self->root, sizeof(self->root), NULL))
> +               SKIP(return, "cgroup v2 isn't mounted");
> +
> +       /* PSI must be enabled (CONFIG_PSI=3Dy, not disabled on the cmdli=
ne). */
> +       psi_fd =3D open("/proc/pressure/memory", O_RDONLY);
> +       if (psi_fd < 0)
> +               SKIP(return, "PSI unavailable (CONFIG_PSI=3Dn or psi=3D0)=
");
> +       close(psi_fd);

Why can't cgroup setup be done here? IOW, why not do

self->cg =3D cg_name(self->root, "psi_trigger_test");
cg_create(self->cg))

here only once? Usually FIXTURE_SETUP and FIXTURE_TEARDOWN are
symmetric: you teardown what you setup.


> +}
> +
> +FIXTURE_TEARDOWN(psi)
> +{
> +       if (self->cg) {
> +               cg_killall(self->cg);
> +               cg_destroy(self->cg);
> +               free(self->cg);
> +       }
> +}
> +
> +/*
> + * /proc/pressure/<resource> accepts exactly one trigger per file
> + * descriptor. For io, memory and cpu verify that a "some" trigger arms
> + * and that a second trigger on the same fd is rejected with EBUSY.
> + */
> +TEST_F(psi, proc_trigger_io)
> +{
> +       int fd;
> +
> +       fd =3D pressure_open("io");
> +       ASSERT_GE(fd, 0);
> +       ASSERT_GT(write_trigger(fd, "some 150000 2000000"), 0);
> +       ASSERT_EQ(-1, write_trigger(fd, "full 150000 2000000"));
> +       ASSERT_EQ(EBUSY, errno);
> +       close(fd);
> +}
> +
> +TEST_F(psi, proc_trigger_memory)
> +{
> +       int fd;
> +
> +       fd =3D pressure_open("memory");
> +       ASSERT_GE(fd, 0);
> +       ASSERT_GT(write_trigger(fd, "some 150000 2000000"), 0);
> +       ASSERT_EQ(-1, write_trigger(fd, "full 150000 2000000"));
> +       ASSERT_EQ(EBUSY, errno);
> +       close(fd);
> +}
> +
> +TEST_F(psi, proc_trigger_cpu)
> +{
> +       int fd;
> +
> +       fd =3D pressure_open("cpu");
> +       ASSERT_GE(fd, 0);
> +       ASSERT_GT(write_trigger(fd, "some 150000 2000000"), 0);
> +       ASSERT_EQ(-1, write_trigger(fd, "full 150000 2000000"));
> +       ASSERT_EQ(EBUSY, errno);
> +       close(fd);
> +}

proc_trigger_io, proc_trigger_memory and proc_trigger_cpu do almost
the same thing. You can refactor them:

static void test_psi_write(const char *filename)
{
       int fd;

       fd =3D pressure_open(filename);
       ASSERT_GE(fd, 0);
       ASSERT_GT(write_trigger(fd, "some 150000 2000000"), 0);
       ASSERT_EQ(-1, write_trigger(fd, "full 150000 2000000"));
       ASSERT_EQ(EBUSY, errno);
       close(fd);
}

TEST_F(psi, proc_trigger_io)
{
       test_psi_write("io");
}

TEST_F(psi, proc_trigger_memory)
{
       test_psi_write("memory");
}

TEST_F(psi, proc_trigger_cpu)
{
       test_psi_write("cpu");
}

> +
> +/*
> + * irq only tracks "full", so a "some" trigger must be rejected while a
> + * "full" trigger arms. irq is optional -- it only exists with IRQ-time
> + * accounting -- so a missing /proc/pressure/irq is SKIP, not FAIL.
> + */
> +TEST_F(psi, proc_trigger_irq)
> +{
> +       int fd;
> +
> +       fd =3D pressure_open("irq");
> +       if (fd < 0)
> +               SKIP(return, "/proc/pressure/irq unavailable");
> +
> +       ASSERT_EQ(-1, write_trigger(fd, "some 150000 2000000"));
> +       ASSERT_GT(write_trigger(fd, "full 150000 2000000"), 0);
> +       close(fd);
> +}
> +
> +/*
> + * cgroup.pressure gates visibility of the per-resource *.pressure files
> + * inside a cgroup: writing 0 hides them, writing 1 shows them again.
> + * Drive one hide/show cycle and check that memory.pressure appears and
> + * disappears along with it.
> + */
> +TEST_F(psi, cgroup_pressure_toggle)
> +{
> +       char buf[BUF_SIZE];
> +
> +       self->cg =3D cg_name(self->root, "psi_toggle_test");
> +       ASSERT_NE(NULL, self->cg);
> +       ASSERT_EQ(0, cg_create(self->cg));
> +
> +       ASSERT_EQ(0, cg_write(self->cg, "cgroup.pressure", "0"));
> +       ASSERT_EQ(0, cg_read_strcmp(self->cg, "cgroup.pressure", "0\n"));
> +       ASSERT_LT(cg_read(self->cg, "memory.pressure", buf, sizeof(buf)),=
 0);
> +
> +       ASSERT_EQ(0, cg_write(self->cg, "cgroup.pressure", "1"));
> +       ASSERT_EQ(0, cg_read_strcmp(self->cg, "cgroup.pressure", "1\n"));
> +       ASSERT_GE(cg_read(self->cg, "memory.pressure", buf, sizeof(buf)),=
 0);
> +}
> +
> +/*
> + * A child that burns CPU forever; stopped by cg_killall() on teardown.
> + * It also dies with the runner, so an interrupted run (e.g. Ctrl-C
> + * during poll()) does not leave orphaned hogs pinning every CPU.
> + */
> +static int hog_cpu(const char *cgroup, void *arg)
> +{
> +       prctl(PR_SET_PDEATHSIG, SIGKILL);
> +       for (;;) {}
> +       return 0;
> +}
> +
> +/*
> + * Arm a "some" trigger on a cgroup's cpu.pressure, oversubscribe the
> + * cgroup with more spinning hogs than there are CPUs, and check that th=
e
> + * trigger fires once the cgroup stalls on CPU.
> + */
> +TEST_F(psi, cgroup_trigger_fire)
> +{
> +       char *cpupress;
> +       struct pollfd pfd =3D { .events =3D POLLPRI };
> +       long ncpus;
> +       int fd;
> +       int i;
> +
> +       self->cg =3D cg_name(self->root, "psi_trigger_test");
> +       ASSERT_NE(NULL, self->cg);
> +       ASSERT_EQ(0, cg_create(self->cg));
> +
> +       cpupress =3D cg_control(self->cg, "cpu.pressure");
> +       ASSERT_NE(NULL, cpupress);
> +       fd =3D open(cpupress, O_RDWR);
> +       free(cpupress);
> +       ASSERT_GE(fd, 0);
> +       pfd.fd =3D fd;
> +
> +       /*
> +        * 1usec threshold over a 2s window: any CPU stall fires it. The =
2s
> +        * window is the smallest unprivileged users are allowed to arm.
> +        */
> +       ASSERT_GT(write_trigger(fd, "some 1 2000000"), 0);
> +
> +       ncpus =3D sysconf(_SC_NPROCESSORS_ONLN);
> +       if (ncpus =3D=3D -1)
> +               TH_LOG("sysconf(_SC_NPROCESSORS_ONLN): %s", strerror(errn=
o));
> +       ASSERT_NE(-1, ncpus);
> +
> +       /* ncpus+1 hogs guarantee CPU contention inside the cgroup. */
> +       for (i =3D 0; i < ncpus + 1; i++)
> +               ASSERT_GE(cg_run_nowait(self->cg, hog_cpu, NULL), 0);
> +
> +       ASSERT_EQ(1, poll(&pfd, 1, PSI_POLL_TIMEOUT_MS));
> +       ASSERT_NE(0, pfd.revents & POLLPRI);
> +       close(fd);
> +}
> +
> +TEST_HARNESS_MAIN
> --
> 2.43.0
>
