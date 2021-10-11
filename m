From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v5.15-rc6
Date: Mon, 11 Oct 2021 12:02:57 -1000
Message-ID: <YWS0kcEY3MmKrZJk@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=HAdOW08pUGdUyMrTZxurTqi+ppgklE5YNPt3pyK3J9Y=;
        b=msXhSiuDh0TAfFpXf7otQ4GKX/jL9A3xSgn0ohRua33XqhiKTEwLRhyXaaueECwKeh
         4FOUyz1OrCpiS5KlUDb60Fu6L6I6GWsAa5Jy7GHfcEwv7mX56CD9H7gb67LydZKqqWEx
         za2+mtS2MGrNocBbyNpxOVnStZpVkJgnrrmsDBkSs48INoZuBgggWkJ9eyDXpK9IYlro
         nzJAiTLGR0Fl1kFLb9qK0JRfQPZBIYKbz0A2CZ4+vLHrmGdyro1qFIIBkArE/oMY/1Vt
         mTdsTFmBnul1MsYiC3UAp7E6aP39tFgn1trqg1mvD/xViQu2F++i95WG7e8AnGJgrrKL
         kz+Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

All documentation / comment updates.

Thanks.

The following changes since commit 6880fa6c56601bb8ed59df6c30fd390cc5f6dd8f:

  Linux 5.15-rc1 (2021-09-12 16:28:37 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.15-fixes

for you to fetch changes up to c0002d11d79900f8aa5c8375336434940d6afedf:

  cgroupv2, docs: fix misinformation in "device controller" section (2021-09-13 08:08:46 -1000)

----------------------------------------------------------------
ArthurChiao (1):
      cgroupv2, docs: fix misinformation in "device controller" section

Chunguang Xu (1):
      docs/cgroup: remove some duplicate words

Waiman Long (1):
      cgroup/cpuset: Change references of cpuset_mutex to cpuset_rwsem

 Documentation/admin-guide/cgroup-v2.rst | 28 ++++++++---------
 kernel/cgroup/cpuset.c                  | 56 +++++++++++++++++----------------
 2 files changed, 43 insertions(+), 41 deletions(-)

-- 
tejun
