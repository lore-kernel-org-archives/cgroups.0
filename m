Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792775771;
	b=pyxIiwdm9d9dNpvGUigwDomc1HafcdNSQH/SyLvTyWUJwBI/FKMsFNxlV/zo5oEZqU/b
	 pk8nitY/YcUiMvEGx/NoLms3VczN4sINqde/5/FdqfGoJqezIX8l1IJIIsY480skMl+BL
	 +ETBVum+smP9H+1zv533qhqNG6mPV0L61pvIgq1gVADrc6oi8BS7n3zV9juERHJoNyJSG
	 KtmHnsv5W+j3DOaIMJLE0VixV8X76vZxn20B4yygxoWXwVzrNlhHhWZxKy6c9YKnPKmX7
	 ZTKRPADzqxJO6dl0oFMNesGiWhDsH8eYOogOnZ7uWIZSpVYN1QsLeQ0lEVHfWP2SJVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792775771;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=ZgOlDzXt0WORbMUfnF0VlgyMvvT0T5eAjz5SOF8GRhU=;
	b=gP8q+t5PXpWAIohutWlHtKo2E1DxC/Ka93Hk+R6UdXQEZhH+BKLxOVFQVo2xK4i2ljD0
	 u80VlUYZeEeOjrptfXEXDCqvh6c3+gLErGlq07Cl+RrAndhGQQMCg9i3cUmWKIux2xdv8
	 lC0RAsFHP8ELgnAMpbnmuwXBYkI0hWjbDRoqUUDCWwRqj3F1H++CVnJVUwfx8ZCMnv0To
	 vBPBMpZAMe9PrA/n8Bh4F3hlUVqiXvtmbLJK40hcjjjRPgljcbRUbvvhN4hKVqrq73cA7
	 5dLjhbnGtlKmcdRK1E7pmit20G9lZsoNoyS4vL9lGgj/XplHxda+kd1Q85CcFLMqmFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X5Pwca9E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E80606A31E;
	Fri, 23 Oct 2026 17:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X5Pwca9E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033EA1F01825;
	Fri, 23 Oct 2026 17:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792775771;
	bh=ZgOlDzXt0WORbMUfnF0VlgyMvvT0T5eAjz5SOF8GRhU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=X5Pwca9EUxPYThC3UU+P85v8C6Iv5PzE97lR1YUEylE7EkfniLm+BUTwXVgYvwMhp
	 t4e7J3OJKQ8E+lgu5Kk9HquprfzFkVSvw7n0iD7ySVra1VKMFIjclL8p0v1goNrCXR
	 fj56+ZiQEYle87sGukT4i8Xasvrlc2o/59GHD8mK1Ff12Gvsl5xJHhu/GnTitnzjwU
	 /hfcQxNBlncyZml3JWeE7VWJGFJEiAxBcpRuZBKxD9UaXhw6JY341ltpnFjiTjkUiZ
	 Xq/Johu8y4K711XwaNlCNsy9fvL0YJes0puYhnKgSOGsunutqh5f7K5NlSTGxsug1o
	 Ua/KqX0IPQEFg==
Date: Fri, 23 Oct 2026 07:16:10 -1000
Message-ID: <f29f77edb2776b734306fd482b47a64f@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-devel@lists.linux.dev, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 K Prateek Nayak <kprateek.nayak@amd.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
 John Ogness <john.ogness@linutronix.de>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Yuri Andriaccio <yurand2000@gmail.com>,
 Yuri Andriaccio <yuri.andriaccio@santannapisa.it>,
 Luca Abeni <luca.abeni@santannapisa.it>
Subject: Re: [RFC] RT throttling, DL/ fair server, RT_GROUP_SCHED and everything
In-Reply-To: <20261023161348.t3lpPLQZ@linutronix.de>
References: <20261023161348.t3lpPLQZ@linutronix.de>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello, Sebastian.

On Fri, Oct 23, 2026 at 06:13:48PM +0200, Sebastian Andrzej Siewior wrote:
> - Remove CONFIG_RT_GROUP_SCHED
>   [ ] Yes [ ] No, because
>               _____________________

RT_GROUP_SCHED in its current form isn't widely useful. No major distro
kernel enables it (Fedora, RHEL/CentOS Stream, Debian, Ubuntu, openSUSE,
Arch and the Android GKI defconfig, PREEMPT_RT flavors included). I have
no objection to removing it.

There was an attempt to make it more useful: the Hierarchical Constant
Bandwidth Server (HCBS) patchset from Yuri Andriaccio and Luca Abeni. It
replaces RT_GROUP_SCHED with per-cgroup deadline servers and a cgroup2
interface. The last posting was RFC v6 in June:

https://lore.kernel.org/all/20260608121546.69910-1-yurand2000@gmail.com/

The effort seems to have stalled.

Thanks.

--
tejun
