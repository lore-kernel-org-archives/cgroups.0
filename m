Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7173009F2
	for <cgroups@vger.kernel.org>; Sun,  9 Aug 2026 03:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786247106; cv=pass; b=L25qrg9UmGOFfBmedy+JBg2MZnDRlz5VqFGSQxgXLmI7ZNqvZqcJEfrNWUlbPigOyqJJYWCSU2IIfZ3UBntt/fJOffuXY//d/oWd3nVHB1SPV1bO59tXHUPJF5fNgzQxtsd6tBeFumtsk7BiCbZvX87Pb0IQFpxSLW6zBuWvDDg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786247106; c=relaxed/simple;
	bh=T0pGFxhxXGrL/kMAbpO1veK76flk1lXKaFcRxlspGtc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R5rBBlaCCyQQQr7YijU27XrtQ0VzY+Qdksay4pc8JyrYH+M6FqhC5ElkyhMhkGBUVVTOIqcMvXZ5eOMYtHoAm23iYsWhdNf2fz1+eL2/8KGkeomKoy4ojecOvP7GrABhNZ/a8YHSqH/6b8lD7urXbKAoHGwNsitXBncTkYwdH+E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tQl2yyEC; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tQl2yyEC"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51c10ed63c0so128811cf.1
        for <cgroups@vger.kernel.org>; Sat, 08 Aug 2026 20:45:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786247103; cv=none;
        d=google.com; s=arc-20260327;
        b=JjkfuszSrEjOJ039fNxI0sB7RjBoML0NUt6LCus0y1JRbRyVBaR/l1kKaFFEEdYuBK
         p85DSwSovGOyxwVYJA9dW1OIERALiSL5Tc3W7/dB5gjLoAGmYefg2zZmbX+ayXre+5+n
         zPpE7fbqUljN2h5XgoF+tf5hz9TF6zzp4QaJ5lkh6VcCx6P6vWXwRpC5J/YEjn7vGfqX
         Y54NYPWRYTga9A7+SB8eEe5SWz6BTJyJGO8jKe/E+Vwa3CoLpAlxQSgnwj4hHGJNJgEL
         74Rn31Y8p2wuR7SGY0LPsYe0BatVemRLdiYUBpG2VVzx8WiBE3OAqrcXcc9XWShRI1NU
         L9tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NkogbAmn7Wcdi8/UNOS2zMEvw0dJAg09JNaIPc7jdGg=;
        fh=M988kktAqZ3IebfwK2Ulqk7ViDdZIEHDasmoy0iLEt0=;
        b=VQAXje+Unz638EZqOo2KBkgLfJ2Dc6gduynTRkYSSasdYgyrA2fcxdDFLyGJ3YqfcO
         CGev2DQGMPJYGKfTg6bvP0SVYEYhI+OInM+oDpGQnaURdM0ZT5O9uJBvTuZmcIBEY9gA
         0yC7d8N1a5K/Uz0L/74ADKxlDFZqBkIgvroMGnWU+tGGWNDJVrk5QeXdqsm63R8bKntC
         Yext/xI1Kffn7dORvV5yKxxVzdmBNG7UH/hLowJKkQscDakhib7mCn84Q+1qKPVVVyrn
         O5fhLWGXvd+SZnAcrP0/jrKRe6Vat5+fi4YIznjzzFVwGO+eZwnIv+T9OcGIMgzx/v02
         sF2A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786247103; x=1786851903; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NkogbAmn7Wcdi8/UNOS2zMEvw0dJAg09JNaIPc7jdGg=;
        b=tQl2yyECe6pxzvPUvRlOSzozWw3323p2AwLb00MIl5i+Qu5kIBhCQX+OGCmsSJrNEj
         hZ6o9UdU/7dzfYkBWtrT8pNEdNnIsWfvC0DrgbR7ZSqvyl9In6ObE6rW0I0DfUuOh2qA
         HUYxddNQpxcLVR0MbC5MtBGeyuTuBSGzDya423k8E90LuYX6nQZXqOdqrg+Ogl+ReyLx
         WMZXidH77yv9mQu14F5ssdGxdbKJyKZQWc4vhM0OM6UD9QuXDyyG1Qg5HzcXGZpxT5ok
         VXMHHKMBl8SGgwA8CBlC27sPH0t9Og2OTgqz4KSdr2IjoKNhRlUMcWlgfHDuK4zL8Tpb
         UJmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786247103; x=1786851903;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NkogbAmn7Wcdi8/UNOS2zMEvw0dJAg09JNaIPc7jdGg=;
        b=da0+rwxFiWrXDK12TGvFSkdCeIbogIO6RKvAq9R6mfhrIBSuNF6dVxZ2Vpck/0Fus8
         H2XGa4JeR9FBuTg6zhVMD1WOyMV19GOgpHFkshjw8czVvMaL4DtQKvtZvYC54gIObtZx
         s/2TrLYNuWbVfjsc5/lLoAM48U5Wv/OQFGc+nlZ78yWOzELYn0TuKFJ/bHsX3O9T3QWu
         /N0nuH0ELI9rYWz70dv1qQ7InsULplX65H0olU9ZF6mcjAqLTHRumDFKHXJsHOaDgrGX
         W04CMj8fmb6ItjjhiHyd0DStblChEn1u5em6N82tgtdRh7Iiemlh862OVtwWHIiXsQt6
         +i0g==
