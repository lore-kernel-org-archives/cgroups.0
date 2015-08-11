From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET cgroup/for-4.3] cgroup,memcg: generalize event handling and enable notifications on "memory.events"
Date: Tue, 11 Aug 2015 13:58:01 -0400
Message-ID: <1439315889-3492-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=UbRstaWuMTWXECfQPNMkJnAN7zSXi8nDJUAacZie1QI=;
        b=apbcYuN+y5a021fYovjx862JjDmo4FUQjG5b/tIzKsvgB2S6DlwDOzTxSLyJ4JQB4t
         oX9QdXpIvYMF8CnCoHVngEbGuGzSoWt3k5XqiTAZO6WFg3TxsXNB7VwJocSBPKb2I0FE
         KOa1zHEOwEDxBym9OUGGDOtHFi5+yGjLCKCm+BYwyVlFt1qYRN47Pwb7oVmrnrFTwZ+8
         JfmpqlmxWgGAwQd/JIju+RO6kpXW3aeTrEeK+7lyYQF6Kiwlgqwf3aP0sA59X26NExoZ
         wThIeRpenbkfhRfZPZG6fJDZU6j+wNF6V37ePuLn+CEGHtldtxYsvxOJ9g/VFxA1yIEX
         xWng==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

This patchset establishes conventions on low frequency events,
converts "cgroup.populated" to "cgroup.events" accordingly,
generalizes event handling and enable notifications for
"memory.events".

This patchset contains the following eight patches.

 0001-cgroup-replace-cgroup.populated-with-cgroup.events.patch
 0002-cgroup-replace-cftype-mode-with-CFTYPE_WORLD_WRITABL.patch
 0003-cgroup-relocate-cgroup_populate_dir.patch
 0004-cgroup-make-cgroup_addrm_files-clean-up-after-itself.patch
 0005-cgroup-cosmetic-updates-to-rebind_subsystems.patch
 0006-cgroup-restructure-file-creation-removal-handling.patch
 0007-cgroup-generalize-obtaining-the-handles-of-and-notif.patch
 0008-memcg-generate-file-modified-notifications-on-memory.patch

0001 replaces "cgroup.populated" with "cgroup.events".  0002-0006 are
prep patches.  0007 generalizes event notification.  0008 hook up
event notifications for "memory.events".

This patchset is on top of cgroup/for-4.3 e753531991b8 ("Merge branch
'for-4.3-unified-base' into for-4.3") and available in the following
git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-events

diffstat follows.  Thanks.

 Documentation/cgroups/unified-hierarchy.txt |   15 +
 include/linux/cgroup-defs.h                 |   32 ++-
 include/linux/cgroup.h                      |   13 +
 kernel/cgroup.c                             |  264 ++++++++++++++--------------
 kernel/cpuset.c                             |    6 
 mm/memcontrol.c                             |    8 
 6 files changed, 194 insertions(+), 144 deletions(-)

--
tejun
