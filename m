Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5ED317164;
	Fri,  2 Oct 2026 19:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790968872; cv=none; b=KbJeJzqdG50MP0FmadAjiLUqYv+bYiZ1kfgjlineZyXN7NvSXBAI/XKAQ3G0fZwCfP91VbyNf2K5kl3bd/cHm5G3X92YO3ZOL4q09wFmdHLa7cD3Qh1AidJL3MV02vP3OdSkrOda1WRrJ5DpUBvZgd5O6agzyi6ZmKXd66qV61o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790968872; c=relaxed/simple;
	bh=0/eVKtwYx7bI64sChNrMU6bYG7D2qmY2Fz9of35KQJ0=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EqRKZOLeQUyNmb0RyrWUUabWCvEFlAIMIAgnh3obr7F7mnDR2EOcpUKD26Lh4eR3T5kdehlgE07Lw//GQucTUQZd9m+Ei9XJPMp9br9rGdV8+FmilHSuKJlyj8jG4wBqedl4+2/7GxmFCbCubrMLKrhPIljTj28tzMyGK0ch2nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ovNnAyh3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ovNnAyh3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1AB1F000FF;
	Fri,  2 Oct 2026 19:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790968870;
	bh=0/eVKtwYx7bI64sChNrMU6bYG7D2qmY2Fz9of35KQJ0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ovNnAyh346GWrvM/Pa4D7TmP57u88mdg15Owap9hy+bR+bDXlso3az5ZkBVUPJAmY
	 n5Om3CMG2tUjOwCbGeOJ0uEmXSDHNdUcT9bVOy7n+HOO5HeSntzsH+z4YO7ZjHc5SD
	 GYZixomL1Ko3ERKHrl13WDWj9+jwrf76p7RigkANmjR11oHZeN/fgPWf+9EwzAi3iq
	 IxCEnwkhqLfqBEm5Ph8gP08PdbjpIRobw8mr0hWSwtPnLMF50I8322MKexn9mxM9Q3
	 GV4zKxYpJ+Ck2xqV2XJyiUcqF1gziFjdxsRL0zRMmqVYP6aOfYYuCcPshShD3Gzm+B
	 Gky+ebnhMrl/Q==
Date: Fri, 02 Oct 2026 09:21:09 -1000
Message-ID: <94e7126416dd6407a46a857e5eaff36b@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Liz Fong-Jones <lizf@honeycomb.io>
Cc: Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Xin Yin <yinxin.x@bytedance.com>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ian@honeycomb.io
Subject: Re: [PATCH v5 1/3] writeback: clear the old wb's dirty IO state after
 switching inodes
In-Reply-To: <20261001-wb-dying-cgwb-flush-v5-1-8361eb8c65c6@honeycomb.io>
References: <20261001-wb-dying-cgwb-flush-v5-0-8361eb8c65c6@honeycomb.io>
 <20261001-wb-dying-cgwb-flush-v5-1-8361eb8c65c6@honeycomb.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello, Liz.

On Thu, Oct 01, 2026 at 11:50:20PM +0000, Liz Fong-Jones wrote:
> Test: a later patch in this series switches all of a replaced cgwb's
> inodes, dirty ones included, to its successor. After that, with every
> writer stopped and the filesystem synced, BdiWriteBandwidth in
> /sys/kernel/debug/bdi/*/stats stayed at 411700 and 407820 kBps with
> b_dirty, b_io and b_more_io all empty, and the replaced wb was released
> with WB_has_dirty_io set. With this patch it read 0 kBps and the wb was
> released clean, in 3 of 3 runs.

Maybe trim this to a sentence?

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

--
tejun
