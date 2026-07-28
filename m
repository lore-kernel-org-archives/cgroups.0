Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DCC437859;
	Tue, 28 Jul 2026 13:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785245117; cv=none; b=SLJ8bhTfpuuoFq7Lmd4IwNpx/Vju1NaMfOSv2bFRZA+CMi3nVz0SPa83l1eIMjaCKgJutqRGCyJV7DhqH0qyIMEvZEIChXr2xELsJtEMsNQ/sk4JV5uQB+HLZeykOu6ACErlD79dtNP5cVzYxETvtwkTZrDJgrIuSQCsNNjvKsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785245117; c=relaxed/simple;
	bh=4glszNDGDkZCNUUib9wOB6hfAD9K8tlzhdm/to2C9Yc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PyYQdNPTDdoNgctGKOuNnFzuoXVF5xuWmdJqPqcoHQH3vVk10kTZ45bpfSVZHjix6zx7IHgVuFSLNqUrAJ7g3EcpvZFMDCQR0m/QBHwrHPZlUd3drD6StVJqMwkUPSe7SplP7HWySjvr6YbbDg13UIsZY6EU1a3o91Q6LbfNhOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VaJ4jUWV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VaJ4jUWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3936B1F000E9;
	Tue, 28 Jul 2026 13:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785245116;
	bh=YJ6nTW8uRRvGa9uxb9XpHnqlyfY+CSFnQPSaLsTQkoQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VaJ4jUWVuOmuzpDqjmybmjd+t76vdlUgJE4E5RC9QK/aLvtmgtBAF7/Jgny7U+PT8
	 7zG16BN9At68+LTxJz+jBbFmu2bS3Fl4HHMk0ewnQeC/pVVJXVNDSoHmpAqo00iisl
	 GuEUmHWXHt087Dza2+d6mpaTYTacALG0oTgh/k5NUYl5eo/6x9zuwPxcvr5twpx3oz
	 o39/wu/NTJo8slYtSqJI7WQaldXhYgQV86x+LZIgCAgCsddpq+HDqd/CidxVQwzBjN
	 JI8rnthiDC9cObvsUwgpXnj4Z7oW36vaEeQwnSuMv5SqqiCVPnl1vuJplgI3F87KZj
	 15GjoMl7aCGgw==
Date: Tue, 28 Jul 2026 22:25:14 +0900
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
Message-ID: <20260728132514.EQFEIa_TmuURcDcjuFzEEUVrRjWxrNyE1TUZyIWSV4A@z>

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
