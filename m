Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792794205;
	b=iw9LDMGu0MHWbuzVH0wNTi5IGoY3pOdtp9Bv0UcZZZBHcRpegCnjNSShwrrUtOdOLm+5
	 a8WsSUvcqVJxcPHoNix+0eWMwQQaWBDZFq6g6lHXewVdjjFw6Ffq9FiCaq6xYEH7p3t0w
	 DwSTnDZPzZInFCQLfZ5zoBOSMML0i3fszrSFtqaZYmsUOciLzkZOBZ0+yeJLl28AbsytE
	 Wj2GTAg5CVynQ6WRN82R5SN8FQiokdHDVDsCxvh7JC5aj54E1O6GiRp98+ZnFDsHbwOqv
	 y0YCAR12uuz9KQ4Q4q90gb0NYDVE1aqR7qwwYDjqB5G0+ldVeEF2cGUuFa4aaYWiJeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792794205;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=m7KKbTD6zkxGWQDQagVs7cuoj2KRJ/Aw4DV65L9A76w=;
	b=4NU7zy+ujkvl76OzHzCGVq4Nh4Ms1ZUTX4yi8mEJSid5VJtsyRw/jdC17YSyj7qwWo9E
	 efUoG4Le07VELDEw2MqpGhIFyIQw/RdQ9N7LOlWFa0zgTrHJ84SCduT2gj3tljzLeEpM1
	 zwv5oXsmn7+k5o96IK2qSWBAXx2BpOXzJtIvZVtpyciw7pQRO9Hx4O2qZOlb/JuNT0ltL
	 Zzy3hPfC4jyPfFUKB4vYYdgtOyCjJtQf/QWhsFjhtI6i6jvw4EaOMm9R4h0WAZ01i8S5/
	 Lf9BiI4OQYNJeLDXNiYJoDXVzljE3FEsKC44OkoXmDuZ8jt9HhW0Xvvn1Ix50T0gpkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--tjmercier.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=um+biKSq;
	arc=none smtp.remote-ip=209.85.210.200
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11D2606A31B
	for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 22:23:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C11D2606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tjmercier.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=um+biKSq
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8a0589ff620so1025228b3a.1
        for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 15:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792794204; x=1793399004; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=m7KKbTD6zkxGWQDQagVs7cuoj2KRJ/Aw4DV65L9A76w=;
        b=um+biKSqbEf/5Pc8OicqQEuWwC4h9z+U66oOoqS6SECLfWMufJ5OBLqzgXTJRrIKzV
         F7C7KhCaBzSGIqDoKg+qbtGDjDcULbSAt9qDi218OqK6cDbeWPNukmJFpgNy0F+DWDTk
         Pt1Mef/Sj1HKyXMiZp+MLMNmkZcNF8XUSrJibv6ZeDRrlRY3T9REWJ/ExKlsUuDeOaxw
         +oB2x6XmtggVbcPy87IoQcWcZ6rnmrh0tGpR8VJ1XJfNBhpoGN7cewEtfknBCuneMtsN
         yKH3/VyTTOE7X3GXfyoDQRi8qYHVWQtqgB/5WSDBBUkzzP+mxVCwPDW6gpkC9+N7uaCA
         XTZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792794204; x=1793399004;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m7KKbTD6zkxGWQDQagVs7cuoj2KRJ/Aw4DV65L9A76w=;
        b=RAh04q89th4NaBErbHZNOFTGhJSqm5Lq+8LVZ76y8IaQvGCuhtwnDt6DX5nidSrv7/
         RIAn3ihA1lafP5hHmuik5+EXqvvdCl8bYmOwSWwMPYq5vt9Dwvx7FEXiz2oJn9i3kF8d
         rRYY/5+2uhBOAI7OCZlcm+jx0GLDMwpcPd9dlZ+Nov41YeSr5PrBJlHoOieimuQHlnYX
         tTZFBSJmXjaAQDRA8eSaNyI+KHHWTGVQb5lhoZ/nFbGM9mWFXudCspKZDYE9OAb+QIu1
         DlqPX8GXgWSfjXMs33P7Y6ew6j+bQDurYCZhalEOm4cR4o9MKXai6Fv2GPvhtcWe2IUp
         ipWQ==
