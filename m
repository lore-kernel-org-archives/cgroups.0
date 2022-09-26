From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH 0/4] memcg swap fix & cleanups
Date: Mon, 26 Sep 2022 09:57:00 -0400
Message-ID: <20220926135704.400818-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=fVdpPr3f8bRd7B1cM3PWSFoALdvL6AntNtNCVepwQ2Q=;
        b=1d9f5RsBJxy54KAvlvlDlqBnvfh09snGIaY+6tvR2PwJb8W2/H0yK3jGriNt2JmahM
         gqWhIFwuh0UZ+C2UumnkbJWyJ6rDK2pKaxW3puzSUzrz7sSlzakzLN6njU4R/pYzJSIB
         EuFwuwSTppmZFSyDEE7eJVdFYUo9Et/OiqExxX95fifd0xJ6t8vDLsVCXFg8equ7uAz0
         iNmSSjeT76pA7UVs2IMoN/Lf9vxrk+ItFKLIw2pndSHR6oVHp4yIhTQmVRrKY9KJhjkm
         lN8vWWAsrcoQtS+NIFmjYmsrjW0h5S5vkeXtfCCVgzk4o8/Emjt6fufYXfGeZs8kzjQ0
         xPZw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This is a refresh of older patches that fell through the cracks.

Applies on top of mm-unstable.

 Documentation/admin-guide/cgroup-v1/memory.rst  |  4 +-
 Documentation/admin-guide/kernel-parameters.txt |  6 --
 arch/mips/configs/db1xxx_defconfig              |  1 -
 arch/mips/configs/generic_defconfig             |  1 -
 arch/powerpc/configs/powernv_defconfig          |  1 -
 arch/powerpc/configs/pseries_defconfig          |  1 -
 arch/sh/configs/sdk7786_defconfig               |  1 -
 arch/sh/configs/urquell_defconfig               |  1 -
 include/linux/swap.h                            |  2 +-
 include/linux/swap_cgroup.h                     |  4 +-
 init/Kconfig                                    |  5 --
 mm/Makefile                                     |  4 +-
 mm/memcontrol.c                                 | 79 ++++++++---------------
 mm/swap_cgroup.c                                |  6 ++
 tools/testing/selftests/cgroup/config           |  1 -
 15 files changed, 39 insertions(+), 78 deletions(-)


