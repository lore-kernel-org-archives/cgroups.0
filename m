Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AD03DA7F3
	for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 10:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784544150; cv=none; b=iv1VFrLMzpJGcOYdDi91f3OF1fHAFPOPXVJ7OEUPN4hI7C7AWl9sncriSaARbVPeMjfPHGJUT1HQKBdFz0LWm5YwVT24/bNkdlCFKW4S2ULbN9VVL3mzP45gnFAWguqnOx6dIO5XL7st0ztS45F1NztrWSZsBSA8jmJtEQQoLi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784544150; c=relaxed/simple;
	bh=6JPYsvz+kuqrxzxOte0jMvl3Z6TMqRpNZy7PzO7lDVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lqp03957ldTI10wdhv2zcllCriaxRrdeUuV0V4dz+zVUkGBgMJOocgz2mweYz4h98btqo/DyWwpdUgjVfx3QdMgxA3Od+6ztlJqwVeiCvfKGOA/B4WkzCpZosCne5iECVq0fxefCxCb/eogUkDjDdYcxp0AdNuTibKKN5eYMHGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=jtQaI1T4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=irzBSGxy; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=jtQaI1T4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=irzBSGxy; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="jtQaI1T4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="irzBSGxy";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="jtQaI1T4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="irzBSGxy"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F262379EDE;
	Mon, 20 Jul 2026 10:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784544144;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aqap3wdPva9/l6VNETK9i+qMdkB62Ft/1ZxEFof7ChI=;
	b=jtQaI1T4n6R0UUo1+22JWN66cg+JsX33EFSvQxdLO+z/ukidOKrUlWsTFzLw9u5w/xmN7u
	aSiw/Myip7rXPbbzRJqEzLCQBIVfCRaX2m2ngdrcNgchkQkb/O8G6UoE5xmLda+8131RL5
	jjoEzaoaUb+60K2F4tE2sqoirMvlOuY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784544144;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aqap3wdPva9/l6VNETK9i+qMdkB62Ft/1ZxEFof7ChI=;
	b=irzBSGxyGWq64BLmlkqnrOdIxhHPNmLP4WuHGPapcQNxqfvwaxdiQ5tfj5WotMOvjC7wiK
	O+2cBrYo+fGynHDw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jtQaI1T4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=irzBSGxy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784544144;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aqap3wdPva9/l6VNETK9i+qMdkB62Ft/1ZxEFof7ChI=;
	b=jtQaI1T4n6R0UUo1+22JWN66cg+JsX33EFSvQxdLO+z/ukidOKrUlWsTFzLw9u5w/xmN7u
	aSiw/Myip7rXPbbzRJqEzLCQBIVfCRaX2m2ngdrcNgchkQkb/O8G6UoE5xmLda+8131RL5
	jjoEzaoaUb+60K2F4tE2sqoirMvlOuY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784544144;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aqap3wdPva9/l6VNETK9i+qMdkB62Ft/1ZxEFof7ChI=;
	b=irzBSGxyGWq64BLmlkqnrOdIxhHPNmLP4WuHGPapcQNxqfvwaxdiQ5tfj5WotMOvjC7wiK
	O+2cBrYo+fGynHDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C5CD7779AA;
	Mon, 20 Jul 2026 10:42:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qhMYMI/7XWpybAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 20 Jul 2026 10:42:23 +0000
Date: Mon, 20 Jul 2026 12:42:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@fromorbit.com,
	dgc@kernel.org, qi.zheng@linux.dev, baolin.wang@linux.alibaba.com,
	brauner@kernel.org, cgroups@vger.kernel.org, clm@fb.com,
	dsterba@suse.com, hannes@cmpxchg.org, hughd@google.com,
	jack@suse.cz, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>, kernel-team@meta.com
Subject: Re: [PATCH v2] fs: push nr_cached_objects memcg gating into
 individual filesystems
Message-ID: <20260720104218.GA10684@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260715103516.2410175-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715103516.2410175-1-usama.arif@linux.dev>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,twin.jikos.cz:mid,suse.cz:email,suse.cz:dkim,suse.cz:replyto,linux.dev:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: F262379EDE
X-Spam-Score: -4.21

On Wed, Jul 15, 2026 at 03:35:16AM -0700, Usama Arif wrote:
> Commit 0baad6f9b997 ("fs/super: skip non-memcg-aware nr_cached_objects
> in memcg slab shrink") added a check in fs/super.c that skipped every
> ->nr_cached_objects() hook whenever the shrinker was invoked for a
> non-root memcg, on the assumption that none of them honour sc->memcg.
> 
> That assumption is wrong for XFS, whose inode-reclaim hook is
> intentionally driven from per-memcg contexts to free memcg-charged
> slab. Encoding a blanket "never memcg-aware" policy in fs/super.c
> short-circuits that path.
> 
> Push the check down into the callbacks whose counters really are
> irrelevant to per-memcg reclaim - btrfs_nr_cached_objects() and
> shmem_unused_huge_count() - and drop the fs/super.c gate. Each
> filesystem can now lift the restriction independently if its counter
> later grows memcg awareness, without touching fs/super.c.
> 
> Introduce mem_cgroup_shrink_is_root() in <linux/memcontrol.h> so the
> callbacks don't open-code "sc->memcg is NULL or root".
> 
> Fixes: 0baad6f9b997 ("fs/super: skip non-memcg-aware nr_cached_objects in memcg slab shrink")
> Acked-by: Qi Zheng <qi.zheng@linux.dev>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
> v1 -> v2:
> - Do not gate xfs_fs_nr_cached_objects(); XFS's inode reclaim is
>   intentionally driven from per-memcg contexts to free memcg-charged
>   slab (Dave Chinner).
> - Add mem_cgroup_shrink_is_root() helper in <linux/memcontrol.h> so the
>   filesystem callbacks don't open-code "sc->memcg is NULL or root".
>   (Dave Chinner)
> - Add fixes tag (Dave Chinner)
> ---

For

>  fs/btrfs/super.c           | 10 ++++++++++

Acked-by: David Sterba <dsterba@suse.com>

Thanks.