X-Forwarded-Encrypted: i=1; AHgh+Rrq15o66W7sZt+WtNYaZ4IPHGriLoeoacYBHxyr/fT4//twWOVRsM3Spgm5kzLJuZ66tA01Qj7e@vger.kernel.org
X-Gm-Message-State: AOJu0YwlkteT819Qo61rO7YS66j3I0nc89FC9EGlgZvsSyqKDulr0JdU
	XhAUMnObbGI9qvqTGqL+Qyo35t6UOZ3eMbeBAEzMAtmkkqHfP5OsCxe6iLuT4gcD/JrPnowvvov
	gwn8STca0LCJcnpqfYo1LOqSdKF63RXcsrWIBIqgi
X-Gm-Gg: AR+sD11fhyZxObVT/+MxgbpnMrWvLJOBZtwt9ZO/+t/h6b8N6oey4EC4Ue9rsAOtlf5
	vi0mjDZOYX3jHQqfIuoNJ4gLpmiz618V+E7ves7x2736spEpiMwxmmcovMrVCKWhH2zZ+9cwYNZ
	XLeG3vyp4ey+dC3q4mzZBiCWBdFH90Tz5CueHaVrq4u4fvfZF4k+1AWa9r+d3V5+VPlUwpZtrYk
	K21P41/0urGRYnKl5Z3xjqyV6BcLuvBF/vcoXEGZI7EhVHph9cPQg3lwxAXdNt2+BIZnnS6ntZO
	OpWfGfcgpd4ZXISKeyM/R8U+NtgjMW+lrbzc3c3gIHg=
X-Received: by 2002:a05:622a:1f12:b0:51c:6b7:d3de with SMTP id
 d75a77b69052e-52d2810403cmr13879741cf.5.1786247102454; Sat, 08 Aug 2026
 20:45:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260728083742.2359320-1-cui.tao@linux.dev>
In-Reply-To: <20260728083742.2359320-1-cui.tao@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 8 Aug 2026 20:44:50 -0700
X-Gm-Features: AUfX_mzzisx242Oaznh-4i7q-AEZQvUdF8Br6aVq-DC_MaLshBRAgK_OZ_tS0YQ
Message-ID: <CAJuCfpHyX5BP88Fk1dOY3F=vk-Me3D-8vF=Dv_Uh17TnaphBhw@mail.gmail.com>
Subject: Re: [PATCH v2] selftests/cgroup: add PSI pressure trigger and
 validation tests
To: Tao Cui <cui.tao@linux.dev>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, 
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Ziyang Men <ziyang.meme@gmail.com>, 
	Tao Cui <cuitao@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 28, 2026 at 1:38=E2=80=AFAM Tao Cui <cui.tao@linux.dev> wrote:
