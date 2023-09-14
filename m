From: Huan Yang <link@vivo.com>
Subject: [PATCH 0/3] Per memcg lru_gen node stat
Date: Thu, 14 Sep 2023 18:47:42 +0800
Message-ID: <20230914104754.55-1-link@vivo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N+m0VxUwTyDGYqfeRvoQz6OFTcCzoA6YG47/myLxRHI=;
 b=LjNXJZapGwODgKeLHl9A1+6K6HXFAAS6JA1w/YeV1/SAb5oCQ5EgNy2LHg7i/FH6fBqsBQJBWPlDg9H/ejvXEFkj67t65olRRgJiJnpQvcbMGaWH0eV+pevCrUd06CtFGcQUY1AQwE9P14NJcoEe8ss+tBlBZZtwkbJQMJTwn9b1zqwOacWCgAdW0RfbhXMY80rNJXiHhYgXK2v23vOOlQn+rPOGeV0wXRzl4wjOpClbOVUSN9wK/GZUMtrWyikSYuLgkBjfL07b2uBsRmnm/L0wiV5JVcqZIeSuY8wda5IUT9u6NFj8uXjyFGkRejHjWGNXsts5q7CeuxJ1gndFwg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Suleiman Souhlal <suleiman@google.com>, Mike Rapoport <rppt@kernel.org>, "Jan Alexander Steffens (heftig)" <heftig@archlinux.org>, Yu Zhao <yuzhao@google.com>, Huan Yang <link@vivo.com>, Brian Geffon <bgeffon@google.com>, Gaosheng Cui <cuigaosheng1@huawei.com>, Peter Xu <peterx@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>, "T.J. Alumbaugh" <talumbau@google.com>, Kefeng Wang <wangkefeng.wang@huawei.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvac
Cc: kernel@vivo.com

On original global lru_gen node in debugfs, it can all show each memcg's
lru gen info in "lru_gen" or "lru_gen_full", and can type cmd into lru_gen.
But which show info contains all memcg's info, and cmd need to 
know memcg's id.

This patchset add lru_gen node in per memcg, with this node, we can
get lru_gen info in each memcg.
Also, we can type cmd to control each memcg's lru_gen seq, but, this node
don't support multi cmd, single memcg just process one cmd once time.

Huan Yang (3):
  mm: multi-gen LRU: fold lru_gen run cmd
  mm: memcg: add per memcg "lru_gen" node
  mm: multi-gen LRU: add per memcg "lru_gen" document

 Documentation/admin-guide/mm/multigen_lru.rst |  10 ++
 include/linux/mm_inline.h                     |   9 +
 include/linux/mmzone.h                        |   4 +-
 mm/memcontrol.c                               | 163 ++++++++++++++++++
 mm/vmscan.c                                   |  82 ++++++---
 5 files changed, 246 insertions(+), 22 deletions(-)

-- 
2.34.1

