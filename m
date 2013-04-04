From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET] cgroup: unexport locking interface
Date: Thu,  4 Apr 2013 16:36:24 -0700
Message-ID: <1365118589-10619-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer;
        bh=UxrzgmamzBiZh8R6N4gx7AdnSTD5w7RuIveSg7aykhQ=;
        b=cXlMITKROrEWWm9rOn0g5P/US2YGVRhs8jLRuSpSiUiGwY5jS9I/ULYOi1MUAH178M
         a1MFx3zKnz2Z+B09FGjEkdBVuUbl8ZXEM0haXaUjFeQw5mI800+nYghBtFJ6NpjzE8rT
         4oByK+Ymq/l5p5U+VTxiW7+EgK60cEeoNWx1Q1LzbH1Kx8q3DRWGZaGE94NYbr7jqLVW
         XyriB03FtgdIkew8MkrNUKSFnSmrfRVvoK5Sl+U6Z4KSL+w4toAbCBAIH37/i3cuU1u4
         AXj/7WR0CF2xkwFQKr2gH973GmdkwRjwD3Mj0/rAg6hjuXM3+BkS+OWpQSeBsNvtY9zI
         rerw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

Most cgroup_mutex abuses outside cgroup core proper have been
eradicated but there's still one use remaining and locking interface
is still exported.  This patchset updates the last user and unexports
the locking interface and is composed of the following five patches.

 0001-cgroup-cpuset-replace-move_member_tasks_to_cpuset-wi.patch
 0002-cgroup-relocate-cgroup_lock_live_group-and-cgroup_at.patch
 0003-cgroup-unexport-locking-interface-and-cgroup_attach_.patch
 0004-cgroup-kill-cgroup_-un-lock.patch
 0005-cgroup-remove-cgroup_lock_is_held.patch

It's on top of cgroup/for-3.10 a423ecb8a ("memcg: fix
memcg_cache_name() to use cgroup_name()") and available in the
following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-unexport-locking

diffstat follows.  Thanks.

 include/linux/cgroup.h |   19 +++--
 kernel/cgroup.c        |  162 ++++++++++++++++++++++++-------------------------
 kernel/cpuset.c        |   51 +--------------
 3 files changed, 96 insertions(+), 136 deletions(-)

--
tejun
