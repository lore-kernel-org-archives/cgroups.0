Received: from mx9.didiglobal.com (mx9.didiglobal.com [111.202.70.124])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 54A804E2372;
	Mon, 19 Oct 2026 12:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.202.70.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792414676; cv=none; b=t/DKOWCjlg08TQp7CBuISOtXhmiqw3InJFWB8juRcZt71jd7QI3oVrtbCqUKK2OQAuwdivrIQJ08rMvObdu1595FeHGLi7oGRJsFIE3WwWURt77qZj39ACA04LuBry9ugfUXF9+60Jcdz3G4hwCziMfuDCKyUY4mOpEuHq94LY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792414676; c=relaxed/simple;
	bh=24vK8Q5xtyzmhS/g+2C/QPGvVqUhzpAJz+hYy1TqqzY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:MIME-Version:
	 Content-Type; b=K+XS1fuOcYLkj6kQzjtjg8mrVfU82SlYr2ZGOK0jsQTqIcRZCII3E2PuXijhN4InC6Yt9B3GpPcn69aTfrcWb7QcMTehTXzoCVB29JQ9qKIupoebOjUbQkCYJYvpvTRMHFdMJO0RkwtfpE/rFHsqqC6A7LhqlxA332xPwmdRy0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=didiglobal.com; spf=pass smtp.mailfrom=didiglobal.com; dkim=pass (1024-bit key) header.d=didiglobal.com header.i=@didiglobal.com header.b=jxuWTtvF; arc=none smtp.client-ip=111.202.70.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=didiglobal.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=didiglobal.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=didiglobal.com header.i=@didiglobal.com header.b="jxuWTtvF"
Received: from mail.didiglobal.com (unknown [10.79.71.38])
	by mx9.didiglobal.com (MailData Gateway V2.8.8) with ESMTPS id D09EE198006EF9;
	Mon, 19 Oct 2026 20:54:35 +0800 (CST)
Received: from BJ01-ACTMBX-05.didichuxing.com (10.79.64.32) by
 BJ03-ACTMBX-02.didichuxing.com (10.79.71.38) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 19 Oct 2026 20:54:35 +0800
Received: from ml-justfortest.ys (10.79.64.102) by
 BJ01-ACTMBX-05.didichuxing.com (10.79.64.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.45; Mon, 19 Oct 2026 20:54:35 +0800
X-MD-Sfrom: daikunhai@didiglobal.com
X-MD-SrcIP: 10.79.71.38
From: Kunhai Dai <daikunhai@didiglobal.com>
To: <tj@kernel.org>
CC: <axboe@kernel.dk>, <josef@toxicpanda.com>, <yukuai@fygo.io>,
	<cui.tao@linux.dev>, <cgroups@vger.kernel.org>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<rostedt@goodmis.org>, <mhiramat@kernel.org>,
	<mathieu.desnoyers@efficios.com>, <linux-trace-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: [PATCH v2 1/2] blk-iocost: abort weight transfer on invalid donation weights
Date: Mon, 19 Oct 2026 08:54:11 -0400
Message-ID: <20261019125412.3123895-2-daikunhai@didiglobal.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20261019125412.3123895-1-daikunhai@didiglobal.com>
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
	bh=XJm75H3TeCaT+jFh4zfoNaIXvTNCGPePFv9zbAerBFs=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=jxuWTtvFafc4eOoJgrq0KLXLGsILfcTySmhBST8rCsHP0+jNM6VNqzXs85Bs1/+kl
	 ylgYxisbZGKvaFIa/XI96F8j7CO0+NTX1um+ArfPZyrFUgPVs26im0oMgA61A41dvw
	 DFu0nmk6/PGyJg6UmBv2qJuH+jLsO9vLMkqWn1KQ=

transfer_surpluses() warns and then keeps going when the donation
calculation produced invalid weights.  The following propagation can then
divide by a zero hweight_inuse, so the warning is immediately followed by a
divide error.

When the check trips, abandon this period's donation transfer and release
the walk lists.  This trades one period without donation for not crashing;
the invalid state is not expected on the normal path.

Developed with assistance from Claude Code (Anthropic): the assistant
analysed the failure path, drafted the change and ran the checks listed
below.  The author reviewed the result and remains responsible for it.

Fixes: e08d02aa5fc9 ("blk-iocost: implement Andy's method for donation weight updates")
Cc: stable@vger.kernel.org
Signed-off-by: Kunhai Dai <daikunhai@didiglobal.com>
---
The failure was originally observed on a vendor 4.18 kernel and reproduced
on v7.3-rc7 by a kprobe widening the current_hweight() publication window.
The guard is a fail-safe: a hand-constructed input can trigger the divide
at the function level, but runtime reachability without a race is not
confirmed, so this patch does not claim to fix a reachable no-race divide.
---
 block/blk-iocost.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 2745bffcd..7b8af094a 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1956,6 +1956,7 @@ static void transfer_surpluses(struct list_head *surpluses, struct ioc_now *now)
 			pr_cont(": active=%u donating=%u after=%u\n",
 				iocg->hweight_active, iocg->hweight_donating,
 				iocg->hweight_after_donation);
+			goto out;
 		}
 	}
 
@@ -2054,6 +2055,7 @@ static void transfer_surpluses(struct list_head *surpluses, struct ioc_now *now)
 		__propagate_weights(iocg, iocg->active, inuse, true, now);
 	}
 
+out:
 	/* walk list should be dissolved after use */
 	list_for_each_entry_safe(iocg, tiocg, &inner_walk, walk_list)
 		list_del_init(&iocg->walk_list);
-- 
2.27.0

