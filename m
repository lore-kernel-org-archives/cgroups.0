Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710DC2D8379;
	Tue, 14 Apr 2026 21:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776201947; cv=none; b=tQQ65eHxg6ddHbdjamq7k4keoVLLvZW0Zv0u/+4u3d2jZqYJRnbRuM47o7Fp1ceQGWzB/qp2ziGtXUOR5HV81f737DMbFHkgwtSKo0sVz9tG9+qPYvhxTz3tzaTGcaGnq5NGi/cGmcAYHWGl8d7Aok/jQ5dhued/Jr/52XymEsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776201947; c=relaxed/simple;
	bh=7P7F7WGcbi2CGd41uCZAd0HNLhsC1TsYqmIPqKA6PoU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=lLE4lZOO5gyKE00eRmopOohqCxsGFhc6NCPzzfYoHAGXivJKBSDrBmkXDIHGHYEFSCUvxKsH2WonAR+5Va43IVoXbmj8ig0aW/WlRvy//SdToSxuwhwHJkvz+6sEeJWvf1cr/+YFCrbTWgVtomUe4Q1oT5/SeD1pFNU6wXGUl/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rbwiMaSd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rbwiMaSd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3471DC19425;
	Tue, 14 Apr 2026 21:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776201947;
	bh=7P7F7WGcbi2CGd41uCZAd0HNLhsC1TsYqmIPqKA6PoU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=rbwiMaSdhUF53StkQMJfEh0fMbLskeFVLCWnhMdfY3z54QSj4fBh65AsS1vLuLU+4
	 KgiZN8mRe0w7LQUfSeH5rUisEjLyGQhGOgPfxwNbiNj9HxgLBg5Wszcx0/hGp84bKF
	 qCsCof+7C7NPbp3K7f0teEe0rAlfUE4486ArlgaOD0lTNQs85Rmg6nWCILPCFzY8P+
	 N304zWX9Va8hhExmbkycx0UdEGIWs27BS2mXRbfUCoXg/YvJurlwy2+WEtVfq4dMzN
	 EOjqJdslad9D25iyRXrXMa9qC+Y5Qih+8yTThRZQ4CW62Vaz5kaFIE6c1aOjYQh8vd
	 hKNe+sBCRDarQ==
From: Thomas Gleixner <tglx@kernel.org>
To: Qiliang Yuan <realwujing@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
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
 <anna-maria@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Tejun Heo
 <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil
 Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Johannes
 Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Waiman Long
 <longman@redhat.com>, Chen Ridong <chenridong@huaweicloud.com>, Michal
 =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, rcu@vger.kernel.org, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Qiliang Yuan <realwujing@gmail.com>
Subject: Re: [PATCH v2 02/12] sched/isolation: Introduce housekeeping
 notifier infrastructure
In-Reply-To: <20260413-wujing-dhm-v2-2-06df21caba5d@gmail.com>
References: <20260413-wujing-dhm-v2-0-06df21caba5d@gmail.com>
 <20260413-wujing-dhm-v2-2-06df21caba5d@gmail.com>
Date: Tue, 14 Apr 2026 23:25:43 +0200
Message-ID: <87wly9dyjs.ffs@tglx>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Apr 13 2026 at 15:43, Qiliang Yuan wrote:
>  
> +int housekeeping_register_notifier(struct notifier_block *nb)
> +{
> +	return blocking_notifier_chain_register(&housekeeping_notifier_list, nb);
> +}
> +EXPORT_SYMBOL_GPL(housekeeping_register_notifier);
> +
> +int housekeeping_unregister_notifier(struct notifier_block *nb)
> +{
> +	return blocking_notifier_chain_unregister(&housekeeping_notifier_list, nb);
> +}
> +EXPORT_SYMBOL_GPL(housekeeping_unregister_notifier);

As I said before, notifiers are a horrible interface especially for
things where most callers are built-in. Especially providing proper
ordering of the callbacks is a badly defined mechanism as demonstrated
by the now eliminated CPU hotplug notifiers.

> +int housekeeping_update_notify(enum hk_type type, const struct cpumask *new_mask)
> +{
> +	struct housekeeping_update update = {
> +		.type = type,
> +		.new_mask = new_mask,
> +	};
> +
> +	return blocking_notifier_call_chain(&housekeeping_notifier_list, HK_UPDATE_MASK, &update);
> +}
> +EXPORT_SYMBOL_GPL(housekeeping_update_notify);

Why is this exported? Are random modules allowed to invoke this?
