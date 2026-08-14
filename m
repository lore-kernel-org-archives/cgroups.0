Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFDA422521;
	Fri, 14 Aug 2026 07:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786693748; cv=none; b=BcZEovGuiUOmsfAUQVyzjWS9IVgdN1/2WP5/sQUlErNqszWwmuaNgCKJ/CXwKxWwzBBNfeYiSa/j2Ab5rKX61tTaRVd3cE+PIjOO5FW6mkOAv5Q2/ge1aCtY3KTlPZ1Nm+ZkOOSUYWphUJf+zg30nu6b7zQxgO9LS/oNR4ymnGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786693748; c=relaxed/simple;
	bh=OdyEdAbGrReWfF+9Bg5n9e1DlCuZbJG/3fgOF4VkI1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Kw/HUcrI5VLjeb/BtgVjL81cCwyxK7Bt1ok5lj0BcHWFA4+O1ziF6xYTw/FoMY0gn+VvZn7HJ6QdrFQXUEYdG6WCswgL9dR5D4+EI3kKE10SPQG9YtboAWJTVcXmUARdIKvUCarLmgbBIYr3PesH/UPaASISedCN2FVboJO8D2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=YRZOO0yd; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="YRZOO0yd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=FI
	ECsLjOcFQ4t6j1nI62wLXm7hufJJ5ekbHLc3/zpck=; b=YRZOO0ydDBW69njRGY
	i72odduzj/kBXY3UjVmE12Y/HVkUzkv6i0HbItjmIN9nNpy8Zq88417ZmcgzFySx
	k32Oys9K8tYfL0uLw4tgWee5YWaOgtLi75uR3eVWoT0CKSNKZ5P1KE2biH46dA7a
	E1YDqEUmmfRCbnl1AkArUP8+I=
Received: from localhost (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wDX5yYOyH5qLnA+Ng--.54207S3;
	Fri, 14 Aug 2026 15:47:29 +0800 (CST)
From: mambaxin@163.com
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeelb@google.com,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	david@redhat.com,
	v-songbaohua@oppo.com,
	hughd@google.com,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	jose.fernandez@linux.dev,
	stable@vger.kernel.org,
	syzbot+e12bd9ca48157add237a@syzkaller.appspotmail.com,
	Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Kairui Song <ryncsn@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Sasha Levin <sashal@kernel.org>,
	chenxin <chenxinxin@xiaomi.com>
Subject: [PATCH] mm: swap_cgroup: fix NULL deref in lookup_swap_cgroup_id on swapless host
Date: Fri, 14 Aug 2026 15:47:06 +0800
Message-ID: <20260814074705.939721-2-mambaxin@163.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDX5yYOyH5qLnA+Ng--.54207S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxZFy3JF4rGr17Cw1fAr17trb_yoW5ur45pF
	95WFnIgryUGr97Kw40ya40ga48ua1rWr47JrWvk3WY9a13Jr15WryI9F1UWryqvanI9Fyj
	qFnIyw1xKw1jvFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jShFxUUUUU=
X-CM-SenderInfo: xpdputx0lqqiywtou0bp/xtbCwhFwemp+yBGO2AAA3C

From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>

[ Upstream commit 63b02a9409cb5180398491b093e48bcb5315f5fb ]

lookup_swap_cgroup_id() passes swap_cgroup_ctrl[type].map to
__swap_cgroup_id_lookup() without checking that the type was ever
registered via swap_cgroup_swapon().  On a swapless host every ctrl->map
is NULL, so __swap_cgroup_id_lookup() dereferences NULL + a scaled
swp_offset().

Since commit bea67dcc5eea ("mm: attempt to batch free swap entries for
zap_pte_range()"), zap_pte_range() -> swap_pte_batch() calls
lookup_swap_cgroup_id() on any non-present, non-none PTE that decodes as a
real swap entry, without first validating it against swap_info[].  A
single PTE corrupted into a type-0 swap entry takes the host down at
process exit.

We hit this in production on a swapless 6.12.58 host: ~1s of
"get_swap_device: Bad swap file entry 3f800204222bb" (do_swap_page() being
correctly defensive about the same entry) followed by

  BUG: unable to handle page fault for address: 000003f800204220
  RIP: 0010:lookup_swap_cgroup_id+0x2b/0x60
  Call Trace:
   swap_pte_batch+0xbf/0x230
   zap_pte_range+0x4c8/0x780
   unmap_page_range+0x190/0x3e0
   exit_mmap+0xd9/0x3c0
   do_exit+0x20c/0x4b0

syzbot has reported the identical stack.

The source of the PTE corruption is a separate bug; this change makes the
teardown path as robust as the fault path already is.  Every other caller
of lookup_swap_cgroup_id() is downstream of a get_swap_device() that has
already validated the entry, so the new branch is cold.

Link: https://lore.kernel.org/20260504-swap-cgroup-fix-7-0-v1-1-f53ff41ee553@linux.dev
Fixes: bea67dcc5eea ("mm: attempt to batch free swap entries for zap_pte_range()")
Signed-off-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
Reported-by: syzbot+e12bd9ca48157add237a@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/69859728.050a0220.3b3015.0033.GAE@google.com
Assisted-by: Claude:unspecified
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: chenxin <chenxinxin@xiaomi.com>
---
 mm/swap_cgroup.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/swap_cgroup.c b/mm/swap_cgroup.c
index db6c4a26cf59..2d0425f4a6b9 100644
--- a/mm/swap_cgroup.c
+++ b/mm/swap_cgroup.c
@@ -161,6 +161,11 @@ unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id,
  */
 unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
 {
+	struct swap_cgroup_ctrl *ctrl;
+
+	ctrl = &swap_cgroup_ctrl[swp_type(ent)];
+	if (unlikely(!ctrl->map))
+		return 0;
 	return lookup_swap_cgroup(ent, NULL)->id;
 }
 
-- 
2.50.1

