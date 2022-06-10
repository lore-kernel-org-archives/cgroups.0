From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH bpf-next v2 0/8] bpf: rstat: cgroup hierarchical stats
Date: Fri, 10 Jun 2022 12:48:44 -0700
Message-ID: <CAJD7tkaMAnxsfyTc4iQibBzYt5-F68yKYqbdd9AM8_8Mh59+tw@mail.gmail.com>
References: <20220610194435.2268290-1-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KdwZ/vUxOQWQkpuIaKHLX7u/kAU2F/0Z5D//aWshiaw=;
        b=DK3zmA3Y7haqkUBhh+3+yCjdIUO5DMoJqNlZ35RjXPjmo+ybkTUvi2TW9NkM6C2CaC
         DCsoxCEmFD/7wosp76WHlPibPHSEpxXST5r95JkllGypUS15xProP8CwEdtzGL0K0jgc
         WJv1l0b+AatR5AVl3to0Q5vkt3HMIDdzzeK4MfoY3vwzXKzyKuH2vkkURu7Xe9ArCjgS
         ekL+9xpCoJWkcAGiatqjoiqH8o9PSRxoSyYWPPTWEvs4nnD8+WplCJWgCPu9hrJwuqTg
         n8Fh936C4qtmi3DWV+T+r5uhUHh5jH/HPkPPvsKR9SsW+H6g6BLaeUwz5Pw3ZiTmkG6l
         3qAQ==
In-Reply-To: <20220610194435.2268290-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Networking <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>

+cc Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org>


