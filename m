Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794318583;
	b=5P+crmYWOxRPUPj9OtytVw0izvdlAxOUDVOJmq/49s9aWAZTEdUyFjMABQi1pZ5uaxcB
	 PRv3RSXeQNCY3ITCcIc+Yu+NwnAKqfUxmIB3jbS0C2xCnktdvjaabIntVFkqBL0q/G9MV
	 Vj/VkjNrSZ5WpSyI4cOGVg0Xe2rrMuuZc8ZSvM/rq0yk6ykiyTdp1SmpN8EAauyCMeWvc
	 uz/JP8hG+57jAmsjwguQN47rvMIPBcnMTHG5FKRYxOUr9DIF9HhvnCOnRw5MOxNi19dRV
	 bCkDm48dfqMRryUDhhmbKyu8aejRIejMMUVt52JiaBgCQ3T4/Ekx/ZHvBdJ+A28IVbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794318583;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=kM24Iv0O8Q0JTUrX0qb/LBnPU6JMQXqIqVQiqBU/VrA=;
	b=KF5z2/T4Z2m/Q6rppjV2Nym/QzJNFf3MQrcwsLY2Q4wG4T4ENWnHdE3d/IGVo+lrBB8a
	 1v4KcJuS2X3GgbYdatClnBYbcVjn+k2f7R2Ok2VTJcF8OUTI8vFr7oDZkjavsdtkviwKr
	 TVrqCk/xm7LpGl3U0tdzu1nnHD0yl8OR6LFxfj3SB1w8e3rIWS+J5McXnmrrhDG8QDzuX
	 jrxz+WnXIeCY3Qt40s9vxCEBuQCXQ0FWicwsufgZhKIx0YQ4/WYdQxe/KJxiBnr8f6PEo
	 5Dse1dVQE9lpTybRB0n/xiBLrAP93s0zu8GjXU1OezGScmh6INy5c6ORUGjVzkvLZxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FGxENUEx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BAC606A31C;
	Tue, 10 Nov 2026 13:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FGxENUEx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB781F0089F;
	Tue, 10 Nov 2026 13:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794318582;
	bh=kM24Iv0O8Q0JTUrX0qb/LBnPU6JMQXqIqVQiqBU/VrA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FGxENUExDJd15vnxkEJJOX9RFzx/yli0npWPMJNIfD+TXZS4mzFWYW4UssjxQKAgY
	 LUG1BRfLBAofJn0SGbwyr82mb4BNIsIvViWofIDjZYpFoDYFAp3ylSj1DL4Wq3Lfvm
	 jZSEk1Awn0SiCbl8jpkJA6VrVXxao31yIx4xDQ7ZwSt39p7uzjJGqN5Stv6XN+p1Wz
	 cthl7ukNH7qWaWL4FgcSl98mNRadY7vNiWB9t95FrklFFvnJi9u6VJxy+BzuyjshEY
	 Qd+sBN26cD200bgigwgEqeR3qGjnBTJO6Kq7sgujvelh5LAqaizjRMTlr/mG27bFPG
	 QMxhq0ls4jdag==
Date: Tue, 10 Nov 2026 14:49:40 +0100
From: Harry Yoo <harry@kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, kernel-team@meta.com, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH for-next-fixes v2 4/5] mm/slab: fix a deadlock in
 memcg_alloc_abort_single()
Message-ID: <avMeJWO5OF4GBe9r@thinkstation>
References: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org>
 <20261103-kmalloc-nolock-fixes-v2-4-19167cfe4779@kernel.org>
 <DMLSN9VHK0P3.2A97046A4YXGY@gmail.com>
 <auo5G__ac1qA9JRs@thinkstation>
 <DMLVUTB5J1RJ.2QKOUW6UB04ZM@gmail.com>
 <6441429b-eff2-485b-acf3-26c3034910ae@kernel.org>
 <DMMKUQVDEM0N.322USN1ZSYMCU@gmail.com>
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
Content-Disposition: inline
In-Reply-To: <DMMKUQVDEM0N.322USN1ZSYMCU@gmail.com>

On Wed, Nov 04, 2026 at 04:46:26PM +0000, Alexei Starovoitov wrote:
> On Wed, Nov 04, 2026 at 07:35 AM Vlastimil Babka (SUSE) <vbabka@kernel.org> wrote:
> >> I don't insist on kfree_nolock() there,
> >> but can we try free_to_pcs() before defer_free() ?
> >> Like:
> >>
> >> 	if (likely(allow_spin))
> >> 		__slab_free(s, slab, object, object, 1, _RET_IP_);
> >> 	else if (!can_free_to_pcs(slab) || !free_to_pcs(s, object, false))
> >> 		defer_free(s, object);
> >
> > Why not try free_to_pcs with allow_spin as well then, and improve
> > memcg_alloc_abort_single() for both contexts?
> 
> yep. Even better.
> The bulk side does that already.
> Like:
> 
> 	if (likely(can_free_to_pcs(slab)) &&
> 	    likely(free_to_pcs(s, object, allow_spin)))
> 		return;
> 
> 	if (likely(allow_spin))
> 		__slab_free(s, slab, object, object, 1, _RET_IP_);
> 	else
> 		defer_free(s, object);
> ?

Will adjust in v3 (hopefully by end of this week!)
Thanks.

-- 
Cheers,
Harry / Hyeonggon
