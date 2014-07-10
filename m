From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v3.16-rc4
Date: Thu, 10 Jul 2014 11:25:22 -0400
Message-ID: <20140710152522.GF6609@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=UTZxFSMeLZxRytbEGIze3vLlg3Ae0wex1wBkYyaa2H4=;
        b=lzehDY6kUULT5WaiHIRxkcQGJTSQa42gmPL71YnislHtkqnCnN0V2Wn/+RrFW2yb8z
         iGKLnlivNbkIE+qVBRGNBxQ2M1NYhfwXJLrvrPS9AuG9z+u8GS0IGbEWzlMM/9Nw1aiU
         h4waE2VussyTCrllLkSHWLEUXvZf5D/+cewUYa4u4pyFu4047fgiEJIKPUfAu5YK+7Od
         zNabbDWZLa94ZXd3DDJSSEt9cbUqK0ZQO0oaYz4LCWnGfEQtpA5ypfOwtL1iEollB3nw
         jWfinKCyNGe87LJcY5XskPcQx85TZCr61pvzGscxwf8hN7kaVJY3iaNLgObBLxpXU/Mh
         Pjww==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, again.

Mostly fixes for the fallouts from the recent cgroup core changes.
The decoupled nature of cgroup dynamic hierarchy management
(hierarchies are created dynamically on mount but may or may not be
reused once unmounted depending on remaining usages) led to more
ugliness being added to kernfs.  Hopefully, this is the last of it.

Thanks.

The following changes since commit ebe06187bf2aec10d537ce4595e416035367d703:

  epoll: fix use-after-free in eventpoll_release_file (2014-06-16 17:21:59 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.16-fixes

for you to fetch changes up to 76bb5ab8f6e3e7bebdcefec4146ff305e7d0b465:

  cpuset: break kernfs active protection in cpuset_write_resmask() (2014-07-01 16:42:28 -0400)

----------------------------------------------------------------
Gu Zheng (1):
      cpuset,mempolicy: fix sleeping function called from invalid context

Li Zefan (4):
      cgroup: fix broken css_has_online_children()
      cgroup: fix mount failure in a corner case
      kernfs: introduce kernfs_pin_sb()
      cgroup: fix a race between cgroup_mount() and cgroup_kill_sb()

Tejun Heo (1):
      cpuset: break kernfs active protection in cpuset_write_resmask()

 fs/kernfs/mount.c      | 30 ++++++++++++++++++++++++++
 include/linux/kernfs.h |  1 +
 kernel/cgroup.c        | 58 +++++++++++++++++++++++++++++++++++++++++++-------
 kernel/cpuset.c        | 20 ++++++++++++++++-
 mm/mempolicy.c         |  2 --
 5 files changed, 100 insertions(+), 11 deletions(-)

-- 
tejun
