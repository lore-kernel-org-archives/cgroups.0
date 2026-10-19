Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7E626F289;
	Mon, 19 Oct 2026 10:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792404509; cv=none; b=ur4WJUFb30a71yvgqFRSAOT1WRfnJGtPCKgTSWiSPSKk2Y/Udav/a5pVCyM/dbl0FkP42POU/7cWjTkchhm0lOHAMMX4+6jLzB6yaO+1phIOEod0XTxEXhT2CcU1msRPe12pGNxtEQ7sF+AvNfxTxKHn3/T3SgUs9g7SpV/REDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792404509; c=relaxed/simple;
	bh=sSyDmkyVT/dhanTdK837i1+kyD20aLuR6WspTbHELYY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QH3JpivnLIJpOzs4mN7IOtmyn2R/upL1/lPIdsuL0EdtyUCXB+XAVdB7ZFScSsDkEanh6T9VtgNqVsElztp/eJ6IXl0JIaYVtetW9TOZQyMEd5UHyXy7gAwAwFDQeiMItFct1lCArJ58Kxr3tH7NSEXsDBAQzZwUpvulbU2nuvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=2j6yhaJO; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4+XFpOjI; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=g7uDNZIP; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=y3evbgPT; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2j6yhaJO";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4+XFpOjI";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="g7uDNZIP";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="y3evbgPT"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BCB9E21C12;
	Mon, 19 Oct 2026 10:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792404506; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Onx+JeZfqT4n7RqEsTp5HZW4tzK5tNL6plqqoY4dhVk=;
	b=2j6yhaJOCaIivir0SE6H+TxgSjRNEeEo8Y7vd/UgyirvA4Lbll3mdscbM7KESQGVWMU3n0
	Nw6A/+8o7FcmauMj1J/vidT0P0+uiI3EbR2BVtYpYl3eIRFjDc2QjtyCe5CQ++CTqPDpAv
	Y/BcUj717agCPF2s6G3xABDGSRdp6Lg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792404506;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Onx+JeZfqT4n7RqEsTp5HZW4tzK5tNL6plqqoY4dhVk=;
	b=4+XFpOjIhT5MYmu6nuoe8mbULZGnUBeLqtc0OVg0M2rjvj9bmQDysZPeWHotyf6uCH4kVi
	HxP6FlJl4MUi/KBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=g7uDNZIP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=y3evbgPT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792404504; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Onx+JeZfqT4n7RqEsTp5HZW4tzK5tNL6plqqoY4dhVk=;
	b=g7uDNZIPEpg2kFzeIAwWJt0X1jbKHGG/3UmOkhLl59qCjVe3OiPcjYTA5R1rg7LiIFVCM5
	/oCPGceBaNjA1I3QeI9F6cGDDFa/RDZrcZtFBEYB0+Tc/jBnA44zDTf0vv8ZWmIbDIEBGL
	mjWqztuXStAcA5BZtDgyoDaKxX+1taY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792404504;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Onx+JeZfqT4n7RqEsTp5HZW4tzK5tNL6plqqoY4dhVk=;
	b=y3evbgPTXWaM6PrgtT/BQ6enNXBnrmxMlayO1rf0Oce++uNu1CJR59WkO+SuFk8tUozpcF
	cmOZpAGq0xXkhsDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 951BB136CC;
	Mon, 19 Oct 2026 10:08:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id O/jdGxjs1WrSSgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 19 Oct 2026 10:08:24 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 230CDA1413; Mon, 19 Oct 2026 12:08:24 +0200 (CEST)
Date: Mon, 19 Oct 2026 12:08:24 +0200
From: Jan Kara <jack@suse.cz>
To: Liz Fong-Jones <lizf@honeycomb.io>
Cc: Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, 
	Christian Brauner <brauner@kernel.org>, "Patrick Lu (Anthropic)" <perf.patrick.lu@gmail.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ian@honeycomb.io
Subject: Re: [PATCH v2] writeback: keep cleanup_offline_cgwb()'s scan out of
 syncs
Message-ID: <lw7ovj3ubo27lfhyyklzt6cevl2silk7g7dv62wlk76l462thg@nnskkgjljah5>
References: <20261015114307.1041273-1-lizf@honeycomb.io>
 <20261017040710.1174009-1-lizf@honeycomb.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261017040710.1174009-1-lizf@honeycomb.io>
