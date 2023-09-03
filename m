From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH bpf-next 0/5] bpf, cgroup: Enable cgroup_array map on cgroup1
Date: Sun,  3 Sep 2023 14:27:55 +0000
Message-ID: <20230903142800.3870-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693751288; x=1694356088; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wXDwjjmxqBAOxuWYsnka7JEJGco2H68JBbaxg6PfkIk=;
        b=jSNWjZ5wyBil44ZjC6NBwT9tp9IDYKITmez76HTetNXNAJrdXuSQ73e82iagc3zblY
         lT5N439w2C5Lp38k8a5dQNI3BSkVScx/GMR7XBDsAuBF0fQ7TzLkzXiYP+57XulMi4vS
         Cfj3mL5QoV5IVkF5LWuiqU64aL7FliupZM6JpYFdmXiS6S3+VHDBtqYlmVIDAWuz2i8t
         tvJ4l24W4SxWYox+tKm8dhLVdAvNhG20EQfWvl/cRh7Xq2Nri1le6V3oJI7788Q7Qffu
         6TvqjfZMRiGTC/fGFYdIne9UrdoaQ5PQE00jTEgTaE3NBLuNgZ61BP0dUCwNYojiUdpG
         mOLQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yonghong.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Currently, the cgroup_array map serves as a critical component for
bpf_current_under_cgroup() and bpf_skb_under_cgroup() functions, allowing
us to determine whether a task or a socket buffer (skb) resides within a
specific cgroup. However, a limitation exists as we can only store cgroup2
file descriptors in the cgroup_array map. This limitation stems from the
fact that cgroup_get_from_fd() exclusively supports cgroup2 file
descriptors. Fortunately, an alternative solution presents itself by
leveraging cgroup_v1v2_get_from_fd(), which accommodates both cgroup1 and
cgroup2 file descriptors.

It is essential to note that it is safe to utilize a cgroup1 pointer within
both bpf_current_under_cgroup() and bpf_skb_under_cgroup(), with the result
of receiving a "false" return value when verifying a cgroup1 pointer. To
enable the checking of tasks under a cgroup1 hierarchy, we can make a minor
modification to task_under_cgroup_hierarchy() to add support for cgroup1.

In our specific use case, we intend to use bpf_current_under_cgroup() to
audit whether the current task resides within specific containers.
Subsequently, we can use this information to create distinct ACLs within
our LSM BPF programs, enabling us to control specific operations performed
by these tasks.

Considering the widespread use of cgroup1 in container environments,
coupled with the considerable time it will take to transition to cgroup2,
implementing this change will significantly enhance the utility of BPF
in container scenarios. This is especially noteworthy because the necessary
adjustments can be made with minimal alterations to both the cgroup
subsystem and the BPF subsystem.

Yafang Shao (5):
  cgroup: Enable task_under_cgroup_hierarchy() on cgroup1
  bpf: Enable cgroup_array map on cgroup1
  selftests/bpf: Fix issues in setup_classid_environment()
  selftests/bpf: Add new cgroup helper open_classid()
  selftests/bpf: Add selftests for current_under_cgroupv1v2

 include/linux/cgroup.h                             | 24 ++++++-
 kernel/bpf/arraymap.c                              |  2 +-
 tools/testing/selftests/bpf/cgroup_helpers.c       | 34 ++++++++--
 tools/testing/selftests/bpf/cgroup_helpers.h       |  1 +
 .../bpf/prog_tests/current_under_cgroupv1v2.c      | 76 ++++++++++++++++++++++
 .../bpf/progs/test_current_under_cgroupv1v2.c      | 31 +++++++++
 6 files changed, 160 insertions(+), 8 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/current_under_cgroupv1v2.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_current_under_cgroupv1v2.c

-- 
1.8.3.1

