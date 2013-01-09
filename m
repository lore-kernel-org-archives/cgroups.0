From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: 2 bug fixes for the 3.4 cgroup code (v2)
Date: Wed,  9 Jan 2013 16:03:40 +0100
Message-ID: <1357743822-21707-1-git-send-email-hdegoede@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

So I messed things up a bit with v1 of this patchset, the problem is that
to simplify debugging I had disabled all CGROUP Kconfig options, except
for CGROUPS itself. Which turned cgroup_clear_css_refs() into a nop.

Upon further testing after posting v1, with the CGROUP Kconfig options
enabled again, I hit a kernel-panic. The problem was I did the cgrp->count != 0
test after calling/testing cgroup_clear_css_refs(), so now
cgroup_clear_css_refs() would get called twice despite succeeding the first
time in case the cgrp->count != 0 test fails. Causing the BUG() in there to
avoid the refs being decremented twice to trigger.

The fix in v2 of the patch is easy, simply test cgrp->count != 0 before
calling/testing cgroup_clear_css_refs().

And for people just tuning in, here is the "cover letter" for v1 from
v1 of the patch-set:

As a spare-time project I'm working on Linux on Allwinner A10 socs (ARM
mach-sun4i). While the linux-sunxi project is slowly working on cleaning
up the code and getting support for these socs upstream (first bits have
landed in 3.8), to be able to truely use these systems we're stuck on using
3.4 for now, since that is the latest to which all the ugly Allwinner code
has been forward-ported. See: http://linux-sunxi.org

I'm using Fedora-18 as userland, and since that uses systemd it exercises
the cgroup subsystem quite a bit. Thanks to building the kernel with
CONFIG_DEBUG_LIST this has exposed a use after free bug in the 3.4 cgroup
code. While debugging this I've also noticed some missing locking (or so
I believe).

The current cgroup code seems to be unaffected by both issues. Since the
current code is significantly changed, I've written a simple fix for 3.4,
which I would like to propose to be added to the 3.4.xx bugfix releases.

Allthough I know everyone dislikes looking back at old code once it has
been rewritten in a better fashion, I hope you are still willing to make
some time to review these 2 simple patches, as a first step in getting
them into 3.4.xx.

Some details on the differences between the current cgroup code, which
does not have these issues and the 3.4 code, in the current code:
1) The code-segment missing the locking has been removed
2) Unlike the 3.4 code cgroup_rmdir() properly checks cgrp->count

Note that the cgrp->count check in the current cgroup_rmdir() code has the
check before waiting on the cgroup_rmdir_waitq, and simply returns EBUSY when
cgrp->count != 0, where as my patch adds the check inside the waiting block
and waits for the waitq to be woken up.

The reason for this difference is that the current cgroup code handles
the clearing of a css_set / the link->cgrp_link_list elements from
cgrp->css_sets directly (and does not call cgroup_wakeup_rmdir_waiter()
when doing so), where as the 3.4 code handles the clearing of this list
from a workqueue, and *does* call cgroup_wakeup_rmdir_waiter() when clearing
the list.

Regards,

Hans
