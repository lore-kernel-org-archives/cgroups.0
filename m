Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793975884;
	b=QcEWNderzz+vHcvB8Br+lRYq2R9hewKlgK8NBvBBwfKiwH1aPoGNnTVVhALoOYSQ1X+r
	 EQHFrH+tBolB7YnSybI1wMP++Kxt7P31aIMg9+sArLgYxJmKXEohmYfhzjPCfAwzFPLfo
	 CzIS75opkXIzObrj18WlAjCZyr0NPAxmVaBriuhO9oaZfdyjrK7PX8gGRuLpBCsvKioHQ
	 whd/uoPrVro1rIk0wxj/539bsN5hM1HFpCw8+m9uuSCoPmSeTLcvgi8f/VRUGbMl9b3D5
	 JkTtHAcR+qD2s/h04V141mNYK4ld+olSsm0jggIkeKWWDJjd1AQsU5/cvZY1nvS1ofQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793975884;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=U1z9CMMlVvK3cpazVIozIjM4XgDTPtKDlnzc7HGPx3U=;
	b=hHRr6VrSk2SNMnQob08iOkoPAwabHKCJFBqk3v/TcJGIOi1x8jUwHVQMs69eeRFe3EIa
	 mF8Gjy74M7Au9QKtKEZM/gsYV/y6uzN0t8sCEwkhVeI2YQ/aeqwiOw4LDgpjWWPpfOtVd
	 DkaqrYwi59zkhficT/+dK5d7IQpO3s1vvzdrT5vgsslv+2sOSBzScqhxrbrcti8BDTV/b
	 /PpZX4Bc4wDfXnTMkfVTNoK4jijKqY9qzcWCB7rNIT20UxRBDEZbjcM63T4yjKz6e2bw8
	 V5VkRfc1ghTgbT69NgTmL7QT/jCo7JreRtOVV5I2h6WUkLeY84txGLZPbjCabLIxQVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=M+zsClbe;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ypqcMtH1;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=M+zsClbe;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ypqcMtH1;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB470606A32D;
	Fri,  6 Nov 2026 14:38:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB470606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=M+zsClbe;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ypqcMtH1;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=M+zsClbe;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ypqcMtH1
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7646B221EB;
	Fri,  6 Nov 2026 14:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793975881; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U1z9CMMlVvK3cpazVIozIjM4XgDTPtKDlnzc7HGPx3U=;
	b=M+zsClbeXawKRmbSoqHB8vSnhYLKmJu0p6scG/XFngMrof4NKMW5WU57BX+ALDhhWh8zdA
	HiEoHs64z4KRdRn/SjV56lAOiqqKPdqQGCnXOc/vTupbZySjLolBP6yyT+KwgH4B3PayaS
	a/utAwrfz6visoWpK4l3sJhLXQi+t/o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793975881;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U1z9CMMlVvK3cpazVIozIjM4XgDTPtKDlnzc7HGPx3U=;
	b=ypqcMtH1se1Qo38hsRbeYY9AZlO51QMWCAFqrzHQSnRWsVHs7k2atX/I9V1UzcS1gJuH3q
	u6mepYdynYhyV5BQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=M+zsClbe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ypqcMtH1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793975881; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U1z9CMMlVvK3cpazVIozIjM4XgDTPtKDlnzc7HGPx3U=;
	b=M+zsClbeXawKRmbSoqHB8vSnhYLKmJu0p6scG/XFngMrof4NKMW5WU57BX+ALDhhWh8zdA
	HiEoHs64z4KRdRn/SjV56lAOiqqKPdqQGCnXOc/vTupbZySjLolBP6yyT+KwgH4B3PayaS
	a/utAwrfz6visoWpK4l3sJhLXQi+t/o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793975881;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U1z9CMMlVvK3cpazVIozIjM4XgDTPtKDlnzc7HGPx3U=;
	b=ypqcMtH1se1Qo38hsRbeYY9AZlO51QMWCAFqrzHQSnRWsVHs7k2atX/I9V1UzcS1gJuH3q
	u6mepYdynYhyV5BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4D2FA132C9;
	Fri,  6 Nov 2026 14:38:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GgbfCknm7WrifAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 06 Nov 2026 14:38:01 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id CB2B421B95; Fri, 06 Nov 2026 15:37:45 +0100 (CET)
Date: Fri, 6 Nov 2026 15:37:45 +0100
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
Subject: Re: [PATCH 4/4] writeback: report a slow writeback wait once per
 timeout
