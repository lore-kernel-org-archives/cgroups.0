Received: from mta1.migadu.com (out-90.mta1.migadu.com [95.215.58.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF213368A9
	for <cgroups@vger.kernel.org>; Wed, 12 Aug 2026 23:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786578052; cv=none; b=g0g09whYvcqV8O5oYTl9/Q9MwKQLOUkqsIWCia1ubgEY6waPgGHbrbY7bRk1wp6CfjHkvi0FrgzWu8CQo7IN4hulLZiFluUXgUVMH6WAwmCbAM3nsCjBrjG+URRizisK8MWfwmvDldeGjV5E4k6HrWkvhgyT6xcXJ2NGxCJsCPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786578052; c=relaxed/simple;
	bh=yase8ojYlvTroh3czrYooSzU3qkMRoxgGLJx7SI36pA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mt36o+Niq/grLQFHtizZ0mvqYvQXXc8gt20nSxCIcgcNnxaUn2/j6jlFmX0af74+ZTk9P7vVrwpDMURnC9zhywdBxOR5fFzrELZZ5vUYOUq6BMIb7Q6kHNeupY2i7T6bbjqB7T1ZqO8h4MSg5Izeuf5hF0b92eOwK/+1sgb8MLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=w46SFd1Y; arc=none smtp.client-ip=95.215.58.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="w46SFd1Y"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=yase8ojYlvTroh3czrYooSzU3qkMRoxgGLJx7SI36pA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786578047; v=1; x=1787182847;
 b=w46SFd1YxP2GwaIHnagsI/zDGWuWgdN+2TnOZA1u26dJXWO9zJNXZ3jFkeZCQ56Dj4Z4Z/Rp
 dVsO61vSJi6feeeVRNFQMJxOzaFrh1nfLT7MxCn3qiS6RepB6S2vGyJbhtn9JXmYQ0AOVoajgAt
 eFZl+Nj8Ftdgmt/qIyBD3S5A=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:16::)
	by smtp.migadu.com with ESMTPS id 8bf1ca111f2545f7;
	Wed, 12 Aug 2026 23:40:46 +0000
X-Migadu-Flow: FLOW_OUT
Date: Wed, 12 Aug 2026 16:40:41 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/9] memcg: make the v1 soft limit knob inert
Message-ID: <an0DbbqFL7i9W02s@linux.dev>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
 <20260811203203.3456029-2-shakeel.butt@linux.dev>
 <20260812155010.8710b4a9191c9ee4ad6da255@linux-foundation.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812155010.8710b4a9191c9ee4ad6da255@linux-foundation.org>

On Wed, Aug 12, 2026 at 03:50:10PM -0700, Andrew Morton wrote:
> On Tue, 11 Aug 2026 13:31:55 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> > The v1 soft limit has been deprecated since v6.12 and nobody has
> > reported depending on it. Start the removal by decoupling the interface
> > from the implementation: keep memory.soft_limit_in_bytes, but ignore
> > writes to it and always report the maximum value on read similar to
> > what memory.kmem.limit_in_bytes already does.
> > 
> > Writes are still parsed, so malformed input keeps returning -EINVAL.
> > The knob now also behaves the same everywhere: it used to return
> > -EOPNOTSUPP on PREEMPT_RT, where soft limit reclaim has always been
> > disabled.
> > 
> > This also fixes the syzbot report linked below. Soft limit reclaim is
> > the only caller that runs shrink_lruvec() from kswapd against a
> > specific memcg, so it is the only way to reach lru_gen_shrink_lruvec()
> > and in turn set_mm_walk(), which warns when called from kswapd.
> 
> Thanks, I'll pluck this one as a hotfix.

Sounds good.

> 
> It's old code, yes?

Yes.

> Are there any theories about why the sysbot issue
> has just popped up?

The reproducer is toggling MGLRU on and off continuosly which is not really
recommended.


> Should we backport the fix?

I have no concerns in backporting this to older stable kernels.
