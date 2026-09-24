Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A11139DBCC;
	Thu, 24 Sep 2026 07:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790235373; cv=none; b=NLzwIwX+P2cUCCla/5b4c5SZcLiFXpEYdbStyAvcZE3VWFtz3RYIq42/oEpfe/qdOwRLrjg/zYezgxYaW6Udxgsc/RzLankdpCt76jeMjsyxFq7+nZZmkDJtNEXrrAhuCst/QgMv/69nuNIrQ7PTTOcrRRGqCtoJe+UgQNvR5Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790235373; c=relaxed/simple;
	bh=cfKMIhAwH8jhtZ6WnRWk2d8XsimW7yadTRnQc2/pHjQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=PAL+l/SVGuOCqNIsgbzmkIweEiUNcfxLuG7G1IFitXtAhePZ9HdixWDkVHWkQpuum+fk0e10zuOtMVLIY+U08aydH9xM/0lu0C/kPNdkuXTWCmEiXMWZJXgXcdv2ePT8zjlMckJuBi0mo5krYKxdp7l4UdH/gkJ46UuQ0zNzsBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=1b9WN7Ta; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="1b9WN7Ta"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=cGA4BclgCv1i/IvFkHJAXUEs0wfbHqkLQowiIIB8YsE=;
	b=1b9WN7Tap6vm0/csUpWLxjCK7jZxPzWlkenA5HYWoo3km5g/8gjhEqjXwv+SHF04NYGTP481a
	1JBpT4tNmWxq7DOZen+2Y19oOUGWD+Jxse3VRq3FeRbeyMMJ+c5d8gY1rGi1Ej4CguGiJH+W35b
	iVtkDC08d4gSlIk7gP3TR7E=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hr5181gbNznTVk;
	Thu, 24 Sep 2026 15:23:56 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id 1B42340578;
	Thu, 24 Sep 2026 15:36:00 +0800 (CST)
Received: from octopus.huawei.com (10.67.174.191) by
 whupemk100010.china.huawei.com (7.152.184.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 24 Sep 2026 15:35:57 +0800
From: Cai Xinchen <caixinchen1@huawei.com>
To: <tj@kernel.org>, <hannes@cmpxchg.org>, <mkoutny@suse.com>,
	<corbet@lwn.net>, <skhan@linuxfoundation.org>, <rdunlap@infradead.org>,
	<edumazet@google.com>, <kuniyu@google.com>, <pabeni@redhat.com>,
	<willemb@google.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<horms@kernel.org>, <ncardwell@google.com>, <matttbe@kernel.org>,
	<martineau@kernel.org>, <geliang@kernel.org>, <mhocko@kernel.org>,
	<roman.gushchin@linux.dev>, <shakeel.butt@linux.dev>, <muchun.song@linux.dev>
CC: <cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
	<mptcp@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kselftest@vger.kernel.org>, <caixinchen1@huawei.com>,
	<lujialin4@huawei.com>
Subject: [PATCH RFC -next 0/5] net: charge socket memory budget to memcg upfront
Date: Thu, 24 Sep 2026 16:02:14 +0800
Message-ID: <20260924080219.1036588-1-caixinchen1@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 whupemk100010.china.huawei.com (7.152.184.41)

The memcg socket accounting currently charges pages to the memory
cgroup per grant (__sk_mem_schedule() publishing forward allocation)
and refunds them later from skb destructors.  The refund side folds
per-skb "was this charged" snapshots back into the socket balance
under concurrent lockless RMW, and races there can drive the memcg
socket balance negative, ending with:

    page_counter underflow
    WARNING: ... mm/page_counter.c ... page_counter_cancel()

This series flips the model: a socket is charged its whole memory
budget (sk_sndbuf + sk_rcvbuf + sk_reserved_mem) to its memcg when the
budget is established or grows, and refunded when the budget shrinks
or the socket dies.  Grants and per-skb charge/uncharge stop touching
the memcg entirely, so the racy refund pairing has no code left to go
wrong: refunds can never exceed charges and the balance cannot
underflow by construction.

Beyond removing the racy pairing, charging the budget is the more
accurate accounting: once the budget is established the memory is
effectively allocated to that socket - the protocol fills the buffers
on demand and no other socket in the cgroup can spend that capacity.
The "sock" counter therefore reports memory the sockets already own
rather than memory that happens to be in flight at the sampling
instant, the same model vm_committed_as uses for claimed address
space and hugetlb uses for reservations (charged at creation, not at
first touch).  The visible consequence is that an idle socket holds
its full budget charged for its lifetime.  Global protocol accounting
(memory_allocated, tcp_mem pressure) is untouched.

Patch overview:

  1/5 net: charge socket memory budget to memcg upfront
     Core tracker (sk_memcg_budget), lifecycle charge points, memcg
     removal from the grant path, lazy shrink sync in sk_mem_reclaim().

  2/5 tcp: sync memcg budget on protocol buffer updates
     tcp_init_sock(), tcp_set_rcvlowat() and the four autotune/pressure
     buffer writes in tcp_input.c.

  3/5 mptcp: sync memcg budget and drop backlog page compensation
     MPTCP budget writes, memcg inheritance transfer, and removal of
     the now double-charging backlog_unaccounted compensation.

  4/5 Docs/admin-guide/cgroup-v2: document upfront socket budget
charging

  5/5 selftests/cgroup: compare socket memory deltas in test_memcg_sock
     Make the test valid under both the old and the new model.

Tested: full arm64 build with 0 warnings; each intermediate state
compiles (bisectable); tools/testing/selftests/cgroup builds clean.
Runtime validation on the workload that used to trigger the underflow
is pending.

Cai Xinchen (5):
  net: charge socket memory budget to memcg upfront
  tcp: sync memcg budget on protocol buffer updates
  mptcp: sync memcg budget and drop backlog page compensation
  Docs/admin-guide/cgroup-v2: document upfront socket budget charging
  selftests/cgroup: compare socket memory deltas in test_memcg_sock

 Documentation/admin-guide/cgroup-v2.rst       |   6 +-
 include/net/sock.h                            |  21 ++
 net/core/sock.c                               | 237 ++++++++++++++----
 net/ipv4/tcp.c                                |  11 +-
 net/ipv4/tcp_input.c                          |  10 +-
 net/mptcp/protocol.c                          |  42 +---
 net/mptcp/protocol.h                          |   2 +-
 net/mptcp/sockopt.c                           |   3 +
 net/mptcp/subflow.c                           |   5 +
 .../selftests/cgroup/test_memcontrol.c        |  18 +-
 10 files changed, 261 insertions(+), 94 deletions(-)

-- 
2.18.0.huawei.25

