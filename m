From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] more cgroup fixes for v3.15-rc5
Date: Tue, 13 May 2014 15:28:14 -0400
Message-ID: <20140513192814.GC28815@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=4VznG6h+5ABeDDVOajrbvkIAjnzDQTRrJpxn2PanXU0=;
        b=MNqCxcxtAZJYaqu3q675L+lkDBK9+054jEFb8pQjQay7JMYWooDiG94KD3qvrkBsJP
         Z9F5c9baiojBXkwm0ZOZfVQOQTjk8Nsdc/qk/NQQW9sSRVuWoUf5iGPVOjjr8A9fv7ac
         Bj4s8XCr7Xei+TxMNJWPiAe1xPxIbmDPbfOzmmDMzLsrqVVs1hcZy542dTUenk+j3g+3
         qmENhV2AbfV1iWvTaSmxodmHxtECtwjfc9eycN+J4jucp4DL+rMJ5oXWEQTbat9sN4Ut
         TQxTc7HjhnuHSXleM+Ckl6/cVxtnwufdVAgvMHko09rsNwfyHhDHzm4GiBjEQqn/WoPY
         6Xvg==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

Three more patches to fix cgroup_freezer breakage due to the recent
cgroup internal locking changes - an operation cgroup_freezer was
using now requires sleepable context and cgroup_freezer was invoking
that while holding a spin lock.  cgroup_freezer was using an overly
elaborate hierarchical locking scheme.

While it's possible to convert the hierarchical spinlocks directly to
mutexes, this patch simplifies the overall locking so that it uses a
global mutex.  This has the added benefit of avoiding iterating
potentially huge number of tasks under a spinlock.  While the patch is
on the larger side in the devel cycle, the changes made are mostly
straight-forward and the locking logic is a lot simpler afterwards.

The following changes since commit 36c38fb7144aa941dc072ba8f58b2dbe509c0345:

  blkcg: use trylock on blkcg_pol_mutex in blkcg_reset_stats() (2014-05-05 13:48:18 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.15-fixes

for you to fetch changes up to 36e9d2ebcc15d029b33f42a36146ab5a5bcfcfe7:

  cgroup: fix rcu_read_lock() leak in update_if_frozen() (2014-05-13 11:28:30 -0400)

Thanks.

----------------------------------------------------------------
Tejun Heo (3):
      cgroup: introduce task_css_is_root()
      cgroup_freezer: replace freezer->lock with freezer_mutex
      cgroup: fix rcu_read_lock() leak in update_if_frozen()

 include/linux/cgroup.h  |  15 +++++++
 kernel/cgroup.c         |   2 +-
 kernel/cgroup_freezer.c | 116 ++++++++++++++++++++----------------------------
 3 files changed, 65 insertions(+), 68 deletions(-)

-- 
tejun
