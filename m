Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DC432470F
	for <cgroups@vger.kernel.org>; Wed,  9 Sep 2026 18:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788978846; cv=none; b=jRBtEOUVA2MSEv2M+NLjZZILDbI/WHOd7dfLQJmeSlyFBlPwQMQpLHJg6BVFDKkhbrbDG0h48dm5hegYBGj78tq3ByI6TtDoEVUjM/N7BqC310dth9MLQdSsnjVaEtt+7I5ZmMILSzyHGV1gwsOyBvj49K1AvVHx4rNv12LSdy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788978846; c=relaxed/simple;
	bh=+T1vxVyY4xPdyEV3u2lLYFZUY2l5XRhQuvj6uHG+Xc8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PyCbfdEU7pr26Q6Gw+MbdZuzp8eGHrrMoaDj+Sj0QCE60FRIrgjASQXeL16o8CpZekVz7mP91tCcZEMKV6RX/XCLnJUaAbbUNsie+nv/zh6TKag5zMz3mi2yEANeblctNXkLWT7648WSnLo1VysN1dOob8uk44QX50hmxvltEBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LfsGv/jI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LfsGv/jI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D481F000FF;
	Wed,  9 Sep 2026 18:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788978844;
	bh=ycUBO2JELs2fyXN0c+TiX7BOpgFS+f5iaTaMr/XArow=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LfsGv/jIKlqGMGSQAnveeZtabZKMDxdjFdRRCMyG2srtGbX1SzK9q0lYxJX1/KWdL
	 8xQPT/1iez8J9wES7U/22jicz85h+JRc1LLzBaOT+XOqJ3pttR0BEdtAMhzxAySFm/
	 C2ZDfgO3OrbSdBYhTb5hqvIOmeOcJDjDuHlhxa/xgtMnyt5ovscwtU367QIZ8CGO0p
	 1ljSVEja7i8RdYu754Zsha/Nn4tlX/JMH9FGdtSkjXu0EW49uTORl0Qjl1zqtZr/M6
	 V7Qloc6tBlviXS6M/2ejzK81QyBceZVQiUiUkghFfFR5g+SFfY/YA4m18a0o4vb5I+
	 E7MF0TSv3coQA==
Date: Wed, 9 Sep 2026 08:34:03 -1000
From: Tejun Heo <tj@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Julian Sun <sunjunchao@bytedance.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, akpm@linux-foundation.org, axboe@kernel.dk
Subject: Re: [PATCH v3] writeback, memcg: skip foreign dirty tracking for
 bdev inodes
Message-ID: <aqGmmw3rv_2f5Jk4@slm.duckdns.org>
References: <20260909034343.340703-1-sunjunchao@bytedance.com>
 <iqvi6yo62ydxzshad2mhi55rxhyskfsoo62ji2curbldrg5cc4@z3wju4r6c3ab>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <iqvi6yo62ydxzshad2mhi55rxhyskfsoo62ji2curbldrg5cc4@z3wju4r6c3ab>

Hello,

On Wed, Sep 09, 2026 at 01:03:27PM +0200, Jan Kara wrote:
> On Wed 09-09-26 11:43:43, Julian Sun wrote:
> > The expectation in wbc_detach_inode() that "concurrent write sharing of an
> > inode is expected to be very rare" does not hold for bdev inodes. On ext4,
> > metadata from many memcgs shares the same bdev inode, so dirty throttling
> > in those memcgs can repeatedly trigger foreign flushes of the owner wb.
> > These flushes can also write ordinary file data, reducing overwrite
> > coalescing under continuous buffered overwrites. The resulting extra I/O
> > leaves less device bandwidth for other workloads.
> 
> Hum. Are you aware of [1]? The guy is from the same company so I was
> assuming you two are working together on the problem :). 
> 
> [1] https://lore.kernel.org/all/cover.1788836830.git.yinxin.x@bytedance.com
> 
> > Skip foreign dirty tracking for bdev inodes. Ordinary writeback and
> > foreign dirty tracking for non-bdev inodes are unchanged.
> 
> Frankly, I'm not yet convinced this is worth the risk of regressions. The
> gains are nice but both the winning and the loosing loads are synthetic and
> none of them is like "this is definitely what most people are going to
> hit".
> 
> I think what [1] is proposing is more in the direction where we might go
> (although the second patch in its current form isn't acceptable to me
> either). But what I miss from both your approaches is the verification that
> the change actually helps your *production* workloads. Unless it is an
> obvious fix (like was the case of patch 1 in the series [1]) I'm very
> reluctant to approve any additional heuristics unless it is proven they
> actually help production loads. These heuristics are never going to be
> perfect so you can always come up with a synthetic load breaking it in one
> way or another. The art is in tuning them so they work for the practical
> cases :)

The original design's assumption was that a single inode being actively
written into by multiple cgroups would be rare and rather silly and all we
need to do when that happens is being able to limp along. So, the trade-offs
were made in favor of lower overhead for the common cases where there can be
a huge number of active inodes. This mostly worked out for normal files.

Here, the situation is very different. The sharing isn't silly and there are
only a handful of these inodes. If this is an actual problem, I don't think
it can be solved by slewing the existing mechanism one way or another. Maybe
it will make some scenarios better but it will worsen others. The existing
mechanism simply doesn't have enough knoweldge to make sensible decisions.

Given that, if this is a real problem, I think the right solution likely is
tracking more states for these cases so that it can actually make sensible
decisions rather than trying to guess blindly.

Thanks.

-- 
tejun
