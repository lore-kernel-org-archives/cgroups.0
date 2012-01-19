From: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: [RFC] splitting cgroup.c
Date: Thu, 19 Jan 2012 10:13:59 +0800
Message-ID: <4F177C67.6070907@cn.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

While working on cgroup xattr, it appeared to me it's better to
create a cgroup_xattr.c instead of stuffing things into cgroup.c.

Then I took a look at how big it is.

    $ ls -l -S kernel/*.c
    -rw-rw-r--  1 lizf lizf 142717 Jan 18 10:15 cgroup.c
    -rw-rw-r--  1 lizf lizf 106498 Jan 18 10:15 workqueue.c
    -rw-rw-r--  1 lizf lizf 105206 Jan 18 10:15 lockdep.c
    -rw-rw-r--  1 lizf lizf  91321 Jan 18 10:16 module.c
    
    $ wc -l kernel/*.c | sort -n -r
      90397 total
       5289 cgroup.c
       4206 lockdep.c
       3840 workqueue.c
       3507 module.c

So I think for the sake of readability and maintainability, we'd
better split cgroup.c into smaller pieces:

- event_control.c
- css_id.c
- debug.c
- proc.c
- super.c
...
- cgroup.c

We may add xattr.c and release_agency.c as I'm working on them.

Any objection?
