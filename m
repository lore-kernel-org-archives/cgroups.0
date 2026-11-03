Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717304;
	b=a+65OyWaCB+zTWH53p3fFK8yuHzLrqnktAb+02KGPQvrpDw5s9jiN79R7FavSvPK50jR
	 QGlrSgSCC1DK3w2an3WIr5hzYGTrulsBCO2hDsjHLf6rPYqBQVBdi2BRZgIsC7oAcMYbA
	 p+WGEYi2E3czSzR4WijlvvfxvGommW7S8W2edsEh1naio3310QTrrfIBvYP+6AtoMJHye
	 c6N5Yi85zwLpH/eqPCpMFTVdxuNmvx3OTJPJFDDehj/P+ilYWEh5WZQqesL8glS4zQDb9
	 eihFpsQf4LYFLm3JS6LhiFhS1gT1WLqNhI79jACRH37QMsjB8LxsgB2NN+zmr4xvAgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717304;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer;
	bh=wM4ihzCKOLfh0ZD7M58/6B4bo5IJr12GDvSCHj1N144=;
	b=h4I78+IMSpivReL3Rkb7R8qtzUJU4rXCI4aAS+c65nrfmEub6vmEm6bCZ5qRHPfSR9WU
	 CBAHrTXyjrYyNLy3za3as+8Mb+6hov1yDIRG4W49RcpWd7cVhNWPuuMJiaqxQQA5OhmO5
	 yNc5EMpGui3ZbBiVJrgIda+nOsEoNwTzAVCdTAmBzO4OziG+l+LWdZ3wlcVKXUiXeOdW5
	 +/C9uiInfWplwvUSmbf3UtZzD+b+7vNGkRjcwXDsqLD9KknZ7aWAKrbf+gffZK4ZgmedZ
	 Wbcx6xvdnarVTE6/IRpNBDzTI2O2Sw3aPXfrxrMHGETQqbNIQOY1gdQSqr1RlortG4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C2dwqdtU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB5C606B243;
	Tue,  3 Nov 2026 14:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C2dwqdtU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B112A1F00A25;
	Tue,  3 Nov 2026 14:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717304;
	bh=wM4ihzCKOLfh0ZD7M58/6B4bo5IJr12GDvSCHj1N144=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=C2dwqdtUzJs0e/4mAoyZd9elv6kGwKzRzrkZZLnkSLPmb0EBBXF9mz5ki97+BdPpJ
	 XR3t5RyYj6b5JGCnc4iLzpR9PSDADmGNoM5Kd3Q3Z8+mjRreHGdeq4mhUv0XwtD16Z
	 SXlW5JSQnlmhaOFn59oW5j5O3l95kkxXNXhYvLsr1LZcKDf896lWNYyANEtDQKBG+a
	 tv597acbLMufhvpLiQDo3PFyTTKsytOB/N0JBHE5QTcBCta9qmQDVrOlvNxpjHSu4f
	 3PR0956zqC196DuCc1QWbJtDGLpRfklTrrMuglgZiq0FibC8MHKMBVtWmf8Qls7xfR
	 90csUx2uFzarQ==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Tue, 03 Nov 2026 14:47:54 +0000
Subject: [PATCH for-next-fixes v2 5/5] mm/slab: serialize
 deferred_work_barrier()
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
Message-Id: <20261103-kmalloc-nolock-fixes-v2-5-19167cfe4779@kernel.org>
References: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org>
In-Reply-To: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org>
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

irq_work_sync() uses rcuwait instead of busy waiting in two cases:

  1. The kernel is using PREEMPT_RT and the irq work does not run in a
     hardirq context.

  2. The architecture cannot send inter-processor interrupts to make
     busy waiting reasonably short.

However, rcuwait.h says:
> The caller is responsible for locking around rcuwait_wait_event(),
> and [prepare_to/finish]_rcuwait() such that writes to @task are
> properly serialized.

Since deferred_work_barrier() calls irq_work_sync() without any locks,
it can potentially cause a hang as writes to @task are not serialized.

Fix this by serializing deferred_work_barrier() with a dedicated mutex.
We cannot reuse slab_mutex because e.g.) some users of
kvfree_rcu_barrier() are outside mm/.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260615-kfree_rcu_nolock-v3-0-70a54f3775bb%40kernel.org?part=5
Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 mm/slub.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index 6dfa8ca3c937..50e88edcef3a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6636,8 +6636,12 @@ void defer_kfree_rcu(struct kvfree_rcu_head *head)
 /* Must be called before flush_rcu_sheaves_on_cache() */
 void deferred_work_barrier(void)
 {
+	static DEFINE_MUTEX(barrier_mutex);
 	int cpu;
 
+	/* irq_work_sync() may use rcuwait that requires serialization */
+	guard(mutex)(&barrier_mutex);
+
 	for_each_possible_cpu(cpu)
 		irq_work_sync(&per_cpu_ptr(&deferred_percpu_work, cpu)->work);
 }

-- 
2.54.0

