Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D95390999
	for <cgroups@vger.kernel.org>; Mon,  2 Mar 2026 21:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772488222; cv=none; b=oaP4z2HeQDaL00C1vXNvBZLJrzCuqgXPB8kypBqs9t8G0DRvcdVAE7C+gPg/dOhOi8GgV/snLo/TYXkAz4euPGOjPsCf6cMjvPXaLSgTAo2vTZeztcVjA9Te1kzumqp/AksQX+g/BQ+NMVHKbxUfX2CrKyegGxloPV/yfwTRhz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772488222; c=relaxed/simple;
	bh=cgT6xJCbJ12Lra1qmGa8eQqQTR/NIc0pK4vkLMywbq0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VakKtatclxStq9X2dhCWaaNbH7hRfcXkAW8GnosmicEbQDdI0vcMzWhsFGWSnLcLNmThZq+VTrB4TNCflSat49aDaUYu1EZbBmMOAsw8HArylkHgcQa6/idwk6ToNIiJlX2JrE3GOD91KxCrz1NfZHfPqE6ncJt7DgGlwRDhzps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=edsmp5Uy; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="edsmp5Uy"
Date: Mon, 2 Mar 2026 13:50:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772488219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k5lnpElzH3MrjN324K8FfMsrblMzRrAFN5P279ZSW+U=;
	b=edsmp5Uyhp5+B1N9dEt7Ode4WQXTQ5NrBczor22gjqdJcfVOgy70wrAFZ1cjUnP44vX1pi
	OCCncG5ES3YLQJaypPSomfxvS+r+TxAVX8YGBiYEbd+m7bAfZdlq0d+1BuQnPhIlZKC6kk
	2jCr/YsZcO2DQOo4yubQ0oMIb/HONPc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] mm: memcontrol: use __account_obj_stock() in the
 !locked path
Message-ID: <aaYF-8p5Gvh3Kil-@linux.dev>
References: <20260302195305.620713-1-hannes@cmpxchg.org>
 <20260302195305.620713-5-hannes@cmpxchg.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302195305.620713-5-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 02, 2026 at 02:50:17PM -0500, Johannes Weiner wrote:
> Make __account_obj_stock() usable for the case where the local trylock
> failed. Then switch refill_obj_stock() over to it.
> 
> This consolidates the mod_objcg_mlstate() call into one place and will
> make the next patch easier to follow.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
