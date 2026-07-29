Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AC42877DA;
	Wed, 29 Jul 2026 06:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785307261; cv=none; b=TloZINfxKNIM9sxiY5A9YCywn6PVK3tlZqUpYBAp4xga+7zf8tQZuThKqkyqMUf2x68Plu+jqx3Y3mvmSobEtQ1rtM8m1iL4NhSlhoID+6IQFEb7V+OHOwpGgEi0JK1iEUU5fFloUzkzcDBP5bPhvZ2MLLwMvnyHMfl0PC+3kYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785307261; c=relaxed/simple;
	bh=Gjr+SPEN/khoSfSsCZZAaZFy1cjB7tcQFOXmwxDkf9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UWXujnJP4M97aLLSmT5C3/L6xrlgZJ05ueyCUfCKOhCHl8x7h99TB+B1bsb9/vFj+V8PyjP2O2wo4B55XrqUYLBPjNlw2gBsS0XFuRGleyN7ydEhtZAY2qRR9XNBvsQEpsZfJLfQSt2YRtYDReFShGbFGiGd73moVmKUi5u4D2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h/0JUvwr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h/0JUvwr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C3E1F000E9;
	Wed, 29 Jul 2026 06:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785307259;
	bh=aJ+OYo0jt+7rELKxSKj63C782hUiaz6ZZJLz2l3U6Os=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h/0JUvwrqc9fADdYseINnuUR81h0pXXKxeyvG4vnTsM35njoUbwZSEWo09fw0WCpN
	 h+tgKdMHVHw3x6r/HjuZnAC+ELyh2JJzhDRGjSJU2omixz7cX4r3bQAwy/S4ldY2le
	 ReLMjgqoU6252ken+TyS1q/mANDObeevQS33DrY0K8bfkPEEld0y9pSweCadeKStvO
	 M/VADi1/oYAAft8yswpZc6KQwI1ECNYcDQSiwEqqIsavRlWGJ8JwJSTQnV5WFxRX1q
	 SbxrxW+VhZ78tPB52sv8Q2yFuw9RwG3/mrD2ddNazOX3YPbhH/f33XG9OsmxX5jCPu
	 XDpe4tQrka7RQ==
Date: Wed, 29 Jul 2026 06:40:57 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 07/13] mm/slab: replace slab.stride with
 obj_exts_in_object
Message-ID: <ammbWxBtX7KxgJ5R@dev>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-7-c29ef0f1f257@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727-b4-objext_split-v3-7-c29ef0f1f257@kernel.org>

On Mon, Jul 27, 2026 at 02:54:01PM +0200, Vlastimil Babka (SUSE) wrote:
> The stride field is used to convert object index to an slabobj_ext so
> both compact arrays (kmalloc() or in-slab-leftover) and spread
> in-object-padding obj_ext layouts are supported.
> 
> In practice thus the stride is always sizeof(slabobj_ext) or s->size.
> 
> This simplifies the calculations, but with the upcoming slabobj_ext
> handling changes, it will be easier to stop storing the stride and
> instead just have a flag whether obj_ext is in the object padding.
> obj_exts_in_object() can then rely on this flag and slab_obj_ext()
> can use that to determine the stride.
> 
> No functional change intended. Performance impact TBD, hopefully
> in the noise.

Performance impact is not TBD anymore?

> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
