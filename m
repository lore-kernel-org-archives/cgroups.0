From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET cgroup/for-3.17] cgroup: distinguish the default and legacy hierarchies when handling cftypes
Date: Wed,  2 Jul 2014 19:50:50 -0400
Message-ID: <1404345055-8196-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=3/o/qnHZY0xFD271iXLToKgoqPlia23w+TDec+SVKtM=;
        b=qq6NGrVwe9aGMAzPF8wDiyVAlyim8H/RHM7NxZ0Dl75Cc2OPxs1L4inK5tU6KGLKP6
         C8ttfhOljhvgF/YhKuStvjQvxEDwj5iM6bIJGCc792DdDjzu6oWRCXXuGykiy/kfaGnt
         Ch8NXKEhI1ddNl1YYVQaiFWtNYftzG+v8ADwwGXiWLSpzVFMmfC5jklVqexk48d47fyG
         7K99AqT3YMbpPPAedNHhvxuNLiGPrlUx22xPejxDk0CPrGkMUOQuLqBNzoSaWnfzu5FK
         +Cj8HsoyLtMdkguZTqtsGwlJGQDAcqVjHh78JSqlHWSD5KbkWvY9AxJlYJyaVXauwQsR
         WohQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

Until now, cftype arrays carried files for both the default and legacy
hierarchies and the files which needed to be used on only one of them
were flagged with either CFTYPE_ONLY_ON_DFL or CFTYPE_INSANE.  This
gets confusing very quickly and we may end up exposing interface files
to the default hierarchy without thinking it through.

This patchset makes cgroup core provide separate sets of interfaces
for cftype handling so that the cftypes for the default and legacy
hierarchies are clearly distinguished.  This makes all the existing
subsystem interface files legacy-only by default and all subsystems
will have no interface file created when enabled on the default
hierarchy.  Each subsystem should explicitly review and compose the
interface for the default hierarchy.

This patchset contains the following five patches.

 0001-cgroup-split-cgroup_base_files-into-cgroup_-dfl-lega.patch
 0002-cgroup-rename-cgroup_subsys-base_cftypes-to-legacy_c.patch
 0003-cgroup-replace-cgroup_add_cftypes-with-cgroup_add_le.patch
 0004-cgroup-distinguish-the-default-and-legacy-hierarchie.patch
 0005-cgroup-make-CFTYPE_ONLY_ON_DFL-and-CFTYPE_NO_-intern.patch

This patchset is on top of

  a497c3ba1d97 ("Linux 3.16-rc2")
+ [1] [PATCHSET cgroup/for-3.17] cgroup: remove sane_behavior support on non-default hierarchies

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-dfl_files

diffstat follows.  Thanks.

 block/blk-cgroup.c           |    5 -
 include/linux/cgroup.h       |   17 +++--
 kernel/cgroup.c              |  146 ++++++++++++++++++++++++++++++++-----------
 kernel/cgroup_freezer.c      |    2
 kernel/cpuset.c              |    2
 kernel/sched/core.c          |    2
 kernel/sched/cpuacct.c       |    2
 mm/hugetlb_cgroup.c          |    5 -
 mm/memcontrol.c              |    6 -
 net/core/netclassid_cgroup.c |    2
 net/core/netprio_cgroup.c    |    2
 net/ipv4/tcp_memcontrol.c    |    2
 security/device_cgroup.c     |    2
 13 files changed, 139 insertions(+), 56 deletions(-)

--
tejun

[1] http://lkml.kernel.org/g/1404344747-7957-1-git-send-email-tj@kernel.org
