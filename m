Received: from mx9.didiglobal.com (mx9.didiglobal.com [111.202.70.124])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 549A927A91D;
	Mon, 19 Oct 2026 12:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.202.70.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792414676; cv=none; b=atDusYzYF0HwFCK4Fg/v4sOOlXSL9gFFmz5eXD99yhwYrPRT/1a8e2cDqxAe/fY65Dq3vMP8m3KWJ7ysDEI8v06418KYHs+XXC97PccgDI0xt89yZuQn66C1ujdIuZ0sSpMk/jqoz25UD1aFGcMDiDXe/oH2fcaMB/RffTiQ9d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792414676; c=relaxed/simple;
	bh=PUJ9RFQeAgxLlm+Qf/ZI0Fme+qrJ2ck0QbvTcnCJgeA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Ko0S4LaP+hXYgzjn3ECro9OyOuOc6ctKXARy7sLT5PeixLgppNwxccD+RI20+lgoiI1kQktHZEEOtmc+X8Nf9tGTCtRg91JnNvUIFwH5rYmT4yhmNKDEhqpikBHu3yGxaZ+8m1p5EnqgWYukC80ZG5znsBEY5GDJb6O//CneCT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=didiglobal.com; spf=pass smtp.mailfrom=didiglobal.com; dkim=pass (1024-bit key) header.d=didiglobal.com header.i=@didiglobal.com header.b=MYeZ5eK7; arc=none smtp.client-ip=111.202.70.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=didiglobal.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=didiglobal.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=didiglobal.com header.i=@didiglobal.com header.b="MYeZ5eK7"
Received: from mail.didiglobal.com (unknown [10.79.71.37])
	by mx9.didiglobal.com (MailData Gateway V2.8.8) with ESMTPS id CF996198006EF0;
	Mon, 19 Oct 2026 20:54:33 +0800 (CST)
Received: from BJ01-ACTMBX-05.didichuxing.com (10.79.64.32) by
 BJ03-ACTMBX-01.didichuxing.com (10.79.71.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 19 Oct 2026 20:54:33 +0800
Received: from ml-justfortest.ys (10.79.64.102) by
 BJ01-ACTMBX-05.didichuxing.com (10.79.64.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.45; Mon, 19 Oct 2026 20:54:33 +0800
X-MD-Sfrom: daikunhai@didiglobal.com
X-MD-SrcIP: 10.79.71.37
From: Kunhai Dai <daikunhai@didiglobal.com>
To: <tj@kernel.org>
CC: <axboe@kernel.dk>, <josef@toxicpanda.com>, <yukuai@fygo.io>,
	<cui.tao@linux.dev>, <cgroups@vger.kernel.org>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<rostedt@goodmis.org>, <mhiramat@kernel.org>,
	<mathieu.desnoyers@efficios.com>, <linux-trace-kernel@vger.kernel.org>
Subject: [PATCH v2 0/2] blk-iocost: fix hweight cache publication and donation fail-safe
Date: Mon, 19 Oct 2026 08:54:10 -0400
Message-ID: <20261019125412.3123895-1-daikunhai@didiglobal.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BJ03-PUBMBX-01.didichuxing.com (10.79.71.11) To
 BJ01-ACTMBX-05.didichuxing.com (10.79.64.32)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=didiglobal.com;
	s=2026; t=1792414477;
	bh=FB0ZQAEbI4ojgh9IRbyS5nY8jyGtKRcMUGWMYXfL9PA=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=MYeZ5eK73ABU9w8Che8zvL/Uvrg/qlKrr3A9Sofit8GZyyaifuThjLLq2NwtT80DK
	 oX08pWHGaTmx+XHIhnOW/QfYcd42gru4cuEc52WTG6+uO2rQpprpDuNYrwYBfFbNqZ
	 Wfu5JebcxKi1EFWEubJYtYRKY82Dsw8qBmSQ6UZA=

This series fixes the blk-iocost hweight cache publication race and adds a
fail-safe for invalid donation weights.

Previous version:
  https://lists.openwall.net/linux-kernel/2026/10/15/1954
Replies:
  https://lists.openwall.net/linux-kernel/2026/10/16/1431
  https://lists.openwall.net/linux-kernel/2026/10/16/2798

Changes since v1:
- split into two patches: the donation fail-safe and the atomic cache;
- add the Fixes tags agreed on the list (e08d02aa5fc9, 7caa47151ab2) and
  Cc stable on the fail-safe;
- drop the donating > 1 guard, which only changed the value printed by the
  warning;
- do not add max(after, 1): the no-race path has not been shown to be
  reachable and the total budget invariant has not been re-validated;
- use GENMASK/FIELD_PREP/FIELD_GET helpers for the packed cache;
- have tracepoints decode the packed cache without refreshing it, and only
  evaluate that read when the tracepoint is enabled;
- explain the activation-time cache update;
- update iocost_monitor.py;
- document the AI-assisted work.

The no-race invalid-weight path is still under investigation: a hand-built
input can trigger the divide at the function level, but runtime
reachability has not been demonstrated.  The first patch is therefore a
fail-safe, not a claim that the path is reachable without a race.

Kunhai Dai (2):
  blk-iocost: abort weight transfer on invalid donation weights
  blk-iocost: publish hweights as one atomic value

 block/blk-iocost.c             | 111 +++++++++++++++++++++++++++------
 include/trace/events/iocost.h  |   7 ++-
 tools/cgroup/iocost_monitor.py |   7 ++-
 3 files changed, 101 insertions(+), 24 deletions(-)

-- 
2.27.0

