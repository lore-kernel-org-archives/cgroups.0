Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE36C258EF9;
	Thu, 18 Jun 2026 20:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781816120; cv=none; b=HdhrsnblVEV+BC6GNBe0OTjUJ4f//I2Ai0YG9yiei2I+8hYQwkA7i7dCG1g3r0TZLvfA3sf+Yemj1d3CqDNNY56buy8AjTWXrINEYX0QQvDRJAwtPl0szYyehDGa2uAXESebrYn77BvTyJ0wkBJW4JDRP5gSJuA078dIx8J8Pf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781816120; c=relaxed/simple;
	bh=EFzOHf5GVZI7GX1gDGt7o9SqZnZV3AKOqT6Es/+ZJqU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=RdLcpUyf7W+528zRsJTOKUfHWRl5fVUWpEglhiTqSVE1xKfApWeUCaPe9y50GYsoojRH0juasCL7py7EngeFXq4qgI34p0qxyx53e/+OVcXtlnTGXXzx3ImWKxGzH1Cx8JT0JC/t44C+QAp8kfxdFr6f9R9nuzvMfB4ApbTz67k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RJ1n/ELn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RJ1n/ELn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49EE1F000E9;
	Thu, 18 Jun 2026 20:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781816119;
	bh=g3gG1NcphiUfU6jYPSArRgaQ3Q88ZPYaxNEFliPiUXQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=RJ1n/ELn5TyNV6qBTKBadpMEIpJ8AbEgZHkyanKb/x3jUMLwJEXg+d86TuIabGc9d
	 N+QSl+6OlQ2amqFyisNmFqSgUOeewuExxvAKBq1/33uFL73YqQu1m1Y+k+35teB2IJ
	 GyFt/xzsHrKc80RUPA6D9MJ2JAVn6enqTyvRsNKnm8H5d8cDN+en9V5cuxB8P1WGLq
	 14++h0grtU9DxGxgOZzisyf4/EXUrUYsToOS9+CyvxJo1Uys3xOEK8psS17okyYvPS
	 FplMvU2ilpd5k1gTalPob+5tcf4tSauWlTtk3LLp0tdFPQLlb+WR/Hd2ts9eWjTJQh
	 2SvQHqnV2Vnew==
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
Subject: Re: [PATCH v3 11/13] cgroup/cpuset: Extend isolated partition to
 trigger kernel-noise isolation
In-Reply-To: <20260618-wujing-dhm-v3-11-28f1a4d83b68@gmail.com>
References: <20260618-wujing-dhm-v3-0-28f1a4d83b68@gmail.com>
 <20260618-wujing-dhm-v3-11-28f1a4d83b68@gmail.com>
Date: Thu, 18 Jun 2026 22:55:16 +0200
Message-ID: <877bnvefgr.ffs@fw13>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Jun 18 2026 at 11:11, Jing Wu wrote:
>  
>  	if (update_housekeeping) {
> +		static const unsigned long noise_types =
> +			BIT(HK_TYPE_KERNEL_NOISE) | BIT(HK_TYPE_MANAGED_IRQ);
> +
>  		update_housekeeping = false;
>  		cpumask_copy(isolated_hk_cpus, isolated_cpus);
>  
> -		/*
> -		 * housekeeping_update() is now called without holding
> -		 * cpus_read_lock and cpuset_mutex. Only cpuset_top_mutex
> -		 * is still being held for mutual exclusion.
> -		 */

Why are you randomly removing useful comments?
