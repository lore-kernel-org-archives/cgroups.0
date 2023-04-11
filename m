From: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [LSF/MM/BPF TOPIC] Reducing zombie memcgs
Date: Tue, 11 Apr 2023 16:36:37 -0700
Message-ID: <CABdmKX2M6koq4Q0Cmp_-=wbP0Qa190HdEGGaHfxNS05gAkUtPA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681256208; x=1683848208;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=e+cWg+b19Pk6f8lXfyk0VWgnSnQrmltuo/INztAOGCM=;
        b=vk1Y0/oQzBUKttG+1CE6Ykc1Os1ojCytzOnyh/uKmZw1VqlduwkcIOGwSrjaxmqQZy
         9rbnHcjMsuGy47RJQ0tDwzDsfqZ3odrq+rP2bYEL8fY0bFzv09M8Ns8y9subW8q2Hxmi
         Wy45zN3ZdT6Nn60tro6WBgbtscAv4FWObD957ShoM4DJR3ARE9eSLY78cFkVS9AD3JWQ
         jETav30clTRWo3y8krtaJPOD39cGb6zkkFpSG8Op77Gr0Js3nG0R1MlZ41AF13QSZqFS
         AeSFa3TCWZlR54JH/xtyu8RGrzmUPafEJhPZkfwPIgSMYesdaBp7Uqn6tI5mRFpcNQkF
         nppA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Kalesh Singh <kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

When a memcg is removed by userspace it gets offlined by the kernel.
Offline memcgs are hidden from user space, but they still live in the
kernel until their reference count drops to 0. New allocations cannot
be charged to offline memcgs, but existing allocations charged to
offline memcgs remain charged, and hold a reference to the memcg.

As such, an offline memcg can remain in the kernel indefinitely,
becoming a zombie memcg. The accumulation of a large number of zombie
memcgs lead to increased system overhead (mainly percpu data in struct
mem_cgroup). It also causes some kernel operations that scale with the
number of memcgs to become less efficient (e.g. reclaim).

There are currently out-of-tree solutions which attempt to
periodically clean up zombie memcgs by reclaiming from them. However
that is not effective for non-reclaimable memory, which it would be
better to reparent or recharge to an online cgroup. There are also
proposed changes that would benefit from recharging for shared
resources like pinned pages, or DMA buffer pages.

Suggested attendees:
Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
T.J. Mercier <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Kalesh Singh <kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
