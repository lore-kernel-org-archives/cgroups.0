Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793975394;
	b=UQPihn1F29XwvI1QDKMB2gF5z3jW8/bvEgResvC3L+Nuf/NOaNFeVl0kheZ7Bq3hPPl3
	 0CbAQPuCQ3BFumdT1JQu1f3Cefy6tAj8D33hI0NLPA50Vk4Qv0QjHTn2U3ICLKnh3F3A4
	 +PfviP5C8qqy4QJQz8DTwIE2P1i7TiDS04ckUnDE5nxNKnKLrScbv7EB3vnwE/rF97vDW
	 zGPDJqwUavga0nd82CVvSXnhaG6B8/xPN25vgqnHh3SG7SUCXQBVV/qjyK6um16XL0a7c
	 0Clc9i9Pw9WWZdV1d4JeisiDWu+xb6uroGUjKYP5Rr15+3ItRn3nabtMxuEbPdh8Tgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793975394;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=O3BxtbkW6dUgg0e4SBYmdv0h0k2sMGxdODd1ZfZ8Kws=;
	b=Uv6H5nSx16/I/bEwUMME8wJ70mUHEnjShBHcJb0WNbJ1hrDEjvUnL8Npj+s6P15ZzeC/
	 hFI11X7YoCe7Ya/L23OKLdvJ3MSUBOWXcVP3ljY0uiHHG9Vz4S2D/k+KB5W1G5aR57Dih
	 N5z3ZhGTink5UDE0mV8NaUDPu3EfenTpQfHpPV2JqKgAzq9A0OXFSefGDfa4BFTV7Dxf5
	 woCi+bk3H0wkl6N3OIGKmVW15VjkeLKt8YfDIZunU4YDjYv7tSWqDuT5MQjyb4GEDZxGE
	 hMKqQazktvg5imp/+D9z9AwBfYdIw/6UTbLKndkloJ8yc8aDb4Mf16DgktMJizYKbTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=T9F6eGMH;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=T3BliDtd;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="wP9/6bwL";
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=JTKT7OmU;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D865B606A326;
	Fri,  6 Nov 2026 14:29:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D865B606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=T9F6eGMH;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=T3BliDtd;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=wP9/6bwL;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=JTKT7OmU
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C76B222218;
	Fri,  6 Nov 2026 14:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793975392; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O3BxtbkW6dUgg0e4SBYmdv0h0k2sMGxdODd1ZfZ8Kws=;
	b=T9F6eGMHRkO93M0BvqGAMusPFNwPVE2nZTwMPcHXoJFTTbB3+4NoLHOv1C+toGGOBKGOsM
	Zk4TdOT631Sy0ozE6svg4m/sffbWzP/QAJ9aPH/eJBtbPI2nO8HVCr3M8wwf69BTk6F+b5
	MK/wZecBX5OFBNb0NhG3xr2Kip7cVRY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793975392;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O3BxtbkW6dUgg0e4SBYmdv0h0k2sMGxdODd1ZfZ8Kws=;
	b=T3BliDtd9hpp3d6y1F+DcpLXvmp5oYhKc7XGdJvyWIGfamCNevWsZnL5z/zeAONom/Wnl4
	zQDZz8EVxlBqibBg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="wP9/6bwL";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JTKT7OmU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793975391; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O3BxtbkW6dUgg0e4SBYmdv0h0k2sMGxdODd1ZfZ8Kws=;
	b=wP9/6bwLd7Dg8vz1YAVSAYLlngNth8RT+ABVFG/3gC8noUpc2zJt3wyocGMDkrdQWl7x5I
	WngtzrQB3YSlYjHF4Vl+HeqNxFwnSwYziKY4/4ODYOeCUmuJL3TWzdQFFciBGYPJk3dpMv
	52qK1UnCZMrWr2M1XgV/nQ153kZ26bg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793975391;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O3BxtbkW6dUgg0e4SBYmdv0h0k2sMGxdODd1ZfZ8Kws=;
	b=JTKT7OmUoUh5jLYQxMNsM55o6rRZZSOOxNxxzyR4vBWtUM8EmfkSYsSlSJG9eJG0uMLMFu
	FomoGh0SM6bwlGBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7AA7D132C9;
	Fri,  6 Nov 2026 14:29:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eDMeN17k7WqTdAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 06 Nov 2026 14:29:51 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 7FBCE21B8E; Fri, 06 Nov 2026 15:29:35 +0100 (CET)
