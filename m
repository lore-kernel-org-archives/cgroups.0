From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET] memcg: improve high limit behavior and always enable kmemcg on dfl hier
Date: Fri, 28 Aug 2015 11:25:26 -0400
Message-ID: <1440775530-18630-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=gKqlUi4PTDEXNY6WY95PDIo1ygtNqBVDUUEmqTHakU8=;
        b=mpt8hObAt2QGmxlmFRc0L8aOUIOi2hUyTSAWw2RzRmg31HBo3GC7shvH3m85m5dqoz
         LH2nxNtz40FxbHXy7nXF4xsAo+pjDevCCB52dxrt2ob1v8eKYHm2mKYI0H89rCwvjbjl
         ZRIAOUDfmo8HYzvDtQ+VmBBZykvlQCkv8nbzZHQzsd+OICfxtDawEhBBewbMb2y2vEA2
         4PZP0olLuxIbReeW9AilWeQbo67k7QvcPcxn8XiIdMkKL9zDch1mCAadiYRq58J0yjF3
         CgO5weoWKEZmIU2gJKGrC5MXTir8nUP2oQoVGIqkPONkHUzpmYAffRM297cTBvIgwePw
         UvZw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

This patchset contains the following four patches.

 0001-memcg-fix-over-high-reclaim-amount.patch
 0002-memcg-flatten-task_struct-memcg_oom.patch
 0003-memcg-punt-high-overage-reclaim-to-return-to-userlan.patch
 0004-memcg-always-enable-kmemcg-on-the-default-hierarchy.patch

0001-0002 are simple fix and prep patches.  0003 makes memcg alwyas
punt direct reclaim of high limit overages to return-to-user path.
0004 always enables kmemcg on the default hierarchy.

This patchset is on top of next/akpm 1f3bd508da15
("drivers/w1/w1_int.c: call put_device if device_register fails") and
also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-memcg-dfl

diffstat follows.  Thanks.

 include/linux/memcontrol.h |   16 +++++---
 include/linux/sched.h      |   14 +++----
 include/linux/tracehook.h  |    3 +
 mm/memcontrol.c            |   88 +++++++++++++++++++++++++++++++++++----------
 4 files changed, 91 insertions(+), 30 deletions(-)

--
tejun
