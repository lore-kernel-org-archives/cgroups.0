Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793793604;
	b=d/IGQO/f4L9UOcaIiuWfzlFO1dFDl9TeCxDHMCcFt78Xs0LvhKTFuFORUiOm9ni0j8s1
	 645qg0djJy8sHjY+grmfzcQT8QFI0pX+VnRBVcY1Cj+a/NXC2xQ0QrShfDoLj4ft2leiu
	 Qyrd6aOqKtI960YhKrG1l0QcPe4OeLRe17EdGBPRQKq1Y9hRKBeGbFp2ZyE3SL7Ow0xf1
	 r+Ct+/v8+VHN4SJL2usEERk5CQv5JMznTbE4ACCwOjyZ2Qw7z/Mgs7nJ3bvdNZJKcBdy8
	 59AxRLUW7MQIXpe23JaOl1TkV/i2m/h9g+BD3hN3K1gHnEK9fLg0h64Fk2cRrAEY1eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793793604;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=jJ8X7ehvFW1TVL5y6djFbsTpKjfmqXVJak4szFfMMAs=;
	b=PQSQ8XoUXi1sWytGpxUNZ/Qf95R0FVGScfH5CpcryhfTNOS52nmV+QheI0Knh/66P1Of
	 zoF3b2RZTqjL51JidJuaLQxR91C9aVgSTB6kChRXjV/NmNGU1MuTbI0gDXn3PIBUoSFDK
	 n8lVJ14ozBj+Ou42J1DXWDauL/pk17sRPViYqvW4QJeoUnbuv2c0B5ujvHQeFC3ibHp8u
	 Uq0j2/PGvPQfmlkI+oOnAFYnY7pzDbLaPgH2nh+3LnaPID6Z2a/P5BD2vhmEyKnE1zqWr
	 AUchVVt27IEMSxwFmyWohYOWnT5s4rdPxuysI463BVBZ2syP4PJ5dxzJJgQXQJR4ZYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gu+FrPnq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57B8606A32C;
	Wed,  4 Nov 2026 12:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gu+FrPnq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A301F000C1;
	Wed,  4 Nov 2026 12:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793793603;
	bh=jJ8X7ehvFW1TVL5y6djFbsTpKjfmqXVJak4szFfMMAs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gu+FrPnqdrGmlJP8rTwsTc3xsSUf+Vsia3jvIyTityWnn8TvjEd+mK9AMtrhRn+ww
	 Pte6DhgOcR/eDe0Mt6yxZ89tc/Q2ZWrfHf8Wj6/AUrR2b3H13C96Sf3TxVSVdZq7Cv
	 7QDLYkvfDZXJV4JnAH6IN/UhbS9j/IzwB1T7vwtaX9pcjv9ncdi+9kodKrsew5MWCi
	 JFVCcZBUybJrplG9sox03+J4OMR3ayamgY0ZpGV1Fsh0teewipxFsSRYIIwOzkzYPV
	 OAeW+lPuicqKYpZ2YKUxnefMLDXn55qr81P0rzYuhK1GdtjwoVzn9soLSlbsTnPRtx
	 DhQzOC2ZEIETA==
Date: Wed, 4 Nov 2026 12:00:01 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, kernel-team@meta.com, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH for-next-fixes v2 1/5] mm/memcontrol: defer
 obj_cgroup_release() to irq_work
Message-ID: <ausdFvI5XyDNrrR0@thinkstation>
References: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org>
 <20261103-kmalloc-nolock-fixes-v2-1-19167cfe4779@kernel.org>
 <b181dade-ffa1-4b58-9927-8a2429a59ac1@kernel.org>
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
In-Reply-To: <b181dade-ffa1-4b58-9927-8a2429a59ac1@kernel.org>

On Wed, Nov 04, 2026 at 12:02:55PM +0100, Vlastimil Babka (SUSE) wrote:
> On 11/3/26 15:47, Harry Yoo (Meta) wrote:
> > obj_cgroup_put() can be called from any context.
> > __memcg_slab_free_hook() puts a per-object reference on
> > every accounted free, and draining a per-cpu objcg stock slot puts
> > the cached reference. When it drops the last reference,
> > obj_cgroup_release() takes objcg_lock, frees percpu memory
> > (pcpu_lock, via percpu_ref_exit()) and calls kfree_rcu(). Each of
> > these can deadlock when the current context interrupted a holder of
> > the respective lock.
> > 
> > Defer the release to irq_work. llist_add() and irq_work_queue() are
> > NMI-safe, and the irq_work runs in a context where acquiring a
> > spinlock is allowed.
> > 
> > Add a separate llist_node instead of reusing the list/rcu union
> > because the list stays linked until the deferred release. struct
> > obj_cgroup grows from 56 to 64 bytes, but both are served from
> > kmalloc-64, so no memory is additionally consumed.
> > 
> > Closes: https://lore.kernel.org/20261001044056.75079-3-kmehltretter@gmail.com
> > Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> > Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
> 
> I guess releasing objcg isn't too frequent, so it won't matter that we make
> all cases use the defered work

Yeah, objcg release itself uses a global spinlock (objcg_lock),
so I think this is fine.

> instead of somehow trying to do that only in
> contexts that would really need it.

... and this is not easy as the percpu refcount callback
doesn't know the current context.

> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks!

> since memcg tree will be used from the next cycle, we can just keep this as
> part of the series in the slab tree?

Ah, I see. Will do.

-- 
Cheers,
Harry / Hyeonggon
