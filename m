Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794755409;
	b=vhvMwskds6oj7z+CC9og5pNxsp0/Ad/UKFhIGn5KVCJi9eqvFfvxFe7x/9L4JnXsloIQ
	 2LHqueNcPFP/bVUOq8MMKkg3lkdNo4YNJnRriVKdQBlQYPOnrF4wTsvzHiHoG4btTbwL0
	 /5k4n9wYgiATWmCLGvyw9GUmEOGNAqqLHMbrfIy+lNuYvPqIbLaVoYk5pnbV175pFRFyV
	 0MP22MQt0t328sTKg0fEGnDPAKAsH493awIjYpyz6zyTFatKB8Ax+LsXVCINyVngv48v3
	 JZrLyQbMdwtp/gsDB3NnFKLSRc4fovGf1Ov7cITt8YMQh+EoI4jzMvZ1XlEuBUSsjOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794755409;
	h=Received:DKIM-Signature:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer;
	bh=TEWHh130R00cWzrxjI9RLEu/jO2W72gxEB0EEQ477+k=;
	b=f413v2llTw0zdaGHj41ekJvWeNvFz+f3OLOqeeFVgOyw4MFwfgksv7O0GQipFatPszBq
	 g4tEVQUZGvcXXHTHRaprVPLAqCcrUh3NMf1twNrIRQnA67Ipjcjt2P5/rm7YXWwE5YNbi
	 qBJ/pKxKddvAiRGfGn+Y5iMDip/BDnbAu7KYSuZ/y8sxlNGyFaqGDlLi5IuAAP8pXgvra
	 bgmi6PLvBjN9SriJw7VW1G33OrGkBROCci2bjmb9qB+TqHjGArsVWRYtf0FKvXtobZ9mG
	 OuR9SALB9cqlg4FEHjqveJBn0LHYItNd1Wj8ufn4wU2/Osf7N1B91muPZ8Bjra8tSxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="aKItX/9j";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B18606A31E;
	Sun, 15 Nov 2026 15:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aKItX/9j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA8C1F000C4;
	Sun, 15 Nov 2026 15:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794755408;
	bh=TEWHh130R00cWzrxjI9RLEu/jO2W72gxEB0EEQ477+k=;
	h=From:Subject:Date:To:Cc;
	b=aKItX/9j+oVOU25ty1qIp8xqlkd6ee+UQZ/Hbo8gOignltDgBFfX+79NazSakEtlI
	 UqTDY2DS6PduyUCmZxJCcfWchi4Jv6L+HhN78+jpAg0UJsQkqWeLk3Q3PFHS7rn1mw
	 +J6OGK1IWx0joXcH/Cm2DLslBex/W8Nfez8RvaMp6Q7z56cFOvZ0fIsaDNDq0m+S2Y
	 /SzwDZ105uTbgoU7SnKw3pdwpF+G/xAU6dINP3YYyITYbFIiACIvgTr3jFCtStiDPD
	 Ndvb9m4F4mAvLJ539KxbojNq8GAn4wO0BDv0JI9B+sYxPGsccB6hHq6N4c86dvPXTj
	 vjUk+44fTSmQQ==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Subject: [PATCH for-next v3 0/7] memcg,slab: kmalloc_nolock() fixes
Date: Sun, 15 Nov 2026 15:09:34 +0000
Message-Id: <20261115-kmalloc-nolock-fixes-v3-0-9034dd4ecaab@kernel.org>
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
X-B4-Tracking: v=1; b=H4sIAC/L+WoC/22OzQ6CMBCEX4Xs2TX9wVY8+R6GA9YFKtCaFgmG8
 O4WvHqZZDL7zewCkYKlCJdsgUCTjda7ZOQhA9NWriG0j+RBMKGYEjl2Q9X33qDzSTus7UwRTaG
 VPklx1lpCQl+B9iCRN6h9QEfzCOUvie/7k8y4tW63rY2jD5/9g0nsxDbGOZP/xyaBDHnBlTY15
 VoX146Co/7oQwPluq5f18yaCdUAAAA=
