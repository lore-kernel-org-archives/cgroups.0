Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF853B388A
	for <cgroups@vger.kernel.org>; Thu, 15 Oct 2026 11:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=149.72.141.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792064702; cv=none; b=IJpuCr4cUY/B5QvmcLMpZmipc8FFyGy30IdmMxBTdWEK1qoydgflKHcpguKEggZ43C2JdGjLbujavPuLzK3pcIoJ5R8eAQplVEAN3m+xG5fYf5uhlBrfVu3s8RFHFatNES3ftU+/oCEfrl4qsp2yduDIl0+IF7QH9vpxfQL+d3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792064702; c=relaxed/simple;
	bh=sJmD9ocK7Fs9suTaTWnyV7Zu9zx34PL0h0sFqWfJXTk=;
	h=From:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 To:Cc:Content-Type; b=J6WepbtvizNYtXkkIkNQ5QXhO9OmIcE7uW8VEc3uWUm/2rnP+F2jLohUkl8cak5u2aCFEaGNRX0Bzy58vrof2olV6V8klvInKjnHPu5SgzEMJzicyo825BZmtO1bYx9FUkE0ApO9UWo5gYVCNXcqSOF7zdR0NivQsX+T6V5fdcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io; spf=pass smtp.mailfrom=em.honeycomb.io; dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b=aKFcWymC; arc=none smtp.client-ip=149.72.141.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=em.honeycomb.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b="aKFcWymC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:subject:date:in-reply-to:references:mime-version:to:cc:
	content-type:content-transfer-encoding:cc:content-type:date:from:subject:to;
	s=s1; t=1792064700;
	bh=sJmD9ocK7Fs9suTaTWnyV7Zu9zx34PL0h0sFqWfJXTk=;
	b=aKFcWymCpbK2U7jOrv7orsYLbstUHzod+zvjfY0Pzzd7FJyo8BCsFao+2EiAd+MNVQ0e
	OOzI2CeE5+7y8VpUorgtij77WKMsbF+VEemFDcAS+dIPvQ9Wt7yJXAa1rdtrlqP44hWRK+
	HmB751/FA/DW46SE4XAuVezWnS6MFFISiG7pTjh7f2N1/dwE6K9GkTOCN3cto7hCIJP+sp
	5SaWB64U00YuYfRheqwbWB0J+/nQ+cJ3NCQXZ6FGtffxlDsbMTDHO/kXeZTcthSDNGdhUI
	Meq8N9EVF/MrAaiAHGffWh+mu/q3S7rP6/76cZFrTZQN7THayjFLedINL9DXHHxA==
Received: by recvd-76bcf77c4-v72n6 with SMTP id recvd-76bcf77c4-v72n6-1-6AD0BCBC-1C
	2026-10-15 11:45:00.1120767 +0000 UTC m=+1363486.465368565
Received: from daisy.dens.ffj.family (unknown)
	by geopod-ismtpd-22 (SG)
	with ESMTP
	id 5MqOTtk5QKKOvgGuVd3Z1w
	Thu, 15 Oct 2026 11:44:59.807 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Subject: Re: [PATCH v6 3/3] writeback: switch a replaced cgwb's inodes to its
 successor
Date: Thu, 15 Oct 2026 11:45:00 +0000 (UTC)
Message-ID: <20261015114459.1041805-1-lizf@honeycomb.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <0bc5d58533f10b4841807be3025daa11@kernel.org>
References: <20261002-wb-dying-cgwb-flush-v6-3-1991b4e2dcff@honeycomb.io> <0bc5d58533f10b4841807be3025daa11@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmeR8+gg6UKbfD?=
 =?us-ascii?Q?LHFRc+T=2Fmyn=2FDBRPotnjtiCsmyxPemx3wCGze0c?=
 =?us-ascii?Q?niTUhutH87NutD8y4iKX74jl+ogMc=2FOdfUbm8qm?=
 =?us-ascii?Q?Dd7EtdIPoLsLxjtf15IuRr555HQhbTpbuxpaDb3?=
 =?us-ascii?Q?PJSep05gR2AX7aiOv8TZ+Gg=2F08zHIv3VFE9ll82?= =?us-ascii?Q?KKiY?=
To: Tejun Heo <tj@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner
	<hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
	<shakeel.butt@linux.dev>, Xin Yin <yinxin.x@bytedance.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, ian@honeycomb.io, Liz Fong-Jones
	<lizf@honeycomb.io>
X-Entity-ID: u001.GRlkmHQ+Ka/CKxmoC/CxTw==
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Tejun,

Thanks, confirmed. On mainline, with a debug delay holding a sync's
work between its cutoff and queue_io(), v6 left 378 of 400 files empty
after a crash and v7 none. v7 holds wb_switch_rwsem across the scan and
takes your other three points:
https://lore.kernel.org/all/20261015-wb-dying-cgwb-flush-v7-0-9278d9ebaf5d@honeycomb.io/

Since f6988c90671e, mainline's own cleanup_offline_cgwb() rotates
b_dirty_time the same way, so a racing syncfs can drop lazytime
timestamps. Separate fix:
https://lore.kernel.org/all/20261015114307.1041273-1-lizf@honeycomb.io/

Liz
