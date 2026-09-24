Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5F73AE6F5;
	Thu, 24 Sep 2026 10:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790247483; cv=none; b=dlXRcZwutyhtIYBrt023SOS+hA1u7Ae80yJj98wzI/msXEjiIvrAjGGODadIHejMzwKcVWJj4QU+0AdX8X6QL3p1cvWMQSB2h7MsfuOs50ybmq+392v/x+C1ZFlfkMVXuxR0KT+Q1JlYKY3sGfQWhJzCC5YfrCPfVKgebXY0im0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790247483; c=relaxed/simple;
	bh=9o3NzcqvOIGdzBOEsIKCWMcka79vw2gyCaYu5ehMNUY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ia10jS6XIPaSMqYLyLazPaVR1wXMdakPpRS9RHFukEoXiBeG17tVFx89t20OzFPwk7/h3lw7vZFqP95oZsCs6//KDr+HWvDyH5ToxfXxiUo6diSZa4fyPkX+DufPNyfTFwkrgAD8dOV4LzF7mmfMblLQbT6hpq0+oOJi2Cvge10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=XK2yhAGH; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=WWHHdk7E; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=NdRYl4RN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=5ms3zhBK; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="XK2yhAGH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="WWHHdk7E";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="NdRYl4RN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="5ms3zhBK"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1CFC021EFA;
	Thu, 24 Sep 2026 10:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790247475; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FbmFn96Dr7Y82qM5io19+Dl7w0OLn9pRCPxXUR9XU3U=;
	b=XK2yhAGHuRe7loDBoUcmiUjhc3jq+AXGRrtCd26aJMsjCpTjTc50RShuhwIDHku3jpoWto
	l1fAXLYwqeP2zyTn2oNluiPnUzJEhgh9G8qbngwDg9asFA4FKm693CiJCW5sg7w6Poyklp
	LA82k2G59tmY2/Ikt3DdPOx8V2Vre6A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790247475;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FbmFn96Dr7Y82qM5io19+Dl7w0OLn9pRCPxXUR9XU3U=;
	b=WWHHdk7EANbYYRDXkfinNben5xPkYcXFY49Uj+pTr9iqE9goZWHi6IH6WmhhRaA72XJ06x
	OxGEK2me0Dcj8dCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790247471; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FbmFn96Dr7Y82qM5io19+Dl7w0OLn9pRCPxXUR9XU3U=;
	b=NdRYl4RNFwYn4+r8u8oUBD2piXAAKS7IlbEEr1LFQzjcq8vhhNJqWmmQ8toqMkym/N8Y3F
	dKxPbGkMRIPxdbM3jUgWAiVErkGA9URGXf0na+WXKgWreLRY1cjwu1/6lACocTgg03ua3R
	A8ImfD5/x7S1kzmp+y6vA5bvGIheXF0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790247471;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FbmFn96Dr7Y82qM5io19+Dl7w0OLn9pRCPxXUR9XU3U=;
	b=5ms3zhBK/LwkYNAoYxufp9jcZMjN6u9w+T+22YHBrKfJ08UiDsN9qQi6DxM1ofTTXYk3Ry
	d64Cwu5WvYr3uWBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E926713668;
	Thu, 24 Sep 2026 10:57:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mVg4MC4CtWpeAgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 24 Sep 2026 10:57:50 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8B114A132E; Thu, 24 Sep 2026 12:57:46 +0200 (CEST)
Date: Thu, 24 Sep 2026 12:57:46 +0200
From: Jan Kara <jack@suse.cz>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, willy@infradead.org, jack@suse.cz, 
	tj@kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH v8 1/3] block: introduce bdev_flush_by_dev()
Message-ID: <sb2ptqety3wgay5egv4otva2s7hdvztifhsealwqpdnw5nyprc@ceu2bsedj4wy>
References: <20260922125015.3435215-1-sunjunchao@bytedance.com>
 <20260922125015.3435215-2-sunjunchao@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922125015.3435215-2-sunjunchao@bytedance.com>
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[15];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.com:email]
X-Spam-Flag: NO

On Tue 22-09-26 20:50:13, Julian Sun wrote:
> Add bdev_flush_by_dev() to submit page-cache writeback for a device
> identified by dev_t without requiring callers to hold a persistent
> device reference.
> 
> A subsequent patch will use this helper to flush foreign bdev mappings.
> 
> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  block/bdev.c           | 18 ++++++++++++++++++
>  include/linux/blkdev.h |  4 ++++
>  2 files changed, 22 insertions(+)
> 
> diff --git a/block/bdev.c b/block/bdev.c
> index cd8323083740..c7c192af6262 100644
> --- a/block/bdev.c
> +++ b/block/bdev.c
> @@ -264,6 +264,24 @@ int sync_blockdev_nowait(struct block_device *bdev)
>  }
>  EXPORT_SYMBOL_GPL(sync_blockdev_nowait);
>  
> +/**
> + * bdev_flush_by_dev - attempt writeback of a block device's page cache
> + * @dev: target block device number
> + *
> + * May sleep while submitting writeback; does not wait for I/O completion.
> + */
> +void bdev_flush_by_dev(dev_t dev)
> +{
> +	struct block_device *bdev;
> +
> +	bdev = blkdev_get_no_open(dev, false);
> +	if (!bdev)
> +		return;
> +
> +	sync_blockdev_nowait(bdev);
> +	blkdev_put_no_open(bdev);
> +}
> +
>  /*
>   * Write out and wait upon all the dirty data associated with a block
>   * device via its mapping.  Does not take the superblock lock.
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 4f7905c3412b..27afe3ff6fb5 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1710,6 +1710,7 @@ void invalidate_bdev(struct block_device *bdev);
>  int sync_blockdev(struct block_device *bdev);
>  int sync_blockdev_range(struct block_device *bdev, loff_t lstart, loff_t lend);
>  int sync_blockdev_nowait(struct block_device *bdev);
> +void bdev_flush_by_dev(dev_t dev);
>  void sync_bdevs(bool wait);
>  void bdev_statx(const struct path *path, struct kstat *stat, u32 request_mask);
>  void printk_all_partitions(void);
> @@ -1726,6 +1727,9 @@ static inline int sync_blockdev_nowait(struct block_device *bdev)
>  {
>  	return 0;
>  }
> +static inline void bdev_flush_by_dev(dev_t dev)
> +{
> +}
>  static inline void sync_bdevs(bool wait)
>  {
>  }
> -- 
> 2.39.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
