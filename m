From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET cgroup/for-3.16] cgroup: use css->refcnt for cgroup reference counting
Date: Fri,  9 May 2014 17:13:26 -0400
Message-ID: <1399670015-23463-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=E5aO6jhXablFhZyHHJLsi1uC+GikapwQGrTDBM4hMsY=;
        b=OZGudjph0DCFSBjYPmCjMLzNXdnVIzH0qshsbUMhN1fMi+NSC9CNnbTflyA7kHeEHG
         h84VEdsLkWrK983/TEVLSo+JgYi47e0PGc7V/byMiW537bSBsntQD3KFCPng9+eoV0U8
         HGCq/UUiA7o37SMmB7PAEcb90kkEwbKtz7FetdrXHotP/Rn1vjdjCo1cs8BTuYHUJFj4
         K7nFHrQK/4gv+4timiIdKfYQqRdlcoUdXwnxpCBiGM5oGt0gysFuxWfqlV6hvwyGB7H2
         2lhnCZqgt9y9qbbkeOx3mLj4Jo7zwxLBCb94o6SJK1sE2UHiB3PJ8BM1vKxWwMm0L5Wf
         IxAg==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

Currently, cgroup and css (cgroup_subsys_state) are separately
reference counted.  cgroup->refcnt is an atomic_t and css->refcnt is a
percpu_ref.  css is becoming the primary structural block and used
widely in various operaitons.  cgroup already has a css embedded in it
(cgroup->dummy_css) to use as its proxy in such operations; however,
there still are quite a few differences between cgroup and css
handling limitng how cgroup->dummy_css can be used.

This patchset makes cgroup use the embedded css's refcnt for reference
counting.  This closes one of the gaps between an cgroup embedded css,
which is renamed to cgroup->self early in the patchset, and a normal
css and will allow more unified handling of cgroups and csses.  In
addition, this makes cgroup refcnting use percpu_ref too, which is a
lot more scalable than an atomic_t.

Ultimately, it'd make things far simpler to assign a proper
cgroup_subsys to the cgroup embedded csses and handle them the same as
other csses; however, we can't yet do it thanks to multiple
hierarchies as we end up with multiple csses of the same subsystem for
the same task, but in the very long term, if multiple hierarchies can
be removed, that's where it's headed.

This patchset contains the following nine patches.

 0001-cgroup-use-restart_syscall-for-mount-retries.patch
 0002-cgroup-rename-cgroup-dummy_css-to-self-and-move-it-t.patch
 0003-cgroup-separate-out-cgroup_has_live_children-from-cg.patch
 0004-cgroup-move-check_for_release-parent-call-to-the-end.patch
 0005-cgroup-move-cgroup-sibling-unlinking-to-cgroup_put.patch
 0006-cgroup-remove-cgroup_destory_css_killed.patch
 0007-cgroup-bounce-css-release-through-css-destroy_work.patch
 0008-cgroup-enable-refcnting-for-root-csses.patch
 0009-cgroup-use-cgroup-self.refcnt-for-cgroup-refcnting.patch

0001-0003 are prep patches.

0004-0006 remove cgroup_destroy_css_killed().  This brings cgroup's
destruction path closer to css's so that they can be merged.

0007-0009 make cgroup use the embedded css's refcnt.

This pachset is on top of

 b9a63d0116e8 ("Merge branch 'for-3.16' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu into for-3.16")
 + [1] [PATCHSET v2 cgroup/for-3.16] cgroup: post unified hierarchy fixes and updates
 + [2] (REFRESHED) [PATCHSET cgroup/for-3.16] cgroup: implement cftype->write()
 + [3] (REFRESHED) [PATCHSET cgroup/for-3.16] cgroup: remove cgroup_tree_mutex

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-use-css-ref

diffstat follows.  Thanks.

 include/linux/cgroup.h |   25 ----
 kernel/cgroup.c        |  284 ++++++++++++++++++++++---------------------------
 2 files changed, 136 insertions(+), 173 deletions(-)

--
tejun

[1] http://lkml.kernel.org/g/1399663975-315-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
[2] http://lkml.kernel.org/g/20140509195059.GE4486-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org
[3] http://lkml.kernel.org/g/20140509195827.GG4486-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org
