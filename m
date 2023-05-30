From: Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH v4 0/4] sock: Improve condition on sockmem pressure
Date: Tue, 30 May 2023 19:40:07 +0800
Message-ID: <20230530114011.13368-1-wuyun.abel@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1685446827; x=1688038827;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JO+xdar3MejOJZdKmBkA9ihZEhu1lJTvdVxsMRKinbc=;
        b=WsDOY9jQoN7Z60/CfCewtBbx5WDKyT8UAnjmpj9OQeIMppc40tAvX12MUibOoFeC7F
         1yvBEnazT7feLsOMV4EmMc7BN0meQQncwW7I8uk5n4K35FpQV1ssrM64kI8qNjo86HCU
         q2b3VVlCgdXlWT5ljhv4SobkdECX9a/4ycYrCXq4U/GEy8xocCxQ5uD1oj2uZquQ3me1
         XgBo5tCmkqXMjg0hRKZfkVek1kAWtxJIuKw9xheE9KTLYc2oxLxe/7utv8B1FrJyg2CW
         1Sn6hEVW5ZWW1PfUOx9Kpa62nIcl20BGmKkT1L1FZjER2FvJLR2KYjVryJv1rdsTTDE9
         movg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Simon Horman <simon.horman-JqlR5BE4aJhWk0Htik3J/w@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Currently the memcg's status is also accounted into the socket's
memory pressure to alleviate the memcg's memstall. But there are
still cases that can be improved. Please check the patches for
detailed info.

v4:
  - Per Shakeel's suggestion, removed the patch that suppresses
    allocation under net-memcg pressure to avoid further keeping
    the senders waiting if SACKed segments get dropped from the
    OFO queue.

v3:
  - Fixed some coding style issues pointed out by Simon
  - Fold dependency into memcg pressure func to improve readability

v2:
  - Splited into several patches and modified commit log for
    better readability.
  - Make memcg's pressure consideration function-wide in
    __sk_mem_raise_allocated().

v1: https://lore.kernel.org/lkml/20230506085903.96133-1-wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
v2: https://lore.kernel.org/lkml/20230522070122.6727-1-wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
v3: https://lore.kernel.org/lkml/20230523094652.49411-1-wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/

Abel Wu (4):
  net-memcg: Fold dependency into memcg pressure cond
  sock: Always take memcg pressure into consideration
  sock: Fix misuse of sk_under_memory_pressure()
  sock: Remove redundant cond of memcg pressure

 include/linux/memcontrol.h |  2 ++
 include/net/sock.h         | 14 ++++++++------
 include/net/tcp.h          |  3 +--
 net/core/sock.c            | 10 ++++++++--
 4 files changed, 19 insertions(+), 10 deletions(-)

-- 
2.37.3

