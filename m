From: Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Subject: [RFC v0 0/4] cgroup classid & netprio 'cleanups'
Date: Mon, 16 Apr 2012 17:35:02 +0200
Message-ID: <1334590506-19462-1-git-send-email-wagi@monom.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, tgraf-G/eBtMaohhA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>

Hi, 

While looking into some cgroup code, I had a look at sock_update_classid()
and sock_update_netprio(). I did not really understand why
sock_update_classid() and sock_update_netprio() are implemented 
differently. Especially, when they do the same thing. 

This series changes both funtion to look alike.

I am not so sure about the rcu changes (I did read the documentation
but then...).

The last patch changes the behavior sliglty. Bevor that change
it was not possible to reassign classid 0. Now it would allow this.

cheers,
daniel

Daniel Wagner (4):
  net: Only update sk_cgrp_prioidx on change
  net: Do not double rcu_read_lock()
  net: Move in_interrupt() check one function call up
  net: Allow updating sk_class id to 0

 include/net/cls_cgroup.h |    6 ------
 net/core/sock.c          |   13 +++++++++----
 2 files changed, 9 insertions(+), 10 deletions(-)

-- 
1.7.10.130.g36e6c
