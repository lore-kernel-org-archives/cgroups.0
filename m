From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH 0/2] ipc: allocations cleanup
Date: Mon, 26 Apr 2021 13:18:01 +0300
Message-ID: <ebc3ac79-3190-520d-81ce-22ad194986ec@virtuozzo.com>
References: <e67f2a95-4b01-9db2-fe47-0b2210f0b138@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=bS7qJCt+apou1io9EP23fTA+ismXHEBNwUulXjfdPVc=; b=V2aHQIRfxkj2C8JYCW1
        Xdjs8pF7wKtVSDoELvOh/RFwlqsae9Dqmm8vtmLAkEhzGI3q5f0mGU3RnF8qdWtEIb9Cep2vLJwtp
        dOkPOTieBEBVyNLrF17DZtRKDEF1wvZuQFSQh6KJcVBZDYCdpSywmJJC1H8FbyvsJdkbrDksIQM=
In-Reply-To: <e67f2a95-4b01-9db2-fe47-0b2210f0b138-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dmitry Safonov <0x7f454c46-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Some ipc objects use the wrong allocation functions: small objects can use kmalloc(),
and vice versa, potentially large objects can use kmalloc().

I think it's better to handle these patches via cgroups@ to avoid merge conflicts
with my patches that include accounting for ipc objects.

Vasily Averin (2):
  ipc sem: use kvmalloc for sem_undo allocation
  ipc: use kmalloc for msg_queue and shmid_kernel

 ipc/msg.c |  6 +++---
 ipc/sem.c | 10 +++++-----
 ipc/shm.c |  6 +++---
 3 files changed, 11 insertions(+), 11 deletions(-)

-- 
1.8.3.1

