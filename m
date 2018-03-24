From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET] mm, memcontrol: Implement memory.swap.events
Date: Sat, 24 Mar 2018 09:51:25 -0700
Message-ID: <20180324165127.701194-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=ckKQT32fFZSRySNtoNKALNP4svDt0sbOZ6/hRSc9fWU=;
        b=OTfA3V9tSb+c1kVHoNpK2q4giI3y/3sM2C9zKEnt8kUTk+69m6bGyZTbiELX4qXwK1
         EY+EdSJBItiSegD/BO3+hb4IzOZHuSzn2MOdm4Yg/YY71qfR0niH3FDApSFM9+zkp8lj
         y7GYFSMpkNL+tHmlJi3+JVEHIJCwQXHOk6vVIU4qYnkzVB1mcix4bHlTRzVYZpFxjQhk
         Pge7g1gbnKiwoNOjANGtd/Wdaa1FgKKCOAjfnDz5ZDPxLoyMIOXgacbITeTdTG3lb2Cb
         oLZYdrTRdAA4/gDNQ5OgnkWqnptaVmtl/hKukzITqpascHbHtDT4Y7zsMaAK+vr6FfSC
         ekJA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com
Cc: guro@fb.com, riel@surriel.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, linux-mm@kvack.org

Hello,

This patchset implements memory.swap.events which contains max and
fail events so that userland can monitor and respond to swap running
out.  It contains the following two patches.

 0001-mm-memcontrol-Move-swap-charge-handling-into-get_swa.patch
 0002-mm-memcontrol-Implement-memory.swap.events.patch

This patchset is on top of the "cgroup/for-4.17: Make cgroup_rstat
available to controllers" patchset[1] and "mm, memcontrol: Make
cgroup_rstat available to controllers" patchset[2] and also available
in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-memcg-swap.events

diffstat follows.

 Documentation/cgroup-v2.txt |   16 ++++++++++++++++
 include/linux/memcontrol.h  |    5 +++++
 mm/memcontrol.c             |   25 +++++++++++++++++++++++++
 mm/shmem.c                  |    4 ----
 mm/swap_slots.c             |   10 +++++++---
 mm/swap_state.c             |    3 ---
 6 files changed, 53 insertions(+), 10 deletions(-)

Thanks.

--
tejun

[1] http://lkml.kernel.org/r/20180323231313.1254142-1-tj@kernel.org
[2] http://lkml.kernel.org/r/20180324160901.512135-1-tj@kernel.org
