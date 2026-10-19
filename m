Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=130.117.225.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792431573;
	b=NLOsmmmmjBFExZh8zU6KQ5lAiH0wlDaXwerqZuNzDRuFWgOMq1VdTb6viPKpODWsk9kt
	 QHNSIf3n8gZfZr+o0XZYHYq3oLIkXWk5kSdDYljofpHVafu9qItk55WscqfKDHZGf3Y19
	 BkBQ3zZwrIdDL26lJtul0oJ4BraVlacJkNuQ/1joKreyHIBW0UElxcUD1FOTtntZ279AZ
	 R8quFIUp47W5Ly10loXvnlPdKiUvev9BRCk4VXIFs1seKP11qWq1YsYY3WfXqJOHhAxbC
	 Yx5mjw6kq8CEihsp3YHy1d1adFMQEtWRQkRBsOweKYnF/wwD7kZsItKJW0awmjQQ5Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792431573;
	h=DMARC-Filter:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=51ZqUeACXcpZacBrZlRnXybKqIYTaPAWzvKxnKGcX/w=;
	b=pUnA7fUDFXIv44tGySQqykrrQ6XF4kpXrRLZUoLJUzXL5jo79v0kWUliVd5QnEHLEcAg
	 JE0xaWJGyfJv82lzJtzMhj15J5ZSW7RMXjdF7a32q8O38Iw1oY0eq7O0cJQW/FziQcJEn
	 FfO/OPsZPiDYx0rtijKdNFHjp7i1HIsX9vAD2sE9Gi4hSjqq+UA/SY4ABKO2ESAc7EiPI
	 Z0ah1tqy8tLsVDHKeIZMCX+kNcwE0SBxdpOIZ1PR1J5lrYycYEzVsQYU0g2lsHLS1cqoi
	 NWy33WsPVQmUT07KjOxWFFbPRABFXhkkQBLxX9jxiRj/PUzL9ufnFVBl0VKZBSK80hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=virtuozzo.com;
	spf=pass smtp.mailfrom=virtuozzo.com;
	dkim=pass header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=XfYKDgn5;
	arc=none smtp.remote-ip=130.117.225.111
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FFC606A324;
	Mon, 19 Oct 2026 17:39:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C7FFC606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=XfYKDgn5
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Message-Id:Date:Subject
	:From; bh=51ZqUeACXcpZacBrZlRnXybKqIYTaPAWzvKxnKGcX/w=; b=XfYKDgn5gEgfYoTmKNr
	xHUHTHOszRZBeMzbXeKouUsuzNC88buCs0M3ms7wN4ecL2yOBARp4zhbQwF7LZOTDDvR+BFU2Cn23
	/ElqI0A6Rsc2UCSSzj4wkVkq0yflNp7+hCCpru0v/U8I6JfhqYIwPgI+0RGpq9nqs4zNeqg7Fkm8O
	tLc37NsfpWHgRT3iVNgztf/lY77FgQiU0V9vU7rZcABbAPw+ouoj9o+CVcQeDkUdolBy8AujY9bSs
	ICRN4Ax76QpNqPUd047hSgUse15zm2+lHeCK5zGDFxlnf4qMaY4vf9pZmhIGjU33R/JaUhXU/GS5J
	bbL2LAolfDNbltw==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xIrH1-007Chf-0e;
	Mon, 19 Oct 2026 19:39:19 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: [PATCH 0/2] mm/shrinker: per-memcg shrinker units in an xarray,
 allocated on demand
Date: Mon, 19 Oct 2026 19:39:22 +0200
Message-Id: <20261019-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-v1-0-64ed1f7957c9@virtuozzo.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMpV1moC/02P22rDMBBEf8XouVsk+RaZUvofJZiVvErUYMmVb
 JMm5N8rJyX08cAwM+fKEkVHiXXFlUVaXXLBZxAvBTNH9AcCN2RmkstGcKFAVzBFmmBNc4ggqqo
 VLUwUYaTRHCAdo/OnjIt3c4LgYaAR/QBnjBF/wGo7yBZ3ZmgUyyO5y7rz/cDn/sFp0V9k5m31L
 xHpe8nP5keMaUwEJoyjm7tCViiUVnVJEsuBE9a5vFK1QI56Z0vZSm4Ub7eqkVLCu1JXvD2N/pn
 Uz/+98zb0mwScsllv0BwJ1hIEcKt5I4grbauP1cV5CZdLeM2H3tn+dvsFt9X/T1MBAAA=
