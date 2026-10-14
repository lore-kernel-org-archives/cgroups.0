Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4462931FB;
	Wed, 14 Oct 2026 05:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791955427; cv=none; b=SPOnzgXn9u0mW6QcfOIIWNSJ4Cxl4buGM9fDw/FOK2Ob0qEdhSDj5+H6XZKIeLjWp+4Sk6YpWYeB0xqEDXZNDSBIq2yMPIu5lIIvxOFKqjiAYhho6UC40dxm/8dkA0ewKeunxh0hmV7A2ZOFpuD+Urln6L0GECKsByWwdOcW9aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791955427; c=relaxed/simple;
	bh=4xzljaoL3zgY9ToiX0DtctuAz0Su3Z7YnVQTIWv8yDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPaIZu3ul4OQj005TXjU3vAMaKEFIMR9RO345i027wJPNO3nafbkI4XORfe+lAXMHnMKelnRKeuT88/eEA1S5D56HPqWUtFzdrvQPUjX2CtkFLUDzaHuLpB7A4WN4N3iRS/doxki3nLdnVg8WaaQWppGbm4hT+QKa7ormjItaho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IFFOjUFY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IFFOjUFY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27301F00898;
	Wed, 14 Oct 2026 05:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791955424;
	bh=Fxsf/nP5SXEDzQE941HiSMs2LYMrqlNVsr3+X2+Gtj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IFFOjUFYtKfiXQRi+/4VGn8Cho3PFcrjt/KLhzAkEOul4ZhDMTbBc8/8jnakxDy6g
	 u53u66hNQWsQXxC1bFiGsUWo6mjwcEkvdeUGeLlyvEMAUs9PbN2psfT88MDLt4ZXJN
	 m3e9Ffg2r9ivSVzyurM4Qn00rgI8ldjMXoiOVLn/Hriu8HOarpxNStEcgXVFObFOvh
	 3CcmRi90wHUY5mqzDStkVnK9Lo+902pPPVBfTub5HgiqkrBy8CsqLp5b8uuE9pa9Gu
	 Eq2BIWK8KoH40ON8I/joRIBlLtboMK+UzRp9S53IB0mEe4VtuhneFrf5nl/ZGU9vdN
	 aqLaVe7bG3hzg==
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	Pedro Falcato <pfalcato@suse.de>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	linux-hardening@vger.kernel.org,
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 2/2] ipc, msg: Account msg_msg allocations with GFP_KERNEL_ACCOUNT again
Date: Tue, 13 Oct 2026 22:23:43 -0700
Message-ID: <20261014052344.384723-2-kees@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261014052338.nothing.279-kees@kernel.org>
References: <20261014052338.nothing.279-kees@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1410; i=kees@kernel.org; h=from:subject; bh=4xzljaoL3zgY9ToiX0DtctuAz0Su3Z7YnVQTIWv8yDY=; b=owGbwMvMwCVmps19z/KJym7G02pJDFnnBe8Zz9wX0td0zKxNvuJQ18PvdSY7ejrT1y0uYhF9J TVtZ2toRykLgxgXg6yYIkuQnXuci8fb9nD3uYowc1iZQIYwcHEKwETEFjMynMs8c+Nvx2Hl0t/P 8gIqCgKaxXOWq/M9bfQx2530uDvKjuF//Wo+9ZN8JyZJOJi8ab8Zc+SDRPyGx9NvFZTPFJQoX8L NDQA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Since commit 734bbc1c97ea7 ("ipc, msg: Use dedicated slab buckets for
alloc_msg()"), alloc_msg() allocates with GFP_KERNEL, and a msg_msg is
accounted only through SLAB_ACCOUNT on its bucket caches. With
CONFIG_SLAB_BUCKETS=n, kmem_buckets_create() creates no caches and
kmem_buckets_alloc() is a GFP_KERNEL kmalloc() from the general caches,
which do not account it; the same happens when kmem_buckets_create()
fails. Either way, the allocation is not charged to the sender's memory
cgroup.

Allocate with GFP_KERNEL_ACCOUNT again, as before that commit, so the
allocation is charged whichever cache serves it.

Build tested ARCH=x86_64 defconfig with GCC 16.2.0, with
CONFIG_SLAB_BUCKETS as y and n.

Fixes: 734bbc1c97ea7 ("ipc, msg: Use dedicated slab buckets for alloc_msg()")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
---
 ipc/msgutil.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ipc/msgutil.c b/ipc/msgutil.c
index e28f0cecb2ec..12663a40e9ae 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -58,7 +58,8 @@ static struct msg_msg *alloc_msg(size_t len)
 	size_t alen;
 
 	alen = min(len, DATALEN_MSG);
-	msg = kmem_buckets_alloc(msg_buckets, sizeof(*msg) + alen, GFP_KERNEL);
+	msg = kmem_buckets_alloc(msg_buckets, sizeof(*msg) + alen,
+				 GFP_KERNEL_ACCOUNT);
 	if (msg == NULL)
 		return NULL;
 
-- 
2.55.0

