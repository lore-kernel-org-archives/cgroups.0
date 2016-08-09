From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET] kernfs, cgroup: make kernfs_path*() and cgroup_path*() behave in strlcpy() style
Date: Tue,  9 Aug 2016 01:23:20 -0400
Message-ID: <1470720204-4605-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=TLK9Es1OUn9xQF3a4wb0bRmM5m+RJQ9DbhC9JnHiUh8=;
        b=vUd6VerimHTpynLtvy5T73Jnm1XYyTSUnm70dBpd7p0DgfYY+nHUTQOy0Secd3PN1M
         3+H1OyJk8j7TxLhB+3Cj1E+HVFe63HdwRSAF1bihUGlQTWHZ5ni3nrWxu4p3+pcsMNSz
         NajZ9HJSSJIFz8o0JAvHlZ/J/pW+ewRZSpvtMBeMWOrgidE/ijQs4RmnyVKnPF7YhaUq
         V7G9lEkJt1hQNT2uc4n1SAEwz2NICioLKsg8uG69i8i85EnD4zbQXSiL2fK0Otd+gCTF
         W1w6WQDWFWUk155mun3sbGL0jFS1dTmMOPKS61HQk0KNxeXrI9XoGwD8urF7skbyQd3+
         OIrw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

kernfs path formatting functions always return the length of full path
but the content of the output buffer is undefined when the length is
longer than the provided buffer.  Most cgroup path formatting
functions return the start of the output or NULL on errors including
overflow.  These inconsistent and rather peculiar behaviors developed
over time and make these functions unnecessarily difficult to use.
This patchset updates the formatting functions so that they all behave
in the style of strlcpy().

Greg, these changes are used by cgroup tracepoint additions and
shouldn't affect other users much.  Would it be okay to route these
through the cgroup tree?

 0001-kernfs-add-dummy-implementation-of-kernfs_path_from_.patch
 0002-kernfs-make-kernfs_path-behave-in-the-style-of-strlc.patch
 0003-kernfs-remove-kernfs_path_len.patch
 0004-cgroup-make-cgroup_path-and-friends-behave-in-the-st.patch

The patches are also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-kernfs_path-strlcpy

diffstat follows.  Thanks.

 fs/kernfs/dir.c            |   84 +++++++++------------------------------------
 fs/sysfs/dir.c             |    6 +--
 include/linux/blk-cgroup.h |   11 -----
 include/linux/cgroup.h     |    9 ++--
 include/linux/kernfs.h     |   28 ++++++++++-----
 kernel/cgroup.c            |   48 +++++++++++--------------
 kernel/cpuset.c            |   12 +++---
 7 files changed, 73 insertions(+), 125 deletions(-)

--
tejun
