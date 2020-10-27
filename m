From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH 0/5] Fix some bugs in memcg/slab
Date: Tue, 27 Oct 2020 16:02:51 +0800
Message-ID: <20201027080256.76497-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kG6PqPw8H5tvrqd/aB6QZ20Kiu7xsv86CzlJPEIAW18=;
        b=CvS4lGhbaduFgXwzlkmjhkqLZ9Hbub8RGApcEu/x2HgIai6Ow8JRCxzFzMUUer/bQg
         l3YlphLdok80JRdVICtVtMdnrz7E/IIzYX5Z2KHV/3FFu9czYXaAQooNmjalAPgReeds
         rH7pI0kvJZA2YpVpZgkR4ymZIcCCRP/nzIFHLHEjBT25oI0fXea8GFaTc48z56evVCOK
         GISXlr7jEVbdJufRsIEkvdWmvWOWP2zvoo52TV8Y4Y8qzFA/sgMKuWm8k1CICy9F5ydZ
         9HJir1FdSLBiNegj458SP8b65nBbm0M7xW7k6qafuo08INH1fvs1djvDOwMtmqaEaFO6
         EyVg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, areber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

This patch series fixes some bugs and simplify the code in the
memcontrol.c.

Muchun Song (5):
  mm: memcg/slab: Fix return child memcg objcg for root memcg
  mm: memcg/slab: Fix use after free in obj_cgroup_charge
  mm: memcg/slab: Rename *_lruvec_slab_state to *_lruvec_kmem_state
  mm: memcg/slab: Fix root memcg vmstats
  mm: memcontrol: Simplify the mem_cgroup_page_lruvec

 include/linux/memcontrol.h | 62 +++++++++++++++++++++++++-------------
 kernel/fork.c              |  2 +-
 mm/memcontrol.c            | 61 ++++++++++---------------------------
 mm/workingset.c            |  8 ++---
 4 files changed, 62 insertions(+), 71 deletions(-)

-- 
2.20.1

