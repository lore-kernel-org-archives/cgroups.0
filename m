From: Andrii Nakryiko <andrii.nakryiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH bpf-next v6 5/8] selftests/bpf: Test cgroup_iter.
Date: Mon, 1 Aug 2022 14:51:31 -0700
Message-ID: <CAEf4Bzbdz7=Cg-87G2tak1Mr=1wJkqr6g2d=dkHqu0YH+j2unA@mail.gmail.com>
References: <20220801175407.2647869-1-haoluo@google.com> <20220801175407.2647869-6-haoluo@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=VLuEcIkJtnKoMl8gBoUClGYBdOKVju+Fv4CrOEtOKBE=;
        b=eQywm0SYRown4Vd/F5Sr8QZB48pltddGfTACwJqvJydCzDVTxghTZycjVyzWDiMkmx
         tyyyQjbdCUDr7XtTQ8Ow/Tih7gktgV/xyfyLcPy3yJy4r2s7Hw+2X2ghPlZqM7nVHMLG
         QCJX6wLvU8q8xx94nsmL3NoW5mKF0nqg+5QEysJ6T6a29nFkAFoXXobQSBocpv57pRcL
         z4XvKnxw7JfBduEJtfa4MjDQ3/1NK5RV/ssYjkCtpAm2mGhzllxE7Kc1LCHKxObtsWr3
         B0lzm8o+zw0y3SOBWcaSuVIiA8/z+5kCPMPgv6COUw0f4mbhhWge+Ay9Uh2mSj/gehvA
         g+gw==
In-Reply-To: <20220801175407.2647869-6-haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Tissoires <benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Koutny <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Mon, Aug 1, 2022 at 10:54 AM Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> Add a selftest for cgroup_iter. The selftest creates a mini cgroup tree
> of the following structure:
>
>     ROOT (working cgroup)
>      |
>    PARENT
>   /      \
> CHILD1  CHILD2
>
> and tests the following scenarios:
>
>  - invalid cgroup fd.
>  - pre-order walk over descendants from PARENT.
>  - post-order walk over descendants from PARENT.
>  - walk of ancestors from PARENT.
>  - early termination.
>
> Acked-by: Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>
> Signed-off-by: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  .../selftests/bpf/prog_tests/cgroup_iter.c    | 193 ++++++++++++++++++
>  tools/testing/selftests/bpf/progs/bpf_iter.h  |   7 +
>  .../testing/selftests/bpf/progs/cgroup_iter.c |  39 ++++
>  3 files changed, 239 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
>  create mode 100644 tools/testing/selftests/bpf/progs/cgroup_iter.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_iter.c b/tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
> new file mode 100644
> index 000000000000..5dc843a3f507
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
> @@ -0,0 +1,193 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2022 Google */
> +
> +#include <test_progs.h>
> +#include <bpf/libbpf.h>
> +#include <bpf/btf.h>
> +#include "cgroup_iter.skel.h"
> +#include "cgroup_helpers.h"
> +
> +#define ROOT           0
> +#define PARENT         1
> +#define CHILD1         2
> +#define CHILD2         3
> +#define NUM_CGROUPS    4
> +
> +#define PROLOGUE       "prologue\n"
> +#define EPILOGUE       "epilogue\n"
> +
> +#define format_expected_output1(cg_id1) \
> +       snprintf(expected_output, sizeof(expected_output), \
> +                PROLOGUE "%8llu\n" EPILOGUE, (cg_id1))
> +
> +#define format_expected_output2(cg_id1, cg_id2) \
> +       snprintf(expected_output, sizeof(expected_output), \
> +                PROLOGUE "%8llu\n%8llu\n" EPILOGUE, \
> +                (cg_id1), (cg_id2))
> +
> +#define format_expected_output3(cg_id1, cg_id2, cg_id3) \
> +       snprintf(expected_output, sizeof(expected_output), \
> +                PROLOGUE "%8llu\n%8llu\n%8llu\n" EPILOGUE, \
> +                (cg_id1), (cg_id2), (cg_id3))
> +

you use format_expected_output{1,2} just once and
format_expected_output3 twice. Is it worth defining macros for that?

