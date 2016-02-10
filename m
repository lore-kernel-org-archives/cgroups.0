From: Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] cgroup fixes for v4.5-rc3
Date: Wed, 10 Feb 2016 12:32:27 -0500
Message-ID: <20160210173227.GP3741@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=s1LLbm4xYW2XcEAhw3v6OrlT9WQJwrYQm1hxVLBh83s=;
        b=s2NFoDxqn9TAQSURgVf2PlElz2BDMYA5gi8nsndfqhVPx90tg8z2LzqRZMsGAyDN9h
         vQ0bYJlylklCemTPNi+GhNQD5SNpWNOw+1BBfpOXKPu+uZ+141aRMFJgJUotXHXWJU4h
         g0nMpUDssWTwH201Gu3ysJN4af4MyzkAaygtySNtn+hCQt4mM7Guz+nxcSNwV28ESTXf
         pGbshBiUGYPcsjV+8afY/DdVAARKilW0J0xr+Jkg2dMaIYHlSZw1RgstHbhmn/9+w9m4
         WULH2mRiq8F12bzie7tapCW8HQW7iTzQ/HBT67G1fDs1IP0k5lqMj54sv6vtZZRLrHtV
         OeNA==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>

Hello, Linus.

cgroup fixes for v4.5-rc3.

* The destruction path of cgroup objects are asynchronous and
  multi-staged and some of them ended up destroying parents before
  children leading to failures in cpu and memory controllers.  Ensure
  that parents are always destroyed after children.

* cpuset mm node migration was performed synchronously while holding
  threadgroup and cgroup mutexes and the recent threadgroup locking
  update resulted in a possible deadlock.  The migration is best
  effort and shouldn't have been performed under those locks to begin
  with.  Made asynchronous.

* Minor documentation fix.

Thanks.

The following changes since commit 3e1e21c7bfcfa9bf06c07f48a13faca2f62b3339:

  Merge branch 'for-4.5/nvme' of git://git.kernel.dk/linux-block (2016-01-21 19:58:02 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.5-fixes

for you to fetch changes up to 9a2ddda572a002633a64b1ae5f4bc49cfcbf495f:

  Documentation: cgroup: Fix 'cgroup-legacy' -> 'cgroup-v1' (2016-01-29 06:11:57 -0500)

----------------------------------------------------------------
Tejun Heo (3):
      cpuset: make mm migration asynchronous
      cgroup: make sure a parent css isn't offlined before its children
      cgroup: make sure a parent css isn't freed before its children

W. Trevor King (1):
      Documentation: cgroup: Fix 'cgroup-legacy' -> 'cgroup-v1'

 Documentation/cgroup-v2.txt |  2 +-
 include/linux/cgroup-defs.h |  6 ++++
 include/linux/cpuset.h      |  6 ++++
 kernel/cgroup.c             | 31 +++++++++++++++-----
 kernel/cpuset.c             | 71 +++++++++++++++++++++++++++++++--------------
 5 files changed, 85 insertions(+), 31 deletions(-)

-- 
tejun
