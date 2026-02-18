Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284742FFDD5
	for <cgroups@vger.kernel.org>; Wed, 18 Feb 2026 11:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771413817; cv=none; b=LkoR+qDPn/wDyf4cCwzWObBemC4qlYWLTM2g/35O4Xd2UQC5C3/tirE90G3j6c9b6003zLAi7lcB6jBv4yX1J+T4RzWzNeyAlxuGxHSocQ+bFVU021PCBF34fDPSTA3IVNvjEtjrL4fa0xCrq55uHKzMZKlgPhoiYoHcepmrBA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771413817; c=relaxed/simple;
	bh=yFzmeKNc7jZe/g1nyERcuQ8+IviWJtyHr9DjwQGUEAk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PRU8MrneQqH2zN7cyTWTU2aMV/7/TExqDpbqhROTMkcqg+UKcHqOLoBiSIGV9ie3pANPGr2qi631oCFeWw97Ek3lUV63M2Hut6wQz37nyz1CA8Lm2ETOY3LMAQCvxQ5xueaVSX8oMKJ2EyJpxxyxo0C4LHIRRlgrZLldLA8NA7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TEf8au3N; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=IEKUNOlE; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=YjVaDXeO; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=GkEcKhNC; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TEf8au3N";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="IEKUNOlE";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="YjVaDXeO";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="GkEcKhNC"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 14C715BCC2;
	Wed, 18 Feb 2026 11:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1771413814; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3ZiElcFxYYD1oatQKw1wrqUrp5IBMjHeUNq0WywWxgo=;
	b=TEf8au3NMnRwYsR5VLtTfIB1DZ+18/4Rt/F1tKfE7C4/yNBLd5Vm5xZCUQkkaTWioKLmvA
	V0Qpq8BEB0Q9Kb3nJLXnSfdHdT9Hd6uu4PMhNx8owN2P/TSVOKOMEqzO2IfSFWEn0BFvEF
	LXLfZslfLXmf43hE+T5S10h9gZ4QsvY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1771413814;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3ZiElcFxYYD1oatQKw1wrqUrp5IBMjHeUNq0WywWxgo=;
	b=IEKUNOlER5U2c3PQj2qeSVKFZBC+6dXuXR33rQI1WFI0VB5BDA2D2mQhrfJ1vBeP334LDz
	XfhzcvhCDx2FK9AA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YjVaDXeO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GkEcKhNC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1771413813; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3ZiElcFxYYD1oatQKw1wrqUrp5IBMjHeUNq0WywWxgo=;
	b=YjVaDXeO/Lsd9R+YvmCO66ynrx6X05ZBkYJ6nplpf64mkS0CSUw3D9vR/w3CVrza61iNp7
	/NKfg9fS+YUfofVDV66vtA1hNZxL/rBegeM3a7Rtj8MbSEcgRkGxjSFDIyIKXtm925Wi7X
	KeTps1vjPVpLWrTQv+CBzQQN24MDkCk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1771413813;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3ZiElcFxYYD1oatQKw1wrqUrp5IBMjHeUNq0WywWxgo=;
	b=GkEcKhNCHlUvv2oHbiYdczS5bXSsoxmza9fBW2vL9mK0WTurj5f/GKF41y9L26cFnQu1j0
	TCDXmqdPUO+zHLCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ED05F3EA65;
	Wed, 18 Feb 2026 11:23:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aDjGOTShlWlCWQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 18 Feb 2026 11:23:32 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 92B8AA08CF; Wed, 18 Feb 2026 12:23:32 +0100 (CET)
Date: Wed, 18 Feb 2026 12:23:32 +0100
From: Jan Kara <jack@suse.cz>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: Amir Goldstein <amir73il@gmail.com>, gregkh@linuxfoundation.org, 
	tj@kernel.org, driver-core@lists.linux.dev, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, jack@suse.cz, shuah@kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 2/3] kernfs: send IN_DELETE_SELF and IN_IGNORED on
 file deletion
