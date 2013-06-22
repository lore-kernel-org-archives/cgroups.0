From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET cgroup/for-3.11] cgroup: miscellaneous cleanups
Date: Fri, 21 Jun 2013 18:34:08 -0700
Message-ID: <1371864854-28364-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        bh=pJmVPWK+tLcHzp6Oheka7vZyLyy6OJnWkotRdxrq9xY=;
        b=Gl9s02AD+jvjm+Ocq+hbti+4M72mqhHOnUUKcZGx4ZZnh+8rUBnV7YtSlBIGY7VrXk
         t5Pn/3GqJ/mQYY+nYRCYKwR1Sd4qK6tRP4KIvaXXKLKKHNz+cw+A7btjC7nQbRgR/HnO
         QDlgWvI0GAQUW3f6hXk1BiPDPuawpghoXVFKWXK53duQZeiKapQaGimVb0+VDdbpIl2O
         HsTN+STjBM/Ju4beSwMpH9mwN+lMMAZ+7M2lKzOSrDnEp+zdUwyT97EuH6qafg/QxNTE
         uF8w2zGJZF9LinHCWUkcGQq8GlLRjj5bd/0lzj41T4pLYclbThrGBtLOPBNpYGGT+xqF
         8weA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

These are misc clean up patches mostly focused on subsys handling that
I ended up with while working on unified hierarchy support.  Nothing
too interesting.  Just cleanups.

 0001-cgroup-convert-CFTYPE_-flags-to-enums.patch
 0002-cgroup-prefix-global-variables-with-cgroup_.patch
 0003-cgroup-remove-cgroup-actual_subsys_mask.patch
 0004-cgroup-clean-up-find_css_set-and-friends.patch
 0005-cgroup-s-for_each_subsys-for_each_root_subsys.patch
 0006-cgroup-implement-for_each_-builtin_-subsys.patch

These patches are on top of

  for-3.11 03c78cbebb ("cgroup: rename cont to cgrp")
+ [1] RCU access fix patches

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup-misc-cleanups

Thanks.

 include/linux/cgroup.h |   11 -
 kernel/cgroup.c        |  379 +++++++++++++++++++++++--------------------------
 2 files changed, 188 insertions(+), 202 deletions(-)

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel.cgroups/8130
