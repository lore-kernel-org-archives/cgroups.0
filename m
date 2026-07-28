Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D157C3B6C14;
	Tue, 28 Jul 2026 13:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785245079; cv=none; b=B8aD3C9cdAsvdknP/doQPuAn3RcZjqXl2jRzEl40HN0rZiWzlzIsksnXEAItBlGFzK8URQuzY1Xx2MpwLC49DYXtJKyW5nfc+2o6MmeJyrXILrpTZ29+ZAWaTM9bC9zc0i+ivFc10ZVU4YgkNE7tlhhWzLzJf/IMGLzaufWBdZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785245079; c=relaxed/simple;
	bh=4glszNDGDkZCNUUib9wOB6hfAD9K8tlzhdm/to2C9Yc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TU7c6Isj69M7A+QuxsGeBqvnEF+2D3gG8pVVzn/qk4QDeiHqGD3tOmo6ZQOfDBy9qkxIoyR+FMGnCJElRzT1JPW2+0DW34yXbmQDUZIcTFNTNTUiMi/jfZUp2R85CpftTYxFpWNajecp80/068yhWmlFenKxut7BduXHyuBjIGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eKYfLsxN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eKYfLsxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280441F000E9;
	Tue, 28 Jul 2026 13:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785245078;
	bh=YJ6nTW8uRRvGa9uxb9XpHnqlyfY+CSFnQPSaLsTQkoQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eKYfLsxNclt8oE+pNYIIZIi8pjlDWK/9foqXxg9TrlmLgmTasTk/l1juxhuMe4KFh
	 r74dVpcD0ekm6fTkX3vxpxRUSUAh3K4RXTf1L+tVK8JR0GN96XAkFaDQT25rMuh6ou
	 5sAN0XzViUQf7i6nUy6qGwGS/gAsIqvGKW/mHAmodvzWi//0Z49sIhWrnaWyMkEmPK
	 9BSwHL2jvVc+hlgpOKqq8X3dakUvPvwbBBuxc6WbwdDJbPZfhQ0g+wBrQ+Gv9zsaAZ
	 mYUkDGGsOyQYJ75sD0hP3TIDNNC3DcXG2Sla0JK2MGO6huo8htG009HntZtEXW5KHi
	 oJAC4nIm5QtLg==
Date: Tue, 28 Jul 2026 22:24:35 +0900
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 05/13] mm/slab: abstract slabobj_ext.objcg access
Message-ID: <amitGGcHyVXBdpOI@thinkpad>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-5-c29ef0f1f257@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727-b4-objext_split-v3-5-c29ef0f1f257@kernel.org>

On Mon, Jul 27, 2026 at 02:53:59PM +0200, Vlastimil Babka (SUSE) wrote:
> In preparation for changes to the structure, abstract getting and
> setting the objcg field with slab_obj_ext_objcg() and
> slab_obj_ext_set_objcg().
> Rename the field to _objcg to make an unexpected direct access a compile
> error.
> 
> No functional change intended.
> 
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
