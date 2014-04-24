From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET cgroup/for-3.16] cgroup: implement css->id
Date: Thu, 24 Apr 2014 17:02:07 -0400
Message-ID: <1398373333-1521-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=uQ4NgOW++UQpE0rHP6Fo6K0dQelSt0S2KjOTIFKYJsM=;
        b=kjeWw69Uo/S8nSrqWVoyUR55Nw4cA8XxXP+Jug2z8pFoXzJ6MvLEPZonlx4phuNpFX
         CZwukGWwT71d42ju8syC71gqxPpUqEt1sJ+YbBYzwRNntSzr2nQAfTaVASL/Jf8Z/q5E
         lwzFOWJr7/TTOuZICumIfiuNl5NbAXJsm+j9sKgQLejh2tV+aDiIMMlcWbttBuTp5wMH
         RGbQbYpxR6KQsfvyB2/aduQ3kXUWUQfZ4T/Pu66MIWA0yy/o0Ia6NDQnrlFp5+4F/0Kx
         PjrVTMba7oArPflVgub8X4XKTL/ou5KEwbTTD9MGf95Zinw/onuWnqU4WUaycYNpIbjW
         EZBQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hello,

Until now, cgroup->id has been used to identify all the associated
csses and css_from_id() takes cgroup ID and returns the matching css
by looking up the cgroup and then dereferencing the css associated
with it; however, now that the lifetimes of cgroup and css are
separate, this is incorrect and breaks on the unified hierarchy when a
controller is disabled and enabled back again before the previous
instance is released.

This series adds css->id which is a subsystem-unique ID and converts
css_from_id() to look up by the new css->id instead.  memcg is the
only user of css_from_id() and also converted to use css->id instead.

 0001-cgroup-make-flags-and-subsys_masks-unsigned-int.patch
 0002-cgroup-memcg-allocate-cgroup-ID-from-1.patch
 0003-cgroup-protect-cgroup_root-cgroup_idr-with-a-spinloc.patch
 0004-cgroup-use-RCU-free-in-create_css-failure-path.patch
 0005-cgroup-update-init_css-into-init_and_link_css.patch
 0006-cgroup-memcg-implement-css-id-and-convert-css_from_i.patch

0001-0003 are related prep/cleanups.

0004-0006 add css->id and convert css_from_id() and its user to it.

This patchset is on top of

  cgroup/for-3.16 f8f22e53a262 ("cgroup: implement dynamic subtree controller enable/disable on the default hierarchy")
+ [1] [PATCHSET cgroup/for-3.16] cgroup: implement cgroup.populated
+ [2] Misc comment / warning cleanups

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-css_id

diffstat follows.

 include/linux/cgroup.h |   21 ++++--
 kernel/cgroup.c        |  164 ++++++++++++++++++++++++++++++++-----------------
 mm/memcontrol.c        |   10 --
 3 files changed, 126 insertions(+), 69 deletions(-)

Thanks.

--
tejun

[1] http://lkml.kernel.org/g/1397056052-2829-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
[2] http://lkml.kernel.org/g/1397748555-6647-1-git-send-email-nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
    http://lkml.kernel.org/g/1397748544-6570-1-git-send-email-nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
    http://lkml.kernel.org/g/1397748534-6490-1-git-send-email-nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
    http://lkml.kernel.org/g/1397757955.3104.11.camel@joe-AO725
