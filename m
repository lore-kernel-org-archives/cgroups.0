Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13ECC44CAEE;
	Fri, 27 Feb 2026 16:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772209537; cv=none; b=LTQZLTmll4BzvW5RFpjJus63WMhyy0gziqb/Od+cDn9hfpAk8LwhGHieQhP9Agjd7V3WwrHzDsOcLqRsun6us0ueIU2E2gKvUSscg7tf5wwrZjNbkex2vhAugR3OkO9tEptj1jYWWCh1m5gAsxXWWADDEO0FbVsJvbKQT5i9To4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772209537; c=relaxed/simple;
	bh=7xEINRTAimo9zk78jI743F6BvgPfrdmSZbFfWT+92dU=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=coIuof3iko4gH4OBMoY3JO5Nabj+nUzSKHAPeYNBWDK+1AdK4Upf8Cu2eqLlZmlBA34vVf4Se1rj9JzkJk8HpIkL5NGWiku7aeGjcTDyYXP8F0pt0iB3vBieTl3vIaTGGy2/ebqZ5uM86+mu94Ru1BzTaiwR6+VY1ZN0Miv5Btw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KKzzvY48; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KKzzvY48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1F3C116C6;
	Fri, 27 Feb 2026 16:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772209536;
	bh=7xEINRTAimo9zk78jI743F6BvgPfrdmSZbFfWT+92dU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=KKzzvY48u5koshSFJjWshX08j71sHv+Vp0qJfkQtv5h4cGlYXTjGhtqg1zesBcPS2
	 OBkwaHxVe+49hGHff2PSxCY5Kbx5mkkvVgHMwGxsJIuqmPT+fV5Uaqw90dYTPBteVt
	 BdwhuU26H2QObnp6KVYR1ZQNS6hP+9afhKGinmyE=
Date: Fri, 27 Feb 2026 08:25:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hao Li <hao.li@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, vbabka@suse.cz, harry.yoo@oracle.com,
 muchun.song@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] memcg: fix slab accounting in refill_obj_stock()
 trylock path
Message-Id: <20260227082535.9c83176e7ab9f92f6b80aee6@linux-foundation.org>
In-Reply-To: <twvbu57mdw7ekw26spzzy5e6quq7k7hko3hvxttv6yjlhyuhpb@iolbg2iwsowx>
References: <20260226115145.62903-1-hao.li@linux.dev>
	<aaBM0fN8fqER7Avf@linux.dev>
	<e759dd9b-0857-4155-b570-cd002155f123@suse.com>
	<siuyozcbi5x6vusawdy3be5buho5y4qilc5uls7rgiihagk7uv@cfrr75gh4bty>
	<25f6a18c-0600-4a21-977e-19b8b4b203b2@suse.com>
	<twvbu57mdw7ekw26spzzy5e6quq7k7hko3hvxttv6yjlhyuhpb@iolbg2iwsowx>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 27 Feb 2026 16:37:16 +0800 Hao Li <hao.li@linux.dev> wrote:

> > Thanks, I'm sure Andrew will amend the changelog with those useful details.
> 
> Got it. Thanks.

I made that edit, thanks.
