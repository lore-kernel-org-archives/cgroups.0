Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D413B8945;
	Mon, 20 Jul 2026 14:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784556990; cv=none; b=B+IeYBytJaSIVgypwojb4aVmyorBI+HiE4OwUXXScArZi9JPxDW8kSpbdsB/LwzFyDsXAG3X+Nb7VG2WtC7wS9cHHODSKVOckoEtL3JYr9KY7XOMkh4IiBb4vNmwOrUQUAwX28mbvSRE3IwtmDffF1fWPkrTHn4PfnTAwalI4sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784556990; c=relaxed/simple;
	bh=q+MpVhAkpfWk/nPkX0gTmbO/YWZfUawz/WF6PvX/Lnw=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=JW7hppxaHShWEuLKPvENnu2weKn1CZeP+1KFwqFfOQNq1RIT9Jt3IxfUeVX0igBm2QfteTVVtamZK/mBvfAsiHQ6JNxJbKHUo8EOFSvoGXJMYt/kiuODCiBvhMnK6ReM9OsK7IRosjawInBkEOBYnO8VPv4skdEZmB6SENyZgwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z6fHflev; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z6fHflev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3C21F00A3F;
	Mon, 20 Jul 2026 14:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784556988;
	bh=rLtF0K+0TYJPvPF55k16nUXQBhEpGr25ARgvZmkoWNY=;
	h=From:Subject:Date:To:Cc;
	b=Z6fHflevYEGSDO7qqj7ml46G/+2s89a916N6PqXn3//NnfakNR9A4HXzSo2WoqySI
	 pf5ukJw+Viacz8Wjh4kGhkseq4taWOBAXzlc1DDo099zbKQXGIotR5FGYyhExXXaeh
	 kE7lvpoFst9pBqyp8d8L/Vr4gUrpk8bNtGjlrIO454uAOXaYPONlhshgu0OGdIUcNW
	 ft36YvRYoMxmj6cvKTNVSzCxmuWDclvz3pTZb8dVBl1l95p6bxXBRhIjFawjqtpS7I
	 bMvaxxtREhRa2uuwXbUmYPR8O9sz53ObNi2PQotO2U6nGFTYhrtdyobDSRQ6Wqf5MV
	 f/UilygrDyMFQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH v2 00/13] mm/slab, alloc_tag: reduce obj_ext memory waste
Date: Mon, 20 Jul 2026 16:16:14 +0200
Message-Id: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAK4tXmoC/2WNwQ6CMBAFf4Xs2RpaC4gn/8MQA2WBVdKStjYYw
 r9bMJ48TjJv3gIOLaGDS7KAxUCOjI4gDgmoodY9Mmojg0hFnhZcskYy0zxw9nc3jeRZW5+FFLn
 IijaDuJosdjTvxVv1ZfeKA+W3zGYM5Lyx7/0y8M371bO/euAsZWUtSyWV6qQ6XZ9oNY5HY3uo1
 nX9AH7vk0jBAAAA
X-Change-ID: 20260714-b4-objext_split-da82426257d5
To: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2

The recent fixes for objext array handling inspired me to look into this
finally. It's been bothering me that the memory usage of struct
slabobj_ext depend only on config options and not whether the fields are
actually used. So with both CONFIG_MEMCG=y and
CONFIG_MEM_ALLOC_PROFILING=y there is always objcg field and codetag_ref
field. And thus:

1) Having memory allocation profiling config-enabled but not
   boot-enabled means wasted memory on unused codetag_refs. This makes
   it less suitable for a general distro config and the page allocator
   side doesn't suffer from this, only slab and percpu.

2) Complementary, with memory allocation profiling enabled, there are
   caches/slabs that don't need the objcg field, so memory is wasted on
   those.

This series should solve the point 1) fully for slab, pcpuobj_ext
handling can be perhaps improved similarly, haven't looked into that.

For 2) it avoids allocating objcg fields for KMALLOC_NORMAL caches where
we know they are not necessary because kmalloc() with __GFP_ACCOUNT will
pick a KMALLOC_CGROUP type.

The named kmem_caches are tricky. They can be created with SLAB_ACCOUNT
and then we know objcg fields are always needed. But also they can be
created without SLAB_ACCOUNT and then some allocations have
__GFP_ACCOUNT and some not and we don't know that in advance.

This series introduces a SLAB_MAY_ACCOUNT flag that's currently internal
only and is applied to all caches (unless kmem accounting is disabled)
except KMALLOC_NORMAL (unless that aliases KMALLOC_RECLAIM).

As a followup we can make SLAB_MAY_ACCOUNT explicit and add it to to
caches where we know __GFP_ACCOUNT is used. Then we could only honour
__GFP_ACCOUNT for those, while warning for an unexpected usage
elsewhere.

Only lightly tested, need to run at least some microbenchmarks to see if
the now somewhat more complicated access to objcg is visible or not.

Based on slab/for-next-fixes

Git branch: https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=b4/objext_split

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
Changes in v2:
- Apply Suren's R-b:, thanks!
- Expanded explanation about no longer accounting KFENCE objects (Suren)
  - Also skip them in in mark_obj_codetag_empty() (sashiko)
- Update slab_obj_ext() comments (sashiko)
- Separate slab_obj_ext_objcg() and slab_obj_ext_set_objcg() (Suren)
- Add SLAB_MAY_ACCOUNT internal flag instead of relying on
  is_kmalloc_normal(); also handle mem_cgroup_kmem_disabled()
  - Also fix the SLUB_TINY kmalloc aliasing handling, per Harry.
- Link to v1: https://patch.msgid.link/20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org

---
Vlastimil Babka (SUSE) (13):
      mm/slab: skip kfence objects in allocation profiling
      mm/slub: skip handle_failed_objexts_alloc() with profiling disabled
      mm/slab: remove objs_per_slab()
      mm: move struct slabobj_ext to mm/slab.h
      mm/slab: make slab_obj_ext() determine object index
      mm/slab: abstract slabobj_ext.objcg access
      mm/slab: abstract slabobj_ext.ref access
      mm/slab: replace slab.stride with obj_exts_in_object
      mm/slab: change struct slabobj_ext to a union
      mm/slab: introduce slab_obj_ext_has_codetag()
      mm/slab: reduce slabobj_ext memory with allocation profiling disabled
      mm/slab: add cache_ and slab_needs_objcg() helpers
      mm/slab: stop allocating objcg pointers when unnecessary

 Documentation/mm/allocation-profiling.rst |   7 ++
 include/linux/memcontrol.h                |  13 ---
 include/linux/slab.h                      |   3 +
 mm/kfence/core.c                          |   5 +-
 mm/kfence/kfence_test.c                   |   2 +-
 mm/memcontrol.c                           |  32 +++---
 mm/slab.h                                 | 185 ++++++++++++++++++++++++------
 mm/slab_common.c                          |  25 +++-
 mm/slub.c                                 | 173 ++++++++++++++++++----------
 9 files changed, 314 insertions(+), 131 deletions(-)
---
base-commit: d9e6a7623938968e3752b67e37eaff097e559a54
change-id: 20260714-b4-objext_split-da82426257d5

