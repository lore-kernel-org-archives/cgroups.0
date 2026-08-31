Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E18243C06F
	for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 17:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788198539; cv=none; b=cXPH2aFdMB1D0PMS+FC72svX3lGoKkjtY1DF00IXA7U1oxlFdhyP6HkGQz3v7/QBbBXOc5m7Naj0KCj1gD4ulypwy4jAmt82UPAtMa4YqlCc8svfjBBrIlghAnWnU30DDgvlaNIcbLTLaQ7n18hwuVPVhunw6yxywuFiCeKmtoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788198539; c=relaxed/simple;
	bh=tcb54Qnt2GyKPrrk5QtRoEjYtXqxoV0Zul100yL4uUU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c20f/SenEh5qnIqlYnxC/tr+N+MjV+2A8CzhPQjCgfTvDzXNT276jt996sDTEAXL+MDn8r7pcHhwXCL+aZuS1Wy90Esc31l7g+5t/G09P9vpPi/SxkByCY8MyRmRqq5yDWh8u11OoL3LezCTZ3eCCkUYLqTpCtG7vcUe5ay9Rgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dama.to; spf=none smtp.mailfrom=dama.to; dkim=pass (2048-bit key) header.d=dama-to.20251104.gappssmtp.com header.i=@dama-to.20251104.gappssmtp.com header.b=qeY5HF7s; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dama.to
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=dama.to
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dama-to.20251104.gappssmtp.com header.i=@dama-to.20251104.gappssmtp.com header.b="qeY5HF7s"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-38a0c7e841fso51126a91.2
        for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 10:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dama-to.20251104.gappssmtp.com; s=20251104; t=1788198536; x=1788803336; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vU3022IZTIrb8u3t2YTCnTCe+NuA1eT/LdRMgAStZmk=;
        b=qeY5HF7sPN44DqHyjo9hb6XrePRfPGhYb9ab9rlbWj4ntt1aLxZZ4Iczm7WVQoO7LL
         ZRNQk247JwVLFjzHEEZMRleHvL7l1CWF/MrgYn8I6mbSd8TO4r1ul4zO+OyL3NZECVXa
         W8FZSwd7CXLr1sgLzW10sit2rVI2E8fdmNgMOn0Ia0Ow67LNZnHY57qQE6A77TI4lErs
         gNhJ9AivKD4QHER91YRkPyqE/ZBNXPageMaOMWSTZ47wFXZvipCZX5Hmub4eFJjNQ2hB
         S7aYnKIGYRBnCNHI6s9x7oJjS5cA7R1haR7fOsTH5cb1IhAijKFij4YJefl+pRr1K3Nv
         T9kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788198536; x=1788803336;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vU3022IZTIrb8u3t2YTCnTCe+NuA1eT/LdRMgAStZmk=;
        b=Id84rYUwb5ZjsRU3hUGDZFmbTIChtgXw1eZU0SEX99U+ipgfoU/cm1Tef6I/Yxm4qH
         6/rbMmZvO/BLVsb67mXiF8l+yZ6EZDJOptEn88zg9HTP9FNnnk8QNcJ/U2ZIEQRkZKOE
         RdXJHJO7MpXsXSGcvYt65dN5nmVNbSlm2SsTq/NC1HF2XjC0tX4DCn/uq1KFLSgdCzW1
         zO5jIuBy1gSjmvtIn4Wjpa0IMgIt3lAScTR7zP7v3CPDFuwoyJcSp4ame8ITJLMz3PbM
         IMhzPS4bNr9dFcztIYoTtokNKeSm+Kh99dpFXEHJG4tqDtBY39ICeT9G4eHiuVhYbK10
         884A==
X-Forwarded-Encrypted: i=1; AKwUvBzG5DTrgqXsbDAeGFQWP+YrgrVC6TFiiQKJmqmo3n61SjgYLDlg5viaOjvteHnvGoZWCPucEkBv@vger.kernel.org
X-Gm-Message-State: AFuF++kBl6XpBWUyZhFnyGJJcpUt7kkQIoahimUTOhVReOmAPB/rjh1u
	8NVtN6JQ/+MFJN4aEMwOyzlj1iu7FRDvYMGS5m3/ys4KUhDvnInIaCsz0ebl+QxzUuY=
X-Gm-Gg: AYBFou31I4kobLzhUt2rvPp3PVAVXUh8tP6rA08J3CMr9Je/iSSsX79rTQVWHJNFel4
	I5LnY/L4UjDqoCZPDaiglbZCQXTR3PubQoZnbSC1uH2NoDlOWTIXecs0pN81/l4zjEpBFaPQ1It
	o/VNoLs74No1Au2MzD/qzSGLH+7rb9ZQCO+Z4Z73JWrBZME2JnCTj5oAtV0AShdgmNM1GcIVG1D
	EQKyeP6rXV0Aq0EnEDa17QaAj4N/X8RoJIenh3Oo+OM6seSW7np8qevbR2sDl/vpFVPFbba4sWr
	z6Ed9r0dv2+msOK8ax8sXMesuCSTslzO9W5ebdMD0RASfeTis0Fm+17feCMToxYUjU0V0ZSdXGh
	PrSpKFuIl9to6UR/gYoFX5cLxCR/W/S0M3hayGaaFdkOxFClvTRMF9uxNcjvBpVZXAxyCTcnTSB
	lFVfsfnSOGhXwuL2AuTGkb+I2D2fLHae0q+j0ggWABFPiO9pmkqBTR
