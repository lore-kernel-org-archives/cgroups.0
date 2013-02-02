From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/4] cgroup: bug fixes for eventfd
Date: Sat, 2 Feb 2013 14:50:27 +0800
Message-ID: <510CB733.2080904@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>, Aaron Durbin <adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

There're three bugs.

- If thread A is removing a cgroup, while thread B is closing an eventfd, the
two threads might free the same cgroup event and thus crash the kernel.

This is fixed by patch #1 and patch #2.

- If there're multiple threads are blocking in read() on the same eventfd,
and someone removes the cgroup, only one thread will be notified and unblocked,
and others won't be unblocked until those threads are killed.

- If thread A is removing a cgroup, while thread B is registering a cgroup event
and then read the eventfd, it might block until the thread is killed.

These two are fixed by patch #3.

0001-eventfd-Introduce-eventfd_signal_hangup.patch
0002-cgroup-fix-cgroup_rmdir-vs-close-eventfd-race.patch
0003-eventfd-make-operations-on-eventfd-return-EIDRM-if-i.patch
0004-cgroup-adapt-to-the-new-way-of-detecting-cgroup-remo.patch

--
 fs/eventfd.c                         | 30 ++++++++++++++++++++++++++++++
 include/linux/eventfd.h              |  5 +++++
 kernel/cgroup.c                      | 30 ++++++++++++++++++------------
 tools/cgroup/cgroup_event_listener.c | 12 +++++-------
 4 files changed, 58 insertions(+), 19 deletions(-)
