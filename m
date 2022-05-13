From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH bpf-next 0/9] bpf: cgroup hierarchical stats collection
Date: Fri, 13 May 2022 00:16:28 -0700
Message-ID: <CAJD7tkaUBDnjL_Mt-t1ictGO552QF31DQ+VrEwkm3gg2DFZ14Q@mail.gmail.com>
References: <20220510001807.4132027-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D48I44xYYqEiizbHxYfVxOewlUnyPkLWVYQKrLVTxyk=;
        b=JNZxi5R6tanpqpzBjy/0+KFn83Mbu2fosELlnMjWGAYKkVDQXkm2Xl70193Qjf2ga0
         52j3J3BHgC7rjwYmva0ALj4m2NsVRxFSvRHGk0Lf3TNvHZzsV/NwoBCFhA9cD3/p57qy
         2ABMnn9k7IfWcoZUItEyQBfJZIPT2YNX6QaV4ojKb7sWqd5GxaSlFEQXZdaQ4U3bHmc+
         gWTIS+gwZD4L2fFeX38rX6znFh8nn0InKoksnzJQWb+CN02IH0Ps8bsXq9oNK9+rTE1x
         ZapJZW4IUD1qOP1C29YRya0uensA6pKziFrSpmfx+KBojYD6wNTsqiwWoZiRGT6KGfcz
         Dosw==
In-Reply-To: <20220510001807.4132027-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Networking <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

I have done some significant changes on the BPF side of this. I will
send a RFC V2 soon with those changes and incorporating the feedback
on the cgroup side that I got from Tejun. Hold off on reviewing this
version.


On Mon, May 9, 2022 at 5:18 PM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> This patch series allows for using bpf to collect hierarchical cgroup
> stats efficiently by integrating with the rstat framework. The rstat
> framework provides an efficient way to collect cgroup stats and
> propagate them through the cgroup hierarchy.
>
> The last patch is a selftest that demonastrates the entire workflow.
> The workflow consists of:
> - bpf programs that collect per-cpu per-cgroup stats (tracing progs).
> - bpf rstat flusher that contains the logic for aggregating stats
>   across cpus and across the cgroup hierarchy.
> - bpf cgroup_iter responsible for outputting the stats to userspace
>   through reading a file in bpffs.
>
> The first 3 patches include the new bpf rstat flusher program type and
> the needed support in rstat code and libbpf. The rstat flusher program
> is a callback that the rstat framework makes to bpf when a stat flush is
> ongoing, similar to the css_rstat_flush() callback that rstat makes to
> cgroup controllers. Each callback is parameterized by a (cgroup, cpu)
> pair that has been updated. The program contains the logic for
> aggregating the stats across cpus and across the cgroup hierarchy.
> These programs can be attached to any cgroup subsystem, not only the
> ones that implement the css_rstat_flush() callback in the kernel. This
> gives bpf programs more flexibility, and more isolation from the kernel
> implementation.
>
> The following 2 patches add necessary helpers for the stats collection
> workflow. Helpers that call into cgroup_rstat_updated() and
> cgroup_rstat_flush() are added to allow bpf programs collecting stats to
> tell the rstat framework that a cgroup has been updated, and to allow
> bpf programs outputting stats to tell the rstat framework to flush the
> stats before they are displayed to the user. An additional
> bpf_map_lookup_percpu_elem is introduced to allow rstat flusher programs
> to access percpu stats of the cpu being flushed.
>
> The following 3 patches add the cgroup_iter program type (v2). This was
> originally introduced by Hao as a part of a different series [1].
> Their usecase is better showcased as part of this patch series. We also
> make cgroup_get_from_id() cgroup v1 friendly to allow cgroup_iter programs
> to display stats for cgroup v1 as well. This small change makes the
> entire workflow cgroup v1 friendly without any other dedicated changes.
>
> The final patch is a selftest demonstrating the entire workflow with a
> set of bpf programs that collect per-cgroup latency of memcg reclaim.
>
> [1]https://lore.kernel.org/lkml/20220225234339.2386398-9-haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/
>
>
> Hao Luo (2):
>   cgroup: Add cgroup_put() in !CONFIG_CGROUPS case
>   bpf: Introduce cgroup iter
>
> Yosry Ahmed (7):
>   bpf: introduce CGROUP_SUBSYS_RSTAT program type
>   cgroup: bpf: flush bpf stats on rstat flush
>   libbpf: Add support for rstat progs and links
>   bpf: add bpf rstat helpers
>   bpf: add bpf_map_lookup_percpu_elem() helper
>   cgroup: add v1 support to cgroup_get_from_id()
>   bpf: add a selftest for cgroup hierarchical stats collection
>
>  include/linux/bpf-cgroup-subsys.h             |  35 ++
>  include/linux/bpf.h                           |   4 +
>  include/linux/bpf_types.h                     |   2 +
>  include/linux/cgroup-defs.h                   |   4 +
>  include/linux/cgroup.h                        |   5 +
>  include/uapi/linux/bpf.h                      |  45 +++
>  kernel/bpf/Makefile                           |   3 +-
>  kernel/bpf/arraymap.c                         |  11 +-
>  kernel/bpf/cgroup_iter.c                      | 148 ++++++++
>  kernel/bpf/cgroup_subsys.c                    | 212 +++++++++++
>  kernel/bpf/hashtab.c                          |  25 +-
>  kernel/bpf/helpers.c                          |  56 +++
>  kernel/bpf/syscall.c                          |   6 +
>  kernel/bpf/verifier.c                         |   6 +
>  kernel/cgroup/cgroup.c                        |  16 +-
>  kernel/cgroup/rstat.c                         |  11 +
>  scripts/bpf_doc.py                            |   2 +
>  tools/include/uapi/linux/bpf.h                |  45 +++
>  tools/lib/bpf/bpf.c                           |   3 +
>  tools/lib/bpf/bpf.h                           |   3 +
>  tools/lib/bpf/libbpf.c                        |  35 ++
>  tools/lib/bpf/libbpf.h                        |   3 +
>  tools/lib/bpf/libbpf.map                      |   1 +
>  .../test_cgroup_hierarchical_stats.c          | 335 ++++++++++++++++++
>  tools/testing/selftests/bpf/progs/bpf_iter.h  |   7 +
>  .../selftests/bpf/progs/cgroup_vmscan.c       | 211 +++++++++++
>  26 files changed, 1212 insertions(+), 22 deletions(-)
>  create mode 100644 include/linux/bpf-cgroup-subsys.h
>  create mode 100644 kernel/bpf/cgroup_iter.c
>  create mode 100644 kernel/bpf/cgroup_subsys.c
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/test_cgroup_hierarchical_stats.c
>  create mode 100644 tools/testing/selftests/bpf/progs/cgroup_vmscan.c
>
> --
> 2.36.0.512.ge40c2bad7a-goog
>
