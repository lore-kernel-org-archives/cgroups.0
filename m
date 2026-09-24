Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54641477E58;
	Thu, 24 Sep 2026 12:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790251610; cv=none; b=KA/RbkkQlIZqQkmc7//6GEtQwd4OdLeYeHdHJ/wDezO9xUcOz/JCZpRRp8ANzlvXCvKkCizd8bN/20FBE9pAlrxh0/rUqiNvmNgga9XNpREB2UYkj5QnpgYwqd9PveXzPuVTsWAJ8/UePtAccCX5GmdkturOApof6EBnSjM/J4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790251610; c=relaxed/simple;
	bh=POSpAKSU2r9fexg6/G9FzzNk/dOK2ZZta1d8+WqQEkg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IVHGYCn28vF3zqAaUXqL1wJZAJAHKrPwdP6so0lUryFhuNwcfL4XL66XNmU9yZ4aMgEVlg0LBf5E88PwKcgE/aBExZeGTkNcgXJRoKlJQB/3+dy7lryCsI9AWOSSqDLziJTpNyhtsoNi1efIwTq/qU9KYsaWe3aIvHh0sl5SP8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7855821E38;
	Thu, 24 Sep 2026 12:06:47 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4CBB913354;
	Thu, 24 Sep 2026 12:06:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id unHNDFcStWo5TwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 24 Sep 2026 12:06:47 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D698EA132E; Thu, 24 Sep 2026 14:06:46 +0200 (CEST)
Date: Thu, 24 Sep 2026 14:06:46 +0200
From: Jan Kara <jack@suse.cz>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, willy@infradead.org, jack@suse.cz, 
	tj@kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH v8 1/3] block: introduce bdev_flush_by_dev()
Message-ID: <qjaulcom6f6ggwq5aktkq2glrdzfhdc27utpg36moywpijmbgc@pz3chxpmz6t3>
References: <20260922125015.3435215-1-sunjunchao@bytedance.com>
 <20260922125015.3435215-2-sunjunchao@bytedance.com>
 <sb2ptqety3wgay5egv4otva2s7hdvztifhsealwqpdnw5nyprc@ceu2bsedj4wy>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sb2ptqety3wgay5egv4otva2s7hdvztifhsealwqpdnw5nyprc@ceu2bsedj4wy>
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 7855821E38
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.00

On Thu 24-09-26 12:57:46, Jan Kara wrote:
> On Tue 22-09-26 20:50:13, Julian Sun wrote:
> > Add bdev_flush_by_dev() to submit page-cache writeback for a device
> > identified by dev_t without requiring callers to hold a persistent
> > device reference.
> > 
> > A subsequent patch will use this helper to flush foreign bdev mappings.
> > 
> > Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
> 
> Looks good. Feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

After some though I think it would be better to use

	write_inode_now(BD_INODE(bdev), 0);

in bdev_flush_by_dev().

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
