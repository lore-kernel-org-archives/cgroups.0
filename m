From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/4] cgroup: Introducing bypass mode
Date: Fri, 21 Jul 2017 16:34:49 -0400
Message-ID: <1500669293-21792-1-git-send-email-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com EAE3B5AFC9
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

 v1->v2:
  - Remove relax no-internal-process constraint patch as this feature
    is in the thread mode v4 patch.
  - Remove subtree root mode patch.
  - Remove the skip dying css patch as I can no longer reproduce the
    problem.
  - Rework the bypass mode so that write to "cgroup.controllers"
    to enable or disable controller interface files is only allowed
    if the parent grants bypass mode to children by writing the
    '#'-prefixed controller to "cgroup.subtree_control".
  - Add a patch to disable subdirectory creation on an invalid domain.

 v1 patch - https://lkml.org/lkml/2017/6/14/551

This patchset introduces new capability to the cgroup v2 core to give
more freedom and flexibility to controllers so that they can shape
their own unique views of the virtual cgroup hierarchies that can
best suit thier own use cases.

This patchset is layered on top of the "review-cgroup2-cpu-on-v4"
branch of Tejun's cgroup git tree.

Patch 1 disables subdirectory creation when a cgroup is an invalid
domain.

Patch 2 introduces a new bypass mode that allows a controller to
be disabled in a cgroup, but re-enabled again in its children. This
is enabled by writing the controller name prefixed with '#' to the
"cgroup.subtree_control" file. Then all its children will have this
controller in bypass mode.

Patch 3 extends the bypass mode mechanism to allow those child cgroups
that are put into the bypass mode by their parent to re-enable the
controller by writing the controller name with the '+' prefix to the
"cgroup.controllers" file if they choose to. So setting bypass mode
in "cgroup.subtree_control" effectively delegates the authority to
enable or disable a controller to its children.

Patch 4 extends the debug controller to expose additional controller
masks introduced by this patchset.

Waiman Long (4):
  cgroup: Child cgroup creation not allowed on invalid domain
  cgroup: Allow bypass mode in subtree_control
  cgroup: Allow reenabling of controller in bypass mode
  cgroup: Make debug controller report new controller masks

 Documentation/cgroup-v2.txt |  90 +++++++++++++---
 include/linux/cgroup-defs.h |  19 +++-
 kernel/cgroup/cgroup.c      | 251 +++++++++++++++++++++++++++++++++++---------
 kernel/cgroup/debug.c       |   2 +
 4 files changed, 288 insertions(+), 74 deletions(-)

-- 
1.8.3.1
