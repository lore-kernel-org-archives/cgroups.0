From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH v2 0/2] remove sock memcg dependencies on populate
Date: Thu, 22 Mar 2012 22:19:21 +0400
Message-ID: <1332440363-2754-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

Tejun,

This should do the job. After these two patches, populate() for memcg
is gone. Let me know if you want any more changes.

Glauber Costa (2):
  cgroup: pass struct mem_cgroup instead of struct cgroup to socket
    memcg
  cgroup: get rid of populate for memcg

 include/net/sock.h           |   12 ++++++------
 include/net/tcp_memcontrol.h |    4 ++--
 mm/memcontrol.c              |   32 ++++++++++----------------------
 net/core/sock.c              |   10 +++++-----
 net/ipv4/tcp_memcontrol.c    |    5 ++---
 5 files changed, 25 insertions(+), 38 deletions(-)

-- 
1.7.7.6
