Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099540;
	b=YY0XM7FIDJpqCPHkZoKv3Ytc3HyxYZRNhq2LqI1wS5IpPFyXwLcn7iOY4GyGZJUtms5F
	 7BgPkZOfrFYP3Bp8crTPvTBHIWyPb0prLqV8LmrytCm4mDlnPTKDJfmOAcmvZfYCSU35F
	 0fF2ulSVo0mGoRwpGDWrVAmZIuSv8g7RozCGYGpgxWsnOzIjE75fdRkaRxv6dieapXGf0
	 yAfnbsWjblhWgnI5F0Xr9GqU2KH6rstDAtrIO5fATeO+++w16Wmd4frDIVzXgVusqUMeH
	 vjsberOUyofkDY2P2Ocne7q1e1K18Y2F7lbxmp7C9vH8ro1NMwY5TERBjmDSmTGv6gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099540;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:Content-Language:To:Cc:References:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=H8uICizL3IgafjzWKTuprSU0wxvSh9HNohm4+JHjmeg=;
	b=akFUMPdJyPo6dwc+/Ysz2GYzvp7+t9bGYY3fI/NUw9BBTbZfqcYojKMe5fpZuxvMaNpd
	 1c2etoOQQFv3LUJFZf0WB41YZUxgGlFrAJIzSb6T6cSUUPYlctuzFJobJLYcA5T/cz8Z2
	 mB8Jcz3rXoZ6YrDxs/2rVYKP650XpxUg64/o+apBHHkc3/3jzp71ltlDOoiCe8EZbVXab
	 3yCwM5Ouv0gIjd5XBH6llC4vO6QjAPIdt59n/xz107JI8sO/lO81yqWi8WWwccNZ5V46K
	 8DoBgZgKPMRCU7VSxZ9p/19BvTbLVzgD5nBolevuFTZUOTLbJvPHITfyLPoG0VAyIEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BmFqUsS1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BD2606A324;
	Thu, 19 Nov 2026 14:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BmFqUsS1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A771F000C6;
	Thu, 19 Nov 2026 14:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795099540;
	bh=H8uICizL3IgafjzWKTuprSU0wxvSh9HNohm4+JHjmeg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BmFqUsS1K85/u592qh1PtGaoBxCTrdXeu/D84dWvDLl0C2mdB/xeE46pJPAjzpCrt
	 gqbs7MaYOgX9KT5Kk6Qah4Dd950tZgPHpKvfOyHerUAiI2dH9khMsXeviq0MbyQ65m
	 3897BIe9Sv1KTlAmt7jPbuFfKV9Ybhw6/taafNDmJvm10/Q/51KoWp9nFKrs7XZEbH
	 hH84pvCmMX1Ig/YyWs7Baj8L0+3f8ScGt3vjsPyk+Uq+Ce4zHNqlQleF1agQt+y1rq
	 YgPdSeP3QOENgtniLHKqJ4g38sRHkhyEozGrBPnM5iuduaOnk/JRH/l5hyFlXeGbK2
	 cv+ixvtGHxvFg==
