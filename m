From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH mm v4 0/9] memcg: accounting for objects allocated by mkdir
 cgroup
Date: Mon, 13 Jun 2022 08:34:32 +0300
Message-ID: <4e685057-b07d-745d-fdaa-1a6a5a681060@openvz.org>
References: <3e1d6eab-57c7-ba3d-67e1-c45aa0dfa2ab@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=RTfZfeDWSN9OZfR7Sv1ydjBOr9B3JdsI1X9ofrvtdxQ=;
        b=bWa4lC6WVgrmLNdVVYMdTBcNm6a37vG8B+DS8jzdCwMcANuwtYv2akgfv285oN78T2
         hGpMT+t/LTTVWpKQnVj0/aM+JgR5Oh5UyiTAKL2+NhTokEU6RX7MOnZ1JqaP6Qqly3Oi
         RWPyrXa0GwAdQQOS9/WV9nnhUOMaVi16RHFGXrIBxHCjBbb2YAkHTmraXFOmXYTEHNA4
         tp7Wbni7gfyRw0y7l/9Wbu+zCozeGy9fQ28Q7pz1XTQbq6w1stc6kRO0Y3maWPmE8ax/
         ftgTMltKXboV+qctvSYXMHSXpAckaHfR4UYMMhnsCOTnwHbekGj/wOzwXhUHZM81/YGW
         l+iA==
Content-Language: en-US
In-Reply-To: <3e1d6eab-57c7-ba3d-67e1-c45aa0dfa2ab-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

In some cases, creating a cgroup allocates a noticeable amount of memory.
This operation can be executed from inside memory-limited container,
but currently this memory is not accounted to memcg and can be misused.
This allow container to exceed the assigned memory limit and avoid
memcg OOM. Moreover, in case of global memory shortage on the host,
the OOM-killer may not find a real memory eater and start killing
random processes on the host.

This is especially important for OpenVZ and LXC used on hosting,
where containers are used by untrusted end users.

Below is tracing results of mkdir /sys/fs/cgroup/vvs.test on 
4cpu VM with Fedora and self-complied upstream kernel. The calculations
are not precise, it depends on kernel config options, number of cpus,
enabled controllers, ignores possible page allocations etc.
However this is enough to clarify the general situation.
All allocations are splitted into:
- common part, always called for each cgroup type
- per-cgroup allocations

In each group we consider 2 corner cases:
- usual allocations, important for 1-2 CPU nodes/Vms
- percpu allocations, important for 'big irons'

common part: 	~11Kb	+  318 bytes percpu
memcg: 		~17Kb	+ 4692 bytes percpu
cpu:		~2.5Kb	+ 1036 bytes percpu
cpuset:		~3Kb	+   12 bytes percpu
blkcg:		~3Kb	+   12 bytes percpu
pid:		~1.5Kb	+   12 bytes percpu		
perf:		 ~320b	+   60 bytes percpu
-------------------------------------------
total:		~38Kb	+ 6142 bytes percpu
currently accounted:	  4668 bytes percpu

- it's important to account usual allocations called
in common part, because almost all of cgroup-specific allocations
are small. One exception here is memory cgroup, it allocates a few
huge objects that should be accounted.
- Percpu allocation called in common part, in memcg and cpu cgroups
should be accounted, rest ones are small an can be ignored.
- KERNFS objects are allocated both in common part and in most of
cgroups 

Details can be found here:
https://lore.kernel.org/all/d28233ee-bccb-7bc3-c2ec-461fd7f95e6a-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org/

I checked other cgroups types was found that they all can be ignored.
Additionally I found allocation of struct rt_rq called in cpu cgroup 
if CONFIG_RT_GROUP_SCHED was enabled, it allocates huge (~1700 bytes)
percpu structure and should be accounted too.

v4:
 1) re-based to linux-next (next-20220610)
   now psi_group is not a part of struct cgroup and is allocated on demand
 2) added received approval from Muchun Song
 3) improved cover letter description according to akpm@ request

v3:
 1) re-based to current upstream (v5.18-11267-gb00ed48bb0a7)
 2) fixed few typos
 3) added received approvals

v2:
 1) re-split to simplify possible bisect, re-ordered
 2) added accounting for percpu psi_group_cpu and cgroup_rstat_cpu,
     allocated in common part
 3) added accounting for percpu allocation of struct rt_rq
     (actual if CONFIG_RT_GROUP_SCHED is enabled)
 4) improved patches descriptions 

Vasily Averin (9):
  memcg: enable accounting for struct cgroup
  memcg: enable accounting for kernfs nodes
  memcg: enable accounting for kernfs iattrs
  memcg: enable accounting for struct simple_xattr
  memcg: enable accounting for percpu allocation of struct psi_group_cpu
  memcg: enable accounting for percpu allocation of struct
    cgroup_rstat_cpu
  memcg: enable accounting for large allocations in mem_cgroup_css_alloc
  memcg: enable accounting for allocations in alloc_fair_sched_group
  memcg: enable accounting for perpu allocation of struct rt_rq

 fs/kernfs/mount.c      | 6 ++++--
 fs/xattr.c             | 2 +-
 kernel/cgroup/cgroup.c | 2 +-
 kernel/cgroup/rstat.c  | 3 ++-
 kernel/sched/fair.c    | 4 ++--
 kernel/sched/psi.c     | 5 +++--
 kernel/sched/rt.c      | 2 +-
 mm/memcontrol.c        | 4 ++--
 8 files changed, 16 insertions(+), 12 deletions(-)

-- 
2.36.1

