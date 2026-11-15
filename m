Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794755431;
	b=vZDkMvhO36JTRQeb5oim6QQNyaTFlrw1mWxxC80cW19GdSRymFxKBjTcQbDz+9iJkE/g
	 QmkSAS82zoZd24fLeMKrI0DtEYSlUAsO+/Y6GnnhKHnUHtufS4OKKvXjk7Awk4KH/L/ni
	 yYAryIF/62wI6GUUPvZ1m2EYAvnJDbIhbwR43O09luGArk3kqvJBxfyBpByiPWO6FFTCl
	 YtJxnGelkv8hsyicpsWOEVuLQmwCslYBbICE3G3Z0JSQuje36v7dMJTQUCjWLJJnqEFML
	 LL5f7/wnIxhahmFYHILRA4FTv1YZ2+ZmuEdXcAR9UEpv0axUXQuQ9Ls/7R2E8o/c0TA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794755431;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer;
	bh=1mnep0cJK8UxwJlHhyxURDjkwq1Z3ct/fIg2aInzknE=;
	b=xs5ICt/vzmuWbyeKCOs6CFoiCX03Q9Lomt7K9smQU7PfuuMWeLQsITPU8O2XEyvZr+PY
	 7SJALigqLp29A1YFRtiQ3Aszp7dffXu7KIT9Cup4lhuzGpqX/h7naIcpl6jEbOxxvQUZo
	 A0WLNkZGcdFSCMX7OfT8zOOhWWy9AiCw4Gf/h59xWiBaYco3FsLEHXRlk/bKqV766MlOa
	 YvtuCS2MFQDT+vjhh6g67WKey1JdLffaeyeKpTtGr6qEGpxJOTZzmb0emGV6Zz4cnYNma
	 iZPetECWmVtlpc13Pae3R6tRvcCZsyOhh2Bmu3U19smkq216DRa1bXDTx6P9qT+5hLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FtUdBuuH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC92606A31D;
	Sun, 15 Nov 2026 15:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FtUdBuuH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BCC01F000C5;
	Sun, 15 Nov 2026 15:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794755430;
	bh=1mnep0cJK8UxwJlHhyxURDjkwq1Z3ct/fIg2aInzknE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FtUdBuuHaa92Dz+pXSozP1VKcdWVFJiIYFyztiRtavfFJ2jgDLXPs+06U44Uii4Z3
	 Yoexr4DgKvxF2v++kXQcOG1ui1QT1o96vNrUKWOBLk6+AVmVZsyzm+PEJeu0yXgjkA
	 4Xno4rFqAonBHNjGCAQMVXMqEF6jUUCvK2sHhIAIn/ePzSFwNvezvCqKlI0779pF6l
	 HiWMgAxOyi5L6cyucPkN8Gvbe0WqaRO0BuTX6wsIz6zWzEcGc5cDO5UUQQ374ycfy6
	 ZdbNcief/YMoIIyTR+dtFBDa6JscZ2ip5pc46TUb9gzvT8AwhrrhR/QFQ/58QKfkmn
	 pJYmLrPO18ABQ==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Sun, 15 Nov 2026 15:09:39 +0000
Subject: [PATCH for-next v3 5/7] mm/slab: serialize deferred_work_barrier()
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
Message-Id: <20261115-kmalloc-nolock-fixes-v3-5-9034dd4ecaab@kernel.org>
References: <20261115-kmalloc-nolock-fixes-v3-0-9034dd4ecaab@kernel.org>
In-Reply-To: <20261115-kmalloc-nolock-fixes-v3-0-9034dd4ecaab@kernel.org>
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
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 mm/slub.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index 8252c0b681cc..aec9fb6e2235 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6617,8 +6617,12 @@ void defer_kfree_rcu(struct kvfree_rcu_head *head)
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

