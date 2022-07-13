From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v5.19-rc6
Date: Tue, 12 Jul 2022 17:33:31 -1000
Message-ID: <Ys49Cxqd1YOHpipB@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=iRBwqOO6cKGAh5e+2I9BxcznEBEGg6GBtbTmrmZAD5s=;
        b=m/9mOSPBXNMkaE1X0mHG4cbeDfBiVmCdjCqVPr0gxgae4rsPPH5ZsGmelWEsO9pvyk
         JYMbWC60s74OqbY/ftiH11cWhoVlhqEG9CsMxuBw091hGfMZQ2NoJM+1OKwG9+GlBvkF
         /jrLizyswJWILyj+5WQqn3lPl0cmJaaTlnNlTJCBoz9bwDAgr3MAwMkHcKnqrkLjPVr+
         lM6HXuQSe5saGzMFNmenltA53yQ689Yh+3DdZrEfuEMB2Pfy2cS2bc7h6Wi7+bAcEl1l
         W+sMUcccr4pvX/J+8cCNUcrwVLVHGroO1e0JSkxoWCVwIXaOe2neW62B6q7/e6Lkhmir
         D9Jg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The following changes since commit 48a23ec6ff2b2a5effe8d3ae5f17fc6b7f35df65:

  Merge tag 'net-5.19-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-06-16 11:51:32 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git/ tags/cgroup-for-5.19-rc6-fixes

for you to fetch changes up to 07fd5b6cdf3cc30bfde8fe0f644771688be04447:

  cgroup: Use separate src/dst nodes when preloading css_sets for migration (2022-06-16 09:37:02 -1000)

----------------------------------------------------------------
cgroup fixes for v5.19-rc6

This pull request contains the fix for an old and subtle bug in the
migration path. css_sets are used to track tasks and migrations are tasks
moving from a group of css_sets to another group of css_sets. The migration
path pins all source and destination css_sets in the prep stage.
Unfortunately, it was overloading the same list_head entry to track sources
and destinations, which got confused for migrations which are partially
identity leading to use-after-frees. Fixed by using dedicated list_heads for
tracking sources and destinations.

----------------------------------------------------------------
Tejun Heo (1):
      cgroup: Use separate src/dst nodes when preloading css_sets for migration

 include/linux/cgroup-defs.h |  3 ++-
 kernel/cgroup/cgroup.c      | 37 +++++++++++++++++++++++--------------
 2 files changed, 25 insertions(+), 15 deletions(-)

-- 
tejun
