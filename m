From: Kairui Song <ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 0/2] mm: memcontrol: cleanup and optimize for two accounting params
Date: Tue, 20 Sep 2022 02:06:32 +0800
Message-ID: <20220919180634.45958-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date;
        bh=gEJQAVOMzbt4PPx+Qy3opmg3geJE7rZvH1CdGnwIjt0=;
        b=nbulrSye1Ljiu3ZTZKiIiuL+PXrsz2uUKYqD8NYqbUSgSm3Vi0gErRmMJ0GPmvae9i
         uFrQSoh1Dekn6R4JT7YM9d2sB+smEUc5gTVkoLOgpOXTfVVq5yRmFpBMPNiY+OWHd1Kj
         7sFgW+7uvTFADWLZukSZmOygnPnhuEFahpb4O1RUVtEByOp/h4uLCqIzCz2MARhjf316
         CrtqEu1wm2L0h+YlZ0T1jzFRka98lhHFmUQAsoubRrqiucMdFSGJUbf948tBw19kEGIp
         Y1ZOXVA7Lx/gNKOo6xHFKUxWeh3vBVe2/ypemZtIy0k2iK3bg1qmnklw+AkaME+BTNKX
         jTXA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

From: Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

V2 of "[PATCH 0/2] mm: memcontrol: cleanup and optimize for accounting params".

Patch 1/2 is a minor cleanup for kmem accouting path.

Patch 2/2 optimizes some hot paths by making cgroup_memory_noswap a
static key, benchmark shows swap paths now have a ~5% lower overhead.

Update from V1:
- Collect Acked-by for patch 2/2 from Michal Hocko, Thanks!
- Simplify patch 1/1, don't drop mem_cgroup_kmem_disabled and only
  change one call site as a minor clean up, update commit message
  for patch 2/2, as suggested by Michal Hocko.

Kairui Song (2):
  mm: memcontrol: use memcg_kmem_enabled in count_objcg_event
  mm: memcontrol: make cgroup_memory_noswap a static key

 include/linux/memcontrol.h |  2 +-
 mm/memcontrol.c            | 27 +++++++++++++++++++--------
 2 files changed, 20 insertions(+), 9 deletions(-)

-- 
2.35.2