Message-ID: <ysxh2sfvjikoh6cw2qmk2i6p7xripwnqxkx43jj7unxop5tkiw@gws5wezjt34g>
References: <20261106-writeback_stall_report-v1-0-bf0c3b9023a5@debian.org>
 <20261106-writeback_stall_report-v1-4-bf0c3b9023a5@debian.org>
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
In-Reply-To: <20261106-writeback_stall_report-v1-4-bf0c3b9023a5@debian.org>
X-Rspamd-Queue-Id: 7646B221EB
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
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Score: -13.01

On Fri 06-11-26 04:26:34, Breno Leitao wrote:
> The slow writeback report is printed on every wakeup of the waiter past
> hung_task_timeout_secs, and the waiter is woken more often than that.
> 
> Each flusher working for it wakes it once it has not run for half the
> timeout. All waiters on a bdi share bdi->wb_waitq, so a wakeup meant for
> one of them reaches all of them.
> 
> A sync of files dirtied from two cgroups, on a throttled null_blk device
> with the timeout set to 5 seconds, gets a report every half timeout,
> each printed twice, 18 reports for a 29 second wait:
> 
>   [   10.327992] INFO: The task sync:276 has been waiting for writeback completion for more than 8 seconds.
>   [   10.328000]       bdi 252:0, work items left: 2
>   [   10.328003] INFO: The task sync:276 has been waiting for writeback completion for more than 8 seconds.
>   [   10.328004]       bdi 252:0, work items left: 2
>   [   12.888187] INFO: The task sync:276 has been waiting for writeback completion for more than 10 seconds.
>   [   12.888195]       bdi 252:0, work items left: 2
>   [   12.888197] INFO: The task sync:276 has been waiting for writeback completion for more than 10 seconds.
>   [   12.888198]       bdi 252:0, work items left: 2
>   ...
> 
> Remember when the waiter last reported, and report again only once
> another timeout has passed. The wakeups do not change, so the hung task
> detector still sees the waiter making progress. The same test now
> prints 5 reports:
> 
>   [    7.661129] INFO: The task sync:277 has been waiting for writeback completion for more than 5 seconds.
>   [    7.661136]       bdi 252:0, work items left: 2
>   [   13.241102] INFO: The task sync:277 has been waiting for writeback completion for more than 11 seconds.
>   [   13.241109]       bdi 252:0, work items left: 2
>   ...
>   [   31.801068] The task sync:277 waited 29 seconds for writeback completion on bdi 252:0
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Now I'm waiting for someone to complain it gets written out too
infrequently :). Is this change substantially different from
writeback_sb_inodes() waking up done->waitq less frequently?

								Honza

> ---
>  fs/fs-writeback.c                | 5 ++++-
>  include/linux/backing-dev-defs.h | 1 +
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index cdb2631b8552e1..8d354784326f7a 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -204,7 +204,9 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done,
>  	int left = atomic_read(&done->cnt);
>  
>  	done->progress_stamp = jiffies;
> -	if (left && timeout && (waited_secs > timeout)) {
> +	if (left && timeout &&
> +	    time_after(jiffies, done->report_stamp + timeout * HZ)) {
> +		done->report_stamp = jiffies;
>  		pr_info("INFO: The task %s:%d has been waiting for writeback "
>  			"completion for more than %lu seconds.\n",
>  			current->comm, current->pid, waited_secs);
> @@ -232,6 +234,7 @@ void wb_wait_for_completion(struct wb_completion *done,
>  	unsigned long timeout, waited;
>  
>  	done->wait_start = jiffies;
> +	done->report_stamp = done->wait_start;
>  	atomic_dec(&done->cnt);		/* put down the initial count */
>  	wait_event(*done->waitq, wb_wait_for_completion_cb(done, bdi));
>  
> diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
> index 4f10849373150d..f9fd3b1bf4c609 100644
> --- a/include/linux/backing-dev-defs.h
> +++ b/include/linux/backing-dev-defs.h
> @@ -67,6 +67,7 @@ struct wb_completion {
>  	wait_queue_head_t	*waitq;
>  	unsigned long progress_stamp;	/* The jiffies when slow progress is detected */
>  	unsigned long wait_start;	/* The jiffies when waiting for the writeback work to finish */
> +	unsigned long report_stamp;	/* The jiffies of the last report */
>  };
>  
>  #define __WB_COMPLETION_INIT(_waitq)	\
> 
> -- 
> 2.53.0-Meta
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
