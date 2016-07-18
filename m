From: Aleksa Sarai <asarai@suse.de>
Subject: [PATCH v1 0/3] cgroup: allow for unprivileged management
Date: Tue, 19 Jul 2016 02:18:13 +1000
Message-ID: <20160718161816.13040-1-asarai@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Aditya Kali <adityakali@google.com>, Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Christian Brauner <cbrauner@suse.de>, Aleksa Sarai <asarai@suse.de>, dev@opencontainers.org

This is a rewrite of my old cgroup unprivileged subtree management[1]
patchset. Rather than magically creating a new cgroup, I've instead
modified kernfs so that we can have custom permission hooks. The
following only applies to cgroupv2 trees, due to the fact that cgroupv1
doesn't explicitly require that cgroups be hierarchical.

You can only create a new subtree if you either would traditionally have
write access, or you are attempting to create a new cgroup under the
root cgroup of your current cgroup namespace (and you have CAP_SYS_ADMIN
in the user namespace pinned by the cgroup namespace). This means that
users would only be able to create sub-cgroups of their current cgroup
using this method.

In addition, I relaxed one of the ancestor restrictions so that you can
move to direct descendants of the current cgroup without needing to be
able to join the current cgroup you're in (because that restriction
doesn't make much sense).

[1]: http://marc.info/?l=linux-kernel&m=146319604331859

Cc: dev@opencontainers.org

Aleksa Sarai (3):
  kernfs: add support for custom per-sb permission hooks
  cgroup: allow for unprivileged subtree management
  cgroup: relax common ancestor restriction for direct descendants

 fs/kernfs/inode.c      | 13 +++++++-
 include/linux/kernfs.h |  3 ++
 kernel/cgroup.c        | 86 +++++++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 93 insertions(+), 9 deletions(-)

-- 
2.9.0

