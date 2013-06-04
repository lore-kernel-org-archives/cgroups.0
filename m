From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET] memcg: fix and reimplement iterator
Date: Mon,  3 Jun 2013 17:44:36 -0700
Message-ID: <1370306679-13129-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        bh=YlG5g5U0d9OfJ2GB9aawXbSdmqACu/Kt/gesTFYriyU=;
        b=M+mtSMES90cP4ZvVz0MfOcX+uuf6LRzU7vwB0HkeKQYmyL38fX95pqU6I2DAfomzML
         MT3/Lb9shEzS181C6LdCbC+/CNxnkDWdjlNNVL7G6vaVRAqSFRF9uJkZB+zBXiT0l6h0
         9zTFgSGWbgziNGgAhq/WsAEtBsPytxkIwKBCArgyfUbW5k9w4fZUGMYDswecMx53Uzfz
         hQypQbuFobXaPcN5Jb1TWOkRxvpoMSCM7mciqNvFYEK6SCyZajQY3IJfmRieFRAS4d7d
         zPeUymsjA/w883BNMJPn/PfzHs3ZDWcHa6G+V6oXJLN4YFjQjZX7Djn6bwafL8lPag4n
         I/Qw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

mem_cgroup_iter() wraps around cgroup_next_descendant_pre() to provide
pre-order walk of memcg hierarchy.  In addition to normal walk, it
also implements shared iteration keyed by zone, node and priority so
that multiple reclaimers don't end up hitting on the same nodes.
Reclaimers working on the same zone, node and priority will push the
same iterator forward.

Unfortunately, the way this is implemented is disturbingly
complicated.  It ends up implementing pretty unique synchronization
construct inside memcg which is never a good sign for any subsystem.
While the implemented sychronization is overly elaborate and fragile,
the intention behind it is understandable as previously cgroup
iterator required each iteration to be contained inside a single RCU
read critical section disallowing implementation of saner mechanism.
To work around the limitation, memcg developed this Rube Goldberg
machine to detect whether the cached last cgroup is still alive, which
of course was ever so subtly broken.

Now that cgroup iterations can survive being dropped out of RCU read
critical section, this can be made a lot simpler.  This patchset
contains the following three patches.

 0001-memcg-fix-subtle-memory-barrier-bug-in-mem_cgroup_it.patch
 0002-memcg-restructure-mem_cgroup_iter.patch
 0003-memcg-simplify-mem_cgroup_reclaim_iter.patch

0001 is fix for a subtle memory barrier bug in the current
implementation.  Should be applied to for-3.10-fixes and backported
through -stable.  In general, memory barriers are bad ideas.  Please
don't do it unless utterly necessary, and, if you're doing it, please
add ample documentation explaining how they're paired and what they're
achieving.  Documenting is often extremely helpful for the implementor
oneself too because one ends up looking at and thinking about things a
lot more carefully.

0002 restructure mem_cgroup_iter() so that it's easier to follow and
change.

0003 reimplements the iterator sharing so that it's simpler and more
conventional.  It depends on the new cgroup iterator updates.

This patchset is on top of cgroup/for-3.11[1] which contains the
iterator updates this patchset depends upon and available in the
following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-memcg-simpler-iter

Lightly tested.  Proceed with caution.

 mm/memcontrol.c |  134 ++++++++++++++++++++++----------------------------------
 1 file changed, 54 insertions(+), 80 deletions(-)

Thanks.

--
tejun

[1] git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.11