> +const char *cg_path[] = {
> +       "/", "/parent", "/parent/child1", "/parent/child2"
> +};
> +
> +static int cg_fd[] = {-1, -1, -1, -1};
> +static unsigned long long cg_id[] = {0, 0, 0, 0};
> +static char expected_output[64];
> +
> +int setup_cgroups(void)
> +{
> +       int fd, i = 0;
> +
> +       for (i = 0; i < NUM_CGROUPS; i++) {
> +               fd = create_and_get_cgroup(cg_path[i]);
> +               if (fd < 0)
> +                       return fd;
> +
> +               cg_fd[i] = fd;
> +               cg_id[i] = get_cgroup_id(cg_path[i]);
> +       }
> +       return 0;
> +}
> +
> +void cleanup_cgroups(void)

some more statics to cover (same for setup_cgroups)

> +{
> +       int i;
> +
> +       for (i = 0; i < NUM_CGROUPS; i++)
> +               close(cg_fd[i]);
> +}
> +
> +static void read_from_cgroup_iter(struct bpf_program *prog, int cgroup_fd,
> +                                 int order, const char *testname)
> +{
> +       DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
> +       union bpf_iter_link_info linfo;
> +       struct bpf_link *link;
> +       int len, iter_fd;
> +       static char buf[64];
> +
> +       memset(&linfo, 0, sizeof(linfo));
> +       linfo.cgroup.cgroup_fd = cgroup_fd;
> +       linfo.cgroup.traversal_order = order;
> +       opts.link_info = &linfo;
> +       opts.link_info_len = sizeof(linfo);
> +
> +       link = bpf_program__attach_iter(prog, &opts);
> +       if (!ASSERT_OK_PTR(link, "attach_iter"))
> +               return;
> +
> +       iter_fd = bpf_iter_create(bpf_link__fd(link));
> +       if (iter_fd < 0)
> +               goto free_link;
> +
> +       memset(buf, 0, sizeof(buf));
> +       while ((len = read(iter_fd, buf, sizeof(buf))) > 0)
> +               ;

this is broken, in general, you are overriding buffer content with
each call to len

I think you intended to advance buf after each read() call (and reduce
remaining available buf size)?

> +
> +       ASSERT_STREQ(buf, expected_output, testname);
> +
> +       /* read() after iter finishes should be ok. */
> +       if (len == 0)
> +               ASSERT_OK(read(iter_fd, buf, sizeof(buf)), "second_read");
> +
> +       close(iter_fd);
> +free_link:
> +       bpf_link__destroy(link);
> +}
> +
> +/* Invalid cgroup. */
> +static void test_invalid_cgroup(struct cgroup_iter *skel)
> +{
> +       DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
> +       union bpf_iter_link_info linfo;
> +       struct bpf_link *link;
> +
> +       memset(&linfo, 0, sizeof(linfo));
> +       linfo.cgroup.cgroup_fd = (__u32)-1;
> +       opts.link_info = &linfo;
> +       opts.link_info_len = sizeof(linfo);
> +
> +       link = bpf_program__attach_iter(skel->progs.cgroup_id_printer, &opts);
> +       if (!ASSERT_ERR_PTR(link, "attach_iter"))
> +               bpf_link__destroy(link);

nit: you can call bpf_link__destroy() even if link is NULL or IS_ERR

> +}
> +

[...]

> diff --git a/tools/testing/selftests/bpf/progs/cgroup_iter.c b/tools/testing/selftests/bpf/progs/cgroup_iter.c
> new file mode 100644
> index 000000000000..2a34d146d6df
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/cgroup_iter.c
> @@ -0,0 +1,39 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2022 Google */
> +
> +#include "bpf_iter.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +char _license[] SEC("license") = "GPL";
> +volatile int terminate_early = 0;
> +volatile u64 terminal_cgroup = 0;
> +

nit: you shouldn't need volatile for non-const global variables. Did
you see any problems without volatile?

> +static inline u64 cgroup_id(struct cgroup *cgrp)
> +{
> +       return cgrp->kn->id;
> +}
> +

[...]
