From: Alex Nikiforov <a.nikiforov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH V4 1/1]
Date: Fri, 04 May 2012 13:46:44 +0400
Message-ID: <1336124805-6704-1-git-send-email-a.nikiforov@samsung.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, d.solodkiy-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org

New revision. Get rid from strcmp(), cleanup style.

Alex Nikiforov (1):
  cgroup: add inotify FS_MODIFY event on changing tasks file

 include/linux/cgroup.h |    2 +
 kernel/cgroup.c        |   81 ++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 66 insertions(+), 17 deletions(-)

-- 
1.7.5.4
