From: Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] cgroup fixes for v5.13-rc3
Date: Mon, 24 May 2021 13:43:35 -0400
Message-ID: <YKvlx7PZs6EplU1D@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=zhwu1FpE2bEhuHjrue2EKzTEGamwY+6jfsv2dbB3NtU=;
        b=Qq8H9LT+STnb034ptJPGiLU1qZiDizsNroHu0Q4/azITwgPsDeywMkF3Fs4d258r9m
         sPdmfsrXp4/lo5So6kExMrd+2oTlTbAbok5ESbCabR6bueqbDfO67dVqABNBX4/egmSg
         IGzjMqM0S+sdarQH8iPlFOcWnPCw4sEV6ON+mn0ncvueRz31Ib2xQetWauH1/ks3oaQn
         R4mBmm41kibxqyMqQ6OUeesGUzYckoA/5R5vaZPSVk2mp95uiSC/SsgYG3sqkG/0ftNn
         Z6d67EsRB2Et2dwQ3sxlwlZ6VgcROVB+AnQ4hi6JlxtBBbK/983MSE8lMcY5pfL42amB
         zqtA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Hello, Linus.

* "cgroup_disable=" boot param was being applied too late confusing some
  subsystems. Fix it by moving application to __setup() time.

* Comment spelling fixes. Included here to lower the chance of trivial
  future merge conflicts.

Thanks.

The following changes since commit c3d0e3fd41b7f0f5d5d5b6022ab7e813f04ea727:

  Merge tag 'fs.idmapped.mount_setattr.v5.13-rc3' of gitolite.kernel.org:pub/scm/linux/kernel/git/brauner/linux (2021-05-19 06:12:31 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.13-fixes

for you to fetch changes up to 08b2b6fdf6b26032f025084ce2893924a0cdb4a2:

  cgroup: fix spelling mistakes (2021-05-24 12:45:26 -0400)

----------------------------------------------------------------
Shakeel Butt (1):
      cgroup: disable controllers at parse time

Zhen Lei (1):
      cgroup: fix spelling mistakes

 include/linux/cgroup-defs.h |  6 +++---
 include/linux/cgroup.h      |  2 +-
 kernel/cgroup/cgroup-v1.c   |  2 +-
 kernel/cgroup/cgroup.c      | 21 +++++++++------------
 kernel/cgroup/cpuset.c      |  2 +-
 kernel/cgroup/rdma.c        |  2 +-
 kernel/cgroup/rstat.c       |  2 +-
 7 files changed, 17 insertions(+), 20 deletions(-)

-- 
tejun
