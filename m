From: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 0/2] reuse vmpressure for in-kernel events
Date: Tue, 23 Apr 2013 12:22:07 +0400
Message-ID: <1366705329-9426-1-git-send-email-glommer@openvz.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

During the past weeks, it became clear to us that the shrinker interface we
have right now works very well for some particular types of users, but not that
well for others. The later are usually people interested in one-shot
notifications, that were forced to adapt themselves to the count+scan behavior
of shrinkers. To do so, they had no choice than to greatly abuse the shrinker
interface producing little monsters all over.

During LSF/MM, one of the proposals that popped out during our session was to
reuse Anton Voronstsov's vmpressure for this. They are designed for userspace
consumption, but also provide a well-stablished, cgroup-aware entry point for
notifications.

I am demonstrating this interface by registering a memcg event that tries to
get rid of all dead caches in the system. We never used a shrinker for that
because it didn't feel too natural. The new interface integrates quite nicely,
though.

Please note that due to my lack of understanding of each shrinker user, I will
stay away from converting the actual users, you are all welcome to do so.

Glauber Costa (2):
  vmpressure: in-kernel notifications
  memcg: reap dead memcgs under pressure

 include/linux/vmpressure.h |  6 ++++
 mm/memcontrol.c            | 81 ++++++++++++++++++++++++++++++++++++++++++++--
 mm/vmpressure.c            | 48 ++++++++++++++++++++++++---
 3 files changed, 128 insertions(+), 7 deletions(-)

-- 
1.8.1.4
