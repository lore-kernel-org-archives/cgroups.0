From: Waiman Long <longman@redhat.com>
Subject: [RFC PATCH-cgroup 0/6] cgroup: bypass and subtree root modes
Date: Wed, 14 Jun 2017 11:05:31 -0400
Message-ID: <1497452737-11125-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 03CC6C04B936
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Waiman Long <longman@redhat.com>

This patchset introduces new capability to the cgroup v2 core to give
more freedom and flexibility to controllers so that they can have their
own unique views of the virtual process hierarchies that can best suit
thier own use cases without suffering unneeded performance problem.

This patchset is derived from my previous v2 RFC patchset on

  https://lkml.org/lkml/2017/5/15/440
  cgroup: Major changes to cgroup v2 core

It is on top of Tejun's "cgroup: implement cgroup2 thread mode, v2" and my
"cgroup: Make debug controller useful for debugging" patchsets:

  https://lkml.org/lkml/2017/6/10/93
  https://lkml.org/lkml/2017/6/13/862

Patch 1 relaxes the no internal process constraint to allow internal
processes if no non-threaded (resource domain) controllers are enabled.

Patch 2 introduces a new bypass mode (previously called pass-through
mode) that allows a controller to be disabled in the current cgroup,
but re-enabled again in its children. This is enabled by writing
the controller name prefixed with '#' to the "cgroup.controllers"
file. A controller can be bypassed only if it is enabled in the
parent's subtree_control file.

Patch 3 extends the bypass mode to the "cgroup.subtree_control"
file allowing a parent cgroup to enforce all its child cgroups to
have a controller in bypass mode.

Patch 4 introduces a new subtree root mode which restricts the number
of child cgroups to one and controllers are granted to its child in
bypass mode only. This mode is to be used by containers. The cgroup
with subtree root mode on will control the resources passed down to its
only child which will be the root of the container cgroup hierarchy.
Like a real cgroup v2 root, there is no control knobs to tune the
resources.  Instead, all the tuning will be done in its parent. The
container root can enable controllers in its child cgroups to further
restrict the distribution of resources if it so desires. Like a real
root, the no internal process constraint does not apply to the pseudo
root and it can be a mixable root of a mixed threaded tree.

Patch 5 fixes a problem discovered during testing that rapid enabling
and disabling of controllers can lead to undesirable errors.

Patch 6 extends the debug controller to expose additional information
introduced by this patchset.

Waiman Long (6):
  cgroup: Relax the no internal process constraint
  cgroup: Enable bypass mode in cgroup v2
  cgroup: Allow bypss mode in subtree_control
  cgroup: Introduce subtree root mode
  cgroup: Skip dying css in cgroup_apply_control_{enable,disable}
  cgroup: Make debug controller display bypass and subtree root modes
    info

 Documentation/cgroup-v2.txt     | 194 +++++++++++++++++----
 include/linux/cgroup-defs.h     |  24 +++
 kernel/cgroup/cgroup-internal.h |  12 ++
 kernel/cgroup/cgroup.c          | 372 ++++++++++++++++++++++++++++++++--------
 kernel/cgroup/debug.c           |  27 ++-
 5 files changed, 512 insertions(+), 117 deletions(-)

-- 
1.8.3.1

