Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB4044CF2F;
	Fri,  9 Oct 2026 06:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791527771; cv=none; b=h/bOPwVE+3duCY9S0wZwr5mZmLpzu+BKC29HkbwxCwsdscYLzgXn6RTafHuvFWPO4RCJB/69MoPFIvOilFtKlu4Dsvd4dPvn7pyZIUzHAp1fe1ChHbPmQYIE60GCBEGIYhyNuV/Ytt8I5EBX8+FizHhczaWKi6jSjBCX7S6gSR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791527771; c=relaxed/simple;
	bh=T/J4o4hDhA5TsOsEhsAJsZ6CJlOmR8oD1UmQSr37A/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L/XXsbZsaszgg/5u7axotxZ9XbXsy+fD2FZw8v24ijls2u+xyqthEH2anY5jIlPWkD3yChNu0vg9NQnjiZEMTv00ABjhYsxZupXbk1k6iS4eQzI39HvaRZW2FcbZXtrYD4CkRjCO9ALnxg/1rEJkmuIOQiqbEcGyvdzPqTKwUNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=adm/PXte; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="adm/PXte"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7D51F000FF;
	Fri,  9 Oct 2026 06:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791527770;
	bh=gDpTPyFrfxPK/Uf/lFR6lzmG1KtMFb1k0z6iyA57/Qk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=adm/PXteCoY9Ji6saNhj4L6Dqguia+KG2/3Nr+/ar0UHgfEYUz2BGq6wjJLDGi6F3
	 liU8vicxy2gTOqC4yZ0W5OeGkkJJC0uPn5qOX1/HqutbBsxs3TigwAPxmIwOJzmQ6t
	 nJ9Sn5WzLPXhkmfTQBgZ7He7WVdlb0idBiQIE27jcKbGTZ9QE5yYOtgsUds+hBZGoK
	 bGoPuCSWqujD6cXwPoHslFO++VzLMCWxK29x5mF0jrnvRXkWgGGVihOsEr+E4lhcXg
	 76j+4XTX5LIPQ0B539LHeDrjQVMAD9e+yoPSzyE0uAxVqGBjuhgxQ2a9XcsGNk7BLn
	 iGbpxQ869yG5w==
Date: Thu, 8 Oct 2026 23:36:09 -0700
From: Kees Cook <kees@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Pedro Falcato <pfalcato@suse.de>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>, cgroups@vger.kernel.org,
	netdev@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH net-next v6 0/8] net: skb: isolate skb data area
 allocations into a separate bucket
Message-ID: <202610082331.853F0CBBA@keescook>
References: <20261006092030.got.500-kees@kernel.org>
 <asgAh4mrr_yd622U@thinkpad>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asgAh4mrr_yd622U@thinkpad>

On Thu, Oct 08, 2026 at 11:25:13PM +0200, Harry Yoo wrote:
> On Tue, Oct 06, 2026 at 02:20:26AM -0700, Kees Cook wrote:
> > Hi!
> 
> Hi Kees!
> 
> Was hoping to say hi to you at LPC but I missed the chance ;)
> Maybe next time. Safe travels!

Hi! Yes, I kept trying to find you and Vlastimil but it never worked out.
LPC is a non-stop hallway track usually. :) I will try again next year!

> > So v6 goes back to mirroring the kmalloc cache's alignment,
> 
> I might be missing something, but why is that a problem?
> 
> For kmem_buckets users, the reason* to specify alignment is because
> they might need less strict alignment than kmalloc.
> 
> (*Perhaps it's nice to document that in the comment)
> 
> However, because kmem_buckets can fall back to kmalloc on e.g. kernels
> w/o CONFIG_SLAB_BUCKETS, it should be fine to fall back. No?
> 
> Creating kmem_buckets with more strict alignment than
> kmalloc doesn't make sense. 
> 
> > and drops the ctor and flags arguments for the same reason.
> 
> Uh, for ctor and flags, yes. We can't have them in kmem_buckets.

Yeah, and given that these two, I'd just prefer to keep it a direct
mirror for alignment too and not allow for any configurability here:
they are supposed to be direct stand-ins for the general cache.

> Going thorough slab/for-next sounds reasonable to me once it gets
> some reviews.

Thanks!

-Kees

-- 
Kees Cook
