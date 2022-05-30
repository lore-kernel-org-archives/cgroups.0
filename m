From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH mm v3 0/9] memcg: accounting for objects allocated by mkdir
 cgroup
Date: Mon, 30 May 2022 14:25:45 +0300
Message-ID: <3e1d6eab-57c7-ba3d-67e1-c45aa0dfa2ab@openvz.org>
References: <06505918-3b8a-0ad5-5951-89ecb510138e@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=IK1h75QrK4dLAeCcHF6vHO4eDXNyXwLtZQJf9O+8m78=;
        b=XPNvq5NbB2kQePetWgiJpCVF9J44XxrjS/Fy/stHVxJC8lmeUymcBCUm67p4d1i4cZ
         qnXlnY6v2ktg2Yxt9sZ7Qb5LQooZmoGKsQkH4KxqykKI/mPw6t3xpTHDkwkG0hWfB4mS
         6P7rjpWQ/xXC3Uj/qVEsuI/XpPeotY6Mon2SrfSTES1WWK2jh5LcRYYuBCaW3sA28sqB
         /7wJCIyZKMIn86gR9iZ0rN0ZrA2wz5667OJEMKgDBsFCR5bK6mo5YOtmADsqmMBbeoZ0
         X9zJe7NDh4yO3uILPz/BLIkNy0JCVPgedXFPhYxZ51dXuoXgH1/QHI+8g9nl2zeyeQco
         88hQ==
Content-Language: en-US
In-Reply-To: <06505918-3b8a-0ad5-5951-89ecb510138e-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Below is tracing results of mkdir /sys/fs/cgroup/vvs.test on 
4cpu VM with Fedora and self-complied upstream kernel. The calculations
are not precise, it depends on kernel config options, number of cpus,
enabled controllers, ignores possible page allocations etc.
However this is enough to clarify the general situation.
All allocations are splited into:
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
 kernel/sched/psi.c     | 3 ++-
 kernel/sched/rt.c      | 2 +-
 mm/memcontrol.c        | 4 ++--
 8 files changed, 15 insertions(+), 11 deletions(-)

-- 
2.36.1

