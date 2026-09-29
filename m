Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950BE2EFD9B
	for <cgroups@vger.kernel.org>; Tue, 29 Sep 2026 01:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=149.72.141.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790646408; cv=none; b=Z+YzyUVxxKBv0Brojkrn68HEytBEpBoLAm/pCmkhvwBc2PerEMG5HI3oemagYHyof/Qs+0UzzBLN1NegS/oFuHwK6v9GSDVs825bkPFMD2SdIcrxeFK+pWgVw6epQTtw5gYBZay2lYJDpweLqwctEL7qeeFuJVJlgDFeabuw+W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790646408; c=relaxed/simple;
	bh=6lBeqk7ZMmYqADn0KlVVkmHsuUwcWw3h8t4K/mjrNiE=;
	h=From:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 To:Cc:Content-Type; b=ZcXWt8uXd0/Bca3CWsB/c3A0762loL+Pq5aKL2QA4yE5CoO366uaPnhhp5iH7s5Uj6FvMhuXcgWvgRv9OgsnZnVW185L+kjYjSCSyRChqhRDZos3h0h3oRFghgIU+p9pu+vwKBp+BNHB7LBe7XEiztGuP/OqUCjxCiSez4odZGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io; spf=pass smtp.mailfrom=em.honeycomb.io; dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b=sGKnxiV+; arc=none smtp.client-ip=149.72.141.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=em.honeycomb.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b="sGKnxiV+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:subject:date:in-reply-to:references:mime-version:to:cc:
	content-type:content-transfer-encoding:cc:content-type:date:from:subject:to;
	s=s1; t=1790646405;
	bh=6lBeqk7ZMmYqADn0KlVVkmHsuUwcWw3h8t4K/mjrNiE=;
	b=sGKnxiV+okdIXSvB4OVyd6pGI5U0olcLWwzMYSyWq4Dax/C+GYGqOy5xd8N/QsYXghC0
	DvKhPBwVwRvXTMzgIoDMnn4U4708DFo/VDTGWWk7IELDliFp/5Tji8LZcJASC8lcrux7ha
	GHiwcNY1Lddv06tXXuAipQEUuGipZs9AbGyCQGFVqzDMBQ9hepc3trP63V6zpX30idhrck
	rQgkphQnSTLcU+TvEnusPzk/yOw8nBWUsqvvSHascg5PS6ipE0y/4wrOq6V+pS0PEURU81
	ITdXOFPzeFiju0YQgaCmhx1ZTQN+nB+iUzXRua+pJECTK8mHHV6gWBCyqOTu/NZQ==
Received: by recvd-57cdcfbc54-tb8pr with SMTP id recvd-57cdcfbc54-tb8pr-1-6ABB1885-11
	2026-09-29 01:46:45.321909534 +0000 UTC m=+366573.172150114
Received: from daisy.dens.ffj.family (unknown)
	by geopod-ismtpd-17 (SG)
	with ESMTP
	id -xay3FoUR3mtoIteZJGP0A
	Tue, 29 Sep 2026 01:46:45.196 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Subject: Re: [PATCH v2] writeback: let foreign flushes reach dying cgwbs
Date: Tue, 29 Sep 2026 01:46:45 +0000 (UTC)
Message-ID: <20260929014644.1573035-1-lizf@honeycomb.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <6d0542fc07639c8df7672b12f4ecd906@kernel.org>
References: <20260928-wb-dying-cgwb-flush-v2-1-56b54cda74f2@honeycomb.io> <6d0542fc07639c8df7672b12f4ecd906@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmef9V6iSK9oEL?=
 =?us-ascii?Q?O5dVfUwdZ72bnTq17N=2FPD+RpYmsb=2F1PAS5DkU=2Fa?=
 =?us-ascii?Q?EPirahDBNlWLukVeitbIFb7+FF9QlAKGVgYoWgb?=
 =?us-ascii?Q?BnK1cTEbb8Dmze6zwDIWrs7458DfykvRQ3d90Kg?=
 =?us-ascii?Q?NavUwGYWPSTHeojOw8xaHaZ2XJzd4CY3p83=2FOJr?= =?us-ascii?Q?zOi8?=
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christian Brauner
	<brauner@kernel.org>, Jan Kara <jack@suse.cz>, Alexander Viro
	<viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, Johannes Weiner
	<hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
	<shakeel.butt@linux.dev>, Xin Yin <yinxin.x@bytedance.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, ian@honeycomb.io
X-Entity-ID: u001.GRlkmHQ+Ka/CKxmoC/CxTw==
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi Tejun,

Thank you for your patience with this. It's only my second upstream
contribution to the Linux kernel, and I needed the guidance on how you
handle shared data structures and locking and how you preferred to
resolve this issue.

All addressed in v3:
https://lore.kernel.org/all/20260928-wb-dying-cgwb-flush-v3-0-e35374884667@honeycomb.io/

The writeback kick is patch 2. cgwb_create() can run with interrupts
disabled (folio_account_dirtied() -> inode_attach_wb()), so it kicks
the replaced wb after dropping cgwb_lock and makes wb_wakeup()
irq-safe. The cover letter has a test of that case and a question
about the part the kick doesn't cover.

Thanks,
Liz
