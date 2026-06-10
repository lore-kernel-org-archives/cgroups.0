Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDD7264A9D;
	Wed, 10 Jun 2026 01:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781055002; cv=none; b=VhBdhvPoJRvPfGME9aIGzS3IUELwJgIMEfjdNmYlJIoq+r3ZZn4aZzzNkIRFCKG2O6Sp6TF/Bw9YR3zXXdJC40R1F7t9S2La3aL8EwsSlC4jJ3aISxJ1JmNx/6aSB8lh4FSVnOsl6sWpXPy5MhHuOBdZdaUNxCatkM5CVjwwivg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781055002; c=relaxed/simple;
	bh=bF6VfW3IcdRUU0WmPux4DnQ6Hh8vJP9rlOVl9ttQi9Y=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=EEzb22cnZlXlFz+VR3CdhyOWOezvGH2/U9VIOyJnKcu4Xo0g0pkGvyk2pDuHvmTo5Nqn8dAcJvz9Bp9ErBMmsy/jjRnFfuuGcoBc9HdeqvinoCdbXdLlVyUm6gcSNUIrPC3xx47gOgZD08rnh4RMZq0WPCxYSXk3OhC+5qlF1ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MVvxqZno; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MVvxqZno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196531F00893;
	Wed, 10 Jun 2026 01:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781055001;
	bh=vCu1T632UHHSmMD6YMm6b95GrTeLcRhEQPBtBgubed4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=MVvxqZnoKUjEUjzEL4TCTecwj5jDqNyDY0+GscoaF5wWNyAK71Qwrc34YHlnptrRq
	 nsCmYcJ+Eu1ChHvsa+GonSavxipEUjy74I8tCPdVCbjFfbFTgrTtgzYm4TH7BIi4uZ
	 SqDcuVpaTogPoAcI6Zhrv5rHbhoL64q2dNsunzsE=
Date: Tue, 9 Jun 2026 18:30:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ruoyu Wang <ruoyuw560@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: memcontrol-v1: use nofail allocations for soft
 limit trees
Message-Id: <20260609183000.296ae8ab0f0e90341de43198@linux-foundation.org>
In-Reply-To: <CAK_7xqyyDqNW1+puMSp2LzxmOKxFUx-UO9uGiDKoL7ZTJ8+3ZQ@mail.gmail.com>
References: <20260608063644.39-1-ruoyuw560@gmail.com>
	<aiZ3EZZV6LqsTxQM@tiehlicka>
	<CAK_7xqyyDqNW1+puMSp2LzxmOKxFUx-UO9uGiDKoL7ZTJ8+3ZQ@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 8 Jun 2026 16:34:48 +0800 Ruoyu Wang <ruoyuw560@gmail.com> wrote:

> This was found by static analysis and then checked by reading the code:
> memcg1_init() dereferences rtpn unconditionally after kzalloc_node(). I
> treated the soft-limit tree as mandatory memcg v1 init state and used
> __GFP_NOFAIL because continuing without it would not be useful.
> 
> I agree this is early boot init code, and I do not have a
> runtime failure report or fault-injection reproduction for it.

Thanks.

Please teach the static analyzer that kernel practice is to ignore
allocation failures in __init code.
