From: Hao Luo <haoluo@google.com>
Subject: Re: [PATCH bpf-next v5 8/8] bpf: add a selftest for cgroup
 hierarchical stats collection
Date: Fri, 29 Jul 2022 10:36:26 -0700
Message-ID: <CA+khW7ikSexgprouA6tpbWfsT2fDdgEd7OfXMF4qhDWkxgxf1g@mail.gmail.com>
References: <20220722174829.3422466-1-yosryahmed@google.com>
 <20220722174829.3422466-9-yosryahmed@google.com> <CAEf4BzZQwMeJ5xfzEWWRcTf1Hick862x2qSZ3O0DX47Q++2-4w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eVMmcjZdpoYkfAfcG11mdG+DM47ViTyLlI/HvC0NVqs=;
        b=hrGaOCnwS06hYR6y6b1XfcUUnaDFW93EvujdUgaK7Ka1oAslOsoQxI+GrU6NDwkrRm
         Bm/Oa2nrMa2QlCUPi2rwlMhDvM8LHxk5y1toex4ln/EOra9ZW1TWaPfT1p6nfAKF7wcZ
         IX8ksKXqVjWZSFtHzQsp2hpzy/rIRcdeCVIS5QR14U5wN7UB7U+RZZNnXplmxBT6VUeP
         Pa/gyCFzbAhxsgL3w5kZQndZItJQAj/WT20YCzfZhILOuqdyL1iLoHIq/vN2o1DWFIp5
         Qa6OP91GDqftH6j4Ker359n7z+m5ajtPmTPun+GXwGgSaQSpMyuCsG36Xyoo/lchRbqW
         BBhA==
In-Reply-To: <CAEf4BzZQwMeJ5xfzEWWRcTf1Hick862x2qSZ3O0DX47Q++2-4w@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>, KP Singh <kpsingh@kernel.org>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, John Fastabend <john.fastabend@gmail.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Greg Thelen <gthelen@google.com>, Shakeel

Hi Andrii,

Thanks for taking a look.

On Thu, Jul 28, 2022 at 3:40 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Jul 22, 2022 at 10:49 AM Yosry Ahmed <yosryahmed@google.com> wrote:
> >
[...]
> > +
> > +#define CGROUP_PATH(p, n) {.path = #p"/"#n, .name = #n}
> > +
> > +static struct {
> > +       const char *path, *name;
> > +       unsigned long long id;
> > +       int fd;
> > +} cgroups[] = {
> > +       CGROUP_PATH(/, test),
> > +       CGROUP_PATH(/test, child1),
> > +       CGROUP_PATH(/test, child2),
> > +       CGROUP_PATH(/test/child1, child1_1),
> > +       CGROUP_PATH(/test/child1, child1_2),
> > +       CGROUP_PATH(/test/child2, child2_1),
> > +       CGROUP_PATH(/test/child2, child2_2),
>
> nit: why are these arguments not explicit string literals?...
> CGROUP_PATH("/test/child1", "child1_1") explicitly shows that those
> values are used as strings
>

No particular reason I think. String literals are good. Will fix in v6.

> > +};
> > +
> > +#define N_CGROUPS ARRAY_SIZE(cgroups)
> > +#define N_NON_LEAF_CGROUPS 3
> > +
> > +int root_cgroup_fd;
> > +bool mounted_bpffs;
> > +
>
> static?
>

Yeah, we were careless about 'static' or 'inline'. I am going to go
over the code and mark functions/vars 'static' properly.

> > +static int read_from_file(const char *path, char *buf, size_t size)
> > +{
> > +       int fd, len;
> > +
> > +       fd = open(path, O_RDONLY);
> > +       if (fd < 0) {
> > +               log_err("Open %s", path);
> > +               return 1;
> > +       }
> > +       len = read(fd, buf, size);
> > +       if (len < 0)
> > +               log_err("Read %s", path);
> > +       else
> > +               buf[len] = 0;
> > +       close(fd);
> > +       return len < 0;
> > +}
> > +
>
> [...]
>
> > +       /* Also dump stats for root */
> > +       err = setup_cgroup_iter(obj, root_cgroup_fd, CG_ROOT_NAME);
> > +       if (!ASSERT_OK(err, "setup_cgroup_iter"))
> > +               return err;
> > +
> > +       /* Attach rstat flusher */
> > +       link = bpf_program__attach(obj->progs.vmscan_flush);
> > +       if (!ASSERT_OK_PTR(link, "attach rstat"))
> > +               return libbpf_get_error(link);
>
> this is dangerous, because ASSERT_OK_PTR might overwrite errno by the
> time we get to libbpf_get_error() call. link is NULL and
> libbpf_get_error() extracts error from errno. It's best to just return
> fixed error code here, or otherwise you'd need to remember err before
> ASSERT_OK_PTR() call.
>

Ack. We can just return a fixed error code here. Thanks.

