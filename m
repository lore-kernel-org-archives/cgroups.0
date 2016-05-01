From: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] cgroup: allow management of subtrees by cgroup namespaces
Date: Sun,  1 May 2016 23:03:57 +1000
Message-ID: <1462107838-9843-1-git-send-email-asarai@suse.de>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>

Currently, the maintainers of runC are working on implementing rootless
containers using the new unprivileged user namespace capabilities of
Linux[1]. The only missing core feature is management of cgroups by the
container (such as setting resource limits and pausing containers).

Given the recent addition of the new cgroup namespace, this patchset
implements additional functionality to cgroup namespaces to allow
containers to set up and manage their own cgroup subtrees without
compromising the resource limitations enforced by cgroup controllers.

[1]: https://github.com/opencontainers/runc/pull/774

Aleksa Sarai (1):
  cgroup: allow management of subtrees by new cgroup namespaces

 kernel/cgroup.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 69 insertions(+), 2 deletions(-)

-- 
2.8.1
