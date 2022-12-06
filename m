From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH v2 0/3] mm: push down lock_page_memcg()
Date: Tue,  6 Dec 2022 18:13:38 +0100
Message-ID: <20221206171340.139790-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aHW4AF6UbouyjsoQjAo93Rw4CHPKsRNQFiH676IJZhI=;
        b=U3JPE2wpoXJXzygCbWmscmBrgC7FK5UJNHsQONmaGZiZmH3+sgAYjnYd5Ls05NwlQM
         vONDSCbVwBJkvD+yFM9ZlH2UrOXI+N1akE2rtdo0FhyTxLbcXJNrdp0P8+pXIposb+UE
         IGcNcfKz8Y8mljOCpJv3hMRSWaepYsKExZQ89Ffqglmn9IibZIsuj3nOEpTrpsOKREm8
         f5yPVKxG2TqfCm71/bP+FY8Zs7eq1s5zzjEyw9tPwFRlJlN4dRk6a6hyVJyj1p1wafID
         e4W96vxjpUtly6cSO2Kh3gkhCt0wDtzy0xrJ0UNTk96w+7FtOjPNllJxXrMYRQbjBwzd
         7Ijw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

New series based on the discussion in the previous thread around
getting lock_page_memcg() out of rmap.

I beat on this with concurrent high-frequency moving of tasks that
partially share a swapped out shmem file. I didn't spot anything
problematic. That said, it is quite subtle, and Hugh, I'd feel better
if you could also subject it to your torture suite ;)

Thanks!

Against yesterday's mm-unstable.

 Documentation/admin-guide/cgroup-v1/memory.rst | 11 ++++-
 mm/memcontrol.c                                | 56 ++++++++++++++++++------
 mm/rmap.c                                      | 26 ++++-------
 3 files changed, 60 insertions(+), 33 deletions(-)


