Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5EB3A9D9C;
	Tue,  6 Oct 2026 09:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791278437; cv=none; b=hjRi5Ok2vJbZ8qDtVSShsgTSe9AI9g6Z6R+YEEbOlhDWE4dtEiI4wUkD9pT7GQvWasC1v1kc7LP6CxwtB3Uuybne4BaWidQ6DwyQaSUayG4gUuRf/ioJeR+PvLelJvsQMu+GsRG+xx3ec/4p76pwxLEC1I6273fSZ27cRsWx2co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791278437; c=relaxed/simple;
	bh=Tp8/qFUjEWwmLfgAKlPf3+uMGFYcGpgvjcTyJ+Rn3GA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPRYDllRQDpFvcC3FdSCcL7Nw5oR4Qgj0t7s1jSkeZzd3faML1Je8Tw6wC4bvttyIJXc7bA8jE05Z+7b2WNJu6FY1Byurq/09GjvuGbiIhTVukaW9eHAdh7c5FzCGf8vKVy+7mW60EtFfEvUAdn8oIvaQbvyHgOOsrBdEhiwVOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eNjDfRF9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eNjDfRF9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CDFB1F00898;
	Tue,  6 Oct 2026 09:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791278436;
	bh=ccnT8loHlbzY6gKdlIsiOUq8nG1NhEaTYWMJqGNG+Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eNjDfRF9MjDY8pC4+kVmQa56taS4A/Mks1cpkxJnt2eStLBin7XHBaqwR+h8+70XL
	 gBBZFINQKmk7CBTSc4eXm4iLsxBJg/Pie0SI4i5JpWYMlWzIshznz2BuI8lD/iwtrc
	 e7SH5BEDRCckE9rqxQf7fwbR0Q7HsyUSWCitHpJiiGd45W+OrZQE8AgYSGu1VkcqoG
	 /If8s1fsVircgS13m2yPJiL80IjDUAqFoOWE3Q1TSF2y9Ixs0GFqyo33s4QwzblVds
	 P3jsDmAlhGh5m6VYP7QPnqtbRuPfPtsbT5Ye1/VjxD/H21xguBhl3wdAFBa9fFfRY/
	 Ef1eaoE9uZnOA==
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
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v6 2/8] ipc, msg: Account msg_msg allocations with GFP_KERNEL_ACCOUNT again
Date: Tue,  6 Oct 2026 02:20:28 -0700
Message-ID: <20261006092035.166776-2-kees@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006092030.got.500-kees@kernel.org>
References: <20261006092030.got.500-kees@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1765; i=kees@kernel.org; h=from:subject; bh=Tp8/qFUjEWwmLfgAKlPf3+uMGFYcGpgvjcTyJ+Rn3GA=; b=owGbwMvMwCVmps19z/KJym7G02pJDFlH9san2Z67WWLIEbElYQrLwT+f4ucfDn3AK/JGfX7CB xPei/dbOkpZGMS4GGTFFFmC7NzjXDzetoe7z1WEmcPKBDKEgYtTACby04HhF7NPzR7pnoLNpUZq eziev9U8t9zjVbfapYUfJkzxOb6F5SUjw/X8Wax7yh8xnmPMWqsho7Jzcke0aNvTS5dStju3nDj UyQ0A
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

Allocate with GFP_KERNEL_ACCOUNT again, as before that commit. Memcg
charges such an allocation in whichever cache serves it, so drop the
SLAB_ACCOUNT, which no longer adds anything.

Build tested ARCH=x86_64 defconfig with GCC 16.2.0, with
CONFIG_SLAB_BUCKETS as y and n.

Fixes: 734bbc1c97ea7 ("ipc, msg: Use dedicated slab buckets for alloc_msg()")
Assisted-by: LLM
Signed-off-by: Kees Cook <kees@kernel.org>
---
 ipc/msgutil.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/ipc/msgutil.c b/ipc/msgutil.c
index e28f0cecb2ec..1ba8e59cb255 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -43,7 +43,7 @@ static kmem_buckets *msg_buckets __ro_after_init;
 
 static int __init init_msg_buckets(void)
 {
-	msg_buckets = kmem_buckets_create("msg_msg", SLAB_ACCOUNT,
+	msg_buckets = kmem_buckets_create("msg_msg", 0,
 					  sizeof(struct msg_msg),
 					  DATALEN_MSG, NULL);
 
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

