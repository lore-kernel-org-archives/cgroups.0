From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET] cgroup/for-4.17: Make cgroup_rstat available to controllers
Date: Fri, 23 Mar 2018 16:13:05 -0700
Message-ID: <20180323231313.1254142-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=PqZ9qq7I1Y/tyYn4hU3iLnOCRSdGQHtCU+EGllk40oA=;
        b=Nl7lIDV4WSNvBqWgYkPfBjeAzEY/U5zhbLWvEhr2BENcqWWCFwRE/ImqYLIvfv/XK6
         ISrhL5uu96VNOmleVxljJd02BkcGQL284De+XIMb2SeWv5h1ZVkBZdKNv6l2CA6jEiYj
         jtel++GoIu35a1SHYz+Os84eInwpXZVnW3zlW/tf5hndHnQDbLUe69xZ6n1VClVm5pq1
         q3I41ioh4vl9LdD/+wROxaFC+Th4Z+xsQgLgcFBb8ueGyR9N1DuOFQO6Kzj8X2KHZ708
         vR0oH2AEtUqt7+M2Qmtd3ZXiSWHRvfkSjsJjFQ3+3qkUv/xySefbwEQghmGaMsKtT6+V
         jRJA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, guro@fb.com, kernel-team@fb.com

Hello,

cgroup has scalable recursive stat mechanism implemented in
kernel/stat.c.  It's currently only used to track cpu consumptions and
difficult to use outside of cgroup core.  This patchset generalizes
the mechanism and exposes it as cgroup_rstat so that controllers can
use it.

This patchset contains the following eight patches.  A follow-up
patchset will add usages.

 0001-cgroup-Rename-kernel-cgroup-stat.c-to-kernel-cgroup-.patch
 0002-cgroup-Rename-stat-to-rstat.patch
 0003-cgroup-Distinguish-base-resource-stat-implementation.patch
 0004-cgroup-Reorganize-kernel-cgroup-rstat.c.patch
 0005-cgroup-Factor-out-and-expose-cgroup_rstat_-interface.patch
 0006-cgroup-Replace-cgroup_rstat_mutex-with-a-spinlock.patch
 0007-cgroup-Add-cgroup_subsys-css_rstat_flush.patch
 0008-cgroup-Add-memory-barriers-to-plug-cgroup_rstat_upda.patch

This patchset is also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup_rstat

diffstat follows.

 include/linux/cgroup-defs.h     |   50 ++--
 include/linux/cgroup.h          |   12 -
 kernel/cgroup/Makefile          |    2 
 kernel/cgroup/cgroup-internal.h |   11 -
 kernel/cgroup/cgroup.c          |   29 ++
 kernel/cgroup/rstat.c           |  410 ++++++++++++++++++++++++++++++++++++++++
 kernel/cgroup/stat.c            |  338 --------------------------------
 7 files changed, 477 insertions(+), 375 deletions(-)

Thanks.

--
tejun
