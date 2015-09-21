From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v4.3-rc2
Date: Mon, 21 Sep 2015 17:59:08 -0400
Message-ID: <20150921215908.GJ13263@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=ILCxK7OBgUSHc/GxhiAORxVzr0uhvbu1mECebFp2Nns=;
        b=ttC4Bi8F88RpfY+fwY6iM65kFZifr4njEyV+P1oNcGmTI+2v5In4sULPuodcEgNG5x
         Z2UgnfGVhJ4Wegul1JlFZ8dR2DLgNB0gMd86giP09XKdqGZM5P+f9AhmnO5aruzHuPYA
         aXNIAuUcTz0BM/tVPWWNTifNoeqbX8ICaHZXW/uHh0m7Cf7Z8k8S7H7vSMxi485kcV5E
         z/vfma0l2UaY/aiEg9dFkmIdQw7sAeYBJkha9V4ZoditZHyE9vfoX9tVUoRV9twUWR54
         SF30bwowxIS497sV3v+s8TwIzNv6yj13wXdkxOZXWLgIYKtazsPdY3hiyuy5IUCFkeqH
         XS9Q==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello, Linus.

The threadgroup locking changes which went in during 4.2 devel cycle
added write locking of a percpu_rwsem in cgroup task migration path;
unfortunately, that involved expedited rcu syncing which turned out to
be too slow and heavy for certain workloads.  The patchset which is
dependent on this one didn't get committed during that devel cycle, so
these two patches can be reverted safely.

Oleg reworked percpu_rwsem for 4.4 so that the writer path is a lot
lighter.  The reported issue goes away with Oleg's reworked
percpu_rwsem and I'll reapply these patches on the for-4.4 branch so
that they can land together with Oleg's changes.

Thanks.

The following changes since commit 6ff33f3902c3b1c5d0db6b1e2c70b6d76fba357f:

  Linux 4.3-rc1 (2015-09-12 16:35:56 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.3-fixes

for you to fetch changes up to 0c986253b939cc14c69d4adbe2b4121bdf4aa220:

  Revert "sched, cgroup: replace signal_struct->group_rwsem with a global percpu_rwsem" (2015-09-16 11:51:12 -0400)

----------------------------------------------------------------
Tejun Heo (2):
      Revert "cgroup: simplify threadgroup locking"
      Revert "sched, cgroup: replace signal_struct->group_rwsem with a global percpu_rwsem"

 include/linux/cgroup-defs.h |  27 +----------
 include/linux/init_task.h   |   8 ++++
 include/linux/sched.h       |  12 +++++
 kernel/cgroup.c             | 110 +++++++++++++++++++++++++++++++++-----------
 kernel/fork.c               |   4 ++
 5 files changed, 110 insertions(+), 51 deletions(-)

-- 
tejun
