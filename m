From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET] cgroup: use static_keys for subsystem enabled and on_dfl tests
Date: Tue, 15 Sep 2015 21:51:21 -0400
Message-ID: <1442368285-16306-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=fV/Bn/CHAeD27pp0tDe+PfVoYldlRfqc5dhR4KIeOJ0=;
        b=qMXOZza0GCOpusPHSaoJbKl68oOO1oO+YUa9Y2K+N/UhbbdaHeAuCYYAbD75nbxWUi
         YpfFvqfKAMdpOL7MkAF7Sa0pUkicQw1MshTP1ToovBgmZbgLADthhgOcP+UdgzAmvXe/
         XkLZjcC7sDFcmJ4RUQoOstqlvpJkJQmZgjxvQk+2k1mkpuroAd7xRa1T+gpGNuuxSrf5
         RxXYkQ59iuMQzcWjmW2F0hDgidDlV/Q1a5MawbBM5Qe1QISx3qGKjPi1MRKsXwfcoFDc
         aq76RtKaBOX5377ZKlyRLD2kR5Cp029gwXkT0Zsc7XBb3gi7RDskUZ9oShT61Tucymnr
         oWSQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

cgroup_subsys->disabled and cgroup_on_dfl() tests are likely to be
used in hot paths and seldom change.  The former is set once during
boot and the latter only when a controller is migrated between the
default hierarchy and traditional ones.

This patchset makes these tests static_key based and contains the
following four patches.

 0001-jump_label-make-static_key_enabled-work-on-static_ke.patch
 0002-cgroup-implement-static_key-based-cgroup_subsys_enab.patch
 0003-cgroup-replace-cgroup_subsys-disabled-tests-with-cgr.patch
 0004-cgroup-replace-cgroup_on_dfl-tests-in-controllers-wi.patch

0001 is a prep patch in jump_label.  0002 adds the needed static_keys.
0003-0004 convert the existing usages and drop the old tests.

This patchset is on top of v4.3-rc1 and is availalbe in the following
git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-jump-labels

diffstat follows.  Thanks.

 block/blk-throttle.c           |    2 
 block/cfq-iosched.c            |    4 -
 include/linux/cgroup-defs.h    |    1 
 include/linux/cgroup.h         |   79 +++++++---------------------
 include/linux/hugetlb_cgroup.h |    4 -
 include/linux/jump_label.h     |   18 +++---
 include/linux/memcontrol.h     |    4 -
 kernel/cgroup.c                |  113 ++++++++++++++++++++++++++++++++++++++---
 kernel/cpuset.c                |   23 ++++----
 mm/memcontrol.c                |    4 -
 10 files changed, 157 insertions(+), 95 deletions(-)

--
tejun
