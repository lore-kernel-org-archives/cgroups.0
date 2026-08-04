Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7B73911C0;
	Tue,  4 Aug 2026 05:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785821511; cv=none; b=QsnvbPkpYOnXkLdTm9ys16qHYZT37a6/d2V7n0777aoFGgYFgFFlGwDQG93pqKBPsYDOw3u12sIhwmxbFKnzfWG7pQkXz0h6N+4x5+a6ZAEkHOd2h1KQaQsmJ0xLrarpjp921P8ojS8VpftgF2kdLzGVwCUZIuO1FkFXRPyW9eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785821511; c=relaxed/simple;
	bh=30YaC0YdV0yibsriR2aAvFUZ1OoXZV0AqQt7Etp0lrM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ESKML8gEE7xl1HXl996dfIWyZK+Rbc8BDb5fOhjbjqBBXeIGJLYhynq0O/ssU7+xqx7QAoPXNWhkoE4zmlZZSjIO2cWe8ff5xwz8ipX/yG3BVhzGwcStCvAJ9W1YeoTU02wqfgtOBExSLCFIXW5Gekxzq+dUnRrXwrvyynJW6LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WLddv5q0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WLddv5q0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABABF1F000E9;
	Tue,  4 Aug 2026 05:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785821510;
	bh=GWSze+JX/3oEYUyGGs8rb9z8sW7IoswLYKzyMOmhZZQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WLddv5q0vwdR2xYLraz9KR0veci9iSW5Po2rsbrxSyBMZxLXxJEngBcJeXpvdD/Ok
	 0FZL+id0DfZ73BwBBIXVhd7921g2ZxPz2Gh0YNAhhNUot1rcaLm8Am0ffmf5Vtk5B+
	 3GCYE4RcHpfZakp8hv0OffEosDPXVAFI5LyQjXbOBxOrJ7NpHwmzyOu0xjOescVjcz
	 gx6pazGDhX/sVchNd5Lyf18AVcUyTC1+0QiaajafnxfzoQVUqvtHPNjTE+pRKqvxbR
	 YBO+91cb3UfrYplkvtEQT8qB/AJUh4IjRX5MbelB00cFU98UBeMgMjv4ALS7gPZBkT
	 rDI9rUVl3afqw==
Date: Tue, 4 Aug 2026 05:31:48 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 06/13] mm/slab: abstract slabobj_ext.ref access
Message-ID: <anF4v18W6-aKwuem@dev>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-6-c29ef0f1f257@kernel.org>
 <amivCT7AaPux-GSK@thinkpad>
 <365d8e50-5aeb-45e9-97a3-87d0024cdc5f@kernel.org>
 <ammZpX_77SMsxvPz@dev>
 <aa23851a-5f64-4f01-8804-07b735fc8afe@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa23851a-5f64-4f01-8804-07b735fc8afe@kernel.org>

On Wed, Jul 29, 2026 at 11:46:11AM +0200, Vlastimil Babka (SUSE) wrote:
> 
> OK, so updated to this. VM_WARN_ON_ONCE() added later.
> 
> From db9c3501c0f9747fda8fa92d4f640b6fac8050e0 Mon Sep 17 00:00:00 2001
> From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
> Date: Mon, 27 Jul 2026 14:53:59 +0200
> Subject: [PATCH] mm/slab: abstract slabobj_ext.objcg access
> 
> In preparation for changes to the structure, abstract getting and
> setting the objcg field with slab_obj_ext_objcg() and
> slab_obj_ext_set_objcg().
> Rename the field to _objcg to make an unexpected direct access a compile
> error.
> 
> The helpers take a slab pointer, which is currently unused, but will be
> used by a debug check later.
> Since there is no slab pointer easily available in __kfence_free(), just
> drop the debug check there. The whole memcg_kmem accounting in kfence is
> to be removed later anyway.
> 
> Otherwise, no functional change intended.
> 
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> Link: https://patch.msgid.link/20260727-b4-objext_split-v3-5-c29ef0f1f257@kernel.org
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Thanks, still looks good to me!

-- 
Cheers,
Harry / Hyeonggon
