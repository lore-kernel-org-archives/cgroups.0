From: svc_lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org
Subject: [PATCH v1 0/2] memcg, vmpressure: expose vmpressure controls
Date: Tue, 14 Apr 2020 13:18:38 -0400
Message-ID: <20200414171840.22053-1-lmoiseichuk@magicleap.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=magicleap.com; h=from : to : cc :
 subject : date : message-id; s=pp09042018;
 bh=fZfKoumGyhhUhnpNwaeOKlaokdakEYLl+yjOnNzfDuU=;
 b=T8Ct4Rx2tHtkz81wq8vzedPGxgcA6aZW6p3BL3PWnZThs1D12eKpvtd5QvUAY4N/1p3c
 xUNpgfLk9TDuTAyE1l/7blDaHTYH5umMY8wRxe0W+mak4P0QgWoBdpvA4QZ68TPdyZY8
 G7RZUZk63CMomWdDs4p5XKaLMEiVjz5TQCYckGT2yMC74l9QhbNpWsg3qYO3/3KsiGke
 JCqFfltrdIOhlwJp5fJtfUPIj9AYsqbq8+FzDaHBXfe8QyrTqIgNoLgJ35zjntD7THuz
 yya+IBKmEWSzqeDEyYpanB1aA8dnbZKnfy0uIE7k5O2SZbCI580Q8gImtpGEYi5HWDC/ Bw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=magicleap.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=fZfKoumGyhhUhnpNwaeOKlaokdakEYLl+yjOnNzfDuU=;
        b=ourVl67jKozOKoolrod7Y9uQdDWgHTTaTEH/KkTHbV6Y/dHW1i7oI92eRF32DP8nhK
         fJ4cIK6hodc50LQgxYD11GJBsjoJzC1ZUvtcAXQ80iXRF5CGt69KT2IttWIIr3eOPVMn
         m9jhKhNytrOs8ZXV85c4Lldjf15CljMyGN6to=
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vinmenon-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Leonid Moiseichuk <lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org>

From: Leonid Moiseichuk <lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org>

Small tweak to populate vmpressure parameters to userspace without
any built-in logic change.

The vmpressure is used actively (e.g. on Android) to track mm stress.
vmpressure parameters selected empiricaly quite long time ago and not
always suitable for modern memory configurations. Modern 8 GB devices
starts triggering medium threshold when about 3 GB memory not used,
and situation with 12 and 16 GB devices even worse.

Testing performed:

* Build kernel for x86-64 and aarch64 (Tegra X2 SoC)
* Booted and checked that all properties published
* Tuned settings and observed adequate response
* sysbench and memory bubble application (memsize from lmbench)
  used to verify reactions

Change Log:

  v1:

  => updated commit with 8 GB numbers per Michal Hocko request

  v0:

  => initial implementation
  => tested on x86-64 and aarch64

Leonid Moiseichuk (2):
  memcg, vmpressure: expose vmpressure controls
  memcg, vmpressure: expose vmpressure controls

 .../admin-guide/cgroup-v1/memory.rst          |  12 +-
 include/linux/vmpressure.h                    |  35 ++++++
 mm/memcontrol.c                               | 113 ++++++++++++++++++
 mm/vmpressure.c                               | 101 +++++++---------
 4 files changed, 200 insertions(+), 61 deletions(-)

-- 
2.17.1

