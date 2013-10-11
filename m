From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 00/12] cpuset: separate configured masks and effective
 masks
Date: Fri, 11 Oct 2013 17:49:21 +0800
Message-ID: <5257C9A1.1030404@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

This patcheset introduces behavior changes, but only if you mount cgroupfs
with sane_behavior option:

- We introduce new interfaces cpuset.effective_cpus and cpuset.effective_mems,
  while cpuset.cpus and cpuset.mems will be configured masks.

- The configured masks can be changed by writing cpuset.cpus/mems only. They
  won't be changed when hotplug happens.

- Users can config cpus and mems without restrictions from the parent cpuset.
  effective masks will enforce the hierarchical behavior.

- Users can also config cpus and mems to have already offlined CPU/nodes.

- When a CPU/node is onlined, it will be brought back to the effective masks
  if it's in the configured masks.

- We build sched domains based on effective cpumask but not configured cpumask.


v2:
- fixed two bugs
- made changelogs more verbose
- added more comments
- changed cs->real_{mems,cpus}_allowed to cs->effective_{mems, cpus}
- splitted "cpuset: enable onlined cpu/node in effective masks" into 2 patches
- exported cpuset.effective_{cpus,mems} unconditionally


Li Zefan (12):
  cpuset: add cs->effective_cpus and cs->effective_mems
  cpuset: update cpuset->effective_{cpus,mems} at hotplug
  cpuset: update cs->effective_{cpus,mems} when config changes
  cpuset: inherit ancestor's masks if effective_{cpus,mems} becomes empty
  cpuset: use effective cpumask to build sched domains
  cpuset: initialize top_cpuset's configured masks at mount
  cpuset: apply cs->effective_{cpus,mems}
  cpuset: make cs->{cpus,mems}_allowed as user-configured masks
  cpuset: refactor cpuset_hotplug_update_tasks()
  cpuset: enable onlined cpu/node in effective masks
  cpuset: allow writing offlined masks to cpuset.cpus/mems
  cpuset: export effective masks to userspace

 kernel/cpuset.c | 513 ++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 316 insertions(+), 197 deletions(-)

-- 
1.8.0.2
