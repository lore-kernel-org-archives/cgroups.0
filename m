From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v5.16-rc8
Date: Fri, 7 Jan 2022 12:34:40 -1000
Message-ID: <YdjAAK4AtsUDv5vw@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Hajn5l7U97JtfpTs2/PxkmXJPD+Ebo3WEH1DTWrY9fs=;
        b=IsQj6jO9nIti6ZtG5tnTQXikV7zTjNLfa2WWQSxgWIoYWrKvEATCYX4BjSrB13lF11
         /71JjyKKz89vsseqUkFWfGUB9x75XEk5yasllnCh9yBcaP8WrtA8g6jlpcH5zqq/5KY3
         QxV64YzC1oEuc+Sfc/wRK5mkdKv5XbL/RPffB5Nh+QTOFuBVJX8ZsaN8IeWR1pIWCuVQ
         qQ5TBsa48KxO/TPTUmStiaNyDw42Q/xqcaRWFsxTu/kQLqs2fkMklND9WKJdS4k03lTg
         vMzStdl6fpSiyUOk3XGgLErIYhelFo0re3iX2cv/nWdgqn0AJ3FUFDafW1fx3rbLyOdk
         uRIA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

Sorry about the late pull request. I ended up staying offline longer than
planned. This pull request contains the cgroup.procs permission check fixes
so that they use the credentials at the time of open rather than write,
which also fixes the cgroup namespace lifetime bug.

While the changes seem safe to me and they tested fine, this is on the
invasive side for a pull request this late, so please feel free to ignore.
I'll include them when the merge window opens.

Thanks and happy new year.

The following changes since commit 75acfdb6fd922598a408a0d864486aeb167c1a97:

  Merge tag 'net-5.16-final' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-01-05 14:08:56 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.16-fixes

for you to fetch changes up to bf35a7879f1dfb0d050fe779168bcf25c7de66f5:

  selftests: cgroup: Test open-time cgroup namespace usage for migration checks (2022-01-06 11:02:29 -1000)

----------------------------------------------------------------
Tejun Heo (6):
      cgroup: Use open-time credentials for process migraton perm checks
      cgroup: Allocate cgroup_file_ctx for kernfs_open_file->priv
      cgroup: Use open-time cgroup namespace for process migration perm checks
      selftests: cgroup: Make cg_create() use 0755 for permission instead of 0644
      selftests: cgroup: Test open-time credential usage for migration checks
      selftests: cgroup: Test open-time cgroup namespace usage for migration checks

 kernel/cgroup/cgroup-internal.h              |  19 +++
 kernel/cgroup/cgroup-v1.c                    |  33 +++---
 kernel/cgroup/cgroup.c                       |  88 +++++++++-----
 tools/testing/selftests/cgroup/cgroup_util.c |   2 +-
 tools/testing/selftests/cgroup/test_core.c   | 165 +++++++++++++++++++++++++++
 5 files changed, 263 insertions(+), 44 deletions(-)

-- 
tejun
