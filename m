Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB19130F95C;
	Sun, 27 Sep 2026 20:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790540792; cv=none; b=DdVFYS+iHFEcCIxOZVMnKpG3DHwy7SUlvHvJbcJM5qvPRdERRU1QjDtBnz6+DUfqVmLpU/uA+LjqkMAJB0SSAIYaibat6e2znGuyUDTudC+CeQsRE+AprZB6CFNJYTAoiL56nhcfDm0vBzCFPwLnf7Wo81hiwdRBWDkTC/pQ608=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790540792; c=relaxed/simple;
	bh=7ofVbKI7UwbZtzf8DCr38YnkemcRoO+lOYfaE/MEjJM=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=ZhBUQaaY8myRXvIjqy3+BFVsDEYYubagVpq7WG95G4hohN7BsJ+irZG0qZP70onEI4Spqdcc62GHPBZN8kBgpcgdYSfP7Zdbd/UPKZ8jGcpvMpNAqZbkCpOuIFQZk8xFxoIvEfdKqqt1rloliHMBrihuoIpo100Z62VkXojGAv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fKhzG8Id; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fKhzG8Id"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D446D1F000FF;
	Sun, 27 Sep 2026 20:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790540791;
	bh=Wtc36Zd26DF0UV6qt4ILyxcIdl7ocFhXmsZv9Dy+w+Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fKhzG8IdBSyYx4WwzMQqnpwOPZCr3ooh55LHrwrwCvxbLPkvxBO5t+3+ccAfMHSzE
	 gjHo4hWgMwEazfMjspTgDHCK6Rt8WL8Jiop6CSr+TZqw73IJUiiQm93mcCE9E0f5Ei
	 a0w+rkZtrFS+ecXZrAa+HYyVW7xszMLOpwQAwMzE=
Date: Sun, 27 Sep 2026 13:26:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
 hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, willy@infradead.org,
 jack@suse.cz, tj@kernel.org
Subject: Re: [PATCH v8 0/3] memcg,writeback: flush foreign bdev mappings
 separately
Message-Id: <20260927132630.eef2d0f1704534c7bde8e538@linux-foundation.org>
In-Reply-To: <b5da5c30-7c8b-4c60-aa3b-d2e3603e82c1@bytedance.com>
References: <20260922125015.3435215-1-sunjunchao@bytedance.com>
	<b5da5c30-7c8b-4c60-aa3b-d2e3603e82c1@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 27 Sep 2026 19:48:26 +0800 Julian Sun <sunjunchao@bytedance.com> wrote:

> Do you have any further thoughts on this series?

I'd like to see some feedback from memcg maintainers, please.

> Should I rename bdev_flush_by_dev() to bdev_writeback_by_dev()
> and send the next revision?

Yes please.  "flush" is a pet peeve of mine.  It's used to mean either
"writeback" or "invalidate" in various places.  Or both.  Annoying!

Also, I agree with the "dont check alloc succeeded in __init code". 
Both places.  Maybe save this little cleanup for the next development
cycle.

