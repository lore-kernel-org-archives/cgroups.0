From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET v2 cgroup/for-3.8] netcls/prio_cgroup: update hierarchy support
Date: Mon, 19 Nov 2012 23:06:23 -0800
Message-ID: <1353395190-4530-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        bh=zADN8f+/DU5uPMOKHnK80gHZpr5vFPP9Rt0JRY0dwUQ=;
        b=NwipRmMQiL251Y1z33Je4kXxhQYacEmXaL5C6wGuOBEXXZvlphe0Qz+aPcPpB8nMaO
         FU1a/VEHMB7l+G/okXg2pkr7zRYiBZO0bk/ZiyQ9P0V0Cbb2nwsQ5ka6aOIbsSYREOxq
         4Jk7MHeFXPtnfNtXj7UF36RGs+p0n7c8sjONzh3WUI02mEWgvEIM8xV7zhluBNhcKcZf
         yQuu+dQH1wYdw/ZfKmViPH0UIN+Z19LncEwxquWj8FbwwRh+a+3MVbRzWA86+UENqOEt
         TRIlBeyVWRvRj+nGs363px9VKA/j08auquuvhBEoFkeRzuWEOFjIHXFu65J6Dslx6PPF
         BbBw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org, serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, tgraf-G/eBtMaohhA@public.gmane.org
Cc: davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, guys.

This patchset replaces the following two patchsets.

 [1] "[PATCHSET cgroup/for-3.8] netprio_cgroup: implement hierarchy support"
 [2] "[PATCHSET cgroup/for-3.8] netcls_cgroup: implement hierarchy support"

It turns out that we'll have to live with attributes which are
inherited only while creating a new cgroup - such attributes are
already in wide use in cpuset, and there doesn't seem to be much point
in trying to implement fully hierarchical behavior on all attributes
especially as it requires an otherwise-unnecessary userland behavior
change on netcls_cgroup.

This patchset drop .broken_hierarchy from netcls_cgroup while
retaining the current behavior, and implements the same behavior on
netprio_cgroup.

 0001-netcls_cgroup-move-config-inheritance-to-css_online-.patch
 0002-netprio_cgroup-simplify-write_priomap.patch
 0003-netprio_cgroup-shorten-variable-names-in-extend_netd.patch
 0004-netprio_cgroup-reimplement-priomap-expansion.patch
 0005-netprio_cgroup-use-cgroup-id-instead-of-cgroup_netpr.patch
 0006-netprio_cgroup-implement-netprio-_set-_prio-helpers.patch
 0007-netprio_cgroup-allow-nesting-and-inherit-config-on-c.patch

0001 drops .broken_hierarchy from netcls_cgroup.

0002-0006 prepare for inheritance implementation.  These patches are
identical from the previous posting[1].

0007 implements inheritance on cgroup creation.

This patchset is on top of cgroup/for-3.8 0a950f65e1 ("cgroup: add
cgroup->id").

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup-net-cls-prio-hierarchy

diffstat follows.

 Documentation/cgroups/net_prio.txt |    2
 include/net/netprio_cgroup.h       |   11 -
 net/core/netprio_cgroup.c          |  254 ++++++++++++++++---------------------
 net/sched/cls_cgroup.c             |   20 +-
 4 files changed, 124 insertions(+), 163 deletions(-)

Thanks.

--
tejun

[1] https://lkml.org/lkml/2012/11/16/514
[2] http://thread.gmane.org/gmane.linux.kernel.cgroups/5094
