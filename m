From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH 0/2] mm: memcontrol: cgroup2 memory statistics
Date: Wed, 13 Jan 2016 17:01:07 -0500
Message-ID: <1452722469-24704-1-git-send-email-hannes@cmpxchg.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hi Andrew,

these patches add basic memory statistics so that new users of cgroup2
have some inkling of what's going on, and are not just confronted with
a single number of bytes used.

This is very short-notice, but also straight-forward. It would be cool
to get this in along with the lifting of the cgroup2 devel flag.

Michal, Vladimir, what do you think? We'll also have to figure out how
we're going to represent and break down the "kmem" consumers.

Thanks,
Johannes

 include/linux/memcontrol.h |  5 +++-
 mm/memcontrol.c            | 63 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+), 1 deletion(-)
