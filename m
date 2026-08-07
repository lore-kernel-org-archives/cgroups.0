Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C663A6B8D;
	Fri,  7 Aug 2026 20:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786133506; cv=none; b=kxh89Urrg+HBPFe36DCkpWsCu/Gy8SAUJVeaJk+eN7lta7BzRs4KNWOHqwYQXnwGhvLPPdVcSntGSbuHoGLNUiPghJ6yf1TwPlevKBjbXUjSIYnGQnDhe1stvI3iPjh1FkzD3ZmJsR7N2Sdl4oseNA6E8sf8VDr1z6IAz6Kq32Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786133506; c=relaxed/simple;
	bh=6L2txOyIqAlZbO2HUaZlrbUPzXeb8A5PAc0y5J8YNWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nBKopTvPhC9oqtVKonBn673fBMGPQavOJd5APVmjKaHXY2X9wrZCu32g7owy71HkpLaW/J4yI2ASU2LJuunEUiYpkOOymxUB6MF8ubR+9G1wqA+PbQdw/miVpHSEmn7ZwaJOXNg+lPlvJLwoEUn/7VJ+4WZ+4p1btWNoi44DmYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gsrmj8vr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gsrmj8vr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C631F000E9;
	Fri,  7 Aug 2026 20:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786133504;
	bh=PoT4LgZPx6dpe2ViNgQqI8z1wiZgMRaIvQ2UfGebaK8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gsrmj8vr7c7IjufwJOCf499sr4WiTwxVh/dcgeb+fhpebQQAWLhC7jU/pUcI1RDk+
	 RAFChKOcJHqJsVYtAZoW5Tw9AFhlEPGw0xeBcJ72sLhNZfWfuxCtCFp7IGtImrUUk4
	 06cVSO2uSDAaA/NxiFuJva2/k40AhiXpZo/mzFBlLpWpDQWZkKzoAU6SUCwvEeQDWx
	 MISrOGFzCeRUiFBSyYN0jDVXYKrZPfC/WaT9yFs2NswmSXudgIuxUtgUVyIolUWhNk
	 ms8n7ejef0vp/1VifCy7oCYxc6fy6oKLyIE/KoY3un/57S3E1Wr6i6Sju5u/T0d7Vq
	 9eIRqwOi5oPRg==
Date: Fri, 7 Aug 2026 20:11:41 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	zhaonanzhe@xiaomi.com, baohua@kernel.org, hannes@cmpxchg.org, youngjun.park@lge.com, 
	baolin.wang@linux.alibaba.com, hughd@google.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com
Subject: Re: [RFC PATCH v5 2/4] mm: distinguish large folio swap allocation
 failures
Message-ID: <anY7842WB7C308rX@google.com>
References: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
 <20260730122304.2496440-3-xueyuan.chen21@gmail.com>
 <anWAZ3T6Sz8bsKSo@KASONG-MC4>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anWAZ3T6Sz8bsKSo@KASONG-MC4>

On Fri, Aug 07, 2026 at 04:29:17PM +0800, Kairui Song wrote:
> On Thu, Jul 30, 2026 at 08:23:02PM +0800, Xueyuan Chen wrote:
> > folio_alloc_swap() reports most allocation failures with a generic
> > negative error code. Reclaim cannot tell whether splitting a large folio
> > could make progress or whether there is no backing space at all.
> > 
> > Keep the global free swap count and the remaining hierarchical memcg swap
> > margin as separate inputs. The memcg charge path reports only its own
> > margin; folio_alloc_swap() combines the two layers when classifying an
> > allocation failure.
> > 
> > Return -E2BIG for large folios when a smaller allocation might still fit,
> > -ENOSPC when no global swap space is available, and -ENOMEM when the
> > failure is not helped by splitting.
> > 
> > For early large-folio rejections, check global and memcg swap availability
> > instead of returning -E2BIG unconditionally. On a memcg charge failure,
> > swap slot allocation has already succeeded, so use the remaining memcg
> > margin to decide whether a smaller charge might fit.
> > 
> > This only refines folio_alloc_swap() return codes. The reclaim callers are
> > updated separately.
> > 
> > Suggested-by: Barry Song <baohua@kernel.org>
> > Suggested-by: Youngjun Park <youngjun.park@lge.com>
> > Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > ---
> >  include/linux/swap.h | 16 ++++++++++++----
> >  mm/memcontrol.c      | 32 +++++++++++++++++++++++++++++++-
> >  mm/swapfile.c        | 32 ++++++++++++++++++++++++--------
> >  3 files changed, 67 insertions(+), 13 deletions(-)
> > 
> 
> Hello Xueyuan,
> 
> Thanks for the patch!
> 
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index 0544b2ec4c56..7d12058174ae 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -509,12 +509,13 @@ static inline void folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
> >  #endif
> >  
> >  #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
> > -int __mem_cgroup_try_charge_swap(struct folio *folio);
> > -static inline int mem_cgroup_try_charge_swap(struct folio *folio)
> > +int __mem_cgroup_try_charge_swap(struct folio *folio, long *swap_margin);
> > +static inline int mem_cgroup_try_charge_swap(struct folio *folio,
> > +					     long *swap_margin)
> 
> Am I the only one that feel this returning argument is a bit ugly? See below..

No :)