>
> From: Tao Cui <cuitao@kylinos.cn>
>
> The cgroup selftests have no PSI coverage. Add test_psi.c: trigger
> smoke tests (one per fd, IRQ full-only), cgroup.pressure toggle, and a
> CPU-pressure trigger test using over-subscription. Skips when PSI is
> disabled or a resource is absent.
>
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> ---
> Changes since v1 (Michal Koutny, sashiko review):
> - Trim errno checks to smoke level; loosen toggle range checks.
> - Switch trigger test from memory to CPU pressure (deterministic, no SKIP=
).
> - churn_memory() removed -- sysconf/shared-helper point is moot.
> - Runner stays out of the cgroup; hogs reaped via cg_killall().
> - Add PSI/IRQ skip-guards, zero-init buffers, .gitignore entry.
> ---
>  tools/testing/selftests/cgroup/.gitignore |   1 +
>  tools/testing/selftests/cgroup/Makefile   |   2 +
>  tools/testing/selftests/cgroup/config     |   1 +
>  tools/testing/selftests/cgroup/test_psi.c | 280 ++++++++++++++++++++++
>  4 files changed, 284 insertions(+)
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
> index 000000000000..51dc35e26013
> --- /dev/null
> +++ b/tools/testing/selftests/cgroup/test_psi.c
> @@ -0,0 +1,280 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define _GNU_SOURCE
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <poll.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/wait.h>
> +#include <unistd.h>
> +#include <linux/limits.h>
> +
> +#include "kselftest.h"
> +#include "cgroup_util.h"
> +
> +/* How long to wait for the CPU-pressure trigger before giving up. */
> +#define PSI_POLL_TIMEOUT_MS    5000
> +
> +static int pressure_open(const char *resource)
> +{
> +       char path[PATH_MAX];
> +
> +       snprintf(path, sizeof(path), "/proc/pressure/%s", resource);
> +       return open(path, O_RDWR);
> +}
> +
> +/* Write a trigger descriptor, including the trailing NUL the parser exp=
ects. */
> +static ssize_t write_trigger(int fd, const char *trigger)
> +{
> +       return write(fd, trigger, strlen(trigger) + 1);
> +}
> +
> +/* Trigger smoke test: second on same fd -> EBUSY; IRQ rejects "some". *=
/

Please write more descriptive comments for your tests. I have to guess
what you mean by this.

> +static int test_proc_triggers(const char *root)

Why do you pass root here if you are not using it? AI glitch?

> +{
> +       static const char *const resources[] =3D { "io", "memory", "cpu" =
};
> +       int ret =3D KSFT_FAIL;
> +       int fd =3D -1;
> +       int i;
> +
> +       (void)root;
> +
> +       for (i =3D 0; i < (int)ARRAY_SIZE(resources); i++) {
> +               fd =3D pressure_open(resources[i]);
> +               if (fd < 0) {
> +                       ksft_print_msg("open /proc/pressure/%s: %s\n",
> +                                      resources[i], strerror(errno));

You could move these ksft_print_msg() into pressure_open() and make
that function a bit more useful while making the code here simpler.

> +                       goto cleanup;
> +               }
> +
> +               errno =3D 0;

Why are you resetting the errno? If the next syscall fails, it will
reset the errno and if it succeeds, you won't be using errno anyway.
I'm confused.

> +               if (write_trigger(fd, "some 150000 2000000") <=3D 0) {
> +                       ksft_print_msg("%s: 'some' trigger rejected: %s\n=
",
> +                                      resources[i], strerror(errno));
> +                       goto cleanup;
> +               }
> +               /* A second trigger on the same fd must fail with EBUSY. =
*/
> +               errno =3D 0;
> +               if (write_trigger(fd, "full 150000 2000000") !=3D -1 || e=
rrno !=3D EBUSY) {
> +                       ksft_print_msg("%s: second trigger expected EBUSY=
, got %s\n",
> +                                      resources[i], strerror(errno));
> +                       goto cleanup;
> +               }
> +
> +               close(fd);
> +               fd =3D -1;

When you jump to cleanup label you always need to close the fd. You
could simplify the flow if you remove all these "fd =3D -1;" and change
the end of the function to be:

        return KSFT_PASS
cleanup:
        close(fd);
        return ret;
}

> +       }
> +
> +       /* IRQ is full-only, and only exists with CONFIG_IRQ_TIME_ACCOUNT=
ING. */

It would be better if you split this test into separate tests for
"io", "memory", "cpu" and "irq" and if "irq" is not available you can
return KSFT_SKIP for that test only. This way when a test fails the
user will know exactly what failed.

> +       fd =3D pressure_open("irq");
> +       if (fd >=3D 0) {
> +               errno =3D 0;
> +               if (write_trigger(fd, "some 150000 1000000") !=3D -1) {
> +                       ksft_print_msg("irq 'some': expected failure, got=
 %s\n",
> +                                      strerror(errno));
> +                       goto cleanup;
> +               }
> +               close(fd);
> +               fd =3D -1;
> +       }
> +
> +       ret =3D KSFT_PASS;
> +cleanup:
> +       if (fd >=3D 0)
> +               close(fd);
> +       return ret;
> +}
> +
> +/* cgroup.pressure 0/1 hides/shows the *.pressure files and round-trips.=
 */

