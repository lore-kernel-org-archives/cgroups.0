Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3BB187346
	for <cgroups@vger.kernel.org>; Sat, 17 Oct 2026 23:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=149.72.141.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792279575; cv=none; b=obrdlvR1g16tr9f1UuZkVvQKBpVRqG4gwNWO1+Sj+45hJfVmrTWCFEv9tbeUb1W+jSrj0X3d9DrEFr6ctKnbbvGSV6NoIb05yE7TxGgmLv9ntIRVzKv0ZSnjNt8aT7vyp0lHSrSBRmLLUzem7vu0NukkdsXbZd0yh4rrXzC0Kns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792279575; c=relaxed/simple;
	bh=xnAVFjE1eCbBv4nwANE8WB7XFHdzRK+IhFb0m7alkCk=;
	h=From:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 To:Cc:Content-Type; b=D8jgjxibYnEue2l3Qa5ZPHcQM3ICJfB6qcWsyDQMxhVlAb4nYZ74pNJAWTG7WsLoxatciyfcn0mN04ZI6vt5ooIhkf5CJC4dxkhySkgPjG0x1HRSLiOixpR5A37u87woHaO1s6amE54grnI4D4/RyMJCSabw//e9PGWNxBaZRSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io; spf=pass smtp.mailfrom=em.honeycomb.io; dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b=wzZ/6EHB; arc=none smtp.client-ip=149.72.141.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=em.honeycomb.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b="wzZ/6EHB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:subject:date:in-reply-to:references:mime-version:to:cc:
	content-type:content-transfer-encoding:cc:content-type:date:from:subject:to;
	s=s1; t=1792279572;
	bh=5+ChxQruMtybdrIxH4Oe8hOrLdCEmzhndPHUNt+XKPE=;
	b=wzZ/6EHBiigs8/TQYNjoDCs/bWZhBQxV0oRv+5YMCJCot3fU2FYd14whwZFUYDLrpys3
	kZlYEeQH/bQTabrsz58OVISF2LFeixWETRaWwZKJNS0bpwZbV3qzxg1GJVA+6gpY4P8aWp
	nUh/rCk5wI+tB5+966TTp9MOzLesKXbNHI0vV0FnmGXVIDE1txhlWWy3FG/ZqHQkfZVR0y
	AsN32Yox8zgMV/3++bTYWWkls1ddzl1Esxw1wcFgrYDcL8f5RdIDUN+TAemb3wXQQ8AeSx
	oKFM/1JsiluDALnxZSNCfdUudaJMqAmnvRpXnoDi54KBOm7SDYo1mw5mfWVWAFFw==
Received: by recvd-567c5c9644-whh6j with SMTP id recvd-567c5c9644-whh6j-1-6AD40414-60
	2026-10-17 23:26:12.752423817 +0000 UTC m=+1578342.782868143
Received: from daisy.dens.ffj.family (unknown)
	by geopod-ismtpd-142 (SG)
	with ESMTP
	id BqvlJyNgSimQIUNJgrYm1A
	Sat, 17 Oct 2026 23:26:12.534 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Subject: Re: [PATCH v2] writeback: keep cleanup_offline_cgwb()'s scan out of
 syncs
Date: Sat, 17 Oct 2026 23:26:12 +0000 (UTC)
Message-ID: <20261017232610.58733-1-lizf@honeycomb.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261017040710.1174009-1-lizf@honeycomb.io>
References: <20261015114307.1041273-1-lizf@honeycomb.io> <20261017040710.1174009-1-lizf@honeycomb.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmeZBE29le3x4T?=
 =?us-ascii?Q?AizvtRpU7VP809D=2Fmwb1shMNqfUcvGTQsx53Zse?=
 =?us-ascii?Q?L=2FBtvuK5SBXStd+Nht40iPrZhf4f+iwfv6L71g0?=
 =?us-ascii?Q?FKLbhlTdYeICXNmofBIIRovjOiMjB5G3kdxtmqN?=
 =?us-ascii?Q?KZuW1RCsLVxwBuN2mdNSRqdbpmI=2FqJzsyvHDOLH?= =?us-ascii?Q?aJXU?=
To: Christian Brauner <brauner@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>,
	"Patrick Lu (Anthropic)" <perf.patrick.lu@gmail.com>, Roman Gushchin
	<roman.gushchin@linux.dev>, Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, ian@honeycomb.io, Liz Fong-Jones
	<lizf@honeycomb.io>
X-Entity-ID: u001.GRlkmHQ+Ka/CKxmoC/CxTw==
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Christian,

This fixes f6988c90671e, which went into 7.3-rc5, so the regression is
new in this cycle, and f6988c90671e is already tagged for stable. Could
it go into vfs.fixes before 7.3 is released? Tejun has acked it:

  b4 shazam 20261017040710.1174009-1-lizf@honeycomb.io

Separately, the wb-dying-cgwb-flush series now has Tejun's ack on all
three patches and Jan's Reviewed-by, for whichever cycle suits:
https://lore.kernel.org/all/20261015-wb-dying-cgwb-flush-v7-0-9278d9ebaf5d@honeycomb.io/

Thanks,
Liz
