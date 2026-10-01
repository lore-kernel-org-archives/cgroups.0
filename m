Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BFC3E168C
	for <cgroups@vger.kernel.org>; Thu,  1 Oct 2026 04:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790829740; cv=none; b=ukoB1V5kMfUl6uCVz+96GU77MW3Vf2LryEduDiTwe1wZht74/3TI9NETOrWno9Z4XnxnmEgtQs0tu5wqO6UBZd0lnZ9ftYom+59YUDUaaebTfpZmTtLbaMd6N0zawScnrIoV0YhZvgZT9yONEVB7YuIvHIhAJC+PY1y7Hh9Zp8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790829740; c=relaxed/simple;
	bh=SS7j2Mi3g5GlPry3bUdyss69gJmE53mV446QuvJzBYM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=i2aXL75RBvHaRqN83DO/Nihfc+gZryGuVQJwleaVSD9mqZymuNUn3Pk9m1zMdYz5CbK0CyTIgF/f1IeIAvqNBHVbQTK9gW/uj94TKpmTI/2Ohpn2EvbukaRpA3kAKfaU/a64hCWRVVWLAhl2WVQnw/OtjOg2UoB8/u0F6EM+8lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IWTeAvoA; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IWTeAvoA"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ffed768deso15012145e9.1
        for <cgroups@vger.kernel.org>; Wed, 30 Sep 2026 21:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790829737; x=1791434537; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=a1VMb1gdkAzPRn13HLN7Aa+0FwFU3dz+Af4Wv7wExRg=;
        b=IWTeAvoAJxpZWo5gWWXPhTGXZGjKyzinPbCyh8WkIhAE1IZN2d3IM0DRRSUtd2M481
         PNicrRfD3jw0xzN1lvq/twOaltIi9/c/4ovlN9JAaf81ssUUac9CgsjHy2/0D2Vg5xNr
         DdSrIzpp3FBXy38p7UyM4Fyom/rxabUOxct1aQWC3dATXgwgLvecCCMtKql4L8FJQBet
         b9FQqFutCMY8rDp+pfi1uM1lc++ODeWSPUP1WVCtQTMb8BzlEv6oAckQWUbOJmE4bFrW
         wg8JOHb0+JiT+ibxscn9oKm1dThoOdaSuINrMzYMRhMdAqB0wEGp0BAGC3/Bh24ZJWMo
         SvVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790829737; x=1791434537;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a1VMb1gdkAzPRn13HLN7Aa+0FwFU3dz+Af4Wv7wExRg=;
        b=r+txFriiKelYOXSFjA/6uFIMeinZx9e2ZYwLfikdeCoeipzF8+8oZLyvVcjkMsgYBR
         D5CXligMccR200Q1vuKVSYxowxxeM7HOkTOipTlw+dCMVYLnmotnhDG04+QtkZ77gE6x
         6fg+SZoOlRduu/kLgnIxx8K6sN7m5Q13bFDAI0a4pOiHkfmIVAo43D2RVRoVhaiQDBLv
         34IhxYlsez2kYYxViNFBlKsxXKWo09PJvG7Tz5iwbBD4JZLw/RrZNrLomqhYsQ8JGrL6
         iHV/nnDfMgGbn+F8u91TodpRiacFsWvMtqNf4yUc9bUO6HKDs703UyiE52zqwXwEIHBZ
         om6Q==
X-Forwarded-Encrypted: i=1; AKwUvBxnjl0PpNTy3rsw81tnHdmUcdZD/yDqCE0ci2nZlTMwAVpYkufNEtshyjF8Y2XVp75RxObNrTgF@vger.kernel.org
X-Gm-Message-State: AFuF++kg+oej0dMNl0Y6jCLvggabABdMZVUinMbPEu9NrgD/5WFHcSHP
	EC6iau+GQrAbwKqc5SDIbo3siW5CfKOuQw/HZGSTwl0pJFtuTD8VIM0o