X-Forwarded-Encrypted: i=1; AKwUvBwb9mKYj3ZmFLYVE48fcjEgLH565ZSbKy1rirw0EJZGyqkxnGdwu52C6XEcZbQBrNic2JsIdeTk@vger.kernel.org
X-Gm-Message-State: AFq9FYKds6EEMNaNZMt1FLLXQgBY58iTpUodXSXBOIzlkQf1SSV3k1EG
	/rDjPc/oXLf/UxuCKBTvAEuKnmlL719hsUG706tPX0rp53nOk8C51aqstFUHkfGd7csJFBinJDj
	40uN5sNqaTw+9Pp/Weg==
X-Received: from pgby12-n2.prod.google.com ([2002:a05:6a02:650c:20b0:cc7:aab6:f8a6])
 (user=tjmercier job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:7789:b0:3e2:8fdc:a6c4 with SMTP id adf61e73a8af0-3e7bfa57360mr294406637.31.1792794203997;
 Fri, 23 Oct 2026 15:23:23 -0700 (PDT)
Date: Fri, 23 Oct 2026 15:23:13 -0700
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261023222313.3979455-1-tjmercier@google.com>
Subject: [PATCH] mm: memcontrol: fix NULL pointer deref in high_work_func() on
 dying memcg
From: "T.J. Mercier" <tjmercier@google.com>
To: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev
Cc: zhengqi.arch@bytedance.com, akpm@linux-foundation.org, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, "T.J. Mercier" <tjmercier@google.com>
Content-Type: text/plain; charset="UTF-8"

When memory.high is exceeded in non-task context, try_charge_memcg()
schedules memcg->high_work without taking a CSS reference on the memcg,
and high_work_func() invokes reclaim_high() without pinning the memcg.

Before commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
dying memory cgroup for LRU folios"), memory usage above memory.high
kept the memcg's refcount non-zero. With reparenting, folios and objcgs
charged to a child memcg are reparented to its parent in
mem_cgroup_css_offline(), leaving the offlined child's memory usage
permanently above its memory.high even after its last reference is
dropped.

cancel_work_sync(&memcg->high_work) only runs at the end of teardown in
mem_cgroup_css_free(), so high_work_func() can start or still be running
reclaim_high() after mem_cgroup_css_released() or shrink_many() has
called lru_gen_release_memcg() and unhashed lruvec->lrugen.list. This
causes lru_gen_rotate_memcg() to dereference a NULL pprev pointer.

Fix this by acquiring a reference with css_tryget_online() in
high_work_func() before calling reclaim_high(), and by resetting
memory.high and swap.high to PAGE_COUNTER_MAX in
mem_cgroup_css_offline() so that charges via references on an offlined
memcg do not trigger high_work on the dead child or skip checking live
ancestors in try_charge_memcg().

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 UID: 0 PID: 27 Comm: kworker/1:0 Tainted: G    B   W           7.3.0-rc5-g2bba28e98578 #284 PREEMPT(full) <- Taint from lru_gen_rotate_memcg() VM_WARN_ON_ONCE
Tainted: [B]=BAD_PAGE, [W]=WARN
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
Workqueue: events high_work_func
RIP: 0010:lru_gen_rotate_memcg+0x1a3/0xe90
Code: fd 7f 09 45 84 ed 0f 85 64 0c 00 00 48 89 cf c6 83 6a 07 00 00 00 48 c1 ef 03 88 83 69 07 00 00 48 b8 00 00 00 00 00 fc ff df <80> 3c 07 00 0f 85 ec 0b 00 00 48 89 31 40 f6 c6 01 0f 85 4e 00
RSP: 0018:ffa00000001ef4c8 EFLAGS: 00010046
RAX: dffffc0000000000 RBX: ff1100000779e440 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ff1100000779b9b0 RDI: 0000000000000000
RBP: ff110000bffd8e40 R08: 0000000000000000 R09: ff1100000779ebb8
R10: ff1100000779ebb0 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: ffa00000001efb30 R15: 0000000000000002
FS:  0000000000000000(0000) GS:ff1100011c0e7000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000251ac88 CR3: 0000000009d6c000 CR4: 0000000000751ef0
PKRU: 55555554
Call Trace:
 <TASK>
 ? read_ctrl_pos+0x22f/0x3f0
 shrink_lruvec+0x16cb/0x1b80
 ? ret_from_fork_asm+0x1a/0x30
 ? lapic_next_event+0x15/0x20
 ? clockevents_program_event+0x2bb/0x6f0
 ? lapic_next_event+0x15/0x20
 ? __pfx_shrink_lruvec+0x10/0x10
 ? __pfx_clockevents_program_event+0x10/0x10
 ? _raw_spin_lock+0x84/0xe0
 ? __pfx__raw_spin_lock+0x10/0x10
 ? kasan_save_stack+0x30/0x50
 ? psi_group_change+0x381/0x740
 ? __pfx_sched_clock_cpu+0x10/0x10
 ? save_fpregs_to_fpstate+0xc4/0x2c0
 ? finish_task_switch.isra.0+0x1de/0xac0
 ? __schedule+0xf62/0x42c0
 ? __pfx___schedule+0x10/0x10
 ? __pfx___irq_work_queue_local+0x10/0x10
 ? shrink_node+0x626/0x31e0
 shrink_node+0x626/0x31e0
 ? ring_buffer_unlock_commit+0x11d/0x5c0
 ? kswapd_clear_hopeless+0xa0/0x150
 ? __pfx_shrink_node+0x10/0x10
 ? 0xffffffffc0000095
 do_try_to_free_pages+0x255/0x13b0
 ? ring_buffer_unlock_commit+0x11d/0x5c0
 ? reclaim_high+0x10a/0x1b0
 try_to_free_mem_cgroup_pages+0x1f9/0x5a0
 ? __pfx_try_to_free_mem_cgroup_pages+0x10/0x10
 ? irqentry_exit+0xc6/0x670
 reclaim_high+0x10a/0x1b0
 ? __pfx_reclaim_high+0x10/0x10
 ? process_one_work+0x5ff/0x1030
 ? __pfx_high_work_func+0x10/0x10
 process_one_work+0x6e2/0x1030
 ? __pfx___schedule+0x10/0x10
 ? __pfx_process_one_work+0x10/0x10
 worker_thread+0x422/0xbb0
 ? __pfx_worker_thread+0x10/0x10
 kthread+0x2cd/0x3a0
 ? recalc_sigpending+0x15c/0x200
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x368/0x590
 ? __pfx_ret_from_fork+0x10/0x10
 ? __switch_to+0x588/0xf50
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Fixes: f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of dying memory cgroup for LRU folios")
Cc: stable@vger.kernel.org
Signed-off-by: T.J. Mercier <tjmercier@google.com>
---
 mm/memcontrol.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a05d9a8baa1b..84f4a8fd4d16 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2457,7 +2457,10 @@ static void high_work_func(struct work_struct *work)
 	struct mem_cgroup *memcg;
 
 	memcg = container_of(work, struct mem_cgroup, high_work);
+	if (!css_tryget_online(&memcg->css))
+		return;
 	reclaim_high(memcg, MEMCG_CHARGE_BATCH, GFP_KERNEL);
+	css_put(&memcg->css);
 }
 
 static void high_irq_work_func(struct irq_work *work)
@@ -4463,6 +4466,8 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 
 	page_counter_set_min(&memcg->memory, 0);
 	page_counter_set_low(&memcg->memory, 0);
+	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
+	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 
 	zswap_memcg_offline_cleanup(memcg);
 

base-commit: 2bba28e98578de622ef307d00875aa8f8bca3d10
-- 
2.56.0.257.gf7497c7d27-goog

