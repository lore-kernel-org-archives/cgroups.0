From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH bpf-next v2 0/4] bpf, mm: introduce cgroup.memory=nobpf
Date: Fri, 10 Feb 2023 15:47:30 +0000
Message-ID: <20230210154734.4416-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=s+YH2jubPt3atRm183/M73ZL/tfmWGLNd7PCoTgNemA=;
        b=QNqX8q2ZIQrMW67nmsy+zUNpS7XR5DpjwMa+QC46vQ4QQmBXgjRWFzUADH3PIVQAvM
         FZQ0+Lwy2K0/Q2dxn7RUNIP2sSCxrkOWkrr7iR7EFCZjNYeXAt2HozKhomVVZ84I1Req
         JaybFnw9Q3fIYLoNgQJdOlHfqCehA7iHa+v+DquWbC8y3Quf4X2ILQxsPHjhh2v7hjzD
         HTVfSVvQSXhPC2803RTP2MCbSbL20xfU1iKSVd1lK5EBjizBudJSJxvBrsNGQuyOaTZ/
         njYYNt/pF7HbveYbeszG4LcRP2LxwcPrizgibQa72LOJwIrixuInxvYzU7aTn6mCyyiY
         Ocjg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kafai-b10kYP2dOMg@public.gmane.org, songliubraving-b10kYP2dOMg@public.gmane.org, yhs-b10kYP2dOMg@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

The bpf memory accouting has some known problems in contianer
environment,

- The container memory usage is not consistent if there's pinned bpf
  program
  After the container restart, the leftover bpf programs won't account
  to the new generation, so the memory usage of the container is not
  consistent. This issue can be resolved by introducing selectable
  memcg, but we don't have an agreement on the solution yet. See also
  the discussions at https://lwn.net/Articles/905150/ .

- The leftover non-preallocated bpf map can't be limited
  The leftover bpf map will be reparented, and thus it will be limited by 
  the parent, rather than the container itself. Furthermore, if the
  parent is destroyed, it be will limited by its parent's parent, and so
  on. It can also be resolved by introducing selectable memcg.

- The memory dynamically allocated in bpf prog is charged into root memcg
  only
  Nowdays the bpf prog can dynamically allocate memory, for example via
  bpf_obj_new(), but it only allocate from the global bpf_mem_alloc
  pool, so it will charge into root memcg only. That needs to be
  addressed by a new proposal.

So let's give the container user an option to disable bpf memory accouting.

The idea of "cgroup.memory=nobpf" is originally by Tejun[1].

[1]. https://lwn.net/ml/linux-mm/YxjOawzlgE458ezL-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org/

Changes,
v1->v2:
- squash patches (Roman)
- commit log improvement in patch #2. (Johannes)

Yafang Shao (4):
  mm: memcontrol: add new kernel parameter cgroup.memory=nobpf
  bpf: use bpf_map_kvcalloc in bpf_local_storage
  bpf: allow to disable bpf map memory accounting
  bpf: allow to disable bpf prog memory accounting

 Documentation/admin-guide/kernel-parameters.txt |  1 +
 include/linux/bpf.h                             | 16 ++++++++++++++++
 include/linux/memcontrol.h                      | 11 +++++++++++
 kernel/bpf/bpf_local_storage.c                  |  4 ++--
 kernel/bpf/core.c                               | 13 +++++++------
 kernel/bpf/memalloc.c                           |  3 ++-
 kernel/bpf/syscall.c                            | 20 ++++++++++++++++++--
 mm/memcontrol.c                                 | 18 ++++++++++++++++++
 8 files changed, 75 insertions(+), 11 deletions(-)

-- 
1.8.3.1

