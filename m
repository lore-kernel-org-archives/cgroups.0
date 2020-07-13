From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: [PATCH v4 0/2] mm, memcg: memory.{low,min} reclaim fix & cleanup
Date: Mon, 13 Jul 2020 12:04:56 +0100
Message-ID: <cover.1594638158.git.chris@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=nN3m2m7pEWJxxgE22EVhuHKcD4TrCFPuvsPIp3KGX9k=;
        b=RqGITRMKNmMiYRdu6+vlFczkTYWFJp1c6+1yOC3ohAOzxc8vpAusqQEaQ0E2axiD3D
         QON4GHysm7Te5zUXV4Lz0GiISjc4xgU5T3b391ZpRcwJGbZ1amHXgAgqFQDjhLNJfgyG
         eX0sdzLY1TPzVvZ6Y5DHPyyoWITelQBhUSBaE=
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This series contains a fix for a edge case in my earlier protection
calculation patches, and a patch to make the area overall a little more
robust to hopefully help avoid this in future.

Changes in v4:

- Fix premature OOM when checking protection on root memcg. Thanks
  Naresh and Michal for helping debug.

Chris Down (1):
  mm, memcg: Decouple e{low,min} state mutations from protection checks

Yafang Shao (1):
  mm, memcg: Avoid stale protection values when cgroup is above
    protection

 include/linux/memcontrol.h | 95 ++++++++++++++++++++++++++++++++------
 mm/memcontrol.c            | 36 ++++++---------
 mm/vmscan.c                | 20 +++-----
 3 files changed, 103 insertions(+), 48 deletions(-)

-- 
2.27.0

