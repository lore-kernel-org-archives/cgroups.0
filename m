From: "Yakunin, Dmitry (Nebius)" <zeil-2iiexdXeLXzQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 0/3] Helpers for debugging dying cgroups
Date: Mon, 11 Sep 2023 07:55:09 +0000
Message-ID: <20230911075437.74027-1-zeil@nebius.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nebius.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nCI1H6vMT0KBMX/H5V39gmSgTZSv9N0KOerpNWmPBQM=;
 b=HI/hnt3GWMfFJYCp5l2aSNd+QM2miP1r89KOAl/v1SjfB22RqQdjVjCqCeVM432EEcw7LKctZbETb7G8l9LkA4nc2BfYQQRSL/uR927efdU38zZ0XdbuGEPl/9f3u6aEnhifIHGacP8Xwk1SrOnc/njfocjrZaDKXFu97BfnMNnMb6Pnkz5KxOlfi29jaTy1OjYz2rN+xF3GrTFpWAG+8L2tZnOjieLPBRC06Ub3PoC5bzIh8ob1BDegjxFHRnjJramWi+UdC8/0JRs0jp5Yz1GMPI7bEOefNk5sntVuGMrnpFnd5Hug0Zh+OnK7yy9OUdnynm7jmOwJnlHDOZ2QHg==
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
Cc: NB-Core Team <NB-CoreTeam-2iiexdXeLXzQT0dZR+AlfA@public.gmane.org>, "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Yakunin, Dmitry (Nebius)" <zeil-2iiexdXeLXzQT0dZR+AlfA@public.gmane.org>

This patch series is mostly based on Konstantin's patches which he had sent=
=0A=
years ago [1].=0A=
=0A=
This functionality still seems very useful for debugging the difference=0A=
between entities in cgroupfs and counters in /proc/cgroups, e.g.=0A=
searching for files that have page cache which prevents destruction of memc=
g.=0A=
=0A=
I saw the comments in the original thread but didn't understand the Tejun's=
=0A=
comment about usage of filehandle instead of ino. Also I saved the original=
=0A=
output format in debugfs with extra counters. We can rework this format in=
=0A=
the future but now it seems straightforward for just filtering through=0A=
cmdline utilities.=0A=
=0A=
[1] https://lore.kernel.org/lkml/153414348591.737150.14229960913953276515.s=
tgit@buzz/=0A=
=0A=
Dmitry Yakunin (3):=0A=
  cgroup: list all subsystem states in debugfs files=0A=
  proc/kpagecgroup: report also inode numbers of offline cgroups=0A=
  tools/mm/page-types: add flag for showing inodes of offline cgroups=0A=
=0A=
 fs/proc/page.c              |  24 ++++++++-=0A=
 include/linux/cgroup-defs.h |   1 +=0A=
 include/linux/memcontrol.h  |   2 +-=0A=
 kernel/cgroup/cgroup.c      | 101 ++++++++++++++++++++++++++++++++++++=0A=
 mm/memcontrol.c             |  19 ++++++-=0A=
 mm/memory-failure.c         |   2 +-=0A=
 tools/mm/page-types.c       |  18 ++++++-=0A=
 7 files changed, 159 insertions(+), 8 deletions(-)=0A=
=0A=
-- =0A=
2.25.1=0A=
=0A=
