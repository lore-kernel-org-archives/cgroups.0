Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42C9412294;
	Wed,  2 Sep 2026 23:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788390457; cv=none; b=YPjGO1KmK3hdGEIOZTtTGlesxZ4KYW/8EFh1n4IOjUZqYbrYIGescIS5l4Szfdvce37D2WiUOjhUOOLTpxx8qKjb0g6H7Tc2DWsCtTlOwHsAcLboeNv0htKyxuYi2d6r6+rKeixDfW/77Y95JfPzrwnM9FaL8nfPypZ5rp7MVvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788390457; c=relaxed/simple;
	bh=sOmAom8I1iWhOrJf9sHTK3xeFSTBo6pwGIigKTohvJc=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=DSZ+9b87yWAFOOBfmnhHS2at8Bo2J0TA2ieDAsU59hz5BgqKBYy0rwbM0Rsv+oU8X0qgK6H9R3Wk4YM5hcrRmGhdtXv7YmYIZxfsrHlNzTzTPkZeG3XUHBQwyRFFVdVOyEgonHRmYjXST0DZBkga4zSISFEWPgiMQmT5HcipXDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jppbb1Fs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jppbb1Fs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7815B1F000E9;
	Wed,  2 Sep 2026 23:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788390456;
	bh=slAwe+kuVy9iU67E+4jVH5XI++YCHgm8QBMnwUs+uWA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=jppbb1FstLz7nnkIxg+2Woi5ERrQ61V0oXEQHWZwqp70z15bizC8JOSB8i04CzR86
	 c3g3u81r9gQw/+JHozouXnJYbZJQNxqBVqMj7Krdb45emqblkGTaTU4opaSc41AOA9
	 gr7j8K5XhkVg+QQWx/WvWrQtsqwaM1frpPgS26pZP4PpzM8sbv/1Cka4tVeWUh18L+
	 dIguyLtt2BIZUdZDZzqb8Lnp12K6eKZ9VP09JhHkjG89s6VAUWmpqf29rOHt2voc96
	 47FD/PsrM3MCPzrZfr6UqepH41PHSuc0gjl7HBqCsNntcl37+tItt//z+enMmkaFAN
	 wz3HLQ/SINt4Q==
Date: Wed, 02 Sep 2026 13:07:35 -1000
Message-ID: <e959dbda2f689ed524e2a83d4affdfe0@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Yu <tao1.yu@intel.com>
Cc: hannes@cmpxchg.org, mkoutny@suse.com, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzbot+bb2e19a1190a556c01b1@syzkaller.appspotmail.com
Subject: Re: [PATCH] cgroup: reject controller re-enable while css teardown is pending
In-Reply-To: <20260901012342.855056-1-tao1.yu@intel.com>
References: <20260901012342.855056-1-tao1.yu@intel.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

On Tue, Sep 01, 2026 at 09:23:42AM +0800, Tao Yu wrote:
> Stop draining offline csses from subtree_control and cgroup.type writes.
> Instead, reject the operation with -EBUSY if it would reuse a subsystem which
> still has dying csses in the target subtree.

Failing the re-enable isn't the right trade-off. "-cpu" followed by "+cpu"
has always succeeded eventually, and nr_dying_subsys stays non-zero until
the css is released, so it also counts removed cgroups and offlined but
still pinned csses. The -EBUSY would persist well past the actual conflict.

The writer shouldn't be sitting in D state waiting for exiting tasks in the
first place, so I posted a patchset which makes the drain interruptible
instead:

  https://lore.kernel.org/all/20260902230313.530839-1-tj@kernel.org/

Thanks.

--
tejun
