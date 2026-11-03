Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717286;
	b=TjQUwFV8QRzktvLRUdrwc/P1tMMOt9g0SegdJfXo/UXef5H3myE6N8YIsUemjnP3V1hM
	 dwMeK5ZVOFzjkd6wZlzUR+G2RbMgkPfvvH6artqFX+YCqxdMEheJ9xxmn3cVO/DM1i/DL
	 ph6QcJA6lWad/NVvIogciOQgg39/b6IH5LbioZ0Du8aOE/sJRNAX3wwSsJC005nUcZwRM
	 rAierqBG3cbL/v3VQIXbGT1B8vNWJbMCaniYfxK7EJuyV2fhNg96Dgpf47gfOTBey+FVq
	 thgZCjlet0DT3q7JA9Xyu4SNaSYYiTsocySQrhOwQJAPBcqF4Vt6Xrf3VPcKACk2MjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717286;
	h=Received:DKIM-Signature:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer;
	bh=Wcfm4NJTkbtPoo0W4PeJYWfvmalPaASf+2pIVtyvhx8=;
	b=dQ3GzDfyPKggA0a+x9ljslY275ARFxNU46BozFAAVHEZU+sSuyJhdoBVDwkXm6A+zgNZ
	 CghW9tV5D0T36el674+SWq9hW3MtciRRuhCUve6/gW/8a1nfGsz3wMplGljxS9KM0R7xh
	 /twSmwCdj0ZaOH2kLzufAJwZdcgmvpylx8ecHHgEqfYrNUlhrlfJUSJu63LIIUo7Ddz+9
	 fBooGQKb+AIDgtTHQeVyNk4PUD+Pgy57sAFe5grdqIA92Zs22YE6yW/sTLRJA3UJiCzlU
	 E+0xXm7dp2fXCtMXHbnHpjdcUBLtqRPr26HIv02ScohTOWoUXrg0aABwW42+hr+/ziA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=og5bCNnC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A0E60A380C;
	Tue,  3 Nov 2026 14:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=og5bCNnC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478AE1F000C1;
	Tue,  3 Nov 2026 14:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717285;
	bh=Wcfm4NJTkbtPoo0W4PeJYWfvmalPaASf+2pIVtyvhx8=;
	h=From:Subject:Date:To:Cc;
	b=og5bCNnCWypgCWUiGfXpt76OPxMNmpziIPcsV9Zs5WXVFaTldbfNdS4SVH5zwQHNz
	 OjqAfGiEzma5i4WL0gLpzl24H9P8dQavzNaT5aaije6CnIww4V462jcJhFBBVmyTaF
	 l1B+fIXqiY+axDuZBtkIDZMHCO2YItflbVfoiPhhhtNq/3u7V2qvVGQ8SwVaFjvzqs
	 V4aaXA9o8YoZvc8DAtwx9fDkdYbvSQvVOR28KfbxWOdiaOF7qFNDSyyjdTI35uamTm
	 HXE3+ZFWtyerrJw8EwjYQxymxyuwoxsAVAlzc+5WKGI0ivodCEhqOsxeH2g2jQf0W4
	 X2/UXPsn5b30w==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Subject: [PATCH for-next-fixes v2 0/5] memcg,slab: kmalloc_nolock() fixes
Date: Tue, 03 Nov 2026 14:47:49 +0000
Message-Id: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org>
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
X-B4-Tracking: v=1; b=H4sIABX06WoC/yWMwQ6CQAxEf4X0bBNSdBf9FeMB1wIV3DVbNCSEf
 7fCZZKXmTcLKGdhhUuxQOavqKRoQIcCQt/EjlEexkAludLREYdXM44pYEyWA7Yys2I4e+dPFdX
 eV2DqO/NWmHmFNmWMPE/7Fm57r5/7k8P0/4Z1/QFNLHSfiAAAAA==
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

Patch 1 only touches mm/memcontrol.c and no later patche depends on
it, so it can go through to the memcg tree.

Deferring obj_cgroup_release()
==============================

RFC v1 skipped the stock drain in __refill_obj_stock() when spinning is
not allowed. Making sure "obj_cgroup_put() is not called in a restricted
context that doesn't allow spinning." is easy to get wrong.

v2 makes obj_cgroup_release() safe in any context instead (as mentioned
in cover letter of the RFC v1). The release callback only queues the
objcg (llist_add() + irq_work_queue(), both NMI-safe) and the release
runs from irq_work.

This also fixes a performance regression in RFC v1 in a free-heavy
kmalloc_nolock() microbenchmark.

Changes in v2
=============

- Rebased onto the latest slab/for-next-fixes.

- Rebasing the series, writing patch 1 and 5, and verification was
  assisted by AI and carefully reviewed by Harry Yoo.

- Patch 1: replaced with the new approach described above.

- Patch 2:
  - Now introduces the allow_spin local variables itself
    (previously added by the old patch 1).
  - Addressed v1 review comments from Vlastimil (thanks!):
    - restored the blank lines.

- Patch 3 (new): call debug_locks and KCSAN checks in kfree_nolock()
  regardless of allow_spin, as they acquire a spinlock only when
  reporting a bug.

- Patch 5 (patch 4 in v1): Introduce a mutex for
  deferred_work_barrier() as it can no longer reuse slab_mutex. In v1
  the only caller was kmem_cache_destroy(). The barrier is now also
  called from kvfree_rcu_barrier() and friends, which are usable outside
  mm where slab_mutex is not visible. Dropped Vlastimil's Acked-by
  accordingly.

- Dropped the Cc: stable tags to avoid intrusive backports for unlikely
  issues in practice [3].

- Link to v1: https://lore.kernel.org/20260624-kmalloc-nolock-fixes-v1-0-fdf4d17351dd@kernel.org

[1] https://sashiko.dev/#/patchset/20260610-slab_alloc_flags-v2-0-7190909db118%40kernel.org?part=9
[2] https://sashiko.dev/#/patchset/20260615-kfree_rcu_nolock-v3-0-70a54f3775bb%40kernel.org?part=5
[3] https://lore.kernel.org/1816e94b-87e0-4276-8ff7-1fb651326ab3@kernel.org

---
Harry Yoo (Meta) (5):
      mm/memcontrol: defer obj_cgroup_release() to irq_work
      mm/slab: handle allow_spin in slab_free_hook() instead of open coding
      mm/slab: call debug_locks and KCSAN checks in kfree_nolock()
      mm/slab: fix a deadlock in memcg_alloc_abort_single()
      mm/slab: serialize deferred_work_barrier()

 include/linux/memcontrol.h |   2 +
 mm/memcontrol.c            |  27 +++++++++--
 mm/slub.c                  | 112 ++++++++++++++++++++++++++-------------------
 3 files changed, 91 insertions(+), 50 deletions(-)
---
base-commit: 03a176b9248c4513bb705ed3d931af3a7e9c2a08
change-id: 20260624-kmalloc-nolock-fixes-c97675328773

Best regards,
--  
Cheers,
Harry / Hyeonggon

