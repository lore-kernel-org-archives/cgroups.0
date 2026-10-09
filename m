Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9AE8C1F;
	Fri,  9 Oct 2026 01:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791510023; cv=none; b=iPBhOulngKcH+uizWTDLYFEQokyZz5FvNWJ6AIF3MEsvBrH4gTp2aSyrHiTmuXoGTNYcVNHUgY2I+dKy4bpXMe6fAmODNjShqoGJxNKp92lMS69DqBNY95FqaaUPynIKm74P/z+eflYjMjZD7ZvOWh42+XlhGMyrlbqkQaxBMvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791510023; c=relaxed/simple;
	bh=LnbRgxgRltOWmQgvhln7KXPo+6/deA+tNGKyU2+Vu7I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QF0XlWqf6sa9eQesYLA0G7Q+wfYkcKdJqm/B8LC6o+KTh9LQ4OkHMCiJzvYaXF0sQfEzlF+ippkCax3PUCTeHYA3yv+1hml8XKxzGrS1EnnATAjXE9+NJkenYQPs0Tq8hsd+2rX5XuRNuaMrKTg7V6gR7YIHaWR6WDsri6Y43bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LPcvwB8t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LPcvwB8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E2A1F000FF;
	Fri,  9 Oct 2026 01:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791510021;
	bh=sonlmmEbsMw8bb8h1L4x7UUPh61JSBta553UffDZL6Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=LPcvwB8tyoWplYkcjrGGKzxhYDkOKYV10BGcdZc1JNR4XGatGtc+PxpptAUACHsE1
	 12q+HFsPMpBbaqKNpWOYNqkxc0UFZuQGRVjG0ZDJyTXAKJ5OnFua2738PtmeS//+Zx
	 sIT1dLHzFBwk+4VHLOtNQ+dahzCV7l0GIyVyamud21wc3ekSnGaOymUTKTMn+xErYP
	 3Dwk93r2VlVMnvprK+/dw9oW+l/YDAGn7CQOjiJ+j+7KOgeCbuYNKe3m0V1rmmeggA
	 IyZu8QpVke7nIkRJf4R2CGVjt/KkXtLT9+r2bt9kaV44tf/aMbGyER4VYEMkPwKqR7
	 ie09JdWQh/s6A==
Date: Thu, 8 Oct 2026 18:40:20 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 "Harry Yoo (Meta)" <harry@kernel.org>, "David S. Miller"
 <davem@davemloft.net>, Andrew Morton <akpm@linux-foundation.org>, Hao Li
 <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes
 <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, Johannes
 Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
 <horms@kernel.org>, Jason Xing <kerneljasonxing@gmail.com>, Willem de
 Bruijn <willemb@google.com>, Mina Almasry <almasrymina@google.com>,
 =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>, Jiayuan Chen
 <jiayuan.chen@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
 netdev@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH net-next v5 0/7] net: skb: isolate skb data area
 allocations into a separate bucket
Message-ID: <20261008184020.666ef78c@kernel.org>
In-Reply-To: <20261002231120.late.500-kees@kernel.org>
References: <20261002231120.late.500-kees@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  2 Oct 2026 16:11:20 -0700 Kees Cook wrote:
> The bulk of this is mm/slab, but the final patch is netdev, which Paolo
> acked in v4, so I'm hoping this whole series can go via slab?

SGTM, I wonder, tho, why you marked it as net-next in the subject.
-- 
pw-bot: nap
