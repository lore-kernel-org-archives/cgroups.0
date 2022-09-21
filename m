From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH bpf-next 00/10] bpf, mm: Add a new item bpf into memory.stat for the observability of bpf memory
Date: Wed, 21 Sep 2022 16:59:52 +0000
Message-ID: <20220921170002.29557-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=nx1Pb9dM/JhxWQDw5gPMNf7lql+4Go4MShpr0kH8cc0=;
        b=CSmmdZMqYw079U3775ip77HfU+VXCgRduxH7nLU4fKoetQbDbOwQj0N5VV1/R8yDTB
         C5GMBqy47IWpmoTOMmzVq61LzA369UyUVSLinzDwi61L1Axo/PtoSDz2JbP4bzVDzaWl
         1yV5Q4v2g2Z3JLxsorCYmgdPG5ImO6aspZeVppBKF97s56qvy400HqJMer+UI3a14YRR
         gSkLqNo0MAdXwSJHLuriZIstp04xsabXLTTzSVuR4NtzxdYn7TiL3vyQmHPZCYD9N5AT
         3qL2QoEN7swf8pRaRkA/ygy+yZTv4hx4oPBNO5o+2cICKWm6vzzgWsev4IqCrVliZOvV
         rnBw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kafai-b10kYP2dOMg@public.gmane.org, songliubraving-b10kYP2dOMg@public.gmane.org, yhs-b10kYP2dOMg@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

This patchset adds a new item 'bpf' into memory.stat to show the bpf
memory usage in each memcg (except the root memcg because kmem is not
charged into root memcg now). The bpf memory usage is not trivial, so it
deserves a new item.

Patches #1 ~ #8 are from another series[1] which try to fix the pinned bpf
issues, but it seems to be a long way to go. So let's do the observability
first, which has been in my local repo for a long time.

We use the scope-based accouting/unaccouthing to track the bpf memory
usage, which is similar with the way how we charge bpf memory.

We have to annotate both allocations and releases of bpf memory because we
don't want to add something into struct page currently. The allocations
and releases of bpf memory are very clear, so it won't be a trouble.

This patchset only tracks the memory of bpf-map currently.

Future works:
- track the memory of bpf-prog
- observe system-wide bpf memory usage by adding this item into root memcg
- per-map and per-prog bpf memory usage in bpftool or something else
- give user an option to disable memcg-based bpf accouting [2]

Any feedback is welcomed.

[1]. https://lore.kernel.org/bpf/20220902023003.47124-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org/
[2]. https://lore.kernel.org/bpf/CALOAHbAOkUpDWaL2kP8ntBe6sj8S0thLmAwZXhG5kFKBunHt_w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/T/#m3597928c7161b206cb9218c80d9e58a42128d31a

Yafang Shao (10):
  bpf: Introduce new helper bpf_map_put_memcg()
  bpf: Define bpf_map_{get,put}_memcg for !CONFIG_MEMCG_KMEM
  bpf: Call bpf_map_init_from_attr() immediately after map creation
  bpf: Save memcg in bpf_map_init_from_attr()
  bpf: Use scoped-based charge in bpf_map_area_alloc
  bpf: Introduce new helpers bpf_ringbuf_pages_{alloc,free}
  bpf: Use bpf_map_kzalloc in arraymap
  bpf: Use bpf_map_kvcalloc in bpf_local_storage
  bpf: Add bpf map free helpers
  bpf, memcg: Add new item bpf into memory.stat

 include/linux/bpf.h            |  70 ++++++++++++++++++-
 include/linux/memcontrol.h     |  11 +++
 include/linux/sched.h          |   1 +
 include/linux/sched/mm.h       |  24 +++++++
 kernel/bpf/arraymap.c          |  30 ++++-----
 kernel/bpf/bloom_filter.c      |   4 +-
 kernel/bpf/bpf_local_storage.c |  20 +++---
 kernel/bpf/bpf_struct_ops.c    |  14 ++--
 kernel/bpf/cpumap.c            |  24 +++----
 kernel/bpf/devmap.c            |  36 +++++-----
 kernel/bpf/hashtab.c           |  24 ++++---
 kernel/bpf/helpers.c           |   2 +-
 kernel/bpf/local_storage.c     |  14 ++--
 kernel/bpf/lpm_trie.c          |   6 +-
 kernel/bpf/memalloc.c          |  10 +++
 kernel/bpf/offload.c           |   6 +-
 kernel/bpf/queue_stack_maps.c  |   4 +-
 kernel/bpf/reuseport_array.c   |   4 +-
 kernel/bpf/ringbuf.c           | 106 ++++++++++++++++++++---------
 kernel/bpf/stackmap.c          |  13 ++--
 kernel/bpf/syscall.c           | 149 ++++++++++++++++++++++++++++++-----------
 kernel/fork.c                  |   1 +
 mm/memcontrol.c                |  20 ++++++
 net/core/sock_map.c            |  22 +++---
 net/xdp/xskmap.c               |   6 +-
 25 files changed, 439 insertions(+), 182 deletions(-)

-- 
1.8.3.1

