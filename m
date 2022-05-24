From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH bpf-next v1 5/5] bpf: add a selftest for cgroup
 hierarchical stats collection
Date: Mon, 23 May 2022 19:35:44 -0700
Message-ID: <CAJD7tka8zyKhuTAcLJVq9CY6dm47crR1xOArMHFHC0N4LeX+5g@mail.gmail.com>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-6-yosryahmed@google.com> <926b21ee-58e8-18b1-3d60-148d02f1c17a@fb.com>
 <CAJD7tka1HLqyyomPN=a+RW9Z0S9TrNLhbc+tYDwEgDa1rwYggw@mail.gmail.com> <CAEf4BzaSadEhRDgLXtsAoezJEF0WqqBBJq5rXRapq_8ABb-s+w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8uWutP2YOFrjBdurNftIGVdgFUUFQM3uSeuB90bcTRs=;
        b=NShkgZR7MCR0RorSkO0OUidRWnPEeC1q61lLhkWXkJX8lOp/WmDYl9zbjwrUU8mhLQ
         useZYlYfUMF6xVcalSEQsB+0DMZc/P1qCrKnKNLu32COc5UsLaFNVS4NWVu9J4eWJovx
         QPnDWIs/TEQWODmz/xFIez6CN9BBNc4n1+mTVVLLOjvoVuxzz48eyFnhYBJsLFtSPsw1
         m56yVMSjdjV04L6BEQT7wb6o8ZR0449O44CtYWvjrzlm/vt1dbxmcJjTE1Q6B3Dq+PXR
         BJglVCKqZvVr/A8DJdA+sBh8NxaE1KSeHfFZnhIopCC+Lvb3n39sbwuddHIviw7mN2x/
         UDQg==
