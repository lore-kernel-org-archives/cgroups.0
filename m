Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794317394;
	b=zFZKevU9aWlm+9t7M0mm2Iy/GE5IvQ9w7CXCvsas3QtbAukcu2PuanWaMP7sLYXW9BUo
	 F4oQRRQ4FLSx7uDDlceWbOHYNmKwb/zhzpLl2Y/bvtqH4m0fHLVDZr1AtJXVX2VpSH6Nd
	 e6NoZ4ILg3Y643cdys/lPAoy/+tY+VK+gbFekO6B9WWjRnfWZs0KQYCBXul4tFHsDEIoc
	 1fNLsbH3OWG+T9tnAUuF+vOM0wIyOwoTXGvvtQopnTYb4zaxTQCmZuI0D1IsCCE31M8RH
	 zVf2ystLTMnNmM+ttIYeA9NbzQeeofZPJsE9XJNZJnIfvpG7d9GvK9PPT2wmDLWBBtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794317394;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=C4uMTERewdC+9gC+DrjEbRKhFxjcLNPdABLnD4EsWsQ=;
	b=c7Abmsb3qpY1Jrt423CJ4KRBlvRaHMfDy3w56GoDCuZzkPkaarkrz5NwlUe8z0VCzBpe
	 vBPAHPdKAM4t3/vLlf2OAzbX9IgVHOKQqu7/oFv8f8tbmcOf0uGRuyCKyKfUL3GF5eN/i
	 rb95xzg9/gL6IdyyZcaj04/TNfu3EIDxnpRISxE4CS2pRCiMjAdvmB5f6lzdNNJxTHt51
	 hrvB84khE6tbt+R1T5qTqnLqsbcImcaOI9yliOhV4vXEGbUME8Ho1J690aaylw4gzvdQk
	 C7IRfAe/MZakboA0aMZgmzHQ/e+UuQztKSN8wlvM4S+754/AGGf0X53+rldEjvDH2pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=r6bvVSlZ;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=8Zm3DwiJ;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=r6bvVSlZ;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=8Zm3DwiJ;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EF5606B189;
	Tue, 10 Nov 2026 13:29:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13EF5606B189
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=r6bvVSlZ;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=8Zm3DwiJ;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=r6bvVSlZ;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=8Zm3DwiJ
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0832121F1E;
	Tue, 10 Nov 2026 13:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794317392; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C4uMTERewdC+9gC+DrjEbRKhFxjcLNPdABLnD4EsWsQ=;
	b=r6bvVSlZjxpVnwcFk4kD78MioJsu6D3AlYG2tBRTGMWIwes3h5blfHJfCpSINPK6zNmNcd
	anGTtoIWyzenroZAqMeKs0gZv59sRGNsihzn4eAfkEprnd6rA2NPlflHMUywbNSBSmHFkH
	Gvc42hL59nIU3v1lBVN04OusXU+jLhs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794317392;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C4uMTERewdC+9gC+DrjEbRKhFxjcLNPdABLnD4EsWsQ=;
	b=8Zm3DwiJOrYwCmyUyCb5kfOI6SMFHZ/fAo0QthXS82fE1cx9CF1+vEsS5oYJLMLGJ3jtVL
	RwbfsHff24uidGAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=r6bvVSlZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8Zm3DwiJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794317392; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C4uMTERewdC+9gC+DrjEbRKhFxjcLNPdABLnD4EsWsQ=;
	b=r6bvVSlZjxpVnwcFk4kD78MioJsu6D3AlYG2tBRTGMWIwes3h5blfHJfCpSINPK6zNmNcd
	anGTtoIWyzenroZAqMeKs0gZv59sRGNsihzn4eAfkEprnd6rA2NPlflHMUywbNSBSmHFkH
	Gvc42hL59nIU3v1lBVN04OusXU+jLhs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794317392;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C4uMTERewdC+9gC+DrjEbRKhFxjcLNPdABLnD4EsWsQ=;
	b=8Zm3DwiJOrYwCmyUyCb5kfOI6SMFHZ/fAo0QthXS82fE1cx9CF1+vEsS5oYJLMLGJ3jtVL
	RwbfsHff24uidGAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A4AF4134F4;
	Tue, 10 Nov 2026 13:29:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Es4PC08c82o8ZgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 13:29:51 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id C59372250E; Tue, 10 Nov 2026 14:29:50 +0100 (CET)
