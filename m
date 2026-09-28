Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F60470429;
	Mon, 28 Sep 2026 23:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790639775; cv=none; b=Td2/20MDoze8b44v4lVDQUOEvOK+fE2PzBNoWK0eTCXrDybULsjYAb7BZ5IfC4i1wO2+S49FOJAIA+V/fFwcrZEsvGRSSCrFxbwF6vlySvLn7F87Xcc6dADefAGSX5okNTI1TyYDU8pYsYfrymFCwQ6gaFyNH0siiEo9OWhBZ28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790639775; c=relaxed/simple;
	bh=adJsT+7K2CBz4z10c9Dy0gf9OCNeDTK2rTAS2WkT0FM=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=oGKb3btmX8Bti/eaV87KiWmgbL+IsIIxQ4Bmi7UAsHK3cLGplzb23zd/rgKqHV0C3LdMDbYSDM16gkvawd9ItITa6693aH9UnXuaSwTbrmhdBPlw6LKyn+byR1+eRIbzwmGJ1P9otkelqoxOy04GOS6c32MBwa85quhBRaki7ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0mtG3IS3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0mtG3IS3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F541F000FF;
	Mon, 28 Sep 2026 23:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790639773;
	bh=NduKmuGz5k+Yl2Dj4XUx7MOPCMJ1dsEeFTs5x7PbkCU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=0mtG3IS3AjRMlLkBODaCosQqWqMIEqMxHMaiGV2+i4KKWXI63nOdL+oIMrqqRh5sI
	 rnT5XPmaIqHNErbK/3zuzUHkeruyLbjNI4ZgW0BSJV6/xkZNUC5+sp32RrTnT1CdXx
	 LXQfIs/IM2vM+hz/+FTr67ojsO5jGmDveB9Go0GM=
Date: Mon, 28 Sep 2026 16:56:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Liz Fong-Jones <lizf@honeycomb.io>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Tejun
 Heo <tj@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe
 <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Xin Yin
 <yinxin.x@bytedance.com>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 ian@honeycomb.io
Subject: Re: [PATCH v2] writeback: let foreign flushes reach dying cgwbs
Message-Id: <20260928165612.dca65d7bacfc726508ad7d97@linux-foundation.org>
In-Reply-To: <20260928-wb-dying-cgwb-flush-v2-1-56b54cda74f2@honeycomb.io>
References: <20260928-wb-dying-cgwb-flush-v2-1-56b54cda74f2@honeycomb.io>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 28 Sep 2026 22:12:59 +0000 (UTC) Liz Fong-Jones <lizf@honeycomb.io> wrote:

> ---
> At Honeycomb, a container that reads from Kafka and writes columnar
> files to a host volume stalls for 30-60s after each deploy replaces it
> (v6.18). We're increasingly confident this is the cause: the stall
> looks the same as in the reproducer (little CPU use, lag growing
> linearly and then recovering), and the mitigation it predicts, moving
> our final syncfs after the last write, worked in production (below).
> We haven't caught it with probes in production yet.
> 
> ...
>
> Trigger: a cgroup dirties files and is removed while they are still
> dirty; a sibling keeps appending to the same files under a parent memory
> limit. Symptom: cgroup_writeback_by_id() returns -ENOENT and the sibling
> stalls in balance_dirty_pages(). Minimal recipe below; the harness that
> produced the numbers (paced writer, lag per second, MODE=alive control)
> is at https://gist.github.com/lizthegrey/2209d831930588f63076bdc0ac7b78e2.

IMO the above two paragraphs are the most important part of the patch
description yet they're in the throw-away section.  They should be right at
the start of everything.  Thanks for at least including them - many do not.

This is what people want to know!  What problem does this solve?  What
benefit is this to our users?  Downstream people want to know "what
benefit is this to me?".  Maintainers want to know "why should I spend
time on this person's patch rather than the billion others"?

But I keep saying that, to no observable effect, sigh.
