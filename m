Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E587547042;
	Mon, 28 Sep 2026 08:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790583563; cv=none; b=TXAh/UCawLwEtsd5hvGaaKMy9Gl0mutENA0taw2vzFwSafAZV9Bp98HPrdflfi4jvWGLLUHIOV6StFEyrGVj4JsKxSIggxzYpXQQaXf/XTN1ofVNSbcdIpqRItrSey7/5Fxvoc72ailFV5/Wl1cc1e60pdpwXKP2+jwR18fuN4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790583563; c=relaxed/simple;
	bh=FslY3hhSlsoCA+5u1eBS3KOV+FIBlHTLGGXzBMm8t4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MbL2bEE1x1SxxwuHGgezx2kyD+RIjabEGPxOtA16jThcZSkUbfGxS1m/F9FmYtX4oTU6mjWAUoslc5e4BPKU8hU+hnDMTDNf9e4gm0PrB5YF9dJC7L/njGHGRMMi5oazl19gxi7u+lEXwkB5SMD53HgMrG+bLZry1nDF13daFO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 0DE633E972;
	Mon, 28 Sep 2026 08:19:08 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [RFC PATCH 0/4] mm/zswap: make shrinker writeback work with iocost
Date: Mon, 28 Sep 2026 10:18:35 +0200
Message-ID: <20260928081900.4187482-1-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTGDAZTY8FQdfIVgvulh8+Ontt0UHMbNx7VW+SvuP9n/VVpAc15RJUj4OtlP0SQbUn0HcGGGXbzBBp/gASYJS6oVdftruFjiFnihosDaklSoEd+62bXrJAa+/zYSAu4+cl39U0CVLr5WdN46E9L7/Q4tx8ccKm2agYzkHguBa9KkrBths7Yplh0gcXVyS/ngPeLDw2DIh5qJimb0bfwD/0AAsWD/yQvch5ezsNCOkJmyoS5Ic79ZDd4epkxJsioHDkWZtsqSMBR4l6eWELikjxrpKV1btwsNT0QmoHq2jaEkavqSkNYTANQPyP/F43M8V95d8uz5FKIpAMEzb+qV/E9dGOHIu6lbBID3PkMkIQV5fgazvuUzv/CoI1oXR4+kwQITGwxKOht1As2puZhGtjvctCEYLf8n0WF2BN02NFlSuIm7Ob81iipQvFD9c0tP8ElxA7CRRvK581ykoOTp6LX+oErRGuC5JM2LML+EvRXGmcK98f5pELREKePtj8Vgmh+LSRm/ycwcL8UvHQ2po8WykCFDm9GbWnsk8a3kjTw6raq8YKYK1lyUZHmgb6jjStz7q+NbcvKyvNwkbWwi6OzszuZRYfzsQE/tUNwsRLt/dvK7SJ2cUPLiJvDP0Hz8hU3fgPjueoU3fH1OPk894aWjFDSfAOcCZ9Mq8Uo/F8V2ig
X-GND-State: clean
X-GND-Score: -100

We want to enable the zswap shrinker on our fleet, which runs iocost,
but with it on, a large production workload is slower than with it
off. Two reasons:

1. zswap writeback is REQ_SWAP, so the IO controllers issue it as root
   and charge it to the cgroup afterwards, as debt. The workload pays it
   back: its swapin and page cache reads wait, and iocost eventually
   stalls its allocations, which in turn stalls the application.
   Patches 1-3 let zswap writeback be throttled instead, by marking it
   REQ_BACKGROUND.

2. A throttled write sleeps in its submitter, which for the shrinker is
   whoever entered reclaim, often an application thread in a page fault.
   Patch 4 moves that writeback to a per-lruvec kworker.

Large production workload, 10 hosts per arm, CPU matched, one 24h run
per comparison. Change with this series:

                     vs shrinker off    vs stock shrinker
  p50                    -0.7%               -5.8%
  p99                    -0.2%               -6.5%
  memory PSI full        -52%                -94%
  zswap pool             -97%                +12%

The benchmarks below run with iocost enabled, in a cgroup whose
memory.max (the "cap") is smaller than their working set, so they are
under constant memcg reclaim.

UCacheBench, 12G cap, 5 runs:

                     shrinker off    stock shrinker    this series
  ops/s                  469k             280k             634k
  errors                  0%               44%              0%
  p99.9                 5.8 ms           16.6 ms          4.3 ms

MySQL, sysbench OLTP, 256M cap, 5 runs per host:

                     shrinker off    stock shrinker    this series
  TPS, host 1            OOM               413              609
  TPS, host 2            OOM               399              666
  p99, host 1            OOM             334 ms            90 ms
  p99, host 2            OOM             273 ms            44 ms

FeedSim, 16G cap:

                     shrinker off    stock shrinker    this series
  QPS                    4.7              30.2             32.4
  p95                  1306 ms           495 ms           494 ms

kbuild, defconfig -j4, 600M cap, 3 runs per host:

                     shrinker off    stock shrinker    this series
  build time, host 1    784 s             788 s            778 s
  build time, host 2    691 s             696 s            680 s

Alexandre Ghiti (4):
  block: do not issue background swap bios as root
  mm/zswap: turn shrink_memcg_cb()'s argument into a flags word
  mm/zswap: allow writeback to be throttled by the cgroup IO controllers
  mm/zswap: move reclaim-driven writeback to a kworker

 block/blk-cgroup.h       |   8 ++-
 include/linux/swap_ops.h |   1 +
 include/linux/zswap.h    |   4 ++
 mm/page_io.c             |   7 +-
 mm/zswap.c               | 148 ++++++++++++++++++++++++++++++++++-----
 5 files changed, 146 insertions(+), 22 deletions(-)


base-commit: fe2ec83746e501645709761605c2464a44fd2929
-- 
2.53.0-Meta

