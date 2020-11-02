From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH 0/2] bail out early for memcg disable
Date: Mon,  2 Nov 2020 10:17:14 +0800
Message-ID: <1604283436-18880-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

These 2 patches are indepenedent from per memcg lru lock, and may
encounter unexpected warning, so let's move out them from per memcg
lru locking patchset.

Alex Shi (2):
  mm/memcg: bail early from swap accounting if memcg disabled
  mm/memcg: warning on !memcg after readahead page charged

 include/linux/mmdebug.h | 13 +++++++++++++
 mm/memcontrol.c         | 17 ++++++++++-------
 2 files changed, 23 insertions(+), 7 deletions(-)

-- 
1.8.3.1

