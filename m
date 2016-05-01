From: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH v2] cgroup: allow management of subtrees by cgroup namespaces
Date: Sun,  1 May 2016 23:41:04 +1000
Message-ID: <1462110065-4904-1-git-send-email-asarai@suse.de>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>

This is an updated version of v1 of this patchset[1], which properly
unlocks all of the relevant locks in the error path of copy_cgroup_ns().

[1]: https://lkml.org/lkml/2016/5/1/77

Aleksa Sarai (1):
  cgroup: allow management of subtrees by new cgroup namespaces

 kernel/cgroup.c | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 72 insertions(+), 2 deletions(-)

-- 
2.8.1
