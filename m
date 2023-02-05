From: Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next 0/5] bpf, mm: introduce cgroup.memory=nobpf
Date: Sun,  5 Feb 2023 06:58:00 +0000
Message-ID: <20230205065805.19598-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NkWRdzEKke7GR8UIzoPrXe0fCR7Zi4RGiPc8wkbTB4w=;
        b=XSC+bQejMiGP5TbJYVDlLreC8JI6izirwf2lFqkk+LIE4in+7ZH/gEPPm+2/e6s3sj
         4VfBFEKjaVS6SVUHOiDcEf7TGvyMIphk/+tiH/qgiOeuZIC134Qmja6JNox0NpC+uro0
         hq/ZslHjhPEmSkhFXVsx1E3GRLJVqS2ou2fUs/S8qLkFZCFqLLlXdfSht5fx2xt0aPTJ
         wM7CiLm5JJpJYF40pc/jTJpxsXUv5/TfQiDb2/bNX9TsaJVq9fGsjqE8kBNFc6vae5Hm
         FoQHwrX4C/UuNQiWXiNDSB8joi4VfJQGFFL70FV9ToCJ7K64eB+p2C2OG72S8Paoxqvp
         hMSg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com, haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, muchun.song@linux.dev, akpm@linux-foundation.org
Cc: bpf@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Yafang Shao <laoar.shao@gmail.com>

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

So let's give the user an option to disable bpf memory accouting.

The idea of "cgroup.memory=nobpf" is originally by Tejun[1].

[1]. https://lwn.net/ml/linux-mm/YxjOawzlgE458ezL@slm.duckdns.org/

Yafang Shao (5):
  mm: memcontrol: add new kernel parameter cgroup.memory=nobpf
  bpf: use bpf_map_kvcalloc in bpf_local_storage
  bpf: introduce bpf_memcg_flags()
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