X-Received: by 2002:a17:90b:6c7:b0:396:6344:3b63 with SMTP id 98e67ed59e1d1-396d0e25905mr43315795a91.2.1788198536190;
        Mon, 31 Aug 2026 10:48:56 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:54::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3990c40d0c9sm731964a91.7.2026.08.31.10.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 10:48:55 -0700 (PDT)
From: Joe Damato <joe@dama.to>
To: linux-kernel@vger.kernel.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Damato <joe@dama.to>,
	stable@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org
Subject: [PATCH v2] mm: memcontrol: raise MEMCG_MAX for charges that fail without reclaiming
Date: Mon, 31 Aug 2026 10:48:35 -0700
Message-ID: <20260831174836.3102406-1-joe@dama.to>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Charges that exceed memory.max and return through the nomem label can
raise no event and simply return -ENOMEM.

A non-blocking charge can hit the limit, get rejected, but is not
visible in memory.events.

This was noticed in a production setting where bpf_mem_alloc() attempted
to refill its per-cpu freelists, which triggered a non-blocking charge
while at the limit.

Commit d6e103a757fa ("mm: memcontrol: do not miss MEMCG_MAX events for
enforced allocations") added raised_max_event to cover charges that are
force charged without ever reaching reclaim, but charges that are
rejected outright were left out. Getting an allocation failure without
the corresponding MEMCG_MAX event is unexpected and makes debugging and
monitoring harder.

Raise the event on the way out for rejected charges as well, by routing
the -ENOMEM return through the same exit path that already covers forced
charges. The existing behavior of raising a MEMCG_MAX event on every
charge/reclaim/retry iteration is left unchanged.

Tested with a module that performs accounted GFP_NOWAIT page allocations
from a task in a cgroup at its memory.max, and measures the resulting
memory.events:max delta. Without this patch the rejected charges raise
no event at all; with it the delta matches the number of rejected charges
exactly. A GFP_KERNEL|__GFP_NORETRY control, which reaches reclaim, raises
the same two events per failed charge before and after, confirming the
existing charge/reclaim/retry accounting is unchanged.

Fixes: d6e103a757fa ("mm: memcontrol: do not miss MEMCG_MAX events for enforced allocations")
Cc: stable@vger.kernel.org
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Joe Damato <joe@dama.to>
---
v2:
  - v1 raised MEMCG_MAX once, as soon as the charge was known not to fit, which
    collapsed the existing per-iteration events raised while a charge loops
    through reclaim and retry. Instead leave that event where it is and route
    the -ENOMEM return through the same exit path that already covers forced
    charges, so only the rejected-charge case changes, as suggested by Shakeel.
  - Add Fixes tag and CC stable, as suggested by Shakeel.

v1: https://lore.kernel.org/cgroups/20260827233119.411152-1-joe@dama.to/

 mm/memcontrol.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..158b0562e8df 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2656,10 +2656,11 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	bool raised_max_event = false;
 	unsigned long pflags;
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
+	int ret = 0;
 
 retry:
 	if (consume_stock(memcg, nr_pages))
-		return 0;
+		return ret;
 
 	if (!allow_spinning)
 		/* Avoid the refill and flush of the older stock */
@@ -2770,16 +2771,11 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * put the burden of reclaim on regular allocation requests
 	 * and let these go through as privileged allocations.
 	 */
-	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH)))
-		return -ENOMEM;
+	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH))) {
+		ret = -ENOMEM;
+		goto out;
+	}
 force:
-	/*
-	 * If the allocation has to be enforced, don't forget to raise
-	 * a MEMCG_MAX event.
-	 */
-	if (!raised_max_event)
-		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
-
 	/*
 	 * The allocation either can't fail or will lead to more memory
 	 * being freed very soon.  Allow memory usage go over the limit
@@ -2789,7 +2785,15 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (do_memsw_account())
 		page_counter_charge(&memcg->memsw, nr_pages);
 
-	return 0;
+out:
+	/*
+	 * Don't forget to raise a MEMCG_MAX event for forced or rejected
+	 * requests.
+	 */
+	if (!raised_max_event)
+		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
+
+	return ret;
 
 done_restock:
 	if (batch > nr_pages)
@@ -2848,7 +2852,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	    !(current->flags & PF_MEMALLOC) &&
 	    gfpflags_allow_blocking(gfp_mask))
 		__mem_cgroup_handle_over_high(gfp_mask);
-	return 0;
+	return ret;
 }
 
 static inline int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
-- 
2.53.0-Meta

