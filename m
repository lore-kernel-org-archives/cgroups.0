From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH bpf-next v3 00/13] bpf: Introduce selectable memcg for bpf map
Date: Fri,  2 Sep 2022 02:29:50 +0000
Message-ID: <20220902023003.47124-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=D3AdsrAzP/OCg/edNuQ9xj8+/J7mGnaQDmfeSstZF4o=;
        b=etmvLgpdksRnkUosjQdyioujA+kIpML12lmkCnfGCOavvO1XxHfO4TqJcxHP5b7B0j
         F6Hou4guyntbnb0VTPiO0OXyp3wWgBno+i1vUs3kKc8cOzVSOv+zYcDaEs4oKmHXusOz
         Kz6jIDt7pq15ZFqP1aEp9h76JKe7c+t64qfglAp/t9l2JZ8nYeayTjCfPeo23qdGQh5h
         8GsZIoLf2yVn6ZwKBmzMrnmH9eT5JvGfY4uf6vWy9nin6pXUsSFwHRjZqy43r0vXcIpr
         G09X2nMO6OY9ApWWYGQTLHPGglne0PCdMjUHak9SF5TTvTgMCYjwMJ2wHDqAPTBWae+d
         ZlwQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kafai-b10kYP2dOMg@public.gmane.org, songliubraving-b10kYP2dOMg@public.gmane.org, yhs-b10kYP2dOMg@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

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

Besides, there's another issue that the bpf-map's memcg is breaking the
memcg hierarchy, because bpf-map has its own memcg. A bpf map can be
wrote by tasks running in other memcgs, once a writer in other memcg
writes a shared bpf map, the memory allocated in this writing won't be
charged to the writer's memcg but it will be charge to bpf-map's own
memcg instead. IOW, the bpf-map is improperly treated as a task, while
actually it is a shared resource. This patchset doesn't resolve this
issue. I will post another RFC once I find a workable solution to
address it.

This patchset tries to resolve the above two issues by introducing a
selectable memcg to limit the bpf memory. Currently we only allow to
select its ancestor to avoid breaking the memcg hierarchy further. 
Possible use cases of the selectable memcg as follows,
- Select the root memcg as bpf-map's memcg
  Then bpf-map's memory won't be throttled by current memcg limit.
- Put current memcg under a fixed memcg dir and select the fixed memcg
  as bpf-map's memcg
  The hierarchy as follows,

      Parent-memcg (A fixed dir, i.e. /sys/fs/cgroup/memory/bpf)
         \
        Current-memcg (Container dir, i.e. /sys/fs/cgroup/memory/bpf/foo)

  At the map creation time, the bpf-map's memory will be charged
  into the parent directly without charging into current memcg, and thus
  current memcg's usage will be consistent among different generations.
  To limit bpf-map's memory usage, we can set the limit in the parent
  memcg.

Currenly it only supports for bpf map, and we can extend it to bpf prog
as well.

The observebility can also be supported in the next step, for example,
showing the bpf map's memcg by 'bpftool map show' or even showing which
maps are charged to a specific memcg by 'bpftool cgroup show'.
Furthermore, we may also show an accurate memory size of a bpf map
instead of an estimated memory size in 'bpftool map show' in the future. 

v2->v3:
- use css_tryget() instead of css_tryget_online() (Shakeel)
- add comment for get_obj_cgroup_from_cgroup() (Shakeel)
- add new memcg helper task_under_memcg_hierarchy()
- add restriction to allow selecting ancestor only to avoid breaking the
  memcg hierarchy further, per discussion with Tejun 

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

Yafang Shao (13):
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
  mm, memcg: Add new helper task_under_memcg_hierarchy
  bpf: Add return value for bpf_map_init_from_attr
  bpf: Introduce selectable memcg for bpf map

 include/linux/bpf.h            |  40 +++++++++++-
 include/linux/memcontrol.h     |  25 ++++++++
 include/uapi/linux/bpf.h       |   1 +
 kernel/bpf/arraymap.c          |  34 +++++-----
 kernel/bpf/bloom_filter.c      |  11 +++-
 kernel/bpf/bpf_local_storage.c |  17 +++--
 kernel/bpf/bpf_struct_ops.c    |  19 +++---
 kernel/bpf/cpumap.c            |  17 +++--
 kernel/bpf/devmap.c            |  30 +++++----
 kernel/bpf/hashtab.c           |  26 +++++---
 kernel/bpf/local_storage.c     |  11 +++-
 kernel/bpf/lpm_trie.c          |  12 +++-
 kernel/bpf/offload.c           |  12 ++--
 kernel/bpf/queue_stack_maps.c  |  11 +++-
 kernel/bpf/reuseport_array.c   |  11 +++-
 kernel/bpf/ringbuf.c           | 104 ++++++++++++++++++++----------
 kernel/bpf/stackmap.c          |  13 ++--
 kernel/bpf/syscall.c           | 140 ++++++++++++++++++++++++++++-------------
 kernel/cgroup/cgroup.c         |   2 +-
 mm/memcontrol.c                |  48 ++++++++++++++
 net/core/sock_map.c            |  30 +++++----
 net/xdp/xskmap.c               |  12 +++-
 tools/include/uapi/linux/bpf.h |   1 +
 tools/lib/bpf/bpf.c            |   3 +-
 tools/lib/bpf/bpf.h            |   3 +-
 tools/lib/bpf/gen_loader.c     |   2 +-
 tools/lib/bpf/libbpf.c         |   2 +
 tools/lib/bpf/skel_internal.h  |   2 +-
 28 files changed, 462 insertions(+), 177 deletions(-)

-- 
1.8.3.1

