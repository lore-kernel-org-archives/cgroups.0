Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D98C5208DB
	for <cgroups@vger.kernel.org>; Tue, 13 Oct 2026 13:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=149.72.141.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791898472; cv=none; b=LFbwI28cI9eV0CYYRgRzLixx8wjnoRMlva833Gh+SuckqwdZeNaCDHAcmfdI8teAUcTeY+0NWdHHAJqUDwA3HHuFw5Oi4S9mmdYUqIkouS/nSiTYrZsPh5q11rX2FdkN6jw1K+XRgpUw3L4fxmwOJEJ+ezTesWOpPEBj6JZdchk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791898472; c=relaxed/simple;
	bh=Yjc3wFNOxrypJJyu5rTq8Vr1Hd3Zz2aUY0wPnZO4Ji4=;
	h=From:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 To:Cc:Content-Type; b=IBeOWRz/rOlsDmG/AOnnKEMxEkYRllIoiixRmFzyfdK9y7/TzolQDyBfyWBnPFmD4+kWnVi7Al/QUWpVNMr0TLzIJ6VUg88/lADLsgNC+g2nY1GoOdXTx8Btq4EeZyB+EcDX02N7l8FrHGtNi/O/FFq4Qqo9hN06ZGbWBhKzdGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io; spf=pass smtp.mailfrom=em.honeycomb.io; dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b=cjPfxSlL; arc=none smtp.client-ip=149.72.141.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=em.honeycomb.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b="cjPfxSlL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:subject:date:in-reply-to:references:mime-version:to:cc:
	content-type:content-transfer-encoding:cc:content-type:date:from:subject:to;
	s=s1; t=1791898469;
	bh=Yjc3wFNOxrypJJyu5rTq8Vr1Hd3Zz2aUY0wPnZO4Ji4=;
	b=cjPfxSlLQkSUdnf0bT733QfnqIyHwuJRNG6OpW0Z7CvBWxnySk5RMr67Oc8aartloIne
	pK56lqo0wA7bw51ni+1Fcut5Q7x9y5Uavv6FVrVtcE40SFKySwMzXlVILGojlgwyFfNLit
	qbCv0j92NNahom4tTuy0p3LA+dH3TRYvluTbZWUUAdx9ss+S44ajRzJIPWJ4tjWXb0kRLP
	Jef/3beZF2rrIcoj0XVGTFmtxqIksgGYEiSMqcrlhfMjLfbhiI+HLfHgCRTBLcWDW2QwjJ
	gtkvyi8l/XWlXAkflQ0eA+zJtTzDlbJameOVs3/1VpBZormpIJ+VqyABDXqJfqQA==
Received: by recvd-b6785b758-pms9j with SMTP id recvd-b6785b758-pms9j-1-6ACE3364-52
	2026-10-13 13:34:28.727189614 +0000 UTC m=+1197221.645450126
Received: from daisy.dens.ffj.family (unknown)
	by geopod-ismtpd-canary-0 (SG) with ESMTP
	id j7TrPBHQTSyTSY7St2F5YQ
	Tue, 13 Oct 2026 13:34:28.641 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Subject: Re: [PATCH v6 0/3] writeback: let foreign flushes reach dying cgwbs
Date: Tue, 13 Oct 2026 13:34:29 +0000 (UTC)
Message-ID: <20261013133428.725790-1-lizf@honeycomb.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002-wb-dying-cgwb-flush-v6-0-1991b4e2dcff@honeycomb.io>
References: <20261002-wb-dying-cgwb-flush-v6-0-1991b4e2dcff@honeycomb.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmeYytsq=2Fs6xFQ?=
 =?us-ascii?Q?u5VO+EtT9LXkYGlxJUqGOEwoCTZ8+dJNWoztJgA?=
 =?us-ascii?Q?83GYMzdfkdF5Gw1J8iDpMcYzuTiSEt9CPgxMQTC?=
 =?us-ascii?Q?pGzZVQm1U1ZxuHaYW8hkL+IXUDC1TPCzS99Yu3W?=
 =?us-ascii?Q?zXvwbwrQcgmHqTKsNE3l2E5NTbcl7UEbm3pLqXw?= =?us-ascii?Q?ZeAq?=
To: Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, Christian Brauner
	<brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner
	<hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
	<shakeel.butt@linux.dev>, Xin Yin <yinxin.x@bytedance.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, ian@honeycomb.io
X-Entity-ID: u001.GRlkmHQ+Ka/CKxmoC/CxTw==
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Tejun and Jan,

Gentle ping on v6. Patches 1 and 2 carry Tejun's acks. Patch 3 changed
in v6 to queue replaced_work again when a switch lands on a wb that was
replaced after the switch was queued, as Tejun suggested on v5, and it
hasn't had review yet. Jan, you confirmed on v3 that switching all of a
replaced wb's inodes, dirty ones included, is safe; would you have time
to look at patch 3?

Christian, if they're happy with it, could the series go into
vfs-7.4.misc next to Xin's 168a8c13159c? It still applies cleanly there
and to 7.3-rc7. If that's too late for this cycle, I'm happy to repost
on whatever base you'd like to queue it on.

Thanks,
Liz
