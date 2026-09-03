Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BE244239E;
	Thu,  3 Sep 2026 10:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788432234; cv=none; b=Dddexw/3DE29oMzSmJAanuplog+qVeUUcaMTVtCOLvYUJri4DXEOVZJ2U+VCo5c18j3TxJTdjgnE6ddVgumhlySGIdNLgk8y2gHb9rIDKU/UMbA1kmA639WcZK91BblaAhyy/Zsa6Q137zfqpAp3zB4+bOvhiIL9sAEsIq+pug8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788432234; c=relaxed/simple;
	bh=9bwFkXE/f9SR0xge/C4Ui8DJt0PBN+jcuUwCspL0Bmk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=spAFaZzn27QUEne6jNCZZsBjM27bR2w4Hi4bjLShqSGnxPbDSdcHLuUlHI8EgnJ52hPgkLv5sa6mHG/lpl8IMPjJwiZFF+c2OzMhSzjN2peKJUjfCwOhlSwPpDfLpxMnIKijuE0t/rbHQesDTMhrbQpFreAQRmvrA3hNseWsjS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KwL+d+VN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=G/wkuO+8; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rN6OBiun; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=cZzDFwux; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KwL+d+VN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="G/wkuO+8";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rN6OBiun";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="cZzDFwux"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9D7AD1FE40;
	Thu,  3 Sep 2026 10:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788432226; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5bOHKYQ2W0tgyQ7zeKH/M5xbbFFDIk0NaxeQdsh/AfU=;
	b=KwL+d+VN9hYaG8WlrCiRLaX5pPMCsd5IdXQs41gkgFlwdp2sDsXnLsARi+kVxYCbNMuBxe
	6OTCA+IUGtBDP187VfOHXJ7Tkr+tEp56wb9W3bJFEw08/lAvgQJzXPQVIlCXGvtkMfiOqI
	nkabSjYTt7j0qYvC6ob+2n9sb3oB/Jg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788432226;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5bOHKYQ2W0tgyQ7zeKH/M5xbbFFDIk0NaxeQdsh/AfU=;
	b=G/wkuO+85R9pQpdp/KaF+eU3Ux5E+URH540hO4PCT10TP8usSilS+rpV9pPACW5GP4bRgF
	BTKAW0hSPThV0XBw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rN6OBiun;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cZzDFwux
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788432222; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5bOHKYQ2W0tgyQ7zeKH/M5xbbFFDIk0NaxeQdsh/AfU=;
	b=rN6OBiunbfADzwCCzo9S2Jbgt65ss+Sa65NwSPtNFoghWfifxwaZx4z+0pmaG3BwSJhiNx
	M6sRdU61hRvPjksfDFi4fH2PJ+PpRg6/leXERzbVLdyT4b0BhehaP+Hdusb+htnEfHtvIn
	YQamkkrUCackf7Gen7RvUSCUm2TLUKY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788432222;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5bOHKYQ2W0tgyQ7zeKH/M5xbbFFDIk0NaxeQdsh/AfU=;
	b=cZzDFwuxFc3J8HCMTI68idXANFsqI+aofJEJ7z5gKtGOQJTsmyNeZAzbDNSVd+XAsNvQQQ
	VybOXDcn1nhAaHCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5CA33136E6;
	Thu,  3 Sep 2026 10:43:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DsqXFV5PmWqoMAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 03 Sep 2026 10:43:42 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E1FB2A13AC; Thu, 03 Sep 2026 12:43:41 +0200 (CEST)
Date: Thu, 3 Sep 2026 12:43:41 +0200
From: Jan Kara <jack@suse.cz>
To: Shaojie Sun <sunshaojie@kylinos.cn>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] fs: namespace: drop BUG_ON() in copy_mnt_ns()
Message-ID: <nqedakm2hzmzbuu26l6dnnhkyc25k7tls5bognyvcfy7z5oc42@r3bso7zdins4>
References: <aphwXq5bEQwKhqx2@localhost.localdomain>
 <20260903064828.126643-1-sunshaojie@kylinos.cn>
 <20260903064828.126643-4-sunshaojie@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903064828.126643-4-sunshaojie@kylinos.cn>
X-Spam-Score: -4.01
X-Rspamd-Queue-Id: 9D7AD1FE40
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kylinos.cn:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:email,suse.com:email];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO

On Thu 03-09-26 14:48:28, Shaojie Sun wrote:
> The sole caller, create_new_namespaces(), always passes a valid mount
> namespace pointer from the task's nsproxy. The other copy_*_ns()
> helpers, e.g. copy_time_ns() and copy_pid_ns(), don't perform such a
> check either. Drop the BUG_ON() for consistency with them.
> 
> Signed-off-by: Shaojie Sun <sunshaojie@kylinos.cn>

It's indeed pointless. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/namespace.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 1ecd96c918b3..0f35c8c14027 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -4247,8 +4247,6 @@ struct mnt_namespace *copy_mnt_ns(u64 flags, struct mnt_namespace *ns,
>  	struct mount *new;
>  	int copy_flags;
>  
> -	BUG_ON(!ns);
> -
>  	if (likely(!(flags & CLONE_NEWNS))) {
>  		get_mnt_ns(ns);
>  		return ns;
> -- 
> 2.50.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
