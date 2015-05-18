From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET cgroup/for-4.2] cgroup: make multi-process migration atomic
Date: Mon, 18 May 2015 15:49:48 -0400
Message-ID: <1431978595-12176-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=IgXf20MYHTuLU2HKVhNpHmCjgu8eKHXuvpIRg2vz6vE=;
        b=la4qt3wzK5IgG5Yvb1w915eR1DLhd/Obm1F352aezYoeXP2VzOKcK5Q22tlSAEg8xn
         laydX2TAF1fApxV5UM8eHKCezO0VUVNIki09PPkKVw+fkx3t5EpZ+s+tyEQMfJc7lK7C
         yloVx9cQox00Ve4hkEH1GtL8xrieG6/1ymP7AeEBA7B0G374EclUwfLWNGR2CJ3XITfJ
         bnrLvHSJLiQpdSe/+hQCCnAoP7jiqsGsYjWhLQVB2NfhcvuB03Bn8qeWgPMdcDSaszzG
         29WsUCWiordcCUx9kper6PYzFVrZlJJKlKVYrPP/XCiU1REz9DyHB/1xoRUm592OQ+hj
         mUcA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hello,

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
 0002-memcg-restructure-mem_cgroup_can_attach.patch
 0003-memcg-immigrate-charges-only-when-a-threadgroup-lead.patch
 0004-cgroup-memcg-cpuset-implement-cgroup_taskset_for_eac.patch
 0005-reorder-cgroup_migrate-s-parameters.patch
 0006-cgroup-separate-out-taskset-operations-from-cgroup_m.patch
 0007-cgroup-make-cgroup_update_dfl_csses-migrate-all-targ.patch

0001-0004 prepare cpuset and memcg.  Note that 0001 and 0003 do cause
behavioral changes in that mm is now always tied to the threadgroup
leader.  Avoiding this change isn't too difficult but both the code
and behavior are saner this way and I don't think the change is likely
to cause breakage.

0005-0007 prepare and implement atomic multi-process migration.

This patchset is on top of the following patches.

 cgroup/for-4.2 d0f702e648dc ("cgroup: fix some comment typos")
 + [1] [PATCH] cgroup: separate out include/linux/cgroup-defs.h
 + [2] [PATCH] cgroup: reorganize include/linux/cgroup.h
 + [3] [PATCHSET] cgroup, sched: restructure threadgroup locking and replace it with a percpu_rwsem

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-multi-process-migration

diffstat follows.  Thanks.

 include/linux/cgroup.h |   22 +++
 kernel/cgroup.c        |  278 ++++++++++++++++++++++++-------------------------
 kernel/cpuset.c        |   41 +++----
 mm/memcontrol.c        |   74 +++++++------
 4 files changed, 228 insertions(+), 187 deletions(-)

--
tejun

[1] http://lkml.kernel.org/g/20150513193840.GC11388-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org
[2] http://lkml.kernel.org/g/20150513202416.GE11388-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org
[3] http://lkml.kernel.org/g/1431549318-16756-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
