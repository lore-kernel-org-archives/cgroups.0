From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET for-4.11] cgroup: avoid spurious identity ->*attach() invocations
Date: Thu, 29 Dec 2016 17:11:12 -0500
Message-ID: <20161229221115.31995-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=bCOI6OHF7KJy+a+D4eZ2ZIX+4UYi/iqD3O0tWpwtI64=;
        b=II3Srnjbl46XLZiwJtPUPwIO3MDQXZ3K58VLX793dwPO2UdN322vwahPAt2ZJiDbLl
         +1A3o637TYGPN8oohR4b1vubt6I0vYHUOlJpu3UV3PMJXEwoeN3wUUTBSWjbgwMhZmMU
         dTRbHj8W67l7y/jm2jYuOAsYeLQVsCx9DUQhbL9ZHblQYenYp3fXo4gv2D7NJjfsb7sm
         LCL5p+980JAiWcVILKcxxDEI0c2OlhbIjrtBqZWtJ3BuwllPbclDI47YRvl8aBJgMYoJ
         eNhI5w75re/8GohbA2oFz/ZgKfP/x7ve24X1qaiw9w0UFNG1UriXaMXYDS/ji+e9kUaH
         nOuQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

On the v2 hierarchy, when controllers are enabled and disabled, other
->*attach() callbacks of other controllers are called spuriously with
the same source and destination.  While this isn't critical, it's a
bit nasty and can lead to temporary double charging on certain
controllers.  This patchset fixes the issue.

This patchset contains the following three patches.

 0001-cgroup-cosmetic-update-to-cgroup_taskset_add.patch
 0002-cgroup-track-migration-context-in-cgroup_mgctx.patch
 0003-cgroup-call-subsys-attach-only-for-subsystems-which-.patch

0001-0002 restructures migration context tracking so that extra state
can be tracked easily.  0003 fixes the spurious ->*attach()
invocations.

This patchset is also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-avoid-identity-attach

diffstat follows.

 kernel/cgroup/cgroup-internal.h |   69 +++++++++++++++--
 kernel/cgroup/cgroup-v1.c       |   10 +-
 kernel/cgroup/cgroup.c          |  161 ++++++++++++++++------------------------
 3 files changed, 135 insertions(+), 105 deletions(-)

Thanks.

-- 
tejun