In-Reply-To: <CAEf4BzaSadEhRDgLXtsAoezJEF0WqqBBJq5rXRapq_8ABb-s+w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrii Nakryiko <andrii.nakryiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Networking <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, May 23, 2022 at 5:01 PM Andrii Nakryiko
<andrii.nakryiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> On Fri, May 20, 2022 at 9:19 AM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > On Fri, May 20, 2022 at 9:09 AM Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org> wrote:
> > >
> > >
> > >
> > > On 5/19/22 6:21 PM, Yosry Ahmed wrote:
> > > > Add a selftest that tests the whole workflow for collecting,
> > > > aggregating, and display cgroup hierarchical stats.
> > > >
> > > > TL;DR:
> > > > - Whenever reclaim happens, vmscan_start and vmscan_end update
> > > >    per-cgroup percpu readings, and tell rstat which (cgroup, cpu) pairs
> > > >    have updates.
> > > > - When userspace tries to read the stats, vmscan_dump calls rstat to flush
> > > >    the stats.
> > > > - rstat calls vmscan_flush once for every (cgroup, cpu) pair that has
> > > >    updates, vmscan_flush aggregates cpu readings and propagates updates
> > > >    to parents.
> > > >
> > > > Detailed explanation:
> > > > - The test loads tracing bpf programs, vmscan_start and vmscan_end, to
> > > >    measure the latency of cgroup reclaim. Per-cgroup ratings are stored in
> > > >    percpu maps for efficiency. When a cgroup reading is updated on a cpu,
> > > >    cgroup_rstat_updated(cgroup, cpu) is called to add the cgroup to the
> > > >    rstat updated tree on that cpu.
> > > >
> > > > - A cgroup_iter program, vmscan_dump, is loaded and pinned to a file, for
> > > >    each cgroup. Reading this file invokes the program, which calls
> > > >    cgroup_rstat_flush(cgroup) to ask rstat to propagate the updates for all
> > > >    cpus and cgroups that have updates in this cgroup's subtree. Afterwards,
> > > >    the stats are exposed to the user.
> > > >
> > > > - An ftrace program, vmscan_flush, is also loaded and attached to
> > > >    bpf_rstat_flush. When rstat flushing is ongoing, vmscan_flush is invoked
> > > >    once for each (cgroup, cpu) pair that has updates. cgroups are popped
> > > >    from the rstat tree in a bottom-up fashion, so calls will always be
> > > >    made for cgroups that have updates before their parents. The program
> > > >    aggregates percpu readings to a total per-cgroup reading, and also
> > > >    propagates them to the parent cgroup. After rstat flushing is over, all
> > > >    cgroups will have correct updated hierarchical readings (including all
> > > >    cpus and all their descendants).
> > > >
> > > > Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > > ---
> > > >   .../test_cgroup_hierarchical_stats.c          | 339 ++++++++++++++++++
> > > >   tools/testing/selftests/bpf/progs/bpf_iter.h  |   7 +
> > > >   .../selftests/bpf/progs/cgroup_vmscan.c       | 221 ++++++++++++
> > > >   3 files changed, 567 insertions(+)
> > > >   create mode 100644 tools/testing/selftests/bpf/prog_tests/test_cgroup_hierarchical_stats.c
> > > >   create mode 100644 tools/testing/selftests/bpf/progs/cgroup_vmscan.c
> > > >
> > > > diff --git a/tools/testing/selftests/bpf/prog_tests/test_cgroup_hierarchical_stats.c b/tools/testing/selftests/bpf/prog_tests/test_cgroup_hierarchical_stats.c
> > > > new file mode 100644
> > > > index 000000000000..e560c1f6291f
> > > > --- /dev/null
> > > > +++ b/tools/testing/selftests/bpf/prog_tests/test_cgroup_hierarchical_stats.c
> > > > @@ -0,0 +1,339 @@
> > > > +// SPDX-License-Identifier: GPL-2.0-only
> > > > +/*
> > > > + * Functions to manage eBPF programs attached to cgroup subsystems
> > > > + *
> > > > + * Copyright 2022 Google LLC.
> > > > + */
> > > > +#include <errno.h>
> > > > +#include <sys/types.h>
> > > > +#include <sys/mount.h>
> > > > +#include <sys/stat.h>
> > > > +#include <unistd.h>
> > > > +
> > > > +#include <bpf/libbpf.h>
> > > > +#include <bpf/bpf.h>
> > > > +#include <test_progs.h>
> > > > +
> > > > +#include "cgroup_helpers.h"
> > > > +#include "cgroup_vmscan.skel.h"
> > > > +
> > > > +#define PAGE_SIZE 4096
> > > > +#define MB(x) (x << 20)
> > > > +
> > > > +#define BPFFS_ROOT "/sys/fs/bpf/"
> > > > +#define BPFFS_VMSCAN BPFFS_ROOT"vmscan/"
> > > > +
> > > > +#define CG_ROOT_NAME "root"
> > > > +#define CG_ROOT_ID 1
> > > > +
> > > > +#define CGROUP_PATH(p, n) {.name = #n, .path = #p"/"#n}
> > > > +
> > > > +static struct {
> > > > +     const char *name, *path;
> > > > +     unsigned long long id;
> > > > +     int fd;
> > > > +} cgroups[] = {
> > > > +     CGROUP_PATH(/, test),
> > > > +     CGROUP_PATH(/test, child1),
> > > > +     CGROUP_PATH(/test, child2),
> > > > +     CGROUP_PATH(/test/child1, child1_1),
> > > > +     CGROUP_PATH(/test/child1, child1_2),
> > > > +     CGROUP_PATH(/test/child2, child2_1),
> > > > +     CGROUP_PATH(/test/child2, child2_2),
> > > > +};
> > > > +
> > > > +#define N_CGROUPS ARRAY_SIZE(cgroups)
> > > > +#define N_NON_LEAF_CGROUPS 3
> > > > +
> > > > +bool mounted_bpffs;
> > > > +static int duration;
> > > > +
> > > > +static int read_from_file(const char *path, char *buf, size_t size)
> > > > +{
> > > > +     int fd, len;
> > > > +
> > > > +     fd = open(path, O_RDONLY);
> > > > +     if (fd < 0) {
> > > > +             log_err("Open %s", path);
> > > > +             return -errno;
> > > > +     }
> > > > +     len = read(fd, buf, size);
> > > > +     if (len < 0)
> > > > +             log_err("Read %s", path);
> > > > +     else
> > > > +             buf[len] = 0;
> > > > +     close(fd);
> > > > +     return len < 0 ? -errno : 0;
> > > > +}
> > > > +
> > > > +static int setup_bpffs(void)
> > > > +{
> > > > +     int err;
> > > > +
> > > > +     /* Mount bpffs */
> > > > +     err = mount("bpf", BPFFS_ROOT, "bpf", 0, NULL);
> > > > +     mounted_bpffs = !err;
> > > > +     if (CHECK(err && errno != EBUSY, "mount bpffs",
> > >
> > > Please use ASSERT_* macros instead of CHECK.
> > > There are similar instances below as well.
> >
> > CHECK is more flexible in providing a parameterized failure message,
> > but I guess we ideally shouldn't see those a lot anyway. Will change
> > them to ASSERTs in the next version.
>
> The idea with ASSERT_xxx() is that you express semantically meaningful
> assertion/condition/check and the macro provides helpful and
> meaningful information for you. E.g., ASSERT_EQ(bla, 123, "bla_value")
> will emit something along the lines: "unexpected value of 'bla_value':
> 345, expected 123". It provides useful info when check fails without
> requiring to type all the extra format strings and parameters.
>
> And also CHECK() has an inverted condition which is extremely
> confusing. We don't use CHECK() for new code anymore.

I agree with this point. Especially that my test had some ASSERTs and
some CHECKs so the if conditions ended up being confusing. I am
changing them all to ASSERTs in the next version. Thanks for the
insights!

>
> >
> > >
> > > > +           "failed to mount bpffs at %s (%s)\n", BPFFS_ROOT,
> > > > +           strerror(errno)))
> > > > +             return err;
> > > > +
> > > > +     /* Create a directory to contain stat files in bpffs */
> > > > +     err = mkdir(BPFFS_VMSCAN, 0755);
> > > > +     CHECK(err, "mkdir bpffs", "failed to mkdir %s (%s)\n",
> > > > +           BPFFS_VMSCAN, strerror(errno));
> > > > +     return err;
> > > > +}
> > > > +
>
> [...]
