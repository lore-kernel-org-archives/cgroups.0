Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B94A284662;
	Thu, 18 Jun 2026 21:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781817100; cv=none; b=XknVYvuXptZUfaVV6e4MMNTWB2i5P7FyGQdS2fmOXdO+Yp249m9Qy5eDeWvhaq0wFWbhX3pNxPzS8TxcSPGtNdoxbu+DijVVm9F53k982WumXG1V3/5SYn8/OVdrP+fayWw1EnITW48BA2Fnq+TCfo7XN5HMQI4912c6q9iITuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781817100; c=relaxed/simple;
	bh=5J6h2tNPPWn/FYPAOaZ2llids3Y3YxLIy/0yx0sHrgM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=YhWUFFfQKIdRhV/Y8p7ASI7wl+jSwpo7RHPrdwaPsqG2jMoC5QNmLrZt2M2QMxToIcGfd0H6BthPgKg7faHUJEkSik3xt9CkgQQTwcBv2xz077ltkd0itC3NQJez2dxkD5mV450K2lpm81DJTwR3sdhW16BOwqa2JigQeRb83kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NRlpDCJR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NRlpDCJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7CC1F000E9;
	Thu, 18 Jun 2026 21:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781817098;
	bh=aBAfK0AC8Dm0DX5YdQDLhdJtI8Iuh2HnALm598WNeYA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=NRlpDCJRw0x8mRkCKYUNiDKD/ZijAaUiBQKyxzhdEjNmyjeQAF0QjatXwliSbKJkM
	 8tYxA9woFXv/dRVXmmFfTAjvmkY91ZRTKmk0N0ac6eeb1bpYXYrD2wgwjK4ryTl+/T
	 xOOkcUgyRQ6PpKwF05z81XqyS9Sb+vKq4tGJqVqgKfmWpSr1IVP9jEWoiXXwxLe2tJ
	 juHAj0VC6UigQqEDNSieHZFoxuvPETllOy8jEf25QfpRKFUlMVEn6YbnS9pEOWtL9l
	 3habm1Q8OHDj68B3+kdS23NlfLI94fgqt2va9UYYhX2GlsERg3EBOwnisLxP3GraIb
	 JRdklbliVVatw==
From: Thomas Gleixner <tglx@kernel.org>
To: Jing Wu <realwujing@gmail.com>, Ingo Molnar <mingo@redhat.com>, Peter
 Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben
 Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Valentin
 Schneider <vschneid@redhat.com>, "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay
 <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, Josh
 Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>, Uladzislau
 Rezki <urezki@gmail.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>,
 Zqiang <qiang.zhang@linux.dev>, Anna-Maria Behnsen
 <anna-maria@linutronix.de>, Tejun Heo <tj@kernel.org>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan
 <shuah@kernel.org>, Waiman Long <longman@redhat.com>
Cc: linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Jing Wu <realwujing@gmail.com>, Qiliang
 Yuan <yuanql9@chinatelecom.cn>
Subject: Re: [PATCH v3 08/13] genirq: Add explicit housekeeping callback for
 managed IRQ migration
In-Reply-To: <87cxxnegqa.ffs@fw13>
References: <20260618-wujing-dhm-v3-0-28f1a4d83b68@gmail.com>
 <20260618-wujing-dhm-v3-8-28f1a4d83b68@gmail.com> <87cxxnegqa.ffs@fw13>
Date: Thu, 18 Jun 2026 23:11:36 +0200
Message-ID: <87zf0rd053.ffs@fw13>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Jun 18 2026 at 22:27, Thomas Gleixner wrote:
> On Thu, Jun 18 2026 at 11:11, Jing Wu wrote:
>> +		 */
>> +		if (irqd_affinity_is_managed(&desc->irq_data)) {
>
> So you set the affinity even on an interrupt which is shutdown?
>
>> +			const struct cpumask *mask;
>> +			struct cpumask *tmp = this_cpu_ptr(&__tmp_mask);

How is this correct? You cannot get the per cpu pointer in preemptible
context. The task might be migrated and then fiddle with the wrong
per CPU data. But that's moot as this code is broken anyway.


