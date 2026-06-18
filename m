Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA8631ED7D;
	Thu, 18 Jun 2026 16:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781798806; cv=none; b=Gt+IZ92GArG/QPv657nG3SgfQ8toRrrzbEkRj+6Yk3g0DTqajH11yM7g0+3y9pLQf/+KY2/hjoks0/9d/qqeV0qDDnFX3CkpynWl5mzozdpninpd1csvrFMpjThDHixHDD/xThRzH4rK2QfcdKLYeqU/bCryj9mhnMWV7Z/LTgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781798806; c=relaxed/simple;
	bh=NWBKKhk/6xsHpvh58NSa3ma7bMlAH3QHjJJSfoiRTDQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=p7xOyaBecsh3PqcieMPUeLcPKjXSjU4t74MuqTGY7tKGEjLujtvhR5KvKbc+tDsqMgJy1pUX/kb9nGr86PGYgsl14y++rRdKJMOPlGRjLgONz+sdfPNS9BkM5WqU9mRUXlXUCOLjGxkpoJzM126dwWoFj00lf1nyJqKTJy4kciU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ffTr70mi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ffTr70mi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01CC81F000E9;
	Thu, 18 Jun 2026 16:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781798803;
	bh=GFJ910Nv9NJncfqGCeAFA1Jf6vpmd6wpUP1Hnqw3glw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=ffTr70miIAv2QzdbUBh1pJwaCw0U4usX+rPcYeq7Oaq325gf/NRUfvy8P3RnyYBYe
	 pAoUC8z4iGE+Tv2Xpmm/JIqxPV+J2S74SBZWvz14dG0KK1hYA68miwSGp7zliXen5J
	 IFeSSgo2V//PEUNpBJ7R4+BBx2C9+1Uo1B9/9vESmZcGKj27eqMCf1fy0ozV4edcIF
	 OENZJ6fmEyU+ofpAT78G7XM+MjAvetJaZJ2i8Jp2WS31PCqzLBPdCQO/Q3pyE41iyd
	 QUMj2ZzLsu7X+I75N3SfAr7A1YzRPwlM3ygja9nVMkth4nnQMiEm2Zn6OVz4BZBY6b
	 8djoBayrR1ZIA==
From: Thomas Gleixner <tglx@kernel.org>
To: Jing Wu <realwujing@gmail.com>, Ingo Molnar <mingo@redhat.com>, Peter
 Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben
 Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Valentin
 Schneider <vschneid@redhat.com>, "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay
 <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, Josh
 Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>,
 Zqiang <qiang.zhang@linux.dev>, Anna-Maria Behnsen
 <anna-maria@linutronix.de>, Tejun Heo <tj@kernel.org>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan
 <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Jing Wu <realwujing@gmail.com>, Qiliang
 Yuan <yuanql9@chinatelecom.cn>
Subject: Re: [PATCH v3 05/13] cpu/hotplug: Reserve CPUHP states for
 nohz_full and managed IRQ down-paths
In-Reply-To: <20260618-wujing-dhm-v3-5-28f1a4d83b68@gmail.com>
References: <20260618-wujing-dhm-v3-0-28f1a4d83b68@gmail.com>
 <20260618-wujing-dhm-v3-5-28f1a4d83b68@gmail.com>
Date: Thu, 18 Jun 2026 18:06:40 +0200
Message-ID: <871pe3de9b.ffs@fw13>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Jun 18 2026 at 11:11, Jing Wu wrote:
> Add CPUHP_AP_NO_HZ_FULL_DYING and CPUHP_AP_IRQ_AFFINITY_DYING to the
> cpuhp_state enum.  These dying callbacks are invoked during CPU offline
> before the tick is stopped, enabling clean tick handover and managed
> IRQ migration when a CPU transitions between isolated and housekeeping
> states.
>
> The existing CPUHP_AP_IRQ_AFFINITY_ONLINE already handles managed IRQ
> restoration on CPU online.  The new dying callback completes the pair,
> migrating managed interrupts away from the CPU before it goes down.

What? They are migrated away today already when the CPU goes down unless
the CPU is the last one in the affinity set of the interrupt. So why do
you need a new step for something which already exists?

> Subsequent patches register handlers for these states.
>
> Signed-off-by: Jing Wu <realwujing@gmail.com>
> Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>

This SOB chain is broken (in all patches). See Documentation/process/...

Thanks,

        tglx
