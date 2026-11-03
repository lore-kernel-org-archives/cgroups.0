Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793701849;
	b=RZwkss73yh0cXoAgxsyxkxhLKI5R43mVekGFtt+4uV9tRbq19lc/skh8WHNCvMnOjY3U
	 EZUod9MKgwfNXAKrhFdR+8QXIX4ek/qRKoRat0zKmrpWb46N62MIiDAtH69BKRpe+4CuB
	 ZlFY9yHCm3dplOn0s9hgUYLsvelFietEMdAD8DG4zERXhxJe5uRxxkEk9fHxtdlNr9Ula
	 nMNkvyFFMfvVzxZ1H/dE0ymWNfIDlXh9kY/B/6HOzx8n0iwrAmLv1RZtvZIZsEXB5mzDr
	 7Kg0ZihKvhQfNjCzDnU4PxFP+DZPJU2qnQWMD14NtxghjdaZi5xNjHUjsTmGhDJYSCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793701849;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=LX5axVMOj5+LNVZyhy4UCdkzJORi67a8TUGxLDQdgqM=;
	b=Qz1TF/QQAEsnPJbpBCJDueULQlDL4gCztMvtFImcoQfPIuY3opeDOpEtm7w9c4Jwopjy
	 Wn9swPW5X1i0AdRZ2xE4F1WZ/SC5HX7Z57Kekse5i/S9PcVDls+1W62jZhRSPDmL9WEgi
	 nGGbotxDAYfPcB6q3H4cUmIZfS7IAgWnlC3iKQm9C1MRtjbX+z577meScyB2U+r2oBny2
	 OWbTnA+DLTxY9oDY7gF+FAnxLnsVNj9xTz5HVW/LPgqwuFggnrSr+w7pRzSt/VnqIW5NV
	 o00iimzXM3jSc/ephUTgCSKohIx5AllGlCk232/bBsFzsrRm/qzzIiq+t17KMF7SXWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=KKHEULN0;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C46F606A80F;
	Tue,  3 Nov 2026 10:30:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C46F606A80F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=KKHEULN0
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LX5axVMOj5+LNVZyhy4UCdkzJORi67a8TUGxLDQdgqM=; b=KKHEULN0j+MCzFZ2EutZManWvB
	LmBQia+tFgoDG59w7dfEnXAlthauE4QnZLP2ATUDk3D20PfCqkdgvgWnvYOlFf3ceGeRRbeAmflTt
	xT+ulMNsxH7v979tCE7q3nHc9I5DWueD54k20FIC8AcQshbjhz1dUPn16w/8OFp1m5CDtmNEmpfKt
	84M3RSzGKk2d9dNIuZ+hi0x87NoWz3vfBenEpCV5N6uIPxCxv0vrgPBjxR4vC341k46mAE7cuR9v4
	mlOyZ2VPlcsfaBDezZcaWkn6J+u/fYtMjnKzPZ8jmDM6/L+SBxvz5eEqpYJma8nq8iMehGI36tN8+
	CZsnrMfQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOBmx-000000020u9-32wV;
	Tue, 03 Nov 2026 10:30:47 +0000
Date: Tue, 3 Nov 2026 02:30:47 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Li kunyu <likunyu@open-hieco.net>
Cc: axboe@kernel.dk, tj@kernel.org, josef@toxicpanda.com,
	cgroups@vger.kernel.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] block: Add done_split_bio() for chained bio
 post-processing
Message-ID: <aum31_1jjv7OROxl@infradead.org>
References: <20261030065945.88742-1-likunyu@open-hieco.net>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030065945.88742-1-likunyu@open-hieco.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Oct 30, 2026 at 02:59:43PM +0800, Li kunyu wrote:
> 
> patch 1:  Introduce a new abstract function 'done_split_bio' and call it
> from bio_remaining_done to resolve this issue.
> 
> patch 2: Implement the blkcg_iolatency_done_split_bio callback in
> blk-iolatency to correctly decrement the inflight count when the other
> bio headers, which have not called rq_qos_done_bio(bio), complete.

Why are you not simplify calling rq_qos_done_bio before
bio_remaining_done?  __bi_remaining is only incremented for clones of
various types, and the qos processing should probably happen before
calling back into the submitter anyway.

As far as I can tell all the code here is duplicating the existing
done code without much of an explanation of why we need another copy.

While we're at, the existing code in rq_qos_done_bio added in commit
aa1b46dcdc7b ("block: fix rq-qos breakage from skipping rq_qos_done_bio()")
is extremly wrong and dangerous.  Once a bio completes, bi_bdev
is invalid, the driver could have even used it for something that is not
a block device like md raid5 does, but it certainly does not have any
use for the qos/iocost code.  So it really needs to derive anything
it needs to I/O processing from the bio itself.