On Fri, Jun 10, 2022 at 12:44 PM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> This patch series allows for using bpf to collect hierarchical cgroup
> stats efficiently by integrating with the rstat framework. The rstat
> framework provides an efficient way to collect cgroup stats percpu and
> propagate them through the cgroup hierarchy.
>
> The stats are exposed to userspace in textual form by reading files in
> bpffs, similar to cgroupfs stats by using a cgroup_iter program.
> cgroup_iter is a type of bpf_iter. It walks over cgroups in two modes:
>
>  - walking a cgroup's descendants.
>  - walking a cgroup's ancestors.
>
> When attaching cgroup_iter, one needs to set a cgroup to the iter_link
> created from attaching. This cgroup is passed as a file descriptor and
> serves as the starting point of the walk.
>
> For walking descendants, one can specify the order: either pre-order or
> post-order. For walking ancestors, the walk starts at the specified
> cgroup and ends at the root.
>
> One can also terminate the walk early by returning 1 from the iter
> program.
>
> Note that because walking cgroup hierarchy holds cgroup_mutex, the iter
> program is called with cgroup_mutex held.
>
> ** Background on rstat for stats collection **
> (I am using a subscriber analogy that is not commonly used)
>
> The rstat framework maintains a tree of cgroups that have updates and
> which cpus have updates. A subscriber to the rstat framework maintains
> their own stats. The framework is used to tell the subscriber when
> and what to flush, for the most efficient stats propagation. The
> workflow is as follows:
>
> - When a subscriber updates a cgroup on a cpu, it informs the rstat
>   framework by calling cgroup_rstat_updated(cgrp, cpu).
>
> - When a subscriber wants to read some stats for a cgroup, it asks
>   the rstat framework to initiate a stats flush (propagation) by calling
>   cgroup_rstat_flush(cgrp).
>
> - When the rstat framework initiates a flush, it makes callbacks to
>   subscribers to aggregate stats on cpus that have updates, and
>   propagate updates to their parent.
>
> Currently, the main subscribers to the rstat framework are cgroup
> subsystems (e.g. memory, block). This patch series allow bpf programs to
> become subscribers as well.
>
> Patches in this series are based off a patch in the mailing
> list which adds a new kfunc set for sleepable functions:
> "btf: Add a new kfunc set which allows to mark a function to be
> sleepable" [1].
>
> Patches in this series are organized as follows:
> * Patch 1 enables the use of cgroup_get_from_file() in cgroup1.
>   This is useful because it enables cgroup_iter to work with cgroup1, and
>   allows the entire stat collection workflow to be cgroup1-compatible.
> * Patches 2-5 introduce cgroup_iter prog, and a selftest.
> * Patches 6-8 allow bpf programs to integrate with rstat by adding the
>   necessary hook points and kfunc. A comprehensive selftest that
>   demonstrates the entire workflow for using bpf and rstat to
>   efficiently collect and output cgroup stats is added.
>
> v1 -> v2:
> - Redesign of cgroup_iter from v1, based on Alexei's idea [2]:
>   - supports walking cgroup subtree.
>   - supports walking ancestors of a cgroup. (Andrii)
>   - supports terminating the walk early.
>   - uses fd instead of cgroup_id as parameter for iter_link. Using fd is
>     a convention in bpf.
>   - gets cgroup's ref at attach time and deref at detach.
>   - brought back cgroup1 support for cgroup_iter.
> - Squashed the patches adding the rstat flush hook points and kfuncs
>   (Tejun).
> - Added a comment explaining why bpf_rstat_flush() needs to be weak
>   (Tejun).
> - Updated the final selftest with the new cgroup_iter design.
> - Changed CHECKs in the selftest with ASSERTs (Yonghong, Andrii).
> - Removed empty line at the end of the selftest (Yonghong).
> - Renamed test files to cgroup_hierarchical_stats.c.
> - Reordered CGROUP_PATH params order to match struct declaration
>   in the selftest (Michal).
> - Removed memory_subsys_enabled() and made sure memcg controller
>   enablement checks make sense and are documented (Michal).
>
> RFC v2 -> v1:
> - Instead of introducing a new program type for rstat flushing, add an
>   empty hook point, bpf_rstat_flush(), and use fentry bpf programs to
>   attach to it and flush bpf stats.
> - Instead of using helpers, use kfuncs for rstat functions.
> - These changes simplify the patchset greatly, with minimal changes to
>   uapi.
>
> RFC v1 -> RFC v2:
> - Instead of rstat flush programs attach to subsystems, they now attach
>   to rstat (global flushers, not per-subsystem), based on discussions
>   with Tejun. The first patch is entirely rewritten.
> - Pass cgroup pointers to rstat flushers instead of cgroup ids. This is
>   much more flexibility and less likely to need a uapi update later.
> - rstat helpers are now only defined if CGROUP_CONFIG.
> - Most of the code is now only defined if CGROUP_CONFIG and
>   CONFIG_BPF_SYSCALL.
> - Move rstat helper protos from bpf_base_func_proto() to
>   tracing_prog_func_proto().
> - rstat helpers argument (cgroup pointer) is now ARG_PTR_TO_BTF_ID, not
>   ARG_ANYTHING.
> - Rewrote the selftest to use the cgroup helpers.
> - Dropped bpf_map_lookup_percpu_elem (already added by Feng).
> - Dropped patch to support cgroup v1 for cgroup_iter.
> - Dropped patch to define some cgroup_put() when !CONFIG_CGROUP. The
>   code that calls it is no longer compiled when !CONFIG_CGROUP.
>
> cgroup_iter was originally introduced in a different patch series[3].
> Hao and I agreed that it fits better as part of this series.
> RFC v1 of this patch series had the following changes from [3]:
> - Getting the cgroup's reference at the time at attaching, instead of
>   at the time when iterating. (Yonghong)
> - Remove .init_seq_private and .fini_seq_private callbacks for
>   cgroup_iter. They are not needed now. (Yonghong)
>
> [1] https://lore.kernel.org/bpf/20220421140740.459558-5-benjamin.tissoire=
s@redhat.com/
> [2] https://lore.kernel.org/bpf/20220520221919.jnqgv52k4ajlgzcl@MBP-98dd6=
07d3435.dhcp.thefacebook.com/
> [3] https://lore.kernel.org/lkml/20220225234339.2386398-9-haoluo@google.c=
om/
>
> Hao Luo (4):
>   cgroup: Add cgroup_put() in !CONFIG_CGROUPS case
>   bpf, iter: Fix the condition on p when calling stop.
>   bpf: Introduce cgroup iter
>   selftests/bpf: Test cgroup_iter.
>
> Yosry Ahmed (4):
>   cgroup: enable cgroup_get_from_file() on cgroup1
>   cgroup: bpf: enable bpf programs to integrate with rstat
>   selftests/bpf: extend cgroup helpers
>   bpf: add a selftest for cgroup hierarchical stats collection
>
>  include/linux/bpf.h                           |   8 +
>  include/linux/cgroup.h                        |   3 +
>  include/uapi/linux/bpf.h                      |  21 ++
>  kernel/bpf/Makefile                           |   2 +-
>  kernel/bpf/bpf_iter.c                         |   5 +
>  kernel/bpf/cgroup_iter.c                      | 235 ++++++++++++
>  kernel/cgroup/cgroup.c                        |   5 -
>  kernel/cgroup/rstat.c                         |  46 +++
>  tools/include/uapi/linux/bpf.h                |  21 ++
>  tools/testing/selftests/bpf/cgroup_helpers.c  | 173 +++++++--
>  tools/testing/selftests/bpf/cgroup_helpers.h  |  15 +-
>  .../prog_tests/cgroup_hierarchical_stats.c    | 351 ++++++++++++++++++
>  .../selftests/bpf/prog_tests/cgroup_iter.c    | 190 ++++++++++
>  tools/testing/selftests/bpf/progs/bpf_iter.h  |   7 +
>  .../bpf/progs/cgroup_hierarchical_stats.c     | 234 ++++++++++++
>  .../testing/selftests/bpf/progs/cgroup_iter.c |  39 ++
>  16 files changed, 1303 insertions(+), 52 deletions(-)
>  create mode 100644 kernel/bpf/cgroup_iter.c
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_hierarc=
hical_stats.c
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
>  create mode 100644 tools/testing/selftests/bpf/progs/cgroup_hierarchical=
_stats.c
>  create mode 100644 tools/testing/selftests/bpf/progs/cgroup_iter.c
>
> --
> 2.36.1.476.g0c4daa206d-goog
>