Date: Fri, 6 Nov 2026 15:29:35 +0100
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
	cgroups@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 3/4] writeback: log the end of a slow writeback wait
Message-ID: <ftkoesjrylhcmtij2gi63wnrkjdjf2ps65cwhz4g7rejhpjdh3@ieu2t4wtnjwo>
References: <20261106-writeback_stall_report-v1-0-bf0c3b9023a5@debian.org>
 <20261106-writeback_stall_report-v1-3-bf0c3b9023a5@debian.org>
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
In-Reply-To: <20261106-writeback_stall_report-v1-3-bf0c3b9023a5@debian.org>
X-Rspamd-Queue-Id: C76B222218
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-13.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:dkim,suse.cz:email];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Score: -13.01

On Fri 06-11-26 04:26:33, Breno Leitao wrote:
> A slow writeback wait ends with one more "has been waiting" report,
> printed by the wakeup that sees the last work item complete:
> 
>   INFO: The task sync:180 has been waiting for writeback completion for more than 29 seconds.
>         bdi 252:0, work items left: 0
> 
> That line reads as if the task were still waiting. To tell a slow
> writeback from a stuck one, the reader has to notice that the reports
> stopped, which is easy to miss in a busy log.
> 
> Report only while work items are outstanding, and log how long the wait
> took once it is over:
> 
>   The task sync:181 waited 29 seconds for writeback completion on bdi 252:0
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/fs-writeback.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 3dee9d65eaf721..cdb2631b8552e1 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -201,17 +201,18 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done,
>  {
>  	unsigned long timeout = sysctl_hung_task_timeout_secs;
>  	unsigned long waited_secs = (jiffies - done->wait_start) / HZ;
> +	int left = atomic_read(&done->cnt);
>  
>  	done->progress_stamp = jiffies;
> -	if (timeout && (waited_secs > timeout)) {
> +	if (left && timeout && (waited_secs > timeout)) {
>  		pr_info("INFO: The task %s:%d has been waiting for writeback "
>  			"completion for more than %lu seconds.\n",
>  			current->comm, current->pid, waited_secs);
>  		pr_info("      bdi %s, work items left: %d\n",
> -			bdi_dev_name(bdi), atomic_read(&done->cnt));
> +			bdi_dev_name(bdi), left);
>  	}
>  
> -	return !atomic_read(&done->cnt);
> +	return !left;
>  }
>  
>  /**
> @@ -228,9 +229,18 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done,
>  void wb_wait_for_completion(struct wb_completion *done,
>  			    struct backing_dev_info *bdi)
>  {
> +	unsigned long timeout, waited;
> +
>  	done->wait_start = jiffies;
>  	atomic_dec(&done->cnt);		/* put down the initial count */
>  	wait_event(*done->waitq, wb_wait_for_completion_cb(done, bdi));
> +
> +	timeout = sysctl_hung_task_timeout_secs;
> +	waited = jiffies - done->wait_start;
> +	if (timeout && waited > timeout * HZ)
> +		pr_info("The task %s:%d waited %lu seconds for writeback completion on bdi %s\n",
> +			current->comm, current->pid, waited / HZ,
> +			bdi_dev_name(bdi));
>  }
>  
>  #ifdef CONFIG_CGROUP_WRITEBACK
> 
> -- 
> 2.53.0-Meta
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