The above comment needs to be expanded to explain what you are
testing. It does not read as a proper English sentence.

> +static int test_cgroup_pressure_toggle(const char *root)
> +{
> +       char buf[BUF_SIZE] =3D { 0 };
> +       char *cg =3D NULL;
> +       int ret =3D KSFT_FAIL;
> +
> +       cg =3D cg_name(root, "psi_toggle_test");
> +       if (!cg)
> +               goto cleanup;
> +       if (cg_create(cg))
> +               goto cleanup;

Jumping to "cleanup" above results in a call to cg_destroy() while
cg_create() failed. It will try to rmdir() a directory which we never
created.

> +
> +       if (cg_write(cg, "cgroup.pressure", "0")) {
> +               ksft_print_msg("failed to disable cgroup.pressure\n");

Reporting strerror() in these failure logs would be useful.

> +               goto cleanup;
> +       }
> +       if (cg_read(cg, "cgroup.pressure", buf, sizeof(buf)) < 0 || atoi(=
buf) !=3D 0) {

atoi() will return 0 even on error, so if you want to really check the
value is 0 use a more robust method like strtol() or simply do a
string comparison.

> +               ksft_print_msg("cgroup.pressure=3D0 readback: '%s'\n", bu=
f);
> +               goto cleanup;
> +       }
> +       if (cg_read(cg, "memory.pressure", buf, sizeof(buf)) >=3D 0) {
> +               ksft_print_msg("memory.pressure visible while disabled\n"=
);
> +               goto cleanup;
> +       }
> +
> +       if (cg_write(cg, "cgroup.pressure", "1")) {
> +               ksft_print_msg("failed to re-enable cgroup.pressure\n");
> +               goto cleanup;
> +       }
> +       if (cg_read(cg, "cgroup.pressure", buf, sizeof(buf)) < 0 || atoi(=
buf) !=3D 1) {
> +               ksft_print_msg("cgroup.pressure=3D1 readback: '%s'\n", bu=
f);
> +               goto cleanup;
> +       }
> +       if (cg_read(cg, "memory.pressure", buf, sizeof(buf)) < 0) {
> +               ksft_print_msg("memory.pressure unreadable while enabled\=
n");
> +               goto cleanup;
> +       }
> +
> +       ret =3D KSFT_PASS;
> +cleanup:
> +       if (cg)
> +               cg_destroy(cg);
> +       free(cg);

free(NULL) works but would be cleaner to do this instead:

      if (cg) {
              cg_destroy(cg);
              free(cg);
      }

> +       return ret;
> +}
> +
> +/* Induce deterministic CPU pressure (more hogs than CPUs). */
> +static int test_cgroup_trigger_fire(const char *root)
> +{
> +       char *cg =3D NULL, *cpupress =3D NULL;
> +       int fd =3D -1, ret =3D KSFT_FAIL;
> +       struct pollfd pfd;
> +       long ncpus, i;
> +       pid_t pid;
> +
> +       cg =3D cg_name(root, "psi_trigger_test");
> +       if (!cg)
> +               goto cleanup;
> +       if (cg_create(cg))
> +               goto cleanup;

Same issue with this jump. You will be calling cg_killall(cg) and
cg_destroy(cg) even though cg_create() did not succeed.

> +
> +       cpupress =3D cg_control(cg, "cpu.pressure");
> +       if (!cpupress)
> +               goto cleanup;
> +       fd =3D open(cpupress, O_RDWR);
> +       if (fd < 0) {
> +               ksft_print_msg("open cpu.pressure: %s\n", strerror(errno)=
);
> +               goto cleanup;
> +       }
> +
> +       /* 1us threshold in a 1s window: any cpu stall fires it. */
> +       errno =3D 0;
> +       if (write_trigger(fd, "some 1 1000000") <=3D 0) {
> +               ksft_print_msg("arming trigger failed: %s\n", strerror(er=
rno));
> +               goto cleanup;
> +       }
> +
> +       ncpus =3D sysconf(_SC_NPROCESSORS_ONLN);
> +       if (ncpus <=3D 0)

Why is this not treated as a test failure?

> +               ncpus =3D 1;
> +
> +       pid =3D fork();
> +       if (pid < 0) {
> +               ksft_print_msg("fork: %s\n", strerror(errno));
> +               goto cleanup;
> +       }
> +       if (pid =3D=3D 0) {
> +               /* Enter the cgroup, then over-subscribe it with CPU hogs=
. */
> +               if (cg_enter_current(cg))
> +                       _exit(KSFT_FAIL);
> +               for (i =3D 0; i < ncpus; i++) {
> +                       if (fork() =3D=3D 0) {
> +                               for (;;)
> +                                       asm volatile("" ::: "memory");
> +                               _exit(0);
> +                       }
> +               }
> +               for (;;)
> +                       asm volatile("" ::: "memory");  /* child is also =
a hog */
> +               _exit(0);
> +       }
> +
> +       pfd.fd =3D fd;
> +       pfd.events =3D POLLPRI;
> +       switch (poll(&pfd, 1, PSI_POLL_TIMEOUT_MS)) {
> +       case -1:
> +               ksft_print_msg("poll: %s\n", strerror(errno));
> +               break;
> +       case 0:
> +               ksft_print_msg("no trigger event; could not induce cpu pr=
essure\n");
> +               ret =3D KSFT_SKIP;
> +               break;
> +       default:
> +               if (pfd.revents & POLLPRI)
> +                       ret =3D KSFT_PASS;
> +               else
> +                       ksft_print_msg("poll returned 0x%x\n", pfd.revent=
s);
> +               break;
> +       }
> +
> +       /* Stop the hogs (bounded, so waitpid can't hang) and reap the ch=
ild. */
> +       cg_killall(cg);
> +       waitpid(pid, NULL, 0);
> +
> +cleanup:
> +       if (fd >=3D 0)
> +               close(fd);
> +       if (cg) {
> +               cg_killall(cg);
> +               cg_destroy(cg);
> +       }
> +       free(cpupress);
> +       free(cg);
> +       return ret;
> +}
> +
> +#define TEST(x) { #x, x }
> +
> +struct psi_test {
> +       const char *name;
> +       int (*fn)(const char *root);
> +};
> +
> +static struct psi_test tests[] =3D {
> +       TEST(test_proc_triggers),
> +       TEST(test_cgroup_pressure_toggle),
> +       TEST(test_cgroup_trigger_fire),

Instead of setting up these tests manually you could use
TEST_HARNESS_MAIN, TEST_F and other helpers from kselftest_harness.h.

> +};
> +
> +int main(int argc, char **argv)
> +{
> +       char root[PATH_MAX];
> +       int mempress_fd;
> +       int i;
> +
> +       (void)argc;
> +
> +       ksft_print_header();
> +       ksft_set_plan(ARRAY_SIZE(tests));
> +
> +       if (cg_find_unified_root(root, sizeof(root), NULL))
> +               ksft_exit_skip("cgroup v2 isn't mounted\n");
> +
> +       /* PSI must be enabled (CONFIG_PSI=3Dy, not default-disabled). */
> +       mempress_fd =3D open("/proc/pressure/memory", O_RDONLY);
> +       if (mempress_fd < 0)
> +               ksft_exit_skip("PSI unavailable (CONFIG_PSI=3Dn or psi=3D=
0)\n");
> +       close(mempress_fd);
> +
> +       if (cg_read_strstr(root, "cgroup.controllers", "memory"))
> +               ksft_exit_skip("memory controller isn't available\n");
> +       if (cg_read_strstr(root, "cgroup.subtree_control", "memory"))
> +               if (cg_write(root, "cgroup.subtree_control", "+memory"))
> +                       ksft_exit_skip("failed to enable memory controlle=
r\n");
> +
> +       for (i =3D 0; i < (int)ARRAY_SIZE(tests); i++) {
> +               switch (tests[i].fn(root)) {
> +               case KSFT_PASS:
> +                       ksft_test_result_pass("%s\n", tests[i].name);
> +                       break;
> +               case KSFT_SKIP:
> +                       ksft_test_result_skip("%s\n", tests[i].name);
> +                       break;
> +               default:
> +                       ksft_test_result_fail("%s\n", tests[i].name);
> +                       break;
> +               }
> +       }
> +
> +       ksft_finished();
> +}
> --
> 2.43.0
>