> > +       obj->links.vmscan_flush = link;
> > +
> > +       /* Attach tracing programs that will calculate vmscan delays */
> > +       link = bpf_program__attach(obj->progs.vmscan_start);
> > +       if (!ASSERT_OK_PTR(obj, "attach raw_tracepoint"))
> > +               return libbpf_get_error(link);
> > +       obj->links.vmscan_start = link;
> > +
> > +       link = bpf_program__attach(obj->progs.vmscan_end);
> > +       if (!ASSERT_OK_PTR(obj, "attach raw_tracepoint"))
> > +               return libbpf_get_error(link);
> > +       obj->links.vmscan_end = link;
> > +
> > +       *skel = obj;
> > +       return 0;
> > +}
> > +
> > +void destroy_progs(struct cgroup_hierarchical_stats *skel)
>
> static?
>

Ack.

> > +{
> > +       char path[128];
> > +       int i;
> > +
> > +       for (i = 0; i < N_CGROUPS; i++) {
> > +               /* Delete files in bpffs that cgroup_iters are pinned in */
> > +               snprintf(path, 128, "%s%s", BPFFS_VMSCAN,
> > +                        cgroups[i].name);
> > +               ASSERT_OK(remove(path), "remove cgroup_iter pin");
> > +       }
> > +
> > +       /* Delete root file in bpffs */
> > +       snprintf(path, 128, "%s%s", BPFFS_VMSCAN, CG_ROOT_NAME);
> > +       ASSERT_OK(remove(path), "remove cgroup_iter root pin");
> > +       cgroup_hierarchical_stats__destroy(skel);
> > +}
> > +
> > +void test_cgroup_hierarchical_stats(void)
> > +{
> > +       struct cgroup_hierarchical_stats *skel = NULL;
> > +
> > +       if (setup_hierarchy())
> > +               goto hierarchy_cleanup;
> > +       if (setup_progs(&skel))
> > +               goto cleanup;
> > +       if (induce_vmscan())
> > +               goto cleanup;
> > +       check_vmscan_stats();
> > +cleanup:
> > +       destroy_progs(skel);
> > +hierarchy_cleanup:
> > +       destroy_hierarchy();
> > +}
> > diff --git a/tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c b/tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
> > new file mode 100644
> > index 000000000000..85a65a72482e
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
> > @@ -0,0 +1,239 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Functions to manage eBPF programs attached to cgroup subsystems
> > + *
> > + * Copyright 2022 Google LLC.
> > + */
> > +#include "vmlinux.h"
> > +#include <bpf/bpf_helpers.h>
> > +#include <bpf/bpf_tracing.h>
> > +
> > +char _license[] SEC("license") = "GPL";
> > +
> > +/*
> > + * Start times are stored per-task, not per-cgroup, as multiple tasks in one
> > + * cgroup can perform reclain concurrently.
>
> typo: reclaim?
>

Ack. Will fix.

> > + */
> > +struct {
> > +       __uint(type, BPF_MAP_TYPE_TASK_STORAGE);
> > +       __uint(map_flags, BPF_F_NO_PREALLOC);
> > +       __type(key, int);
> > +       __type(value, __u64);
> > +} vmscan_start_time SEC(".maps");
> > +
>
> [...]
>
> > +static inline int create_vmscan_percpu_elem(__u64 cg_id, __u64 state)
> > +{
> > +       struct vmscan_percpu pcpu_init = {.state = state, .prev = 0};
> > +       int err;
> > +
> > +       err = bpf_map_update_elem(&pcpu_cgroup_vmscan_elapsed, &cg_id,
> > +                                 &pcpu_init, BPF_NOEXIST);
> > +       if (err) {
> > +               bpf_printk("failed to create pcpu entry for cgroup %llu: %d\n"
> > +                          , cg_id, err);
> > +               return 1;
> > +       }
> > +       return 0;
> > +}
> > +
> > +static inline int create_vmscan_elem(__u64 cg_id, __u64 state, __u64 pending)
>
> all those inlines above are not necessary, they don't have to be
> actually inlined, right?
>

No. They don't have to. Will fix this.

> > +{
> > +       struct vmscan init = {.state = state, .pending = pending};
> > +       int err;
> > +
> > +       err = bpf_map_update_elem(&cgroup_vmscan_elapsed, &cg_id,
> > +                                 &init, BPF_NOEXIST);
> > +       if (err) {
> > +               bpf_printk("failed to create entry for cgroup %llu: %d\n"
> > +                          , cg_id, err);
> > +               return 1;
> > +       }
> > +       return 0;
> > +}
> > +
> > +SEC("tp_btf/mm_vmscan_memcg_reclaim_begin")
> > +int BPF_PROG(vmscan_start, int order, gfp_t gfp_flags)
> > +{
> > +       struct task_struct *task = bpf_get_current_task_btf();
> > +       __u64 *start_time_ptr;
> > +
> > +       start_time_ptr = bpf_task_storage_get(&vmscan_start_time, task, 0,
> > +                                         BPF_LOCAL_STORAGE_GET_F_CREATE);
> > +       if (!start_time_ptr) {
> > +               bpf_printk("error retrieving storage\n");
>
> does user-space part read these trace_printk messages? If not, let's
> remove them from the test
>

No. I will remove them in v6.

> > +               return 0;
> > +       }
> > +
> > +       *start_time_ptr = bpf_ktime_get_ns();
> > +       return 0;
> > +}
> > +
>
> [...]
