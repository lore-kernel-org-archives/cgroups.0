From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET sched,cgroup] sched: Implement interface for cgroup unified hierarchy
Date: Mon,  3 Aug 2015 18:41:26 -0400
Message-ID: <1438641689-14655-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=edTvliMvWvZQieuDxAyK//Zt2/Hcxg2ofLFoND9/KmI=;
        b=bwhLeBFwACytBKHnzHOSdTna34rXo4YczqJrOGV1R2Iz81ZplTBT2X2yh40/5x9ekx
         AQDAv9cIuLcI8M4F1y9YH6JyWjqLCnTfp97Bz8XUojN4RJ9YrKQgWUuq7Uh6eBtiemrO
         4qk5teVBYoh3rlxiz/QZrBL0luKtsgDWX85txZAyKP/vd56h1QtZiXm7JHOC0KyAZssn
         vfBfVgf2kWATG7Tv+cwoU1CqkPT2rbhKyC0JDwLZ9xxZjR19buy57cIRTfAsw/u5DJ+F
         ZTrKt5nE6V0w9qkiR/5I3SBhsmi6zoDjMvm/74no+oGRYwSM88Yu6qEFy0NL8WVR3ypg
         w8JQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

This patchset implements cpu controller's interface for unified
hierarchy.  While cpu controller didn't have structural issues that
memcg and blkcg had, there still are minor issues such as cpuacct and
use of different time units and its interface can be made consistent
with other controllers so that cgroup as a whole presents uniform ways
to achieve similar things with different resources.

This patchset contains the following three patches.

 0001-cgroup-define-controller-file-conventions.patch
 0002-sched-Misc-preps-for-cgroup-unified-hierarchy-interf.patch
 0003-sched-Implement-interface-for-cgroup-unified-hierarc.patch

The "Controller file conventions" section in
Documentation/cgroups/unified-hierarchy.txt which is added by the
first patch codifies the syntax and semantics for controller knobs and
the next two patches implement the new interface for the cpu
controller.

The first patch is needed by blkcg too, so once the changes get acked
I'll set up a branch containing the patch so that it can be pulled
from both sched and blkcg.

This patchset is on top of v4.2-rc1 and also available in the
following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-sched-unified-intf

diffstat follows, thanks.

 Documentation/cgroups/unified-hierarchy.txt |  128 +++++++++++++++++++-
 include/linux/cgroup.h                      |    9 +
 kernel/sched/core.c                         |  173 +++++++++++++++++++++++++++-
 kernel/sched/cpuacct.c                      |   57 ++++++---
 kernel/sched/cpuacct.h                      |    5 
 5 files changed, 342 insertions(+), 30 deletions(-)

--
tejun
