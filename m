Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9FC367B86;
	Mon, 27 Jul 2026 12:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785156849; cv=none; b=DZycWNw4FYiqdjt6XpO04S4k83ADFk3nlfLFnPfaS/5HzHo30cWEHtz0x46RMJUBHCT4L7FZHTwk0p+GsVnHLLf2mACcQM9/6z425O9hwZcR8gw6lQVY8Bm3pAcIoA6RJjOGRQ3FpJ7kyH8/1mlaMq9hr63Cp9w2pSZGsj2GeuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785156849; c=relaxed/simple;
	bh=voXlQsdNnQ7Hv2FMR6To+pkYh4z0pNUG74KxFNkT5wU=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=W5JFQL/trYRSt1heLaKebfV7fNMcCuXQQXAcer5nGJW75nXMzp8Cv+EoeLkVMa3jBgc3I5jINzhmJKS5qtRAUy0fPH5E37uQ2Vb6ksb0hj6ZVP9Q6NnLvgrOpz+tk75kfGegMZALuQQIpNPx+KpFJHiDajrzFEpyVm+rZ4NIl+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ls8MpmHA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ls8MpmHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548CD1F00A3A;
	Mon, 27 Jul 2026 12:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785156848;
	bh=y9olFz4RC6C1U7zYxBQoZxiDRdf5OldBtN1enHJw5Kc=;
	h=From:Subject:Date:To:Cc;
	b=ls8MpmHAhsKvwNvNa/Q/2fVB4LTcEBCBfbTZKm2UUX2BO7+/BUTL7sNffmT1Ve+nY
	 aeBznRVglidHOLdmOzrmE+NWF3ZmFlV3K14BdaSDfDCGk4lKpIYtOYnK+TlI6+QcU2
	 mB8hFL5MLoflRqpTyupnU5a/1A18lQ/pgZZKbbZQffF04SSTqxmC7KTf7wA4piH2dp
	 9Ml+7RJN7lFQex4koS3qSgxEW/NPz8yzLUOcSFy1QqW2XszJCM8nnanHdeL3o/ROdx
	 PKYNROUsWzXLiUVGTiZ8rFzf9RYVl6zvQwhXYwB6xUk4sOXeEDFiRYgti7leuPhbNT
	 XaxZHjsBTBsqg==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH v3 00/13] mm/slab, alloc_tag: reduce obj_ext memory waste
Date: Mon, 27 Jul 2026 14:53:54 +0200
Message-Id: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOJUZ2oC/2XN0QqCMBgF4FeJXbeYv1Ozq94jIub2qytxsq1hi
 O/eNILCywPnfGciDq1GR067iVgM2mnTx5Dud0S2om+QahUzAQY5KxJOK05NdcfR39zQaU+VOAK
 HHLJCZSSuBou1Hlfxcv1k94wD6RdmabTaeWNf62VIlt5XzzZ6SCijpeCl5FLWXKbnB9oeu4OxD
 Vn4AD8AsC0AEYBaFDKvc6Yq/APmeX4D9bEfMgIBAAA=
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

For 2) it avoids allocating objcg fields for KMALLOC_NORMAL and
KMALLOC_NO_OBJ_EXT caches where we know they are not necessary because
kmalloc() with __GFP_ACCOUNT will pick a KMALLOC_CGROUP type (except
with SLUB_TINY).

The named kmem_caches are tricky. They can be created with SLAB_ACCOUNT
and then we know objcg fields are always needed. But also they can be
created without SLAB_ACCOUNT and then some allocations have
__GFP_ACCOUNT and some not and we don't know that in advance.

This series introduces a SLAB_MAY_ACCOUNT flag that's currently internal
only and is applied to all caches (unless kmem accounting is disabled)
except KMALLOC_NORMAL (unless that aliases KMALLOC_RECLAIM) and
KMALLOC_NO_OBJ_EXT.

As a followup we can make SLAB_MAY_ACCOUNT explicit and add it to to
caches where we know __GFP_ACCOUNT is used. Then we could only honour
__GFP_ACCOUNT for those, while warning for an unexpected usage
elsewhere.

Based on slab/for-next-fixes

Git branch: https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=b4/objext_split

Moderately tested, nothing seems to crash.

To check for regressions, I forward-ported a microbenchmark hacked into
slub_kunit that was used to evaluate sheaves. You can find it here along
with the series:

https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=objext_split-v3-bench

Tried 3 scenarios, MEMCG and KFENCE were always enabled:
- CONFIG_MEM_ALLOC_PROFILING=n
- CONFIG_MEM_ALLOC_PROFILING=y but _ENABLED_BY_DEFAULT=n
- same but booted with sysctl.vm.mem_profiling=1

The results are quite noisy, but no regression was apparent, except
perhaps few percents for the last case. I don't expect it will be
visible in any real workloads.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
Changes in v3:
- Review tags from Harry, Hao, Suren - thanks!
- Patch "skip handle_failed_objexts_alloc() with profiling disabled"
  removed, the check is done as part of "reduce slabobj_ext memory with
  allocation profiling disabled" using slab_obj_ext_has_codetag()
  (Harry).
- Move kfence checks earlier in mark_obj_codetag_empty() in Patch 1
  (Harry).
- Remove SLAB_MAY_ACCOUNT also for KMALLOC_NO_OBJ_EXT caches and more
  precise description in Patch 11 (Hao)
- Add a new cleanup patch 13 that removes also memcg accounting from
  kfence allocations, as suggested by Harry.
- Link to v2: https://patch.msgid.link/20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org

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
      mm/slab, kfence, memcg: completely remove obj_ext for kfence objects

 Documentation/mm/allocation-profiling.rst |   7 ++
 include/linux/memcontrol.h                |  13 --
 include/linux/slab.h                      |   3 +
 mm/kfence/core.c                          |  12 --
 mm/kfence/kfence.h                        |   3 -
 mm/kfence/kfence_test.c                   |   2 +-
 mm/memcontrol.c                           |  40 ++++---
 mm/slab.h                                 | 189 ++++++++++++++++++++++++------
 mm/slab_common.c                          |  26 +++-
 mm/slub.c                                 | 184 ++++++++++++++++++-----------
 10 files changed, 325 insertions(+), 154 deletions(-)
---
base-commit: 5ff172f6c94d282d83cb88bdfec5f647ad9c6105
change-id: 20260714-b4-objext_split-da82426257d5

