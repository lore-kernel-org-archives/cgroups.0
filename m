From: svc_lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org
Subject: [PATCH 0/2] memcg, vmpressure: expose vmpressure controls
Date: Mon, 13 Apr 2020 17:57:48 -0400
Message-ID: <20200413215750.7239-1-lmoiseichuk@magicleap.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=magicleap.com; h=from : to : cc :
 subject : date : message-id; s=pp09042018;
 bh=ULBffSSWiOkyC0UR59o7WDkKeU3p81EFjrY635dhS+U=;
 b=f3l7rFKUzkcoM6KQGgSHmVZAnhe+VEgmqVy8P01gzUxXpL0G+NXbe/XkGqleHPFiixKV
 TlG93I2LrH/G50XHWYew5i6AdBfLnn/UGJT+S7/Lcbl0RGgqvbsLgUpvSXKuLGcCD2ke
 EHtw38bz/CTf5A16HfMnE1dvMYM0zOjWKUgJOPtXg7CwB2j9+r8pGdRKoE92yOnLzP5d
 GYXNr6BxD82wIEM6k24soPhE7u0N7gfeiZHFlKr7iNBfAPt5sd/iCN595/zzxwMUI4kW
 ZEDycoNnI+LC+t0wIB1OgDJUrLVdQscEH5e/sv3/P5oNAvbKKeMilD4oYS1G7OmvkEn6 0g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=magicleap.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=ULBffSSWiOkyC0UR59o7WDkKeU3p81EFjrY635dhS+U=;
        b=ph7XMJp0u7u47D42UuMsJEZo++sq1SAbd5hRXfZm9Ps9o3lAWcIxA//cc06JvLdvwD
         b/E+KO4wT1LoNQEZwQriMNexQ1kyJBtVgSr+DVf7Auy4GmYerSyxUCFnVE/dNm4Sb7wy
         xBeHz8K1IG5SP1hfUz4D0vI77KEpmBbo6BZb4=
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vinmenon-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Leonid Moiseichuk <lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org>

From: Leonid Moiseichuk <lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org>

Small tweak to populate vmpressure parameters to userspace without
any built-in logic change.

The vmpressure is used actively (e.g. on Android) to track mm stress.
vmpressure parameters selected empiricaly quite long time ago and not
always suitable for modern memory configurations.

Leonid Moiseichuk (2):
  memcg: expose vmpressure knobs
  memcg, vmpressure: expose vmpressure controls

 .../admin-guide/cgroup-v1/memory.rst          |  12 +-
 include/linux/vmpressure.h                    |  35 ++++++
 mm/memcontrol.c                               | 113 ++++++++++++++++++
 mm/vmpressure.c                               | 101 +++++++---------
 4 files changed, 200 insertions(+), 61 deletions(-)

-- 
2.17.1

