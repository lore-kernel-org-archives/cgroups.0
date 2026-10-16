Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C4A384243;
	Fri, 16 Oct 2026 14:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792161306; cv=none; b=MhzNlXLbyiyyhQjfOrFqwKQ7wwn7j6MNI9A8lI8f5ZpKh7vSmTVg46uaLx+qK5ZjSwcxjIqJCXJQn6+2MtDHuP0EGkdf+edRtPudsbhpbpgpd/jxbp6JLtr4OuSIFM0hZQRuO0SfceT8JSS1tHRwim1mKvOJK05S+4voXfWM+Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792161306; c=relaxed/simple;
	bh=aBVgL8O/8INZNFlNDJwxZAU+ZC8md4pxGzLmVIYYXgA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nYwrvU4zl70VUfxOEGd9TxlUgVmrivf4XJX+UMSKUjGCwXOHr3w2ni5fk9iEw4AzZMYveRZsICljYihusRvQhxPjZL5f6Oc7yzij0YFIf+XaPe8YwiIToZAYdw5L4FsZqbEevU1uueWbSzkRlWggd/0Gsk1/2RNXQKYWpKZxZ/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nrPNjHrN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mMNOoK6G; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nrPNjHrN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mMNOoK6G; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nrPNjHrN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mMNOoK6G";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nrPNjHrN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mMNOoK6G"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CF34B1F445;
	Fri, 16 Oct 2026 14:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792161303; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DvevIo56gnD9RKfRjHMCZAoapMkclUhhZLXxXNOsKFw=;
	b=nrPNjHrNIwZqSdnT+S2HVu9fYo8T+GCugireiC7KlLuJP4f+ehAQRuLl6pePQ6dJaIC1q2
	GNSYj3MEl4wuGijoCWZjAUn/twscjJOIeaosYj9t/XVS7rCZs/weJfF1y23VfbBljJx1oh
	5Z14GJ8axXI09jlYiKHygstCBYqeAVw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792161303;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DvevIo56gnD9RKfRjHMCZAoapMkclUhhZLXxXNOsKFw=;
	b=mMNOoK6G6Ocet99MnO8c8h594dYsTr4U2fP4oNNKJ3SNRHni99cmls3pXJoxSDUf/SaCBm
	NOQl+0z/7m2KJnDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792161303; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DvevIo56gnD9RKfRjHMCZAoapMkclUhhZLXxXNOsKFw=;
	b=nrPNjHrNIwZqSdnT+S2HVu9fYo8T+GCugireiC7KlLuJP4f+ehAQRuLl6pePQ6dJaIC1q2
	GNSYj3MEl4wuGijoCWZjAUn/twscjJOIeaosYj9t/XVS7rCZs/weJfF1y23VfbBljJx1oh
	5Z14GJ8axXI09jlYiKHygstCBYqeAVw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792161303;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DvevIo56gnD9RKfRjHMCZAoapMkclUhhZLXxXNOsKFw=;
	b=mMNOoK6G6Ocet99MnO8c8h594dYsTr4U2fP4oNNKJ3SNRHni99cmls3pXJoxSDUf/SaCBm
	NOQl+0z/7m2KJnDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BD7C61378C;
	Fri, 16 Oct 2026 14:35:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MNLIJBY20mr7JAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 16 Oct 2026 14:35:02 +0000
Date: Fri, 16 Oct 2026 15:35:01 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, Kuniyuki Iwashima <kuniyu@google.com>, 
	linux-hardening@vger.kernel.org, stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 2/2] ipc, msg: Account msg_msg allocations with
 GFP_KERNEL_ACCOUNT again
Message-ID: <atI1-HjSgPkLCNQT@pedro-suse.tail5790ac.ts.net>
References: <20261014052338.nothing.279-kees@kernel.org>
 <20261014052344.384723-2-kees@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014052344.384723-2-kees@kernel.org>
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spam-Flag: NO

On Tue, Oct 13, 2026 at 10:23:43PM -0700, Kees Cook wrote:
> Since commit 734bbc1c97ea7 ("ipc, msg: Use dedicated slab buckets for
> alloc_msg()"), alloc_msg() allocates with GFP_KERNEL, and a msg_msg is
> accounted only through SLAB_ACCOUNT on its bucket caches. With
> CONFIG_SLAB_BUCKETS=n, kmem_buckets_create() creates no caches and
> kmem_buckets_alloc() is a GFP_KERNEL kmalloc() from the general caches,
> which do not account it; the same happens when kmem_buckets_create()
> fails. Either way, the allocation is not charged to the sender's memory
> cgroup.
> 
> Allocate with GFP_KERNEL_ACCOUNT again, as before that commit, so the
> allocation is charged whichever cache serves it.
> 
> Build tested ARCH=x86_64 defconfig with GCC 16.2.0, with
> CONFIG_SLAB_BUCKETS as y and n.
> 
> Fixes: 734bbc1c97ea7 ("ipc, msg: Use dedicated slab buckets for alloc_msg()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <kees@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
 

-- 
Pedro
