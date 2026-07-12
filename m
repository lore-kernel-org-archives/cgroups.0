Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC9B366557;
	Sun, 12 Jul 2026 17:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783878384; cv=none; b=G6p50wZutVrX++4BAATjeZiNtW8jEMI+zWYSntzS9xM3KYvjxvxZY8WX67/N+cQEfMPnWgLkaZWs6sXnuU09nB6X2QJEBI6c10CAfr2CQhbsosSbYp5sXIM66G9mdFA03Zm8cE6BZm43QvZXdyU0ZJMbSgpUpCbFRrs0XRrxrmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783878384; c=relaxed/simple;
	bh=JY71zZN3AcJoRLbQ7PXiopJJONv12qYKHQGDvpxrzvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3SXOg9SYRJyQAxug23I+BtLRDGNDmT565MyoY24c3GttrlH1c0l/KHGamDt5aku9rStq5ZVRmONfz+xsr2NnL7l0A6cppOZFTQAflpZ408FDosUH2WmecIXlMkLJv39x5vcPBKwm+DvZUImA4Zk+W8E0ul8k2qAFoSmsoLgbMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=js8IV0Pp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="js8IV0Pp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D421F000E9;
	Sun, 12 Jul 2026 17:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783878383;
	bh=KHF9t7moUNFfnXNPE/xe3rLfSjmB8jjCrzAU8dZt5Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=js8IV0Ppj6bhl38+QsXSYNXuCjtoHIN4n45z8F28u65ZiwZK9blz5bEkRIreaeWS2
	 fbtG2ZYbQI69WxTizRxtKORWglkuNQJFMvJAg9ffu50QPNS7J2CORVwaHSpFiP4HC4
	 0YE5bqC1y+91Om4Q4/x52MoRvOeGEzxBJNSQ6pBE77KRHM3o0GI+JLOEGODEVia5FN
	 MLBP8D7EhDzY70MagAnd5iSwbGlacRB74XqQ4w0KBf4PPUIhKxDvS0dgGZBENSRhyd
	 ms/dmcD5+x0JHg0cmKKRdgdwhxQu+1RebmifGXDt3oagLDYCbjVqeMdMY3bkeWNBmN
	 YKVuSSg10K/FA==
From: Tejun Heo <tj@kernel.org>
To: Matt Fleming <matt@readmodwrite.com>
Cc: David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Edward Adam Davis <eadavis@qq.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
	"ziwei . dai" <ziwei.dai@unisoc.com>,
	"ke . wang" <ke.wang@unisoc.com>,
	Matt Fleming <mfleming@cloudflare.com>,
	sched-ext@lists.linux.dev,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	kernel-team@cloudflare.com,
	Tejun Heo <tj@kernel.org>,
	Sashiko AI <sashiko-bot@kernel.org>
Subject: [PATCH 2/2] sched/psi: Shut down rtpoll_timer in psi_cgroup_free()
Date: Sun, 12 Jul 2026 07:46:19 -1000
Message-ID: <20260712174619.3553231-3-tj@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260712174619.3553231-1-tj@kernel.org>
References: <20260712174619.3553231-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

psi_schedule_rtpoll_work() is called locklessly from the scheduler hotpath
and can race psi_trigger_destroy() taking down the last rtpoll trigger under
rtpoll_trigger_lock:

  psi_schedule_rtpoll_work()        psi_trigger_destroy()

  rcu_read_lock();
  task = rcu_dereference(rtpoll_task);
                                    rcu_assign_pointer(rtpoll_task, NULL);
                                    timer_delete(&rtpoll_timer);
  mod_timer(&rtpoll_timer, ...);
  rcu_read_unlock();
                                    synchronize_rcu();
                                    kthread_stop(task_to_destroy);

The group can then be freed with the re-armed timer still pending, and
poll_timer_fn() runs on freed memory.

461daba06bdc ("psi: eliminate kthread_worker from psi trigger scheduling
mechanism") deleted the timer synchronously after the synchronize_rcu(),
which prevented this but raced trigger creation instead: the deletion could
cancel the timer that a new trigger set armed during the grace period and,
as creation also reinitialized the timer at the time, corrupt it.
8f91efd870ea ("psi: Fix race between psi_trigger_create/destroy") moved the
initialization into group_init() and the deletion into the locked section,
trading the creation races for the window above.

Neither placement in the destruction path works. A pending timer firing
while the group is alive is harmless though. poll_timer_fn() just wakes the
rtpoll waitqueue and doesn't re-arm itself. Bind the timer to the group's
lifetime instead and shut it down in psi_cgroup_free(). Nothing can arm it
by then. timer_shutdown_sync() because the timer is never armed again.

Fixes: 8f91efd870ea ("psi: Fix race between psi_trigger_create/destroy")
Cc: stable@vger.kernel.org # v5.10+
Reported-by: Sashiko AI <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260711000434.36C4A1F000E9@smtp.kernel.org/
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/sched/psi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 565ec7b80743..e2e825dcd088 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1134,6 +1134,12 @@ void psi_cgroup_free(struct cgroup *cgroup)
 		return;
 
 	cancel_delayed_work_sync(&cgroup->psi->avgs_work);
+	/*
+	 * A psi_schedule_rtpoll_work() call racing the last trigger's
+	 * destruction may have re-armed the timer after psi_trigger_destroy()
+	 * deleted it. Spurious firing while the group is alive is harmless.
+	 */
+	timer_shutdown_sync(&cgroup->psi->rtpoll_timer);
 	free_percpu(cgroup->psi->pcpu);
 	/* All triggers must be removed by now */
 	WARN_ONCE(cgroup->psi->rtpoll_states, "psi: trigger leak\n");
-- 
2.55.0

