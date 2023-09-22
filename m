From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH bpf-next 0/8] bpf, cgroup: Add bpf support for cgroup controller
Date: Fri, 22 Sep 2023 11:28:38 +0000
Message-ID: <20230922112846.4265-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695382142; x=1695986942; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eBmYJOqhxd1SazsqJY85EKAZwokTy4dGQOyg7MypJ/k=;
        b=matmz69ZegDxdG4AsiHkPrzY4o4hx9uJZ72pFkr3JzSSPTQA/pfMwPR+YRAqrmNW1h
         6ZM5wYGeLlNgqo8sKnIgAI4yUPmFjAxrHoswAIjRaoAll+HZCQYT+nAj6MkdscLvZpz5
         GJCcHmem1m/RUJEBWdGMbOSfy8HvUupABRKZPzlStGWrFmBg5rbTEhYuruqQH/jUwmM4
         Jt++HW1f3Xl1TslnbFZgbFyW/e31QmWq5PN+j/FlRj1gXSBewNhdeUjCTuvQPppOzkQn
         ta2PlXa031TQPujFpmCpdOEDrnTPxC+qTkmtj7HNiIhdwPAX7ACXrLR6+65N3yCIDTvJ
         yM+w==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yonghong.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Currently, BPF is primarily confined to cgroup2, with the exception of
cgroup_iter, which supports cgroup1 fds. Unfortunately, this limitation
prevents us from harnessing the full potential of BPF within cgroup1
environments.

In our endeavor to seamlessly integrate BPF within our Kubernetes
environment, which relies on cgroup1, we have been exploring the
possibility of transitioning to cgroup2. While this transition is
forward-looking, it poses challenges due to the necessity for numerous
applications to adapt.

While we acknowledge that cgroup2 represents the future, we also recognize
that such transitions demand time and effort. As a result, we are
considering an alternative approach. Instead of migrating to cgroup2, we
are contemplating modifications to the BPF kernel code to ensure
compatibility with cgroup1. These adjustments appear to be relatively
minor, making this option more feasible.

Given the widespread use of cgroup1 in container environments, this change
would be beneficial to many users.

Based on our investigation, the optimal way to enable BPF on cgroup1 is to
utilize the cgroup controller. The cgroup becomes active only when it has
one or more of its controllers enabled. In production environments, a task
is consistently managed by at least one cgroup controller. Consequently, we
can always establish a direct link between a task and a cgroup controller,
enabling us to perform actions based on this connection. As a consequence,
this patchset introduces the following new kfuncs: 

- bpf_cgroup_id_from_task_within_controller
  Retrieves the cgroup ID from a task within a specific cgroup controller.
- bpf_cgroup_acquire_from_id_within_controller
  Acquires the cgroup from a cgroup ID within a specific cgroup controller.
- bpf_cgroup_ancestor_id_from_task_within_controller
  Retrieves the ancestor cgroup ID from a task within a specific cgroup
  controller.

The advantage of these new BPF kfuncs is their ability to abstract away the
complexities of cgroup hierarchies, irrespective of whether they involve
cgroup1 or cgroup2.

In the future, we may expand controller-based support to other BPF
functionalities, such as bpf_cgrp_storage, the attachment and detachment
of cgroups, skb_under_cgroup, and more.

Changes:
- bpf, cgroup: Enable cgroup_array map on cgroup1
  https://lore.kernel.org/bpf/20230903142800.3870-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org/

Yafang Shao (8):
  bpf: Fix missed rcu read lock in bpf_task_under_cgroup()
  cgroup: Enable task_under_cgroup_hierarchy() on cgroup1
  cgroup: Add cgroup_get_from_id_within_subsys()
  bpf: Add new kfuncs support for cgroup controller
  selftests/bpf: Fix issues in setup_classid_environment()
  selftests/bpf: Add parallel support for classid
  selftests/bpf: Add new cgroup helper get_classid_cgroup_id()
  selftests/bpf: Add selftests for cgroup controller

 include/linux/cgroup-defs.h                   |  20 +++
 include/linux/cgroup.h                        |  31 +++-
 kernel/bpf/helpers.c                          |  77 ++++++++-
 kernel/cgroup/cgroup-internal.h               |  20 ---
 kernel/cgroup/cgroup.c                        |  32 +++-
 tools/testing/selftests/bpf/cgroup_helpers.c  |  65 ++++++--
 tools/testing/selftests/bpf/cgroup_helpers.h  |   3 +-
 .../bpf/prog_tests/cgroup_controller.c        | 149 ++++++++++++++++++
 .../selftests/bpf/prog_tests/cgroup_v1v2.c    |   2 +-
 .../bpf/progs/test_cgroup_controller.c        |  80 ++++++++++
 10 files changed, 430 insertions(+), 49 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_controller.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_cgroup_controller.c

-- 
2.30.1 (Apple Git-130)