Message-ID: <lc2jgt3yrvuvtdj2kk7q3rloie2c5mzyhfdy4zvxylx732voet@ol3kl4ackrpb>
References: <20260212215814.629709-1-tjmercier@google.com>
 <20260212215814.629709-3-tjmercier@google.com>
 <aZRAkalnJCxSp7ne@amir-ThinkPad-T480>
 <CABdmKX3wsWphRTDanKwGGiUWoO0xTaC8L_QxjHzhpxfZn256MQ@mail.gmail.com>
 <CAOQ4uxgrP=VdTKZXKcRE8BeWv6wZy7aFkUF-VoEpRSxVnHZi2w@mail.gmail.com>
 <CABdmKX1ztzJ6B13uzdDtN-uVWbdWuYJ6PMvjGoAfu40MMHCpaA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABdmKX1ztzJ6B13uzdDtN-uVWbdWuYJ6PMvjGoAfu40MMHCpaA@mail.gmail.com>
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[11];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,linuxfoundation.org,kernel.org,lists.linux.dev,vger.kernel.org,suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 14C715BCC2

On Tue 17-02-26 14:32:25, T.J. Mercier wrote:
> On Tue, Feb 17, 2026 at 1:25 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > > > Are you expecting to get IN_IGNORED|IN_DELETE_SELF on an entry
> > > > while watching the parent? Because this is not how the API works.
> > >
> > > No, only on the file being watched. The parent should only get
> > > IN_DELETE, but I read your feedback below and I'm fine with removing
> > > that part and just sending the DELETE_SELF and IN_IGNORED events.
> > >
> >
> > So if the file was being watched, some application needed to call
> > inotify_add_watch() with the user path to the cgroupfs inode
> > and inotify watch keeps a live reference to this vfs inode.
> >
> > When the cgroup is being destroyed something needs to drop
> > this vfs inode and call __destroy_inode() -> fsnotify_inode_delete()
> > which should remove the inotify watch and result in IN_IGNORED.
> 
> Nothing like this exists before this patch.
> 
> > IN_DELETE_SELF is a different story, because the inode does not
> > have zero i_nlink.
> >
> > I did not try to follow the code path of cgroupfs destroy when an
> > inotify watch on a cgroup file exists, but this is what I expect.
> > Please explain - what am I missing?
> 
> Yes that's the problem here. The inode isn't dropped unless the watch
> is removed, and the watch isn't removed because kernfs doesn't go
> through vfs to notify about file removal. There is nothing to trigger
> dropping the watch and the associated inode reference except this
> patch calling into fsnotify_inoderemove which both sends
> IN_DELETE_SELF and calls __fsnotify_inode_delete for the IN_IGNORED
> and inode cleanup.
> 
> Without this, the watch and inode persist after file deletion until
> the process exits and file descriptors are cleaned up, or until
> inotify_rm_watch gets called manually.

Hrm. I was scratching my head how it is possible VFS isn't involved for a
while. So let me share what I found:

Normally fsnotify_inoderemove() is called from dentry_unlink_inode() which
is called from d_delete() (name unlinked) and __dentry_kill() (last dput()).
Now it is true that kernfs doesn't bother with pruning child dentries from
its rmdir implementation. It just marks all corresponding kernfs_nodes
(inodes) as dead and that's it so d_delete() isn't called. But vfs_rmdir()
makes up for this by calling shrink_dcache_parent() on the removed
directory so the child dentries end up going through __dentry_kill(). *But*
kernfs also doesn't bother to set i_nlink for these child dentries to 0
when marking them as dead and so __dentry_kill() doesn't call
fsnotify_inoderemove(). So at this point it seems more like a kernfs bug
that children inodes aren't properly cleaned up by setting i_nlink to 0 and
I don't think we should paper over this by calling fsnotify_inoderemove()
explicitely.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
