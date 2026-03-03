Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0324D386C0A
	for <cgroups@vger.kernel.org>; Tue,  3 Mar 2026 08:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772525230; cv=none; b=rVs4QP/IUZskK1p6LEttXVFnMJYAiGyfCnO9xh60VlMPNFP96UUncvvouxLlpJKVhyMhbbmtuwxb/EWQxwjP4JXPZuWl7mMN75d45TKq3VkX+s7XdNUqwHwzWQcYg3fnupex+8YmD2gv/0hs6N5uxUWdLijlG+DLhra4vHX2xsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772525230; c=relaxed/simple;
	bh=Cjq8VkvXFRCxUngCrZxEWwlQepIVgF41nugKlaEpeBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HFjzz5mv3iqtHNKCIgyzOeOCC7EpK6xxxO6BBfot9uoQibdqF5QiDBA4YLrAxxjZIqcVcobF/oewPdGtu9XDSqCAA6HXxKz+yqQPCQ9SgfkhmqoX8NH+FhDhpMMxSIlOLZuwC4tzVa4oANQ/FosdjmNBfEA11cMf11HpLV6VWy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ud/YZkPH; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ud/YZkPH"
Date: Tue, 3 Mar 2026 16:06:44 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772525224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EP+zAnJ+UxTB5O6daIsb9DhZ3FbIUZFGJrbg3N0r1PI=;
	b=ud/YZkPHqub32UXTYjtmLzF4QYZzguG8X3rHXBC6lwzBFf+n9C4xn3xSzDLkgg4HoCj4aN
	/vgd9dZJ1JYkvDijejM6FkFNEDoGZ+WGKHX9pFjQAhIKwuZbRbLAhIJzbTETtO18D57X7d
	4MBnl+MC+K4HjFHNX6Hg7pQt+1EBSpI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka <vbabka@suse.cz>, 
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] mm: memcontrol: use __account_obj_stock() in the
 !locked path
Message-ID: <e45q7htkmtf2uh7ry2wa3be4erlxtmw6g7v52qipdcatzhakgf@jjrlwpgkbig4>
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
> ---
>  mm/memcontrol.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 

LGTM.

Reviewed-by: Hao Li <hao.li@linux.dev>
