Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF69E425872;
	Thu,  1 Oct 2026 18:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790880225; cv=none; b=UQMQRL9MzKBB0BV70Yb9O4l677yvgub7jCT2xv0ElOywH2eQSYnDNARfgUROg7qEY5l8YklEG7eYIUQdSurq6M0rLnIPezWiXnWp9hmMHkVbIKzp6C4mafNgqVUs/gBcP37brjduygBxGAS2p0h79/2uPZ4u+9fnvgex1EgRDSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790880225; c=relaxed/simple;
	bh=fQh5POTK+q9BTx7WT1J4poQSlvm3gOoIRiWfRW/aGc0=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r90pLUMN9wX2ni/7Y7bCCR1dNm5OzYenUasUfXdA6rjECg4toaGwwP8HXp3dfTsZ5sfKotj1NPqxMtzIxzpEpxqAMGqhu6rUYLyreV6KN3j4g4PnIZtqcIwba+W6bhGfDK3bbMdIy63nOKrQvglocT0afilSjqKJ4n7Hyismx2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZXHKEJiH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZXHKEJiH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A06981F000FF;
	Thu,  1 Oct 2026 18:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790880221;
	bh=Nf7k3kUZJ8lq1fxACTFvD6heNgFRBaaOnt6+P+Ou9hM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ZXHKEJiHam3Z2xUpQMDGRKdXcZRxWTOI/dwRFHVYOszxIyjzXh/2KukXPW5tcl6+v
	 5qXOQIL9wrwUJHtf5jzaTWLy2Z83KOGJeqqy6Buv03l9TZqulFqoiLscBARN4GZGzX
	 Fr3btU8qMBKAe5LomhIa2cKvT2m8V8Cka5j4wJgcTBrUwd/lWbXW73ScaIkA1yLcn3
	 a0u65q04EujCObMXKy8nWmY1Jz/aCW7m+k+LDlbgTOkkFX2Cs/H3xlwLiBZ2cAejsf
	 tY3qJke5nvl+aDB0xe9MuWUD5j1YJvx470DP3iuL4299Zxj3vJSTktKdKzQ/pNadu+
	 oq8pn8LPrT5FA==
Date: Thu, 01 Oct 2026 08:43:41 -1000
Message-ID: <f5e9ef4614d5f9ca4b7fe6420dbf8454@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Liz Fong-Jones <lizf@honeycomb.io>
Cc: Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Xin Yin <yinxin.x@bytedance.com>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ian@honeycomb.io
Subject: Re: [PATCH v4 1/2] writeback: let foreign flushes reach dying cgwbs
In-Reply-To: <20260930-wb-dying-cgwb-flush-v4-1-bde637803a96@honeycomb.io>
References: <20260930-wb-dying-cgwb-flush-v4-0-bde637803a96@honeycomb.io>
 <20260930-wb-dying-cgwb-flush-v4-1-bde637803a96@honeycomb.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello, Liz.

On Wed, Sep 30, 2026 at 07:35:37PM +0000, Liz Fong-Jones wrote:
>  	if (test_bit(WB_registered, &bdi->wb.state) &&
> -	    blkcg_cgwb_list->next && memcg_cgwb_list->next) {
> +	    blkcg_cgwb_list->next && memcg_cgwb_list->next &&
> +	    !css_is_dying(memcg_css)) {

With patch 2 switching a replaced wb's inodes to its successor instead of
flushing them in place, this doesn't matter anymore. If a removed memcg's
wb gets replaced, the successor takes over the inodes and stays in the
tree until released, so foreign flushes still reach them. I asked for it
against v3, where patch 2 only kicked writeback on the old wb. Can you
drop it and the description sentence about it?

Thanks.

--
tejun
