From: Waiman Long <longman@redhat.com>
Subject: [PATCH-cgroup 0/5] cgroup: Make debug controller useful for debugging
Date: Tue, 13 Jun 2017 17:18:00 -0400
Message-ID: <1497388685-31207-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com A498A7D4E4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Waiman Long <longman@redhat.com>

The current debug controller is vaguely called an "Example controller"
at the Kconfig prompt, and it is just not that useful for debugging
purpose.

This patchset aims to make the debug controller useful again for
debugging the cgroup core, especially for cgroup v2 and the thread
mode support.

This patchset is based on top of the Tejun's cgroup v2 thread mode
patchset:

  https://lkml.org/lkml/2017/6/10/93

which is available in the following git branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup2-threads-v2

Patch 1 adds a new field to css_set to make accurate count of the
number of tasks in a css_set.

Patch 2 moves the existing debug controller code in cgroup-v1.c into
a new debug.c file.

Patch 3 changes the Kconfig prompt to "Debug controller".

Patch 4 enhances the debug information displayed by the debug
controller to make them more useful for debugging purpose.

Patch 5 hides the debug control files of the debug controller unless
the "cgroup_debug" kernel command line option is specified.

Waiman Long (5):
  cgroup: Keep accurate count of tasks in each css_set
  cgroup: Move debug cgroup to its own file
  cgroup: Make Kconfig prompt of debug cgroup more accurate
  cgroup: Make debug cgroup support v2 and thread mode
  cgroup: Enable debug controller only with cgroup_debug boot option

 include/linux/cgroup-defs.h     |   3 +
 init/Kconfig                    |   7 +-
 kernel/cgroup/Makefile          |   1 +
 kernel/cgroup/cgroup-internal.h |   2 +
 kernel/cgroup/cgroup-v1.c       | 155 +-----------------
 kernel/cgroup/cgroup.c          |  12 +-
 kernel/cgroup/debug.c           | 342 ++++++++++++++++++++++++++++++++++++++++
 7 files changed, 366 insertions(+), 156 deletions(-)
 create mode 100644 kernel/cgroup/debug.c

-- 
1.8.3.1

