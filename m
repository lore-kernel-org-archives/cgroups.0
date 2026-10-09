Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A15749620;
	Fri,  9 Oct 2026 04:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791521946; cv=none; b=iJotFC8rux92sMmPB7h+X93h4wyJryBBEn4/8+Xk7opKP9AAPHEF6goOiTofEeDnxJzxFwMAh37UNQ1BZkTwKiVP6TawS1W91qvqdIAYjc3aiDZ82ZPzifVy6cnGjfCWWgUKpKzOafMQm5jYNx1HY0aNaoC5cfZsc3wIfQbSNCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791521946; c=relaxed/simple;
	bh=xgRNijzul8vYJlAaZrtpe7i0z8MV/d7+SxHO8+z1oXs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CfvYHSvsFh4jo3+yXgHxKOQUYBW0hdNbe9toRMweYdfFz13h9/zjebGLlW/+Xc0FwTHYbkMjTzusQ/41Yz/E5knuzpbW7TUDDFGJkXsqr6Rrw+4jhiGLLztYIcuTk8CZRsIXf6nnXWKjixq848KUS7v9zs2f9SGNAVfVp/xHQFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=al4jGM3O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="al4jGM3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2F21F000FF;
	Fri,  9 Oct 2026 04:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791521945;
	bh=pvwc8qpTFSOttTRxIpKEV19bQt6aeCiKQ4I6N4/P8tg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=al4jGM3Oh4hjRtjtRtUYgeoaAK61OAO+AK7xuCcN8L2CrIA6aPsiUhhhmyF3xwlIJ
	 kwaOJ3FYtPXf/yJ+R0AAEW9ub4q//U4QKCU/0W/7i25Sorse9nPOVbQOMhP3S5W2XJ
	 MdKWS2V2M1N8NMZbKWmlbPn4omNdEebTR2UoGge1v+N5tqEU9MKfkegXdFgizHUS4y
	 CS6Y7X3b885Bw5ZSMZRBVZc3GW+AjVO21xby+8FaKMpQ2C4UgRWjTecZONszFBeisF
	 CxIJnDakcFHGa39xXOEj42lJodQJkLOI92x8+V9Cp6XKZnt74B9vXqS7uGytyDGKtT
	 s2irS2skeU8tg==
Date: Thu, 8 Oct 2026 21:59:05 -0700
From: Kees Cook <kees@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
	"Harry Yoo (Meta)" <harry@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Mina Almasry <almasrymina@google.com>,
	=?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Kuniyuki Iwashima <kuniyu@google.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org, netdev@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH net-next v5 0/7] net: skb: isolate skb data area
 allocations into a separate bucket
Message-ID: <202610082155.E697E600@keescook>
References: <20261002231120.late.500-kees@kernel.org>
 <20261008184020.666ef78c@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008184020.666ef78c@kernel.org>

On Thu, Oct 08, 2026 at 06:40:20PM -0700, Jakub Kicinski wrote:
> On Fri,  2 Oct 2026 16:11:20 -0700 Kees Cook wrote:
> > The bulk of this is mm/slab, but the final patch is netdev, which Paolo
> > acked in v4, so I'm hoping this whole series can go via slab?
> 
> SGTM, I wonder, tho, why you marked it as net-next in the subject.

My "send all the patches" automation saw a file touching net and put
the "net-next" in all the subjects. I'm struggling to figure out how to
redefine this logic to not fire with a series like this (it's very rare
that if I'm touching a file in net/ that it isn't going via netdev). The
best I can think of is to check if the cover letter is also being sent
"To:" a netdev maintainer?

-- 
Kees Cook
