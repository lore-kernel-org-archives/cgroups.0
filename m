Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B03F318EC7;
	Wed,  1 Apr 2026 16:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775061877; cv=none; b=eITdiYDg5mJsQxBLLTZceo3UKpJlWvOkRhZiA3DbO71QpxKOIzdSOpZt5RFe8ewwcnaor/rAwWkcsAIR43mDgjj6WFCQeNUcaNJS1NAyUF18T1goBVJ+K+wWCxXVLB/QwoDwJzhVX6dKbjzpUJ9rduvH4oc/rG+c+PcGwQytmDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775061877; c=relaxed/simple;
	bh=iq//KXqZOjYC2twVYm1HleMs4iVAx+pB1nyZhEdk28c=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=HrAD6e4ovW8QqFcaUrS2REo4BkruZvjtQsKnbmFleMI3I7lI2l8mXrEBLf0BEXqF08bjoCY6ZRbIepghfxMG5SdXCey0e53oEqKDGlaoZbrNg1z9mm0Vzxk1lQi0V0b7qJxGPms438Ma2BJtqxQPNYIbVP+LfypAH9fsgTFgJz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t83NRmcz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t83NRmcz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DBF4C4CEF7;
	Wed,  1 Apr 2026 16:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775061876;
	bh=iq//KXqZOjYC2twVYm1HleMs4iVAx+pB1nyZhEdk28c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=t83NRmczOO0cMyNqAWnMMzAFCQWZ4uxYr9ha25Y06L/IB+bKIyE5VgtUFHeKgWg0J
	 qgpTX9DQySC96eevO0W7dcXR7oE4UuY60oAQUpUWXuES+wGN1Zc8e6zW5Qp/g45nWD
	 zWoR/9As7DMkw6JZzf2mUCoFRG8QYkkFzAu0+Vtw=
Date: Wed, 1 Apr 2026 09:44:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, David Hildenbrand
 <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko
 <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel
 Butt <shakeel.butt@linux.dev>, Harry Yoo <harry@kernel.org>, Alexander
 Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>,
 Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino
 <vincenzo.frascino@arm.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Muchun Song
 <muchun.song@linux.dev>, Hao Li <hao.li@linux.dev>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Pedro Falcato
 <pfalcato@suse.de>, Jann Horn <jannh@google.com>, Matthew Wilcox
 <willy@infradead.org>, Petr Tesarik <ptesarik@suse.com>,
 linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, cgroups@vger.kernel.org
Subject: Re: [PATCH] slab: remove the SLUB_DEBUG functionality and config
 option
Message-Id: <20260401094435.cf1d3ad4bf473c3ddc00c434@linux-foundation.org>
In-Reply-To: <20260401-b4-are-you-serious-v1-1-dcacda70647d@kernel.org>
References: <20260401-b4-are-you-serious-v1-1-dcacda70647d@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 01 Apr 2026 12:59:29 +0200 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:

> Since the slub kunit test depends on SLUB_DEBUG, remove it too. It's not
> a big loss, see the first point above.
> 
> Singed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

I love this one!

hp2:/usr/src/25> grep Singed-off-by ../gitlog | wc -l
62

> ---
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
