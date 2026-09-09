Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119E0379C4A;
	Wed,  9 Sep 2026 17:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788976088; cv=none; b=oXO0+ZPfRmuAKTljod454s6TX2SYgHz/6T10SLmM2dq6VcNG1ZO8YpBmUhpIFn9PPXuB04HJBpHN5wWWRUbrOD6iZUraahhf6biu8RXKa0KSu+I/rN4n1SUYepJ5PFwiSNDxeXLzbBwLs8otDe/5lhXLK7GFpnkGvRhLnSe3qic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788976088; c=relaxed/simple;
	bh=swhipFGCgTw2+IQl8E66bUVOtf8/3I0VhQnKt+ABSJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LCmCAUIf7o7ywGpfI5/PloBesVfmZ9is+/Oi3Kyks0m720sUNAQ9wloKM/QRjgiwLPWEol1UtFE1oXze5UWiNdJEB8JqZH2cHI97YzUDfRGpjWJEtlV56gCXz3O9OvXb8C1oyuJzPgw/rbTxY80Ptm3VUJMPlbU/OwlJvX3dLUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RYZTmPpA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RYZTmPpA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C021F000FF;
	Wed,  9 Sep 2026 17:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788976086;
	bh=0lq8U7Nns721xEVNEIRFRaavqEdot8DXOm9Nf7pQSj8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RYZTmPpA8pOUPEq/l/KdVxECpY9zlGVpC7OgrBePY76UiJN/oS+ZtemULPuELihcN
	 6s+w/9No201Y5nQ73w+ddyzMNCp00I5OWsoyjWAfp6buWHqz46S8cmIilc6o/EOCe5
	 cCWdEI8mP11BTBYCxhi43XoZQ5Xv+gTTaH1qWYBiS0VRt1j7X2SSKrHH1qmlFJLL9B
	 49aNZX9a2lNDmc7hF8h3BZCPXsPSeVBTMali7pMufzWo0oGT0jymlbnD7riC9srhSL
	 YNqw7kfQO8scQzVHd2X3ysNyjue7J3n7hgMX2vUB9AApE6JHkMwKNghb/BXzqx+kYV
	 XTZf3uKp8lLYA==
Date: Wed, 9 Sep 2026 07:48:05 -1000
From: Tejun Heo <tj@kernel.org>
To: John Stultz <jstultz@google.com>
Cc: Hui Su <sh_def@163.com>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sched: Account cgroup CPU time to the execution
 context
Message-ID: <aqGb1ar23XBzdaKn@slm.duckdns.org>
References: <20260904034707.268416-1-sh_def@163.com>
 <appnKwylGK3QUIJ3@slm.duckdns.org>
 <CANDhNCq5iPq87=iKSJv-XzYzTYJ8Hp+bPJ6SoVfWB3pRa=HypQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANDhNCq5iPq87=iKSJv-XzYzTYJ8Hp+bPJ6SoVfWB3pRa=HypQ@mail.gmail.com>

Hello,

On Tue, Sep 08, 2026 at 10:17:45PM -0700, John Stultz wrote:
...
> But if it is causing trouble for the accounting, and you think it
> makes more sense the other way, I'll trust your judgement.
> Tentatively:
>    Acked-by: John Stultz <jstultz@google.com>
> 
> Eventually I think we'll want to track per-task "donated" and "gifted"
> time so folks can more finely distinguish the accounting.

Yeah, I want the cgroup base stats to agree with what's reported for
threads. This makes it disagree with bw enforcement but I think it makes
more sense to bridge that gap with explicit stats for proxy execution like
you're suggesting.

Thanks.

-- 
tejun
