From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/3] mm/memcg: some cleanup for mem_cgroup_iter()
Date: Fri, 25 Feb 2022 00:34:34 +0000
Message-ID: <20220225003437.12620-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=l406JsmQ/9uHOd645BEgXJ9iwo5dFGG+M3DDOGQskWM=;
        b=AxgCPgFo9m4iTfxiNc3Kp/VTeCR+mrjpl/1u4/YA7zC01jyqIlaAvaz1O7r5gh9sr4
         xRsjVa8DlT5P1IYmHb/vPOYa1eqfogoBw8FdWBKPlE5NfrBoabHtn34nmJZBju5Q1PhT
         Nbz6TaFicOpbm8B0Z/j4/nRJaj0fVirZD/Nx0kVsktldUuqZoI3nXV1KJP6C5djg0VWJ
         NUIY1CGZfGaLJzzzJV3PZSiGMF6IBpUwK4r+/SzzTLdR9H5zd0CXrcWaNALW2CSTYN2j
         VxqNB2p/RRFpUeDOBqCVlPrw317qXse8GZ3XZ+H8sLe0OLcIzXPVTDHPc6P4/AxwGuAt
         nMAw==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

No functional change, try to make it more readable.

Wei Yang (3):
  mm/memcg: set memcg after css verified and got reference
  mm/memcg: set pos to prev unconditionally
  mm/memcg: move generation assignment and comparison together

 mm/memcontrol.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

-- 
2.33.1

