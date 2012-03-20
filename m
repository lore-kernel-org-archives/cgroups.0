From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH 0/4] My contribution towards the end of populate()
Date: Tue, 20 Mar 2012 20:50:52 +0400
Message-ID: <1332262256-13407-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

Tejun,

Let me know what you think.
I am providing the bugfix for the recently discussed bogus warning
in your tree, + the sock memcg bits. You should be able to get rid
of populate after that.

Let me know if there is any change you want done, and I'll adapt it.


Glauber Costa (4):
  don't trigger warning when d_subdirs is not empty.
  pass struct mem_cgroup instead of struct cgroup to socket memcg
  provide a function to register more cftype files into memcg
  get rid of populate for memcg

 include/linux/memcontrol.h   |    1 +
 include/net/sock.h           |   17 +++++++++++------
 include/net/tcp_memcontrol.h |    4 ++--
 kernel/cgroup.c              |    8 +++++++-
 mm/memcontrol.c              |   38 ++++++++++++++++----------------------
 net/core/sock.c              |   15 ++++++++++-----
 net/ipv4/tcp_memcontrol.c    |   17 +++++++++++------
 7 files changed, 58 insertions(+), 42 deletions(-)

-- 
1.7.7.6
