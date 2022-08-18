From: Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v2 00/12] bpf: Introduce selectable memcg for bpf map
Date: Thu, 18 Aug 2022 14:31:06 +0000
Message-ID: <20220818143118.17733-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=c1WEf4wfw+eYI3/NLfmAkL0HVsaKNZD3LYmt0L7ELIY=;
        b=PiwtgzyiX5ngjtC3a8Zd0FUpTS0q1msVkEh/kNMiegKDzMOSRgih9AVLnLkUxsdk8s
         ypVnUKUkH4t9MsBKkKgGwUTSpDTrNduj+CYwl3GhE77yU1zV97UAG0O5H+WZeVZmXVQz
         WhwBH/8Uz0mm5A1TXwEdmwyG7AaNdmWs4M2ZhqmgyFAtZm0TokzEJjVay6hS6ubjSlOr
         x4eRaudFx/PsVwWvT+LS9gQ4uZ8cantjsfeC/VqQnb2LPFS5PM5qBi1YKIeBTAkvjKO6
         /IK2hEysvwIwSHKJa6ZljuwEOGEwOk/0nzAjgxEl0mg7MY0tFmHWlxTjnQ3Hi6o3DcPV
         br1w==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com, haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, songmuchun@bytedance.com, akpm@linux-foundation.org, tj@kernel.org, lizefan.x@bytedance.com
Cc: cgroups@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org, Yafang Shao <laoar.shao@gmail.com>

On our production environment, we may load, run and pin bpf programs and
maps in containers. For example, some of our networking bpf programs and
maps are loaded and pinned by a process running in a container on our
k8s environment. In this container, there're also running some other
user applications which watch the networking configurations from remote
servers and update them on this local host, log the error events, monitor
the traffic, and do some other stuffs. Sometimes we may need to update 
these user applications to a new release, and in this update process we
will destroy the old container and then start a new genration. In order not
to interrupt the bpf programs in the update process, we will pin the bpf
programs and maps in bpffs. That is the background and use case on our
production environment. 

After switching to memcg-based bpf memory accounting to limit the bpf
memory, some unexpected issues jumped out at us.
1. The memory usage is not consistent between the first generation and
new generations.
2. After the first generation is destroyed, the bpf memory can't be
limited if the bpf maps are not preallocated, because they will be
reparented.

This patchset tries to resolve these issues by introducing an
independent memcg to limit the bpf memory.

In the bpf map creation, we can assign a specific memcg instead of using
the current memcg.  That makes it flexible in containized environment.
For example, if we want to limit the pinned bpf maps, we can use below
hierarchy,

    Shared resources              Private resources 
                                    
     bpf-memcg                      k8s-memcg
     /        \                     /             
bpf-bar-memcg bpf-foo-memcg   srv-foo-memcg        
                  |               /        \
               (charged)     (not charged) (charged)                 
                  |           /              \
                  |          /                \
          bpf-foo-{progs,maps}              srv-foo

srv-foo loads and pins bpf-foo-{progs, maps}, but they are charged to an
independent memcg (bpf-foo-memcg) instead of srv-foo's memcg
(srv-foo-memcg).

Pls. note that there may be no process in bpf-foo-memcg, that means it
can be rmdir-ed by root user currently. Meanwhile we don't forcefully
destroy a memcg if it doesn't have any residents. So this hierarchy is
acceptible. 

In order to make the memcg of bpf maps seletectable, this patchset
introduces some memory allocation wrappers to allocate map related
memory. In these wrappers, it will get the memcg from the map and then
charge the allocated pages or objs.  

Currenly it only supports for bpf map, and we can extend it to bpf prog
as well.

The observebility can also be supported in the next step, for example,
showing the bpf map's memcg by 'bpftool map show' or even showing which
maps are charged to a specific memcg by 'bpftool cgroup show'.
Furthermore, we may also show an accurate memory size of a bpf map
instead of an estimated memory size in 'bpftool map show' in the future. 

v1->v2:
- cgroup1 is also supported after
  commit f3a2aebdd6fb ("cgroup: enable cgroup_get_from_file() on cgroup1")
  So update the commit log.
- remove incorrect fix to mem_cgroup_put  (Shakeel,Roman,Muchun) 
- use cgroup_put() in bpf_map_save_memcg() (Shakeel)
- add detailed commit log for get_obj_cgroup_from_cgroup (Shakeel) 

RFC->v1:
- get rid of bpf_map container wrapper (Alexei)
- add the new field into the end of struct (Alexei)
- get rid of BPF_F_SELECTABLE_MEMCG (Alexei)
- save memcg in bpf_map_init_from_attr
- introduce bpf_ringbuf_pages_{alloc,free} and keep them inside
  kernel/bpf/ringbuf.c  (Andrii)

Yafang Shao (12):
  cgroup: Update the comment on cgroup_get_from_fd
  bpf: Introduce new helper bpf_map_put_memcg()
  bpf: Define bpf_map_{get,put}_memcg for !CONFIG_MEMCG_KMEM
  bpf: Call bpf_map_init_from_attr() immediately after map creation
  bpf: Save memcg in bpf_map_init_from_attr()
  bpf: Use scoped-based charge in bpf_map_area_alloc
  bpf: Introduce new helpers bpf_ringbuf_pages_{alloc,free}
  bpf: Use bpf_map_kzalloc in arraymap
  bpf: Use bpf_map_kvcalloc in bpf_local_storage
  mm, memcg: Add new helper get_obj_cgroup_from_cgroup
  bpf: Add return value for bpf_map_init_from_attr
  bpf: Introduce selectable memcg for bpf map

 include/linux/bpf.h            |  40 +++++++++++-
 include/linux/memcontrol.h     |  11 ++++
 include/uapi/linux/bpf.h       |   1 +
 kernel/bpf/arraymap.c          |  34 ++++++-----
 kernel/bpf/bloom_filter.c      |  11 +++-
 kernel/bpf/bpf_local_storage.c |  17 ++++--
 kernel/bpf/bpf_struct_ops.c    |  19 +++---
 kernel/bpf/cpumap.c            |  17 ++++--
 kernel/bpf/devmap.c            |  30 +++++----
 kernel/bpf/hashtab.c           |  26 +++++---
 kernel/bpf/local_storage.c     |  11 +++-
 kernel/bpf/lpm_trie.c          |  12 +++-
 kernel/bpf/offload.c           |  12 ++--
 kernel/bpf/queue_stack_maps.c  |  11 +++-
 kernel/bpf/reuseport_array.c   |  11 +++-
 kernel/bpf/ringbuf.c           | 104 +++++++++++++++++++++----------
 kernel/bpf/stackmap.c          |  13 ++--
 kernel/bpf/syscall.c           | 136 ++++++++++++++++++++++++++++-------------
 kernel/cgroup/cgroup.c         |   2 +-
 mm/memcontrol.c                |  47 ++++++++++++++
 net/core/sock_map.c            |  30 +++++----
 net/xdp/xskmap.c               |  12 +++-
 tools/include/uapi/linux/bpf.h |   1 +
 tools/lib/bpf/bpf.c            |   3 +-
 tools/lib/bpf/bpf.h            |   3 +-
 tools/lib/bpf/gen_loader.c     |   2 +-
 tools/lib/bpf/libbpf.c         |   2 +
 tools/lib/bpf/skel_internal.h  |   2 +-
 28 files changed, 443 insertions(+), 177 deletions(-)

-- 
1.8.3.1