Date: Tue, 10 Nov 2026 14:29:50 +0100
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
Subject: Re: [PATCH v2 4/4] writeback: report a slow writeback wait once per
 timeout
Message-ID: <bsho4anqsuqew2ao6qlxlccge5hta4fljsdym5jb4l4ry54o5p@i2atspfuwq2g>
References: <20261110-writeback_stall_report-v2-0-9e0ed75074ca@debian.org>
 <20261110-writeback_stall_report-v2-4-9e0ed75074ca@debian.org>
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
In-Reply-To: <20261110-writeback_stall_report-v2-4-9e0ed75074ca@debian.org>
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[22];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:dkim,suse.com:email];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -13.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 0832121F1E

On Tue 10-11-26 03:39:30, Breno Leitao wrote:
> The slow writeback report is printed on every wakeup of the waiter past
> hung_task_timeout_secs, and twice each time.
> 
> Each flusher working for the waiter wakes it once it has not run for
> half the timeout, so the hung task detector sees it make progress.
> 
> Since commit 84654c7f4730 ("wait: avoid spurious calls to
> prepare_to_wait_event() in ___wait_event()"), wait_event() checks the
> condition right after schedule() and again after
> prepare_to_wait_event(), so each of those wakeups reports twice.
> 
> A sync of files dirtied from two cgroups, on a throttled null_blk device
> with the timeout set to 5 seconds, gets 18 reports for a 29 second wait:
> 
>  INFO: The task sync:275 has been waiting for writeback completion for more than 7 seconds (bdi 252:0, work items left: 2).
>  INFO: The task sync:275 has been waiting for writeback completion for more than 7 seconds (bdi 252:0, work items left: 2).
>  INFO: The task sync:275 has been waiting for writeback completion for more than 10 seconds (bdi 252:0, work items left: 2).
>  INFO: The task sync:275 has been waiting for writeback completion for more than 10 seconds (bdi 252:0, work items left: 2).
>  ...
> 
> Set ->progress_stamp when the wait starts, so the first check does not
> take a zero stamp for a timeout. The same test now prints 5 reports:
> 
>  INFO: The task sync:276 has been waiting for writeback completion for more than 5 seconds (bdi 252:0, work items left: 2).
>  INFO: The task sync:276 has been waiting for writeback completion for more than 10 seconds (bdi 252:0, work items left: 2).
>  ...
>  The task sync:276 waited 29 seconds for writeback completion on bdi 252:0
> 
> The flusher only checks for progress between inodes, so the wakeups now
> land on the first inode boundary past the timeout, a bit more than a
> timeout apart. The hung task detector scans once per timeout, so it can
> catch the waiter between two wakeups.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Looks good to me! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/fs-writeback.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index e2da4781b5e00b..fcb7fb0196208b 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -203,12 +203,13 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done,
>  	unsigned long waited_secs = (jiffies - done->wait_start) / HZ;
>  	int left = atomic_read(&done->cnt);
>  
> -	done->progress_stamp = jiffies;
> -	if (left && timeout && (waited_secs > timeout))
> +	if (left && timeout &&
> +	    time_after(jiffies, done->progress_stamp + timeout * HZ))
>  		pr_info("INFO: The task %s:%d has been waiting for writeback "
>  			"completion for more than %lu seconds (bdi %s, work items left: %d).\n",
>  			current->comm, current->pid, waited_secs,
>  			bdi_dev_name(bdi), left);
> +	done->progress_stamp = jiffies;
>  
>  	return !left;
>  }
> @@ -230,6 +231,7 @@ void wb_wait_for_completion(struct wb_completion *done,
>  	unsigned long timeout, waited;
>  
>  	done->wait_start = jiffies;
> +	done->progress_stamp = done->wait_start;
>  	atomic_dec(&done->cnt);		/* put down the initial count */
>  	wait_event(*done->waitq, wb_wait_for_completion_cb(done, bdi));
>  
> @@ -2135,7 +2137,7 @@ static long writeback_sb_inodes(struct super_block *sb,
>  
>  		/* Report progress to inform the hung task detector of the progress. */
>  		if (work->done && work->done->progress_stamp && timeout &&
> -		   (jiffies - work->done->progress_stamp) > HZ * timeout / 2)
> +		   (jiffies - work->done->progress_stamp) > HZ * timeout)
>  			wake_up_all(work->done->waitq);
>  
>  		wbc_detach_inode(&wbc);
> 
> -- 
> 2.53.0-Meta
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
