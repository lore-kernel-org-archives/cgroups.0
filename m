From: Waiman Long <longman@redhat.com>
Subject: [PATCH v3 0/3] cgroup: Introducing bypass mode
Date: Wed,  9 Aug 2017 13:55:47 -0400
Message-ID: <1502301350-19757-1-git-send-email-longman@redhat.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Waiman Long <longman@redhat.com>

 v2->v3:
  - Remove invalid cgroup subdirectory creation patch.
  - Add use cases for the bypass mode and removing statements about
    control files ownership in cgroup-v2.txt.
  - Restrict bypass mode to non-domain (threaded) controllers only.

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
 v2 patch - https://lkml.org/lkml/2017/7/21/606

This patchset introduces new capability to the cgroup v2 core to give
more freedom and flexibility to non-domain controllers so that they
can shape their own unique views of the virtual cgroup hierarchies
that can best suit thier own use cases. It also enables a cgroup
parent to selectively enable a non-domain controller in a subset of
its child cgroups instead of in either all or none of them.

The bypass mode cannot be used on domain controllers as it will
complicate resource distribution model and rules.

One use case is an application that want to use cpuset, for example,
to bind some worker threads to individual cpus. At the same time, the
application may also want to use cpu controller to limit the amount
of cpu consumed by some other threads. Right now, the only way to do
that with the current v2 control scheme is to create child cgroups
with both cpu and cpuset controllers enabled and put the desired
processes or threads into those child cgroups.

The cost of enabling cpuset on a task that need cpu controller is
negligible. However, the cost of enabling cpu controller on tasks
that only need cpuset can be noticeable. The performance difference
may become a concern for users who are thinking of moving from cgroup
v1 to v2.

Similarly, instead of cpuset, if we want to use perf_event, freezer or
other non-domain controllers in a subset of tasks, we will also need
to enable CPU controller along with the associated performance cost.

With bypass mode, we will have the ability to enable just the
non-domain controllers the tasks needed in their respective child
cgroups. It is just like what we can currently do with cgroup v1.

This patchset is layered on top of the "for-4.14" branch of Tejun's
cgroup git tree.

Patch 1 introduces a new bypass mode that allows a non-domain
controller to be disabled in a cgroup, but re-enabled again in its
children. This is enabled by writing the controller name prefixed with
'#' to the "cgroup.subtree_control" file. Then all its children will
have this controller in bypass mode.

Patch 2 extends the bypass mode mechanism to allow those child
cgroups that are put into the bypass mode for a particular non-domain
controller by their parent to be re-enabled again by writing the
controller name with the '+' prefix to the "cgroup.controllers" file.

Patch 3 extends the debug controller to expose additional controller
masks introduced by this patchset.

Waiman Long (3):
  cgroup: subtree_control bypass mode for non-domain controllers
  cgroup: Allow reenabling of controller in bypass mode
  cgroup: Make debug controller report new controller masks

 Documentation/cgroup-v2.txt |  58 +++++++---
 include/linux/cgroup-defs.h |  19 +++-
 kernel/cgroup/cgroup.c      | 250 +++++++++++++++++++++++++++++++++++---------
 kernel/cgroup/debug.c       |   2 +
 4 files changed, 257 insertions(+), 72 deletions(-)

-- 
1.8.3.1