X-Change-ID: 20260624-kmalloc-nolock-fixes-c97675328773
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry@kernel.org>, 
 Alexei Starovoitov <ast@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: kernel-team@meta.com, cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
 Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.16.0

This patchset fixes three kmalloc_nolock() bugs.

1. obj_cgroup_put() takes spinlocks in the release path when it drops
   the last reference, but it can be called from any context.

2. A spinlock may be taken in the following path and may lead
   to deadlock:

   kmalloc_nolock()
   -> slab_post_alloc_hook()
   -> memcg_slab_post_alloc_hook()
   -> memcg_alloc_abort_single().

3. irq_work_sync() is called without synchronization for rcuwait
   (on PREEMPT_RT or some architectures), potentially causing a
   hang.

Bug 1 was reported by lockdep, and bugs 2 [1] and 3 [2] were
reported by Sashiko.

This series fixes the bugs by:
- 1. Deferring obj_cgroup_release() to an irq work.
- 2. Making slab_free_hook() and memcg_alloc_abort_single() respect
     SLAB_*_NOLOCK
- 3. Serializing irq_work_sync() with a mutex

Patch 1, 4, 5 are bugfixes and others are refactoring and cleanup
patches.

Changes in v3
=============

- Rebased onto the latest slab/for-next.

- New patches and changes to existing patches were written and
  verified with AI assistance and carefully reviewed by Harry Yoo.

- Patch 1: added Vlastimil's Reviewed-by (thanks!).

- Patch 2 (new): pass free_flags to slab_free_hook() instead of adding
  a third bool, as suggested by Vlastimil.

- Patch 3 (patch 2 in v2):
  - Now handles SLAB_FREE_NOLOCK in free_flags, so callers no longer
    need the allow_spin local variables.
  - Updated the subject accordingly.
  - Addressed v2 review comments from Vlastimil (thanks!):
    - dropped the memcg_alloc_abort_single() functional change from
      the changelog, as it does not change until patch 4.

- Patch 4 (patch 4 in v2):
  - Try freeing the object to the percpu sheaves first in both
    contexts, as suggested by Alexei and Vlastimil. Dropped Vlastimil's
    Reviewed-by accordingly.
  - memcg_alloc_abort_single() now takes alloc_flags instead of a bool
    allow_spin, and converts them with a new to_free_flags() helper.

- Patch 5 (patch 5 in v2): added Vlastimil's Acked-by.

- Patch 6 (new): Make free_to_pcs() call can_free_to_pcs() and take
  free_flags instead of allow_spin.

- Patch 7 (patch 3 in v2): moved to the end of the series, after the
  fixes. Reworded the comment.

- Link to v2: https://lore.kernel.org/20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org

[1] https://sashiko.dev/#/patchset/20260610-slab_alloc_flags-v2-0-7190909db118%40kernel.org?part=9
[2] https://sashiko.dev/#/patchset/20260615-kfree_rcu_nolock-v3-0-70a54f3775bb%40kernel.org?part=5

---
Harry Yoo (Meta) (7):
      mm/memcontrol: defer obj_cgroup_release() to irq_work
      mm/slab: pass free_flags to slab_free_hook()
      mm/slab: handle SLAB_FREE_NOLOCK in slab_free_hook() instead of open coding
      mm/slab: fix a deadlock in memcg_alloc_abort_single()
      mm/slab: serialize deferred_work_barrier()
      mm/slab: refactor free_to_pcs()
      mm/slab: call debug_locks and KCSAN checks in kfree_nolock()

 include/linux/memcontrol.h |   2 +
 mm/memcontrol.c            |  27 ++++-
 mm/slab.h                  |  14 ++-
 mm/slub.c                  | 247 ++++++++++++++++++++++++++-------------------
 4 files changed, 180 insertions(+), 110 deletions(-)
---
base-commit: a7cdd0af963a420fc0e6f20b7c8bc8d4784098db
change-id: 20260624-kmalloc-nolock-fixes-c97675328773

Best regards,
--  
Cheers,
Harry / Hyeonggon

