Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1FD442FD9;
	Tue, 28 Jul 2026 13:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785246069; cv=none; b=R4suYQrdwt2eumj0ApmWeFc89ND+7apDX+MJgSSYj/XE2HcCxpliQ3ogMD/KqANPB38a5yU8FnNC1jecki7aRXE8qKTKw/BuLuyO7eATGhQP/AQ6dodFbb8Ycr70oGVmXwuJ18YJ30rvqSxxEnCNBMcSEUgxIHGzbBo36OIup88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785246069; c=relaxed/simple;
	bh=ru0MW0y+6goWdkxzMFy1sZveEFFemrh0Cm7fE8zVtX0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jlHB/tytS+CannXdFSXGOoywM8ufdOwPCegEiYhgXeBjxZKStveCTuaZSze3H5nqDZ/E15uEFB6Ru2AlGIpgtnIrlfdn5WLEdaN2PT51YBywWIR0S6UC0FdS89WvuV2YC5XEC0QLU0kvIzjarsWN1Oar6ydsZKI25cIK6uo97fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UTxr3VNy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UTxr3VNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6EE51F00A3A;
	Tue, 28 Jul 2026 13:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785246068;
	bh=49vOlsz1vvSn3SCusf03wXkOOjUxUytKDLaGyr4qNYM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UTxr3VNy09n94NLv23qtAzTfJAA1tzEh2FT706IWQisOEW7UfErgqD9/+hBykrauR
	 8LBOQvvAl+S6cBuiTJXI4cSv0RFmgG345khRwwn5u4ZpChG1RhnYj3GltUYUqF1LJH
	 3HnK+A3hKFgBngyN92rXLeZUgJdJdzpvOCuWD6rrfsaK22so0qb8+TP+yDTgY1wg8i
	 KbI0HgyOU+osu7cywnY7Kke5ZYiNYxB6YK7n0ULro4YSy3CtRVPB+QZLnbJsOrSYF4
	 0iff+EZlgIBpjWai1w9efamVUYuLX+hMcBQrr9VHaY4dI/kEqOgJoihdcrBVHl48a6
	 Fh9JjZw36hSsg==
Date: Tue, 28 Jul 2026 22:41:05 +0900
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 06/13] mm/slab: abstract slabobj_ext.ref access
Message-ID: <amivCT7AaPux-GSK@thinkpad>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-6-c29ef0f1f257@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727-b4-objext_split-v3-6-c29ef0f1f257@kernel.org>

On Mon, Jul 27, 2026 at 02:54:00PM +0200, Vlastimil Babka (SUSE) wrote:
> In preparation for changes to the structure, abstract access to the ref
> field with a slab_obj_ext_codetag_ref() function. Rename the field to
> _ctref to make an unexpected direct access a compile error.
> 
> No functional change intended.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

With a suggestion: it would be nice to have debug warnings
that trigger when slab_obj_ext_codetag_ref() is compiled but
not supposed to be called.

e.g.) for kfence objects, or later in the series when we
reduce slabobj_ext memory (!slab_obj_ext_has_codetag()) 

Similarly, it would be nice (later in the series) to have a warning
in slab_obj_ext_objcg() when slab_needs_objcg() returns false.

>  mm/slab.h | 10 +++++++++-
>  mm/slub.c | 42 ++++++++++++++++++++++++++++--------------
>  2 files changed, 37 insertions(+), 15 deletions(-)
