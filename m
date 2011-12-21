From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/2 v2] cgroup: Remove useless task_lock()
Date: Wed, 21 Dec 2011 03:02:36 +0100
Message-ID: <1324432958-20414-1-git-send-email-fweisbec@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=WW/QW5ZlZrLCfhcEfnEWL2j1fhcB1yk1s0QELDSqCEU=;
        b=nV/K5kmX0NMhuRZEajywNYhNKaFgjKZ0APcd4f6xm+YdCnCCZ+eJ1BPyAPtzCZ6Dh0
         IS116cOKpZMXgGnVSMMxvsei8R8VLvCTE6jcEkIsmFZnim2fPytnShVuaxvgUOmDUSHC
         vzZsIPNEHu79udQEujhOcHjRzxK88XLyfE5Fk=
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>, Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

Hi,

It's the same set but rebased on top of cgroup/for-3.3 instead of
Mandeep's patch.

Although the first patch has changed a bit after the rebase
I have kept the Reviewed-by tag of Li and Mandeep because the
core change itself hasn't changed much.

Second patch is the same.

Thanks.

Frederic Weisbecker (2):
  cgroup: Remove unnecessary task_lock before fetching css_set on
    migration
  cgroup: Drop task_lock(parent) on cgroup_fork()

 kernel/cgroup.c |   30 +++++++++++++++++-------------
 1 files changed, 17 insertions(+), 13 deletions(-)

-- 
1.7.5.4
