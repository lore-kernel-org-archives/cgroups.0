Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5643451AB;
	Wed, 14 Oct 2026 05:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791955426; cv=none; b=B6Wp3As8Jt7mymrjG5Sr1EntrAof3kwGHxAIU9isaY6PfJJUqjXOzXOkVzcAKlareM9hpXmqrvc9RG/L8SAIwJ8e4L9B//rsaE6PFsBhMgInn9thM6vPggI7gPHtTfjpcQcgw/A6vllLkuHlnQMQTZEBuw7CV8REu+Ckg9S1pjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791955426; c=relaxed/simple;
	bh=FiVZUxotLv/zfGLKYRPLznaaXPZGHAbqigwRAF3TMZc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XVWqaIrag+oOIHW3f95u6YTN0UgpLOFirUz7wfLNTKV5ap43eV+pv+Z7E9S9aRDuUQqnfP6eBZoPmffcXHSUa6Ir2jn6hwWxd8nU9NWV0wMZZ7wZRAsP9KYfoJoKKq5SSo4CHw9qfm0aVZSbWEQgJ2t8jXWVI/VCsdcc8y2y634=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HzpPgRZW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HzpPgRZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40BB1F000FF;
	Wed, 14 Oct 2026 05:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791955424;
	bh=SdSYpehsphW4ohcRgZ6kkg4WkXWb7YZZ4YKMZgeJFUc=;
	h=From:To:Cc:Subject:Date;
	b=HzpPgRZW7EyAIbsLd5GKX0VblZsKb+zJCeaRAKypkv55Evn8jSkn5B8p8tvMMPCm2
	 xijzFZB2nYUOGatSBxl83G3DFQTgROkz4XPHhlcd53XCnLhOPoQSe3lsMl3UIHGqRH
	 2ZvJZeV68clhF4aR3d8Bf+jQjTHmh/QyjoUXBhUoj5Vi3SQq9O6JWQBWA05/qcz5bH
	 UEYeQpJ498tvF8RNUuwUyPFuynOakjljBwcHxWBE8XxkC7jaZdHqWlgEDFW5Y6kAWF
	 96LbKMxnTjB2444qTiNG/IP3UVAw3pIGY19tFhb/pY6yKMkjHByQ7heIdqK6dPpiZZ
	 Jm5+7g/w98v7w==
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Pedro Falcato <pfalcato@suse.de>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH v7 0/2] mm/slab, ipc: kmem_buckets kernel-doc and msg_msg accounting fixes
Date: Tue, 13 Oct 2026 22:23:41 -0700
Message-ID: <20261014052338.nothing.279-kees@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1208; i=kees@kernel.org; h=from:subject:message-id; bh=FiVZUxotLv/zfGLKYRPLznaaXPZGHAbqigwRAF3TMZc=; b=owGbwMvMwCVmps19z/KJym7G02pJDFnnBe/t3nuKReGOt/wEt9naXak37qq3HI+ODmi7oReuV aiRdlSqo5SFQYyLQVZMkSXIzj3OxeNte7j7XEWYOaxMIEMYuDgFYCLzyhkZ3t612Gb3y0vhvGLA 1/iXB8P7TM30HgSt8Rc/dmXnGsbrvgz//dzn6TWkHb2UE33h4A7N65/m50X8+XztvE6mTl1ZUv4 XFgA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Hi!

As Vlastimil suggested[1], these are the first two patches of v6, split
out for 7.4. The rest of the skb buckets series will come back for 7.5.

2/2 now keeps SLAB_ACCOUNT on the msg_msg bucket caches and allocates
with GFP_KERNEL_ACCOUNT as well, so a msg_msg is charged with
CONFIG_SLAB_BUCKETS either way.

Thanks!

-Kees

 v7:
 - split v6's 1/8 and 2/8 out for 7.4; 3/8 to 8/8 will return for 7.5
   (Vlastimil)
 - 2/2: keep SLAB_ACCOUNT in kmem_buckets_create(), and add Cc: stable
   (Vlastimil, Andrew, Harry)
 v6: https://lore.kernel.org/all/20261006092030.got.500-kees@kernel.org/
 v5: https://lore.kernel.org/all/20261002231120.late.500-kees@kernel.org/
 v4: https://lore.kernel.org/all/20260921075811.too.775-kees@kernel.org/
 v3: https://lore.kernel.org/all/20260702170728.168755-1-pfalcato@suse.de/

[1] https://lore.kernel.org/all/be34b92e-e82c-4f69-ac9d-b045081ea418@kernel.org/

Kees Cook (2):
  mm/slab: Mark the kmem_buckets_create() context as a Context: section
  ipc, msg: Account msg_msg allocations with GFP_KERNEL_ACCOUNT again

 ipc/msgutil.c    | 3 ++-
 mm/slab_common.c | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

-- 
2.55.0