X-Rspamd-Action: no action
X-Spam-Score: -2.51
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_TWELVE(0.00)[12];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,suse.cz,gmail.com,linux.dev,zeniv.linux.org.uk,vger.kernel.org,kvack.org,honeycomb.io];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[honeycomb.io:email,suse.com:email,suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Level: 
X-Rspamd-Queue-Id: BCB9E21C12
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

On Sat 17-10-26 04:07:11, Liz Fong-Jones wrote:
> On a filesystem mounted with lazytime, sync() and syncfs() can return
> without persisting timestamp updates of inodes attached to a dying
> cgroup wb, so a crash after the sync loses them. File data and sizes are
> not affected.
> 
> Since commit f6988c90671e ("writeback: bound cleanup_offline_cgwb()
> rescans by rotating scanned inodes"), isw_prepare_wbs_switch() moves the
> inodes it walks to the newest end of the list. When a pass fills its isw
> before reaching an inode that got its lazytime update after a sync's
> cutoff, the walked inodes land past it on b_dirty_time, and the sync's
> queue_io(), which stops at the first inode dirtied after the cutoff,
> misses them. The late inode has to be one without a pending lazytime
> update; one already on b_dirty_time keeps its position.
> 
> The window is narrow. cleanup_offline_cgwbs_workfn() skips wbs with
> anything on b_dirty, b_io or b_more_io, so the scan has to land between
> wb_writeback() fixing dirtied_before and taking list_lock for its first
> queue_io(), unless a multi-pass drain started before the wb got dirty
> IO.
> 
> Take wb_switch_rwsem for read across the scan, as
> process_inode_switch_wbs() does for the switches.
> 
> Fixes: f6988c90671e ("writeback: bound cleanup_offline_cgwb() rescans by rotating scanned inodes")
> Cc: stable@vger.kernel.org
> Suggested-by: Tejun Heo <tj@kernel.org>
> Link: https://lore.kernel.org/all/0bc5d58533f10b4841807be3025daa11@kernel.org/
> Assisted-by: Claude:claude-opus-5-5 checkpatch
> Assisted-by: Claude:claude-fable-5-1
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>

Thanks! The fix looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Changes in v2, all from Tejun's review:
> - Correct the trigger and the reordering description, and note how
>   narrow the window is
> - Reword the code comment
> - Move the test details here and trim the description
> 
> Test, with a debug-only delay holding a syncfs's work on the wb between
> its cutoff and queue_io() to widen the window: 300 files on a cgroup's
> wb with lazytime atime updates, one more read after the cutoff, then
> the cgroup removed so the cleanup ran. Without this patch, syncfs()
> queued 48 of the 300 and after a crash 252 atime updates were lost, on
> ext4 (-I 4096, so neighbours' timestamps are not written along) in 3 of
> 3 runs and on XFS in 1 of 1; with it, none were lost. arm64 KVM guests,
> 7.3-rc7.
> 
> v1: https://lore.kernel.org/all/20261015114307.1041273-1-lizf@honeycomb.io/
> 
>  fs/fs-writeback.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index ea3eb40bf828..372ac9785e03 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -789,6 +789,13 @@ bool cleanup_offline_cgwb(struct bdi_writeback *wb)
>  		new_wb = &wb->bdi->wb; /* wb_get() is noop for bdi's wb */
>  
>  	nr = 0;
> +	/*
> +	 * The scan moves walked inodes to the newest end of b_dirty_time,
> +	 * past ones it didn't reach. If one of those was dirtied after a
> +	 * sync's cutoff, the sync's queue_io() stops there and misses the
> +	 * moved ones. Exclude syncs as process_inode_switch_wbs() does.
> +	 */
> +	down_read(&wb->bdi->wb_switch_rwsem);
>  	spin_lock(&wb->list_lock);
>  	/*
>  	 * In addition to the inodes that have completed writeback, also switch
> @@ -803,6 +810,7 @@ bool cleanup_offline_cgwb(struct bdi_writeback *wb)
>  		restart = isw_prepare_wbs_switch(new_wb, isw, &wb->b_dirty_time,
>  						 &nr);
>  	spin_unlock(&wb->list_lock);
> +	up_read(&wb->bdi->wb_switch_rwsem);
>  
>  	/* no attached inodes? bail out */
>  	if (nr == 0) {
> 
> base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
