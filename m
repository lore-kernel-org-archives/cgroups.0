From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/3] mm, memcg: Miscellaneous cleanups
Date: Fri,  1 Oct 2021 15:09:35 -0400
Message-ID: <20211001190938.14050-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633115415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=pz0wmXCAvE18wwAJ1895fO0ypCJsx+A6451tOW6KYDw=;
        b=hgINSBWioI3LDaYBVcahteKMR2/HxSLwY210rtkWc0H4ErvWGCXKf4pNWnW7/1AEanc9LB
        YgH5XOjYbMdfDyGFn0xsi+lKTezd3wtoPtJEkLwafksG+yFpsjpZ6M/SsH88Y+K+QHPD60
        80xEQQqXMa2V6o5kiBEH9EzqdffBRh0=
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

This patch series contains a number of miscellaneous cleanup for memcg. It
is based on the next-20211001 branch.

Waiman Long (3):
  mm, memcg: Don't put offlined memcg into local stock
  mm, memcg: Remove obsolete memcg_free_kmem()
  mm, memcg: Ensure valid memcg from objcg within a RCU critical section

 mm/memcontrol.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

-- 
2.18.1

