Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279261F5437;
	Sat, 30 May 2026 01:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780105249; cv=none; b=ATb8COvawZ2hHSk5/ORD1siQ/5cXrcL3WgtGM3w8wwT7AleIgtYfoTd5irEprqxXz+r3QiCkv0gbVYYunyTaGpvGJFqzN5wYiZlV+uC2o4a807P1PMTwThItrpcH82+CB644V8gWcBMulBXL+oEPDGYOjHUQ8sNvwjp1RzFbtUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780105249; c=relaxed/simple;
	bh=LPciAzN9MSJz04fKuygCdUVBQ+FK+UIYKayrYyeJmHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cmh2MLmojQZmZ9e74carpc6+NrVHL21QnD0CPzFJSUv/xI59GfzF7PN7dk3upanbZdAQM+L5/E4UoRWVfAHymFAC2h+bpnf3JUhyLgr1tr6A942qS7/fBI/jvURNjW8VuVSD7/2RE7NQfNzM1j+cN4PoUbTHd93PGTBtwsJXEQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WD3UrKFz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WD3UrKFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE491F00893;
	Sat, 30 May 2026 01:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780105247;
	bh=4q+rJpKHgVwRxohmm9Chks+vxiJ7/M2vuB2nm9avkVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WD3UrKFzTBhsTvBy8XAR7HT86I2pI5cBYtmza2xJ6PNT7nfBMFJcn8upKnHxLga4E
	 PuS2QXJy17WZnzxh7CPOqWf2sh4s7gU4MrU5x5wYAcW6JbzMe0u/G+qSSIPEGqUhM3
	 WeBppVTvCCn011DeFk0MLQl0EXTAWB2B58gIxslun3IJz+YAN1nVCELMRn4q3VS4Rn
	 3CmKF1oNXAghPXD4mLbJ4tPOwi2HDaSBDBfqb4MHqi779GFCAEjR6HaVzsD5hAv6EI
	 y4PwvP81wRTJ1dRkOwAXjXabzCrn4kyuHaEpPZr8AAwEWpqR8Dt+9P7ichxSadIyL3
	 oChSzUoKET/WQ==
Date: Sat, 30 May 2026 01:40:45 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Hao Jia <jiahao.kernel@gmail.com>, akpm@linux-foundation.org, 
	tj@kernel.org, hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
Message-ID: <aho_VtLCmIRsNyvO@google.com>
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-3-jiahao.kernel@gmail.com>
 <CAKEwX=MQe_KFZe2vBXQYh0aa-x+E8AzNwmyjJGJk4tDoS9ML3A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=MQe_KFZe2vBXQYh0aa-x+E8AzNwmyjJGJk4tDoS9ML3A@mail.gmail.com>

On Fri, May 29, 2026 at 12:58:09PM -0700, Nhat Pham wrote:
> On Tue, May 26, 2026 at 4:46 AM Hao Jia <jiahao.kernel@gmail.com> wrote:
> >
> > From: Hao Jia <jiahao1@lixiang.com>
> >
> > Zswap currently writes back pages to backing swap reactively, triggered
> > either by the shrinker or when the pool reaches its size limit. There is
> > no mechanism to control the amount of writeback for a specific memory
> > cgroup. However, users may want to proactively write back zswap pages,
> > e.g., to free up memory for other applications or to prepare for
> > memory-intensive workloads.
> >
> > Introduce a "zswap_writeback_only" key to the memory.reclaim cgroup
> > interface. When specified, this key bypasses standard memory reclaim
> > and exclusively performs proactive zswap writeback up to the requested
> > budget. If omitted, the default reclaim behavior remains unchanged.
> >
> > Example usage:
> >   # Write back 100MB of pages from zswap to the backing swap
> >   echo "100M zswap_writeback_only" > memory.reclaim
> 
> Hmmm, so this 100MB is the pre-compression size? i.e if this 100 MB
> compresses to 25 MB, then you're only freeing 25 MB?
> 
> I'm ok-ish with this, but can you document it?

That's a good point. I think pre-compressed size doesn't make sense to
be honest. We should care about how much memory we are actually trying
to save by doing writeback here.

The pre-compressed size is only useful in determining the blast radius,
how many actual pages are going to have slower page faults now. But
then, I don't think there's a reasonable way for userspace to decide
that.

I understand passing in the compressed size is tricky because we need to
keep track of the size of the compressed pages we end up writing back,
but it should be doable.

If we really want pre-compressed size here, then yes we need to make it
very clear, and I vote that we use a separate interface in this case
because memory.reclaim having different meanings for the amount of
memory written to it is extremely counter-intuitive.

> 
> The rest seems solid to me, FWIW. I'll defer to Johannes and Yosry for
> opinions on zswap-only proactive reclaim.
