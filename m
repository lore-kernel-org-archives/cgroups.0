From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for v5.18-rc1
Date: Mon, 21 Mar 2022 10:16:17 -1000
Message-ID: <YjjdEUPIoYyPjsvh@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=H5h/m458Q7wYqGc+3uQIHPjw143NJQEVleeRF9aQtyI=;
        b=DOmbSvaV5SAVC3ugCRngQsMixY5lvDsFiyMunecammQfl0Gf5b+ThHvaVvxxyOWHru
         jHqfr0edtm4anbxQDhXIKIEi5p/OGGHf6JKH2asyxA4EBM7jm97RJdoFg8jAc2+12OwN
         XWPawlMTUJ6srDY4NhOv8VAg+h6Q9hzsT79TUt6vRHJbwrMoQlHTUItS31izjo+aTBEx
         BUOykWK5iERg9CnVQeSpYxR0N2rB3X63J8KvIzXztZ4N+F4A6DH77lKbU20Oau6jxdYV
         +JziBrbJ/M9bE+2KEV4/WDz8AWlAEpw9N5cJoRfOyhP5PlGoLgih1KGlIz7uYbd1AZL0
         mdEQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

All trivial cleanups without meaningful behavior changes.

Thanks.

The following changes since commit daadb3bd0e8d3e317e36bc2c1542e86c528665e5:

  Merge tag 'locking_core_for_v5.17_rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2022-01-11 17:24:45 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.18

for you to fetch changes up to f9da322e864e5cd3dc217480e73f78f47cf40c5b:

  cgroup: cleanup comments (2022-03-13 19:19:27 -1000)

----------------------------------------------------------------
Tom Rix (1):
      cgroup: cleanup comments

Wei Yang (2):
      cgroup: rstat: use same convention to assign cgroup_base_stat
      cgroup: rstat: retrieve current bstat to delta directly

Yang Li (1):
      cgroup: Fix cgroup_can_fork() and cgroup_post_fork() kernel-doc comment

 kernel/cgroup/cgroup.c  |  2 ++
 kernel/cgroup/cpuset.c  | 10 +++++-----
 kernel/cgroup/freezer.c |  2 +-
 kernel/cgroup/rstat.c   |  5 ++---
 4 files changed, 10 insertions(+), 9 deletions(-)

-- 
tejun
