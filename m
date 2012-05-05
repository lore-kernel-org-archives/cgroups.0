From: Alex Nikiforov <a.nikiforov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH V5] event about group change
Date: Sat, 05 May 2012 09:50:46 +0400
Message-ID: <1336197047-22145-1-git-send-email-a.nikiforov@samsung.com>
References: <20120504165433.GC24639@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20120504165433.GC24639-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, d.solodkiy-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org

Fix memory leak, also fix missing dput if cgroup_create_file() fails.

Alex Nikiforov (1):
  Currently, user can get inotify FS_MODIFY event only if     "tasks"
    file changed from the user space side (for example     echo $$ >
    /patch/to/cgroup/tasks), but if another process forked     user
    don't get FS_MODIFY event. This patch add this feature.     With
    this user can get FS_MODIFY on do_fork()/do_exit()/move PID    
    from one group to another.

 kernel/cgroup.c |   88 +++++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 69 insertions(+), 19 deletions(-)

-- 
1.7.5.4
