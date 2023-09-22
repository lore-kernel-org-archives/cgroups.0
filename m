From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH 0/2] mm: memcg: fix tracking of pending stats updates values
Date: Fri, 22 Sep 2023 08:25:40 +0000
Message-ID: <20230922082542.466579-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695371145; x=1695975945; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6DHfRiy16OkhCPchGcMG2Wr8n1hI6+/4vWiAKStiZAI=;
        b=PO4IDZ1CB4avwfl3+ABGZsQgyS0OgbqDTbDSsd/oo5A1NOkxQyfLG/b+73VZ8Q2Jmc
         ogmIkaIDH4lSZuvsRh9BHQiMjpFuLjnl6mvazisQhMeZprACGdFk9EBsXfgbDKXOIhOp
         UUqr/8pj4b8na8fxqnevO6zqQiFohqr+Cde1vQh5X/xTfiVVfohXV6Eo7pDCLQ1RzYJ2
         nqxm1ccoeJlcpcucz//1Zl8rUuZiZWtrlCpy0HeCDj61qvqMknFC4JVsy1EjiaSwlH+3
         BjeJfyodIQiwAosBX6lrTU2GZiVnN5fKqxHX4FUT4zqhQ39RuzJ0LmMySUNiZzfFkC+Y
         /FQQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

While working on adjacent code [1], I realized that the values passed
into memcg_rstat_updated() to keep track of the magnitude of pending
updates is consistent. It is mostly in pages, but sometimes it can be in
bytes or KBs. Fix that.

Patch 1 reworks memcg_page_state_unit() so that we can reuse it in patch
2 to check and normalize the units of state updates.

[1]https://lore.kernel.org/lkml/20230921081057.3440885-1-yosryahmed@google.com/

Yosry Ahmed (2):
  mm: memcg: refactor page state unit helpers
  mm: memcg: normalize the value passed into memcg_rstat_updated()

 mm/memcontrol.c | 64 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 51 insertions(+), 13 deletions(-)

-- 
2.42.0.515.g380fc7ccd1-goog

