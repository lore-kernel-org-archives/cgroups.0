Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0C3453A59;
	Thu,  8 Oct 2026 21:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791494717; cv=none; b=f0p8yBEytPbGG6VWiEMb40c49vkaKks2RY80DrNMC4mYedNARxnucV/aW8JZhbmhA9bpcjb7cOFJ1xh2fm6wNmCzMlNqrpNA3s5YTYwevyodMGDxNw4A8eSyCiELYHWh/jPK9A0qY51kO5sZZ0jNOpwYcOnpIZji6hJtkUvHgj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791494717; c=relaxed/simple;
	bh=uPub7OsJ8q3R9qEr6Szplyq7ywrqFt4oHq+xrWrCVEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TgfNLq068SW8JvyjLBUfK4rYfe44iaR7vTgwXQl8rUTK84xlT3a56OSbg6kchHGBTkdH+R4hXs1ACQO70EW3klk7tzGSFRdGemnghhi+CA23qBSejEW116a1C9nX0ifllC2iSB620SIbZnpqm2rG5xX22llxxcL4ird0bAa+TQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZjJl/wo1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZjJl/wo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B5F1F000FF;
	Thu,  8 Oct 2026 21:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791494715;
	bh=odDRkTcjbS423eFUVzRKgzpHhfm86iv3G3/SNcHY7is=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZjJl/wo18DivxZod9Ph2FuLJmJ0Pe6BmpQB57sdezehMYyARbOEVU8OGYlasU7V/S
	 0AT+zRfhasFu1NUWqERoTuQdlxiQP3IIeICSISEgSyXXl35VozAJVTNxB2bysN99vf
	 JfipJu9WkWWRjdDZiddIe/cXmY43UZwTIiDZnEwIxtK2IGH0UoFZxfezn7ejJCJdq4
	 QGd6BQqNjD2yQzAqk9ixMc4c11z/zcWVonaLCd7MlyrrU4sbCkmiHW5YBwRkvRDG8U
	 qZmSxy/lRaMiD4+hT2CFnuTLIH1WH3eg5IzgqjHuPhhOOpSdCVlAbQNo7AT/fvx+ph
	 VX7EkFoGAlt2g==
Date: Thu, 8 Oct 2026 23:25:13 +0200
From: Harry Yoo <harry@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Andrew Morton <akpm@linux-foundation.org>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Pedro Falcato <pfalcato@suse.de>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Willem de Bruijn <willemb@google.com>, Jason Xing <kerneljasonxing@gmail.com>, cgroups@vger.kernel.org, 
	netdev@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH net-next v6 0/8] net: skb: isolate skb data area
 allocations into a separate bucket
Message-ID: <asgAh4mrr_yd622U@thinkpad>
References: <20261006092030.got.500-kees@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006092030.got.500-kees@kernel.org>

On Tue, Oct 06, 2026 at 02:20:26AM -0700, Kees Cook wrote:
> Hi!

Hi Kees!

Was hoping to say hi to you at LPC but I missed the chance ;)
Maybe next time. Safe travels!

Uh, my mailbox stopped working for a few days as I forgot to renew
subscription. (Kiryl told me it's bouncing, thanks!) Hopefully I didn't
miss too much...

> This gets the buckets able to handle memcg (GFP_KERNEL_ACCOUNT) with
> isolation (since it's common due to AF_UNIX),

Cool!

> and GFP_DMA with fall back
> (since it's rare).

> It gave me an excuse to build out bucket kunit tests
> too, and that (and LLM review) found a couple other issues that needed
> fixing too, including msg_msg allocations going uncharged to their memcg
> when CONFIG_SLAB_BUCKETS=n (fixed in 2/8).

Oh.

> Harry, on your v4 question[1] about bucket users giving their own
> alignment: I tried that in v5, but a set's allocations don't always
> come from its own caches. With CONFIG_SLAB_BUCKETS=n, after a failed
> kmem_buckets_create(), and for the DMA and reclaimable fallbacks, they
> come from the general kmalloc caches, which can only give kmalloc()'s
> alignment.
>
> So v6 goes back to mirroring the kmalloc cache's alignment,

I might be missing something, but why is that a problem?

For kmem_buckets users, the reason* to specify alignment is because
they might need less strict alignment than kmalloc.

(*Perhaps it's nice to document that in the comment)

However, because kmem_buckets can fall back to kmalloc on e.g. kernels
w/o CONFIG_SLAB_BUCKETS, it should be fine to fall back. No?

Creating kmem_buckets with more strict alignment than
kmalloc doesn't make sense. 

> and drops the ctor and flags arguments for the same reason.

Uh, for ctor and flags, yes. We can't have them in kmem_buckets.

> And the whole
> exploration made me realize I had a completely wrong understanding of
> how memcg worked. :P
> 
> The bulk of this is mm/slab, but the final patch is netdev, which Paolo
> acked in v4, so I'm hoping this whole series can go via slab?

Going thorough slab/for-next sounds reasonable to me once it gets
some reviews.

Vlastimil?

-- 
Cheers,
Harry / Hyeonggon
