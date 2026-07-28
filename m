Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843233876A7;
	Tue, 28 Jul 2026 04:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785212599; cv=none; b=snrYsB/tO0NZ9YozFUq5NKh0bDMI7OMll0r7C7Vfe1luZ8nAsqDPMoRjYulUGYiy4PcRAELkqAsDM6cwrKgTm9lkicIneAHdr2T8rG9UrNOxd6SUa2KmtlIoHLgxVXT1CjHd/wtd2Hk/KmP7mEa30v6O3T4MqjdLJlYVkL3jD+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785212599; c=relaxed/simple;
	bh=42o9dFVGi9O7tRM0rDfGcZmhyWRAn20kX1FOWgvKqSc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BHkVc80YnKn/Mk+4tk6JkN9/1Yp+rSniqP7rFK3uDQs8rd0k0Iu9RCUUvhnCbHHVlTOmhZ8Bar0jpfNFjghdshtZ8cZZr4jZ5YOpl6ZaOkVcVCf35nDEHn8A5mLgwwUYh7AKOUAdKzJBI+bjVa57UC9ZJ65ebtysGgSFqhOqcKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 24D9168AFE; Tue, 28 Jul 2026 06:23:14 +0200 (CEST)
Date: Tue, 28 Jul 2026 06:23:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: yu kuai <yukuai@fygo.io>
Cc: axboe@kernel.dk, tj@kernel.org, hch@lst.de, dongsheng.yang@linux.dev,
	cengku@gmail.com, josef@toxicpanda.com, nilay@linux.ibm.com,
	ming.lei@redhat.com, linux-block@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/8] block: associate blkg in submit_bio instead
 of bio_set_dev
Message-ID: <20260728042313.GA19817@lst.de>
References: <20260724123037.3004560-1-yukuai@kernel.org> <20260724123037.3004560-2-yukuai@kernel.org> <933b4285-1c85-4076-831a-0501d5c38e16@fygo.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <933b4285-1c85-4076-831a-0501d5c38e16@fygo.io>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 27, 2026 at 04:16:29PM +0800, yu kuai wrote:
> > open-coded blkg_put().
> 
> Turns out bio will be submitted by kworker for some drivers and for
> blkcg_punt_bio_submit(). Is it possible to record blkcg during bio initialization,
> as blkcg must exist, and then covert it to blkg during submission? I can use union
> for blkcg and blkg to avoid new field in struct bio.

Mixing the two up sounds like a receipt for a lot of problems
unfortunately.  I wonder if we could switch to only store the blkcg in
the bio and look up the blkg as needed.  This assumes we can get away
with a relatively small numbers of lookups for typical setups.  I'm not
really sure how much the different users are combined - if not much this
might actually be a big net benefit, if on the other hand we'd have to
do a lot of separate lookups it might not work very well.

This could be combined with a way to do more efficient blkg lookups
using e.g. a rhashtable.

