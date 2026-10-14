Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA2C4E9C0E;
	Wed, 14 Oct 2026 14:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=130.117.225.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791989695; cv=none; b=JM2wZyJrfdP5GCryN5v8ssIAtRCjE0qTODONG5Q8pHU1VDvilERsNp9O+sWZ3PeghGTJojzEzNZa6gk6pGPCPgPq0bmtV+1wuYIOKvSc4k6+iGgZFMHNJ/iZv+JTCf+x/6bJ8V3qVbX0EOhHwVGNRcdiuIVfmE7xHl8DrQLGntY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791989695; c=relaxed/simple;
	bh=S5pKXlc8nyAL42PzwQoBsDoCOCSgtHQeHvMgfKY+ET4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VZfXReg+ifc+eq0y7KEpOnouT+xt6Yn0mbSepcWSk2v+3ytq0A6IDGCryKUttisXrkgv0rXpouW/aSRhCWsZGYJ/vYjXgp8TmJVEJhVgjg0E6MlQMMwH9tlPuf2rz5Hp90yWVJ1oKNVgob9ExUQJV+t0RDV9BGei8s2vtgTULpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com; spf=pass smtp.mailfrom=virtuozzo.com; dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b=V1WGQBEK; arc=none smtp.client-ip=130.117.225.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="V1WGQBEK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=HWkLknY7xKuy1SA57I+rolv6ltWrRmW9nqFyBjSVvQU=; b=V1WGQBEKONr07ayyPOq
	f59wHfgGQCXmctUhu4aQGgSJKvgHsJnKSTouvxK9sfyv8boIWdyvHm/i1C4bBnzSsBgsfd0PMeN6D
	NDISZRH7uTU3M1lqZFdtzwxTH80pg88JI4FLUYc05mU+zX6esk7o+VFHEeaYyJNW3HC73dDKRcQNu
	1MH4uGox25QJDGBcQzgxTOlMiAFphadKDKBpDn17SNaMOgP70AYO2dvY7suLnH4vPXsLbwxMWp3Kz
	NlFQeZCnVZYqmgC6cw3/hzlct944W91ADQRh/4YODFKtOxDwVyskK5+UulXUI5iSlUep3alkSISXk
	th41TVl7iqmJipw==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xH0Jy-005Oui-08;
	Wed, 14 Oct 2026 16:54:42 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Wed, 14 Oct 2026 16:54:37 +0200
Subject: [PATCH v2 1/2] mm/shrinker: size shrinker_info_unit to a power of
 two
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v2-1-51af2aedbe6c@virtuozzo.com>
References: <20261014-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v2-0-51af2aedbe6c@virtuozzo.com>
In-Reply-To: <20261014-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v2-0-51af2aedbe6c@virtuozzo.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3201;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=S5pKXlc8nyAL42PzwQoBsDoCOCSgtHQeHvMgfKY+ET4=;
 b=kA0DAAoBUZYKR/lhXCoByyZiAGrPl7Cj+MS2MZcYboAZyGfaWxUgNJHSegFzxv1aZwzsnYJY1
 YkCMwQAAQoAHRYhBFYPbcg9xdPQY70ILFGWCkf5YVwqBQJqz5ewAAoJEFGWCkf5YVwq+g8P/j71
 4qOS1vdUF33iiqyre5o6E4LH1jmZ8aERi2jJnKkQPqXBGQab5QFxVfVOV4OxX1DS0rPYy89LVhX
 jvirxoS1MDu3fWxpXe7pwgLcPHMK+9uYsei3l6ghVsnEALpriZWvv6urqvtTUaL1MRFyWVp3dZ4
 MqfkPG50rMArlFl9bHXZ0qizhPy6C869lDHsu0UoGXhZagS2Pj8zEhn92V0NvwlvSErzHRPRvhO
 b6jFYkkGVwjtOgHdUv4TnO1rKQ/991MKZcXMO+4P3ZKcffVLCyuX4CI1hN1WQHFihynBJzlVjmX
 6Anie+1bM6zRslYp3Vi9bHHnVorRre86BLtgVrEc15g+SWtXFm4pc238Vb0F+efwAKR9lvoCDPV
 r/WVII5avltoH+MbIcilws8hvPwbIOHXZGdTAtTXWIkrj5KZ4beqLSJuoczqeP6MVQD77wm4BCT
 nuvzyV35XOscvwRVtVHtTzsLn4S6EaP1A4LrzEydsKbv7Qitht0cNIdTgrmO5TnDSfN/RdJuXQF
 IaKszmxzQtzh38MGRKl3dEvXPKaPpL/urMvrGF+xcSySAo/JL/1gaPHe7L8xgDMBQSLrO2lpALx
 p+oCDejJw3R+pkiprYf8q8wpAgiPW8ic94Y0kycYPIM3rD0eRRfHvznJ8N83QTsbnJxcjY4H+E8
 Ztnyr
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A

