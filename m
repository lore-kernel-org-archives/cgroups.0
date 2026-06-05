Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FF43C414F;
	Fri,  5 Jun 2026 12:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780663418; cv=none; b=RnGHZlww4ZkoHLgTicdkiYN5K0DdSPXWGBapYeqyBxEHJ+Jmo4uEvyubnAl6souJGhIsgq6zRNcG9ONnO91hMsmCqBtmBFVAI4vdU+hyPMMd0onfN6b6CuI63Ren1ulMkJ15VjD940N1TYC5nzgso9DdVT1Kqj0euccHX2ad9eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780663418; c=relaxed/simple;
	bh=Ynt7i9S9WcoxmiTkpFWjBbZk4A2pTNZaEtkFTUFzxbY=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=dnFzMCPa4Rd4aE6eSVZRM4kI75HwLPYhjopqjALh9xEhXgQbpxKRM9PkBQ4pVYbZiGmWYhE4mYPdvFhPGT483WpyW6iPqcaQ0iAy009GDANHdeO2o2wd2eHaaEAU55wljdIzYFbpT5CVDypNvYiGQPcguYVmgwehVM4eY7GzFZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cMpwb87j; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cMpwb87j"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
	Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To;
	bh=iagqKCq+Q/VlKH7MvQ1XZ0bf/xG9PDjiUd+QpNkj100=; b=cMpwb87j98ztIVKkVkYzhzizTc
	wK1pXB1k3vKwDP7ALrNE1LK7LRXDhhe5Lxuq4Zoy7UzbM1rPtHpW5k+IfzOaHQKxXheXJe8k43Yva
	JZ/0VbMAesN+6YfUYvWkVF7T2TfIYCXh0dkWna63CQRDgLVO87vw2wLF49YpG0Rd1jSS0MM6YrBGB
	JfqsZ6wc0cwfIqUejDmmF5yo2z4TOWPpv8QoVFa7J1JL0211vDQ57RTCRPFuHlghwc40xzRw+VYzj
	YXLL2/Y7G/MWVdk+5xaHrR5E6FjD2GeIH+k610uqWxVMs9FFvBEESAHlqo1+PlLgaVKR+WjaOqMOm
	QfV1ThhQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wVTtI-00000007var-28pa;
	Fri, 05 Jun 2026 12:43:13 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 0)
	id 3BA2130325A; Fri, 05 Jun 2026 14:43:11 +0200 (CEST)
Message-ID: <20260605124052.080482755@infradead.org>
User-Agent: quilt/0.68
Date: Fri, 05 Jun 2026 14:40:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org
Cc: longman@redhat.com,
 chenridong@huaweicloud.com,
 peterz@infradead.org,
 juri.lelli@redhat.com,
 vincent.guittot@linaro.org,
 dietmar.eggemann@arm.com,
 rostedt@goodmis.org,
 bsegall@google.com,
 mgorman@suse.de,
 vschneid@redhat.com,
 tj@kernel.org,
 hannes@cmpxchg.org,
 mkoutny@suse.com,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 jstultz@google.com,
 kprateek.nayak@amd.com,
 qyousef@layalina.io
Subject: [PATCH v3 6/7] sched/fair: Change the default cgroup_mode to concur
References: <20260605105513.354837583@infradead.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

For all the reasons described in the preceding patches, the way cgroup
weight is computed is problematic. However, changing it is bound to
also lead to trouble. Esp. since people might have taken to inflating
the weight value where they can.

Since things are configurable, change the default and hope this serves
more people than it hurts, esp. in the longer run.

Specifically, this prepares for a flattened runqueue, where the hierarchical
weight becomes far more important (F_g^d terms), so getting rid of small F_g is
imperative.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 kernel/sched/debug.c |    2 +-
 kernel/sched/fair.c  |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -635,7 +635,7 @@ static void debugfs_fair_server_init(voi
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-static int cgroup_mode = 1;
+static int cgroup_mode = 2;
 
 /* See __sched_cgroup_mode_update(). */
 static const char *cgroup_mode_str[] = {
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4921,7 +4921,7 @@ static long calc_up_shares(struct cfs_rq
 	return READ_ONCE(tg->shares);
 }
 
-DEFINE_STATIC_CALL(calc_group_shares, calc_smp_shares);
+DEFINE_STATIC_CALL(calc_group_shares, calc_concur_shares);
 
 void __sched_cgroup_mode_update(int mode)
 {
@@ -4931,10 +4931,10 @@ void __sched_cgroup_mode_update(int mode
 		func = &calc_up_shares;
 		break;
 	case 1:
-	default:
 		func = &calc_smp_shares;
 		break;
 	case 2:
+	default:
 		func = &calc_concur_shares;
 		break;
 	case 3:


