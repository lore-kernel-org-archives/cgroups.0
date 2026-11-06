Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793974691;
	b=S0CjzF8E/oynNxhTAAfxv2EaOUJpI68FWIvJ57wTcM2DX3nWj6l2F/blG7D7xHrYo+4U
	 XPCV43mmZ7RNWJuJDxFFN2bthDhL3eKsmm63qSEMReLw1Dw7P1v9POuBdinAmYGjCcNoX
	 H6BkjqcK8svf7Tpg+YzMxotHdHyLffLFIC8k0fa3JhegoIp2BgSniBR97YLbFd8HRYoF+
	 4LmbQFZbnsHr3ck9Xc05tqp2pf2hi/PHTmUvIHYiCgmM4xrL49t7xXZ78iW+b1KhfXdYu
	 IDuO3wix81eK+CBvNZXwVjTCiZDaKcCIB8AHNq3XmqAnQkL2/GrTmweZczLZhsAoOCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793974691;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=DbXOMRc+RxyXDwhPgVxgq6OSlAD0HlpBTR9dAYmXezE=;
	b=ZniozLnf5pBSyLz8i72JKxnr2VwCMQbOfKFC00z29VPny8Z8Sawc9bgjRjUFVkIOtTEn
	 +jaziS8Z76UQFmf71TZQfxhCoUnuCHJkpEujxdOvlw7LTsqz6ibrWohlzsCrSYqksid+W
	 fFkz66nGJkPeWBgjuiWV6VX4jIduECfg395KxEEqT0BkHOJJkt0+iCidEpUDuMkMrEcsp
	 v0TFc8ycUzi1tzS4VerjWgDb4npoC95jYIQ8hwnUpiyI/QRLVpnBQ19nBWBJ0XWltkAuq
	 A56/JB+hEEs2LCKEUiFqabpFnpNGbstIoGrwUzu7P52SgqTxD14VL2NxAF+PaoOPFgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=FIawBo5u;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=GAIC8+xY;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=FIawBo5u;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=GAIC8+xY;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1AE606A326;
	Fri,  6 Nov 2026 14:18:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1E1AE606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=FIawBo5u;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=GAIC8+xY;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=FIawBo5u;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=GAIC8+xY
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1D076221AB;
	Fri,  6 Nov 2026 14:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793974689; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DbXOMRc+RxyXDwhPgVxgq6OSlAD0HlpBTR9dAYmXezE=;
	b=FIawBo5uxM6qqiDjVJWp3+osfdJHTB7/9k/8ZXnfwSqMSVMQsrA+ls8eohG0IqsgJpshAu
	4k11WqrTgHHWctbcwqEkg37q29R+/n7gnGuz2bQMgmmTJ/h2bxDAuTJMuFv97yn+PnssG4
	8k8LiAdzcqtEIdwStCzpo35K3tJtj+M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793974689;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DbXOMRc+RxyXDwhPgVxgq6OSlAD0HlpBTR9dAYmXezE=;
	b=GAIC8+xY/rXGUL8rB7GiG/X98jUIopLTsD8tl90kFvlhyIwDk5QTCQpDh/2tRDj5r7pbP4
	TKSB1zBzbcO0FBBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793974689; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DbXOMRc+RxyXDwhPgVxgq6OSlAD0HlpBTR9dAYmXezE=;
	b=FIawBo5uxM6qqiDjVJWp3+osfdJHTB7/9k/8ZXnfwSqMSVMQsrA+ls8eohG0IqsgJpshAu
	4k11WqrTgHHWctbcwqEkg37q29R+/n7gnGuz2bQMgmmTJ/h2bxDAuTJMuFv97yn+PnssG4
	8k8LiAdzcqtEIdwStCzpo35K3tJtj+M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793974689;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DbXOMRc+RxyXDwhPgVxgq6OSlAD0HlpBTR9dAYmXezE=;
	b=GAIC8+xY/rXGUL8rB7GiG/X98jUIopLTsD8tl90kFvlhyIwDk5QTCQpDh/2tRDj5r7pbP4
	TKSB1zBzbcO0FBBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EDB5D132C9;
	Fri,  6 Nov 2026 14:18:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WnUKNKDh7WpnaAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 06 Nov 2026 14:18:08 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 8BE5F21B85; Fri, 06 Nov 2026 15:18:04 +0100 (CET)
Date: Fri, 6 Nov 2026 15:18:04 +0100
From: Jan Kara <jack@suse.cz>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Julian Sun <sunjunchao@bytedance.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, kernel-team@meta.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/4] writeback: add the missing newline to the slow
 writeback report
Message-ID: <qmosz7e5iaxgadaltvzzcduym4z3dpzw7qrdcwahfvoh75mbzm@2gfo7v62qajq>
References: <20261106-writeback_stall_report-v1-0-bf0c3b9023a5@debian.org>
 <20261106-writeback_stall_report-v1-1-bf0c3b9023a5@debian.org>
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
In-Reply-To: <20261106-writeback_stall_report-v1-1-bf0c3b9023a5@debian.org>
X-Spamd-Result: default: False [-12.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -12.80
X-Spam-Level: 
X-Spam-Flag: NO

On Fri 06-11-26 04:26:31, Breno Leitao wrote:
> wb_wait_for_completion_cb() reports a writeback wait that exceeds
> hung_task_timeout_secs with a pr_info() that has no trailing newline.
> printk() keeps such a record open for a continuation and does not
> finalize it, so dmesg, the consoles and netconsole only see the report
> once the next message is logged.
> 
> Terminate the message with a newline.
> 
> Fixes: d6e621590764 ("writeback: Add logging for slow writeback (exceeds sysctl_hung_task_timeout_secs)")
> Cc: stable@vger.kernel.org
> Signed-off-by: Breno Leitao <leitao@debian.org>

Sure. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/fs-writeback.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 15260cf2a29b09..01a00d7542b371 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -204,7 +204,7 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done)
>  	done->progress_stamp = jiffies;
>  	if (timeout && (waited_secs > timeout))
>  		pr_info("INFO: The task %s:%d has been waiting for writeback "
> -			"completion for more than %lu seconds.",
> +			"completion for more than %lu seconds.\n",
>  			current->comm, current->pid, waited_secs);
>  
>  	return !atomic_read(&done->cnt);
> 
> -- 
> 2.53.0-Meta
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