X-Change-ID: 20261019-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-fbfd27a8cd69
To: Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3859;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=qX2RYnuIBw7lvnDu9WuIMmC+EJTZiBoSc6ySim5RomA=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq1lXODSiZHrBaM+21Dc0C7nWJidNdICEXrPMvi
 5XzzXEW5viJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCatZVzgAKCRBRlgpH+WFc
 Km/5D/4tacnGJojOgnomfU/sBBP418jNm0kvem0FQ50VsNBh71ibkf6X1CRRAeoj4kf8+6XpkbQ
 rpgLsngzSRti+HCJLe0RFWJgswjPMgULiOmoJgOOoUdzr4MQwBL1okWkXT7mtRycnatX4iZcGsf
 2sk5qzxqZw2qJ7nWr6xpYw42QsGmP5UpFMLemP7kXA5a3puOSbbt+M0C/TFTNPUs2LPyBsvkxaQ
 Hv9Ankk6EuSHUgTlcDkxLOMDrGHw/QWkUqr52oex1/fb4qhHwa/6p4PBuu2PMxedzGe6wCAP5WS
 X6xVkBjc07Wo0YxYSG6bcDiRQB3Yvapo1lrmmi+pguD/0ueasmCBkZIxmnUPIvDcHzVQhiuIq3F
 VoJ012jS5b2Zn/qa+llulh24Tgm20c2CKveUNhI7+glhS5So0i+TFwOx/4lwy6UNY+cO99Kyl/z
 k9Dg9cfvrqrsM3jhApeuu3bgp0oYdxyWAfOKdZJ6DGnHDji7D45rOKZzpRySNS0KahEmPVsBZBL
 uExX18fPekMzVF/fUeuGwIhdcOT+X6sWhCJlcMjNT4522ZKOzQP7TkY/Cohg4PheCjjwkV1ttuC
 zPFgpcgh5BcpYsLGaxMSTDV5zKp6JqlK9d/NNt5OdHq97aGskV2dB+7U6NWB6etYKHzCg3rL6Ev
 ZD0FxeckAFFiswQ==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A

Every memory cgroup allocates, per NUMA node, one shrinker_info_unit
per 64 memcg-aware shrinker ids up to shrinker_nr_max, whether or not
it ever charges an object to those shrinkers, plus a pointer array
sized for shrinker_nr_max. Every superblock registers such a shrinker,
and shrinker_nr_max never comes down, so a host that mounts many
filesystems and runs many cgroups pays for every superblock in every
cgroup, live or dying, and keeps paying for new cgroups after the
mounts are gone.

This replaces patch 2/2 of v2, "mm/shrinker: allocate the per-memcg
shrinker units on demand", with the xarray variant discussed in that
thread. It applies on top of "mm/shrinker: allocate shrinker_info_unit
from a dedicated kmem_cache", patch 1/2 of v2 sent on its own as v3:
https://patch.msgid.link/20261019-vstor-144715-shrinker_info_unit-kmem_cache-v3-1-0fb061e09bf4@virtuozzo.com

Patch 1 keeps the units in an xarray per memcg and node instead of the
pointer array. A new unit is inserted where it belongs: nothing is
reallocated, copied or published under RCU when shrinker_nr_max grows,
and the readers find a unit with xa_load() or walk the present ones
with xa_for_each(). The units are still allocated up front, so this
patch changes no behaviour.

Patch 2 allocates a unit only when the cgroup gets a list on that
shrinker's list_lru, which is where map bits are set: a cgroup pays for
the shrinkers it holds objects of, not for every superblock on the
host. The install is an xarray insert with the gfp of the list
allocation; there is no array to race with, so no lock of its own.
The root memcg keeps its units for the deferred work of global reclaim
and is the only memcg a shrinker registration still visits.

Measured on a 4-CPU, single-node VM, 20000 tmpfs mounts (shrinker_nr_max
20096) and 2000 memory cgroups, on three kernels:

  base                 v7.3-rc7 with the kmem_cache patch: every cgroup
                       has every unit, in a pointer array
  xarray               base + this series: units on demand, in an xarray
  old array on demand  base + patch 2/2 of v2, rebased: units on demand,
                       in the pointer array

                                                     old array
                                      base    xarray  on demand
  slab per empty cgroup               185 KB  18 KB   22 KB
  shrink_slab_memcg(), empty cgroup   1.6 us  0.2 us  1.6 us
  same, cgroup with objects on 100 sb 1.9 us  0.9 us  1.7 us
  mkdir/rmdir the cgroups, 4000 more
  mounts with them alive              same within noise

Changes from the v2 patch 2/2:
- The pointer array is replaced by an xarray in a patch of its own, so
  the on-demand patch no longer needs the spinlock that ordered an
  install against the array copy in expand_one_shrinker_info().
- Link to v2: https://patch.msgid.link/20261014-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v2-0-51af2aedbe6c@virtuozzo.com

---
Konstantin Khorenko (2):
      mm/shrinker: keep the per-memcg shrinker units in an xarray
      mm/shrinker: allocate the per-memcg shrinker units on demand

 include/linux/memcontrol.h |   5 +-
 include/linux/shrinker.h   |   6 -
 mm/list_lru.c              |  15 +-
 mm/memcontrol.c            |   6 +-
 mm/shrinker.c              | 374 ++++++++++++++++++---------------------------
 5 files changed, 163 insertions(+), 243 deletions(-)
---
base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
change-id: 20261019-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-fbfd27a8cd69
prerequisite-message-id: <20261019-vstor-144715-shrinker_info_unit-kmem_cache-v3-1-0fb061e09bf4@virtuozzo.com>
prerequisite-patch-id: 83371af931f7c67d55b59e51720ebaab143aefb6

Best regards,
--  
Konstantin Khorenko <khorenko@virtuozzo.com>

