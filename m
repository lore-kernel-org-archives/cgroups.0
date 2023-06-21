From: Yuanchu Xie <yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH v2 0/6] mm: working set reporting
Date: Wed, 21 Jun 2023 18:04:48 +0000
Message-ID: <20230621180454.973862-1-yuanchu@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687371415; x=1689963415;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SErWj7qxRQBNUC6Smh628AB0v7WlXXsygGd167Tdi3o=;
        b=gH6qZbnmbvzhnYXoZHM0cADGdDaQIJB+Zb3K2J/nt0RJuILN8TTUQfNKhL1NoOpRoz
         4eVB/B6O+ns16KrHXkmaeikTQ1b4ePaYZisr/NBGvmSQq0hmkMR56XmPQ9zVAPgyYpmv
         NWCVADLarekZTb/YF8tUjVsARrtG4eYeUd7AA+vBvQZiMqWNtFY3+HGIkyHzwljwaele
         W05jZa+gTCAsFM8uZ+8pwELeyZ6jb1Kp2qCG2b0T90gXpNA9TB2I4C8u3P2k6nyj8VqU
         jSnRcjmfT6h2C4RkMJHux+0cYzROGVEdGqr7gLxMMg1pIBqe2KL8660Qf2/lKBB+AAlN
         vztQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J . Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Michael S . Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yuanchu Xie <yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T . J . Alumbaugh" <talumbau-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, SeongJae Park <sj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sudarshan Rajagopalan <quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>, kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, jon-8cO4VLV/4DJBDgjK7y7TUQ@public.gmane.org, Aneesh Kumar K V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

RFC v1: https://lore.kernel.org/linux-mm/20230509185419.1088297-1-yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/
For background and interfaces, see the RFC v1 posting.

Changes from v1 -> v2:
- Refactored the patchs into smaller pieces
- Renamed interfaces and functions from wss to wsr (Working Set Reporting)
- Fixed build errors when CONFIG_WSR is not set
- Changed working_set_num_bins to u8 for virtio-balloon
- Added support for per-NUMA node reporting for virtio-balloon

The RFC adds CONFIG_WSR and requires MGLRU to function. T.J. and I aim to support
the active/inactive LRU and working set estimation from the userspace as well.
This series should be build with the following configs:
CONFIG_LRU_GEN=y
CONFIG_LRU_GEN_ENABLED=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_WSR=y

TODO list:
- There's a hack in mm/vmscan.c that calls into the virtio-balloon driver,
  which doesn't work if CONFIG_VIRTIO_BALLOON=m. T.J. Alumbaugh (talumbau-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org)
  and I plan on solving this problem with a working set notification mechanism
  that would allow multiple consumers to subscribe for working set changes.
- memory.reaccess.histogram does not consider swapped out pages to be reaccessed.
  I plan to implement this with the shadow entry computed from mm/workingset.c.

QEMU device implementation:
https://lists.gnu.org/archive/html/qemu-devel/2023-05/msg06617.html

virtio-dev spec proposal v1 (v2 to be posted by T.J.):
https://lore.kernel.org/virtio-dev/CABmGT5Hv6Jd_F9EoQqVMDo4w5=7wJYmS4wwYDqXK3wov44Tf=w@mail.gmail.com/

LSF/MM discussion slides:
https://lore.kernel.org/linux-mm/CABmGT5HK9xHz=E4q4sECCD8XodP9DUcH0dMeQ8kznUQB5HTQhQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/

T.J. Alumbaugh (1):
  virtio-balloon: Add Working Set reporting

Yuanchu Xie (5):
  mm: aggregate working set information into histograms
  mm: add working set refresh threshold to rate-limit aggregation
  mm: report working set when under memory pressure
  mm: extend working set reporting to memcgs
  mm: add per-memcg reaccess histogram

 drivers/base/node.c                 |   3 +
 drivers/virtio/virtio_balloon.c     | 288 +++++++++++++++++
 include/linux/balloon_compaction.h  |   3 +
 include/linux/memcontrol.h          |   6 +
 include/linux/mmzone.h              |   5 +
 include/linux/wsr.h                 | 114 +++++++
 include/uapi/linux/virtio_balloon.h |  33 ++
 mm/Kconfig                          |   7 +
 mm/Makefile                         |   1 +
 mm/internal.h                       |  12 +
 mm/memcontrol.c                     | 351 ++++++++++++++++++++-
 mm/mmzone.c                         |   3 +
 mm/vmscan.c                         | 194 +++++++++++-
 mm/wsr.c                            | 464 ++++++++++++++++++++++++++++
 14 files changed, 1480 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/wsr.h
 create mode 100644 mm/wsr.c

-- 
2.41.0.162.gfafddb0af9-goog

