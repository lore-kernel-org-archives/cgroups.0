From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET v2 cgroup/for-4.4] cgroup: make multi-process migration atomic
Date: Fri, 11 Sep 2015 15:00:17 -0400
Message-ID: <1441998022-12953-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=zkf6PJiTQUT9dGPykAWaiqGMudDd/qzY79hi/gBC06k=;
        b=pf70KNAl+QvsKw0/T7uLPf2hgqSgXhMBH03DHn43FnyVasYwwiRO7jLuE5lxPNttBQ
         T4xmqxdpyNg1ABofSm88UyLCulw03UCwocdde+jhIVkh9c0yrCCYvyN9cjPqUh8Gi4w8
         QaZVH7tku+BctPWZNVcba4VBzqmi8Fu7/NqSiIjlA60XwtUBEXne9wUvdrKOcnsujuhV
         fiO3gwU+PoxngVDtnJOrnRQNiBQYP1oCqYFoab/AxUq5KoF2O7xdvxW4OpB5vLKhbC8+
         8QGKoKe88dpiDaobe9ZAI8mzJODhPyZAcW/Da4TdhP7GQnH99/7xX7/5yl9v0tUQAOC4
         29ag==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, hannes@cmpxchg.org, mhocko@suse.cz, linux-mm@kvack.org, linux-kernel@vger.kernel.org

Hello,

This is v2 of atomic multi-process migration patchset.  This one
slipped through crack somehow.  Changes from the last take[L] are.

* 0002-memcg-restructure-mem_cgroup_can_attach.patch already in
  upstream.

* 0003-memcg-immigrate-charges-only-when-a-threadgroup-lead.patch
  dropped and
  0004-cgroup-memcg-cpuset-implement-cgroup_taskset_for_eac.patch
  updated accordingly.

* Li's acks added and patchset refreshed.

When a controller is enabled or disabled on the unified hierarchy, the
effective css changes for all processes in the sub-hierarchy which
virtually is multi-process migration.  This is implemented in
cgroup_update_dfl_csses() as process-by-process migration - all the
target source css_sets are first chained to the target list and
processes are drained from them one-by-one.

If a process gets rejected by a controller after some are successfully
migrated, the recovery action is tricky.  The changes which have
happened upto this point have to be rolled back but there's nothing
guaranteeing such rollback would be successful either.

The unified hierarchy didn't need to deal with this issue because
organizational operations were expected to always succeed;
unfortunately, it turned out that such policy doesn't work too well
for certain type of resources and unified hierarchy would need to
allow migration failures for some restrictied cases.

This patch updates multi-process migration in
cgroup_update_dfl_csses() atomic so that ->can_attach() can fail the
whole transaction.  It's consisted of the following seven patches.

 0001-cpuset-migrate-memory-only-for-threadgroup-leaders.patch
 0002-cgroup-memcg-cpuset-implement-cgroup_taskset_for_eac.patch
 0003-reorder-cgroup_migrate-s-parameters.patch
 0004-cgroup-separate-out-taskset-operations-from-cgroup_m.patch
 0005-cgroup-make-cgroup_update_dfl_csses-migrate-all-targ.patch

0001-0002 prepare cpuset and memcg.  Note that 0001 causes behavioral
changes in that mm is now always tied to the threadgroup leader.
Avoiding this change isn't too difficult but both the code and
behavior are saner this way and the change is unlikely to cause
breakage.

0003-0005 prepare and implement atomic multi-process migration.

This patchset is on top of 64d1def7d338 ("Merge tag
'sound-fix-4.3-rc1' of
git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound").

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-multi-process-migration

diffstat follows.  Thanks.

 include/linux/cgroup.h |   22 +++
 kernel/cgroup.c        |  278 ++++++++++++++++++++++++-------------------------
 kernel/cpuset.c        |   41 +++----
 mm/memcontrol.c        |   17 ++
 4 files changed, 198 insertions(+), 160 deletions(-)

--
tejun

[L] http://lkml.kernel.org/g/1431978595-12176-1-git-send-email-tj@kernel.org

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