X-Gm-Gg: AYBFou3rsqZdohUCvACfhLgmWuug3BnOESZvfEbgA08YjkHne0827wy+4bQQqYK9Vg0
	nqZfgyOoTFp7zJMDAntWP5JhD2w7p0lQgwI/4gh4tnwq/LtdUS8BMfmttbaHduat+V51rsNJZKQ
	OsAm0jYv6H+FkRWT0RzszsJr+ycRkkQYgNc3noeY/IvgsFm/U53Ecnoe38GxlECpODYyM/FFmhv
	4Y3HeWq6u/q/OKr0bdMAg25JiaPfrFS/rCJMC5NnWGd1rTJSNO9jmy/ue1HxYoToo78K2M+9fWc
	qJXocZUdJbObK/cWNr6kFW16EHaaWQbjsbYj1Xwdej+df+CsWoNBdx0A5t6oZSuBJQd7ImsTrqs
	/fl8z3htvIhygd4+Jsn2MDGjaRJjQh+LeC+ehvN2C8vzqShLoFn61qucVBKEoVDln+UPu+LTN+s
	FDWVme1twMxZnKsr6d0aR5iF2sK+6RnjzdsX4bwCXQFKRzh0d1zBPvAyJq6zb6kvvPTfZgOyhKp
	hgid4LR6qaQyqnB5uIEwlRSggGfddKh5iGsLYFDGf/KQ2BhM20JdyenSFpHRwxFjiPC5Ph/ZjX4
	OYHmodrPSzTZCGc00eGdWE7Z3wYI9x5OC8SLVu6WqVOzZfmD86vUFiOJp8ljWL0=
X-Received: by 2002:a7b:ca5a:0:b0:49f:fbad:29ae with SMTP id 5b1f17b1804b1-4a01eb19ffdmr17039525e9.17.1790829736713;
        Wed, 30 Sep 2026 21:42:16 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-095-117-056-101.95.117.pool.telefonica.de. [95.117.56.101])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a01f6c5059sm32619515e9.0.2026.09.30.21.42.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 30 Sep 2026 21:42:16 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Muchun Song <muchun.song@linux.dev>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Alexei Starovoitov <ast@kernel.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH 0/2] mm: preserve nolock context through memcg cleanup
Date: Thu,  1 Oct 2026 06:40:54 +0200
Message-Id: <20261001044056.75079-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The no-lock allocation and free APIs can still enter regular locking
through two memcg cleanup paths.

Patch 1 handles rollback after a post-allocation charge failure. If
kmalloc_nolock() obtains an object but its memcg charge fails,
memcg_slab_post_alloc_hook() frees the object through the regular SLUB
path. Preserve the selected allocation mode by using kfree_nolock()
when the allocation flags disallow spinning.

Patch 2 handles the final reference to a killed object cgroup.
kfree_nolock() and free_pages_nolock() can drop that reference in the
caller's context, after which obj_cgroup_release() takes regular locks.
Queue the objcg on a lockless list and finish its teardown from normal
irq_work. On PREEMPT_RT that work runs in irq_workd task context.

These paths were found while discussing the following RFC and during
the subsequent investigation of no-lock allocation and free paths:

https://lore.kernel.org/r/20260919171443.90512-1-kmehltretter@gmail.com

Based on 40288c9206c17. Each patch's forced cleanup test passed on
x86-64 release and lockdep PREEMPT_RT QEMU, arm64 and ARM32 SMP QEMU,
and Pi 400 hardware. The objcg test accounted for all 256 queued and
deferred releases. The series also passed non-RT builds and arena tests.

Karl Mehltretter (2):
  mm/slub: preserve no-lock freeing after memcg charge failure
  mm/memcontrol: defer final objcg release from no-lock frees

 include/linux/memcontrol.h |  1 +
 mm/memcontrol.c            | 29 ++++++++++++++++++++++++++---
 mm/slub.c                  |  5 ++++-
 3 files changed, 31 insertions(+), 4 deletions(-)


base-commit: 40288c9206c17eb66a603262e06a58d300d0f279
-- 
2.53.0
