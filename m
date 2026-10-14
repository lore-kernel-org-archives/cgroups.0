Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D4F4A8A08;
	Wed, 14 Oct 2026 12:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791979795; cv=none; b=BS16KLr8cnFaGFLcYXmU8GVdoY+WSIr9JXYBYRXSoHb0kZ4xtbP42RnlHb3rYykacTIb1vgIjjmKHXQOl0QhJv1TwKxygqPxiuCssKtsNWCQxnotTi0Fbb8guXvdZ4VhCJWcQxlEb7iC3PSCMWjlBL77qd1a11N+xLCDssEhb94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791979795; c=relaxed/simple;
	bh=MOJ+mCF3+Xn7WkIz5r+/pVMWVQhOipPwSr8GQSuaNk8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ooi8Pt6bN9o3rBDjjgs/hLaxl8UQHvgTyuv9XKgCyZZxLLtBkFEXEcp60KnlDCzRkmSe+W2ZSvgBfn/rht5mNEpwkKgLvIdAJ2ZKuWbGGB8GHNBS3zNIwp7RGTxV+muQSCxp9+eoU+Lbel5V8BtXeaJHoxj/zZNR/TLog0D+iCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=iQRLg9TI; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CVR1B7ho; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=PJtvjB0A; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=O8w4tWkC; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="iQRLg9TI";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CVR1B7ho";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="PJtvjB0A";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="O8w4tWkC"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6981A221D9;
	Wed, 14 Oct 2026 12:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791979791; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WVgkZ/vvaM7S8C34FvgRuKF0g6RTv4zFtLpv2Bvz05E=;
	b=iQRLg9TI5KfvV6s5JpsBoG8lmaOpqKM9SaPZcmLMreePwZhRTw1n0J06IPaehDuo8w8VUH
	1MM2QX3VfHkCTCmI3VCxaccLUkbiFyGaoDSHkcskcn/uzc5MLXVUS3jNvx4Ok7NMNHnLfZ
	xhg7xc7KF/5qs+I1xlc1qepe1vgxHuw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791979791;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WVgkZ/vvaM7S8C34FvgRuKF0g6RTv4zFtLpv2Bvz05E=;
	b=CVR1B7hocEGhQZ53SQuKvQot9eKYTLYkEdov1kC/ZgJTsdR0K8WhPFrqSarIAnshvd05Ka
	h/kb0Bxit6kfKpAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791979790; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WVgkZ/vvaM7S8C34FvgRuKF0g6RTv4zFtLpv2Bvz05E=;
	b=PJtvjB0ATXY0xuAfABs+PjKs5r9I5eY/PDc7q45U+/XeFotYb+g6h7fY7fr8V0HG5h+P/g
	kpyBak+qCAiBm7YYk1IqfSRDmuSep13QqXYlTUMNoVK1mfl+6zR9GuLxgWjRoJVmTcQjZD
	exELZzYyAScTUsdBs0XlFJrGwGjIVE0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791979790;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WVgkZ/vvaM7S8C34FvgRuKF0g6RTv4zFtLpv2Bvz05E=;
	b=O8w4tWkCMNGFzDnkpHWQ/s3vb4DE2HuKHckr4bWZCMGe0yuiQdolFK2OcHKuq6Q85G2RIS
	lOCFU2C3ohkEBiBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3AC4D1368E;
	Wed, 14 Oct 2026 12:09:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +JkQBg5xz2rbYgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 14 Oct 2026 12:09:50 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C0E1FA140E; Wed, 14 Oct 2026 09:35:32 +0200 (CEST)
Date: Wed, 14 Oct 2026 09:35:32 +0200
From: Jan Kara <jack@suse.cz>
To: Liz Fong-Jones <lizf@honeycomb.io>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Tejun Heo <tj@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Xin Yin <yinxin.x@bytedance.com>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ian@honeycomb.io
Subject: Re: [PATCH v6 1/3] writeback: clear the old wb's dirty IO state
 after switching inodes
Message-ID: <f7cp6bslfs2ktarigwvto63masggncd6al2hefj4fmyvehybhp@3y7pjailoxkh>
References: <20261002-wb-dying-cgwb-flush-v6-0-1991b4e2dcff@honeycomb.io>
 <20261002-wb-dying-cgwb-flush-v6-1-1991b4e2dcff@honeycomb.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002-wb-dying-cgwb-flush-v6-1-1991b4e2dcff@honeycomb.io>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_THREE(0.00)[3];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCPT_COUNT_TWELVE(0.00)[16];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[honeycomb.io:email,suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spam-Flag: NO

On Fri 02-10-26 21:40:45, Liz Fong-Jones wrote:
> Switching a dirty inode to another wb can leave WB_has_dirty_io set on
> the old one. inode_do_switch_wbs() moves the inode onto new_wb->b_dirty
> through inode_io_list_move_locked(), which only updates new_wb, and
> nothing calls wb_io_lists_depopulated() on old_wb. A live wb clears the
> bit on its next dirty to clean transition, but a wb that gets no more
> inodes, such as a dying one, is freed with its avg_write_bandwidth still
> in bdi->tot_write_bandwidth, which wb_split_bdi_pages() and
> wb_min_max_ratio() divide by.
> 
> Call wb_io_lists_depopulated(old_wb) after the switch loop in
> process_inode_switch_wbs(), while old_wb->list_lock is still held.
> 
> Test: after the last patch in this series switched a replaced wb's dirty
> inodes away, BdiWriteBandwidth stayed at 411700 and 407820 kBps with no
> writers and b_dirty, b_io and b_more_io all empty; with this patch it
> read 0, in 3 of 3 runs.
> 
> Suggested-by: Tejun Heo <tj@kernel.org>
> Assisted-by: Claude:claude-opus-5-5 checkpatch sparse
> Assisted-by: Claude:claude-fable-5-1
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/fs-writeback.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index d26b2cf05283..050d507aa554 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -566,6 +566,12 @@ static void process_inode_switch_wbs(struct bdi_writeback *new_wb,
>  		}
>  	}
>  
> +	/*
> +	 * inode_do_switch_wbs() only updates @new_wb's dirty IO state.  Clear
> +	 * @old_wb's if its IO lists are now empty.
> +	 */
> +	wb_io_lists_depopulated(old_wb);
> +
>  	spin_unlock(&new_wb->list_lock);
>  	spin_unlock(&old_wb->list_lock);
>  
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