Message-ID: <f64021c9-21c2-43c9-a847-c44129d8ca75@kernel.org>
Date: Thu, 19 Nov 2026 15:45:34 +0100
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next v3 0/7] memcg,slab: kmalloc_nolock() fixes
Content-Language: en-US
To: "Harry Yoo (Meta)" <harry@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: kernel-team@meta.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 Sashiko <sashiko-bot@kernel.org>
References: <20261115-kmalloc-nolock-fixes-v3-0-9034dd4ecaab@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261115-kmalloc-nolock-fixes-v3-0-9034dd4ecaab@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/15/26 16:09, Harry Yoo (Meta) wrote:
> This patchset fixes three kmalloc_nolock() bugs.
> 
> 1. obj_cgroup_put() takes spinlocks in the release path when it drops
>    the last reference, but it can be called from any context.
> 
> 2. A spinlock may be taken in the following path and may lead
>    to deadlock:
> 
>    kmalloc_nolock()
>    -> slab_post_alloc_hook()
>    -> memcg_slab_post_alloc_hook()
>    -> memcg_alloc_abort_single().
> 
> 3. irq_work_sync() is called without synchronization for rcuwait
>    (on PREEMPT_RT or some architectures), potentially causing a
>    hang.
> 
> Bug 1 was reported by lockdep, and bugs 2 [1] and 3 [2] were
> reported by Sashiko.
> 
> This series fixes the bugs by:
> - 1. Deferring obj_cgroup_release() to an irq work.
> - 2. Making slab_free_hook() and memcg_alloc_abort_single() respect
>      SLAB_*_NOLOCK
> - 3. Serializing irq_work_sync() with a mutex
> 
> Patch 1, 4, 5 are bugfixes and others are refactoring and cleanup
> patches.
> 
> Changes in v3
> =============
> 
> - Rebased onto the latest slab/for-next.
> 
> - New patches and changes to existing patches were written and
>   verified with AI assistance and carefully reviewed by Harry Yoo.
> 
> - Patch 1: added Vlastimil's Reviewed-by (thanks!).
> 
> - Patch 2 (new): pass free_flags to slab_free_hook() instead of adding
>   a third bool, as suggested by Vlastimil.
> 
> - Patch 3 (patch 2 in v2):
>   - Now handles SLAB_FREE_NOLOCK in free_flags, so callers no longer
>     need the allow_spin local variables.
>   - Updated the subject accordingly.
>   - Addressed v2 review comments from Vlastimil (thanks!):
>     - dropped the memcg_alloc_abort_single() functional change from
>       the changelog, as it does not change until patch 4.
> 
> - Patch 4 (patch 4 in v2):
>   - Try freeing the object to the percpu sheaves first in both
>     contexts, as suggested by Alexei and Vlastimil. Dropped Vlastimil's
>     Reviewed-by accordingly.
>   - memcg_alloc_abort_single() now takes alloc_flags instead of a bool
>     allow_spin, and converts them with a new to_free_flags() helper.
> 
> - Patch 5 (patch 5 in v2): added Vlastimil's Acked-by.
> 
> - Patch 6 (new): Make free_to_pcs() call can_free_to_pcs() and take
>   free_flags instead of allow_spin.
> 
> - Patch 7 (patch 3 in v2): moved to the end of the series, after the
>   fixes. Reworded the comment.
> 
> - Link to v2: https://lore.kernel.org/20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org
> 
> [1] https://sashiko.dev/#/patchset/20260610-slab_alloc_flags-v2-0-7190909db118%40kernel.org?part=9
> [2] https://sashiko.dev/#/patchset/20260615-kfree_rcu_nolock-v3-0-70a54f3775bb%40kernel.org?part=5
> 
> ---
> Harry Yoo (Meta) (7):
>       mm/memcontrol: defer obj_cgroup_release() to irq_work
>       mm/slab: pass free_flags to slab_free_hook()
>       mm/slab: handle SLAB_FREE_NOLOCK in slab_free_hook() instead of open coding
>       mm/slab: fix a deadlock in memcg_alloc_abort_single()
>       mm/slab: serialize deferred_work_barrier()
>       mm/slab: refactor free_to_pcs()
>       mm/slab: call debug_locks and KCSAN checks in kfree_nolock()
> 
>  include/linux/memcontrol.h |   2 +
>  mm/memcontrol.c            |  27 ++++-
>  mm/slab.h                  |  14 ++-
>  mm/slub.c                  | 247 ++++++++++++++++++++++++++-------------------
>  4 files changed, 180 insertions(+), 110 deletions(-)

Merged as slab/for-7.5/kmalloc-nolock

Rebased to
d866d5bafc5e ("Merge tag 'mm-hotfixes-stable-2026-11-17-19-55' of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm")
to avoid conflicts with mainline

Nit for 6/7 resolved locally

> ---
> base-commit: a7cdd0af963a420fc0e6f20b7c8bc8d4784098db
> change-id: 20260624-kmalloc-nolock-fixes-c97675328773
> 
> Best regards,
> --  
> Cheers,
> Harry / Hyeonggon
> 

