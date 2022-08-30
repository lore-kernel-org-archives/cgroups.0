From: Kairui Song <ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/2] mm: memcontrol: cleanup and optimize for accounting params
Date: Tue, 30 Aug 2022 13:59:47 +0800
Message-ID: <20220830055949.12640-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:from:to:cc;
        bh=qUSrr+Dj5JEyxXLU0zu9XCionGxLBWlgtmoR99MFjhQ=;
        b=FjZ0kPOazz55wM/uQwXnHAUHofevmUyS/fY5Hz9pws04EQKglg986u+lddR1MBRc9G
         JhOVc1ONM6hZeGw2sGMV8DtQCGEPaPSGYJlAE3j2M9fRp2J3R53+q3V4/ZLUfQk904XT
         0BA1sw4kr4vqPw4k02HrQD6uldwsF7nVrYd7e9NMkOr/e3zEC67KEAKtT44+xc9mUIxc
         glCfCRac7UFvijpundB+UUlCZwIAuNLfu+MRin/B7JuwhHAhnEu/5Wptuq9lmQfCdfH6
         nEv5wN1UV6Opd14YB/YIvNr9vvUZobL0C6Ozo8qY6k0eQ/7g/2n7LwYub6AXvivgh11d
         BiYQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

From: Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Patch 1/2 changes the behavior of kmem accounting a bit, making
it either globally enabled or globally disabled by boot params and
no longer affected by the creation of the first non-root cgroup.
This might be a bit arguable though.

Patch 2/2 optimizes some hot paths by making cgroup_memory_noswap a
static key, benchmark shows swap paths now have a ~4% lower overhead.

Kairui Song (2):
  mm: memcontrol: remove mem_cgroup_kmem_disabled
  mm: memcontrol: make cgroup_memory_noswap a static key

 include/linux/memcontrol.h |  8 +------
 mm/memcontrol.c            | 45 +++++++++++++++++++++++---------------
 mm/percpu.c                |  2 +-
 mm/slab_common.c           |  2 +-
 4 files changed, 30 insertions(+), 27 deletions(-)

-- 
2.35.2

