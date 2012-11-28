From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET cgroup/for-3.8] cpuset: drop cpuset->stack_list and ->parent
Date: Wed, 28 Nov 2012 14:26:58 -0800
Message-ID: <1354141621-11906-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        bh=WPkVhAawpIOQ90Lg+9B5X57nrsGtD4lqYgJvfhyOgCw=;
        b=BR+lLH/gQBlAozN13YJwpFg6/luqz2UALbKOaDmT5f7dN3Wg6LyFbgAY6zKOSsS8gT
         9EzAVSasAtDBPr2wW9wkxwmNt6DQcw4+cwR0+NQaPO+0H3dt2sgbXDFAogJBdzwBPH1O
         EZIFtOmSKjkCWqB/rRz5/ZFeQUqfowTMcC3rtcOm04Q03fbvf0LO6Y29HDASw8Wj7HnF
         6nROrIXDwgfYARO20nxM0BK1K+9MR8sa7zqmY+CwxVBZOW77m+QIa41BX+KlIy46Ip5y
         1dOaPqUglwPoUgc84w0YDdcznP7jeoQq/O0t9AoYTgAfDDXDIAMLgFpVmavLkSN+grWI
         rDCA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, guys.

cpuset implements its own descendant iteration using
cpuset->stack_list and has its own ->parent pointer.  There's nothing
cpuset specific about descendant walking or finding the parent.  This
patchset makes cpuset use cgroup generic API instead.

 0001-cpuset-implement-cgroup_rightmost_descendant.patch
 0002-cpuset-replace-cpuset-stack_list-with-cpuset_for_eac.patch
 0003-cpuset-remove-cpuset-parent.patch

0001 implements cgroup_rightmost_descendant() which can be used to
skip subtree during pre-order tree walk.  Michal, maybe memcg can use
it too?

0002 replaces cpuset->stack_list with generic
for_each_descendasnt_pre().

0003 replaces cpuset->parent with cgroup->parent.

This patchset is on top of

cgroup/for-3.8 fddfb02ad0 ("cgroup: move list add after list head initilization")
+ [1] "[PATCHSET cgroup/for-3.8] cpuset: decouple cpuset locking from cgroup core"

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cpuset-iter

 include/linux/cgroup.h |    1
 kernel/cgroup.c        |   26 ++++++++
 kernel/cpuset.c        |  151 +++++++++++++++++++++----------------------------
 3 files changed, 92 insertions(+), 86 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel.cgroups/5251
