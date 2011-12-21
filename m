From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/2 v3] cgroup: Remove useless task_lock()
Date: Wed, 21 Dec 2011 20:03:17 +0100
Message-ID: <1324494199-23928-1-git-send-email-fweisbec@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=WSzjqwLznvw6QscOsFQVgmyvuxcdrrGUSpOGUsjZe+c=;
        b=S8MIPq3QrLgS47Ue3a8KfTmwcy9eJwMamC2lI0QEzpA6SD0dH5zGA9+zOypvlRsMsM
         QNAcrxtiCz6Xwgt+bc9xi514+P/lZvF3wTjiWl6XQwWkyU8JaTrUwpp0cQv+F0Es68uF
         arPubuwWoYcsXB3XNfLSbgKx71uCCpwq+QeeU=
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>, Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

Hi,

I just updated the comments in the second patch to better
explain the locking involved, otherwise nothing new.

Thanks.

Frederic Weisbecker (2):
  cgroup: Remove unnecessary task_lock before fetching css_set on
    migration
  cgroup: Drop task_lock(parent) on cgroup_fork()

 kernel/cgroup.c |   43 +++++++++++++++++++++++++++----------------
 1 files changed, 27 insertions(+), 16 deletions(-)

-- 
1.7.5.4