Every memory cgroup allocates, per NUMA node, one shrinker_info_unit
for every SHRINKER_UNIT_BITS shrinker ids up to shrinker_nr_max. The
unit holds BITS_PER_LONG atomic_long_t of deferred work, a power of
two, plus the one-word bitmap of shrinkers with objects charged to the
cgroup. That word takes the unit just past the power of two, to 520
bytes on 64-bit, so every unit comes from kmalloc-1k and almost half of
it is padding.

The units are allocated when the cgroup goes online and freed when it is
freed, so a dying cgroup keeps them until the last reference to it is
gone. Their number is the number of memory cgroups, times the NUMA
nodes, times shrinker_nr_max / SHRINKER_UNIT_BITS. shrinker_nr_max is
the peak number of memcg-aware shrinkers registered at once, and every
superblock registers one, so a host that mounts many filesystems and
runs many cgroups carries the padding as unreclaimable slab, and keeps
paying it for new cgroups after the mounts are gone.

Let a unit cover one id less than a word holds. The bitmap still fits
one word, and nr_deferred[] plus that word add up to BITS_PER_LONG
longs, so the unit fills a power-of-two kmalloc slot exactly and, on
64-bit, the memory taken by units halves, for about one unit more in
BITS_PER_LONG.
round_up() in expand_shrinker_info() needs a power-of-two step and
becomes roundup(); the other uses of SHRINKER_UNIT_BITS are divisions,
modulos and multiplications that do not care. Assert the unit size at
build time, since the layout depends on it.

Assisted-by: LLM
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 include/linux/shrinker.h | 6 +++++-
 mm/shrinker.c            | 4 +++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
index 1a00be90d93a9..f1cf6096a7a06 100644
--- a/include/linux/shrinker.h
+++ b/include/linux/shrinker.h
@@ -7,7 +7,11 @@
 #include <linux/refcount.h>
 #include <linux/completion.h>
 
-#define SHRINKER_UNIT_BITS	BITS_PER_LONG
+/*
+ * One id less than a word holds, so that nr_deferred[] and the map word add
+ * up to BITS_PER_LONG longs: a power of two, which fills a kmalloc slot.
+ */
+#define SHRINKER_UNIT_BITS	(BITS_PER_LONG - 1)
 
 /*
  * Bitmap and deferred work of shrinker::id corresponding to memcg-aware
diff --git a/mm/shrinker.c b/mm/shrinker.c
index 7ec2a9704f6f2..5e4a5ce231868 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -46,6 +46,8 @@ static inline int shrinker_unit_alloc(struct shrinker_info *new,
 	int start = old ? DIV_ROUND_UP(old->map_nr_max, SHRINKER_UNIT_BITS) : 0;
 	int i;
 
+	BUILD_BUG_ON(!is_power_of_2(sizeof(struct shrinker_info_unit)));
+
 	for (i = start; i < nr; i++) {
 		unit = kzalloc_node(sizeof(*unit), GFP_KERNEL, nid);
 		if (!unit) {
@@ -159,7 +161,7 @@ static int expand_one_shrinker_info(struct mem_cgroup *memcg, int new_size,
 static int expand_shrinker_info(int new_id)
 {
 	int ret = 0;
-	int new_nr_max = round_up(new_id + 1, SHRINKER_UNIT_BITS);
+	int new_nr_max = roundup(new_id + 1, SHRINKER_UNIT_BITS);
 	int new_size, old_size = 0;
 	struct mem_cgroup *memcg;
 

-- 
2.43.0

