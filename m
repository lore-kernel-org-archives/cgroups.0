From: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH v3 0/2] cgroup: allow management of subtrees by new cgroup namespaces
Date: Tue,  3 May 2016 00:01:19 +1000
Message-ID: <1462197681-6879-1-git-send-email-asarai@suse.de>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>

This is an updated version of v2 of this patchset[1]. It includes an
improvement to cgroup core to correctly apply the common ancestor
cgroup.procs restriction on cgroupv1 hierarchies. This fixes
187fe84067bd ("cgroup: require write perm on common ancestor when moving
processes on the default hierarchy"), ensuring that the three guarantees
described in the second patch are held for both cgroupv1 and cgroupv2.

In addition, this patchset now includes a way to disable the auto-mode
changing functionality. An administrator may disable it on a
cgroup-by-cgroup basis by setting the cgroups to have the permissions
a-rx. This update also includes an updated version of the comment
describing the guarantees given by Unix directory permissions and cgroup
core.

[1]: https://lkml.org/lkml/2016/5/1/87

Aleksa Sarai (2):
  cgroup: apply common ancestor cgroup.procs restriction in cgroupv1
  cgroup: allow management of subtrees by new cgroup namespaces

 kernel/cgroup.c | 97 ++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 92 insertions(+), 5 deletions(-)

-- 
2.8.1
