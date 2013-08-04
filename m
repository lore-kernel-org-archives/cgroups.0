From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET cgroup/for-3.12] cgroup: make cgroup_event specific to memcg
Date: Sun,  4 Aug 2013 12:07:21 -0400
Message-ID: <1375632446-2581-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        bh=KK9MP8fLYwCGh8LvwzYKcPE5Ub1fnk6fMj0gMncVlc0=;
        b=YAKARqTu30flNETxiRyGb4q/q724Nt7bU7uOpuUG7tzaOOLZrcRXVwLtlC1Tw8Vv2Q
         Pk/UL0sboFx6lrrfGh4sq6e6gEsTCaH3aI/q57MNoj2ultni2VA3+NO1R8/cAOTHTISU
         0aa1Rgomm10zp6IVf+Pn6XgVVWjo3HJ3Sa6Sndwhml1l5Bj/pqxy3HOGw+weEytbKw9e
         H7OY2nDdz1ku4VIRfmbnHeIgvhFN7yWp6Z6hb9oOwTberTFiw58Wed/I7QMWG4LoSM6O
         RhBEjIXWROprXswlFv8x8wOwiLi1tKTBw9k1cCFJVHSjfdFZLvCI0kG2JXkaNSCbwQqA
         r4LQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

Like many other things in cgroup, cgroup_event is way too flexible and
complex - it strives to provide completely flexible event monitoring
facility in cgroup proper which allows any number of users to monitor
custom events.  This is overboard, to say the least, and I strongly
think that cgroup should not any new usages of this facility and
preferably deprecate the existing usages if at all possible.

Fortunately, memcg along with vmpressure is the only user of the
facility and gets to keep it.  This patchset makes cgroup_event
specific to memcg, moves all related code into mm/memcontrol.c and
renames it to mem_cgroup_event so that its usage can't spread to other
subsystems and later deprecation and cleanup can be localized.

Note that after this patchset, cgroup.event_control file exists only
for the hierarchy which has memcg attached to it.  This is a userland
visible change but unlikely to be noticeable as the file has never
been meaningful outside memcg.  If this ever becomes problematic, we
can add a dummy file on hierarchies w/o memcg when !sane_behavior.

This patchset is consited of the following five patches.

 0001-cgroup-implement-CFTYPE_NO_PREFIX.patch
 0002-cgroup-export-__cgroup_from_dentry-and-__cgroup_dput.patch
 0003-cgroup-memcg-move-cgroup_event-implementation-to-mem.patch
 0004-cgroup-memcg-move-cgroup-event_list-_lock-and-event-.patch
 0005-memcg-rename-cgroup_event-to-mem_cgroup_event.patch

The patchset is on top of

  cgroup/for-3.12 61584e3f4 ("cgroup: Merge branch 'for-3.11-fixes' into for-3.12")
+ [1] cgroup: use cgroup_subsys_state as the primary subsystem interface handle

and available in the following branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-memcg_event

diffstat follows.

 Documentation/cgroups/cgroups.txt |   19 --
 include/linux/cgroup.h            |   29 ---
 include/linux/vmpressure.h        |    1
 kernel/cgroup.c                   |  265 +--------------------------------
 mm/memcontrol.c                   |  302 ++++++++++++++++++++++++++++++++++++--
 5 files changed, 315 insertions(+), 301 deletions(-)

Thanks.

--
tejun

[1] https://lkml.org/lkml/2013/8/1/722
