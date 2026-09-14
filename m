Received: from mta0.migadu.com (out-73.mta0.migadu.com [91.218.175.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A399647ECC2
	for <cgroups@vger.kernel.org>; Mon, 14 Sep 2026 15:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789398047; cv=none; b=PEpeiG6pPRuSsSp6d6tSHXktved4DA83IvJJVCk8EVq8X5Wux9Z5vtK3Ml0w11ANpJq3vCd6G9s3cznIc/xuJbwiUhCJlnQvJeJ6rtq6Om973376nE60BT3bAmHrBldN2zfAWhgdCxqTswacFIhqxNRSiXyuxuIfkOeUQ9De1CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789398047; c=relaxed/simple;
	bh=hwtaTLMA1sYqRp29cSIfiy68ZXQatt6fyt/Ot6ycecQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VxPLSbTzssrabyJa7wja/FwlUU0Zx9jLqTONIEaVr3m0QD9jtPLcXVqnWGuaOrcYiIFWGwSk72mdRVoH3HDu5xa7XZpWmrHeteQRSzlqr3WPIIeQxdOvJ2T9nqXP2ty1Ut4O5v/VRgnrUQ5it+v5JtBQXtEFthYWFo+P5JhpIw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lMeKd2OP; arc=none smtp.client-ip=91.218.175.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lMeKd2OP"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=hwtaTLMA1sYqRp29cSIfiy68ZXQatt6fyt/Ot6ycecQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789398042; v=1; x=1790002842;
 b=lMeKd2OPeWI5xdKjNJhCkAzknfMSH3RcFG8v98Xjq6Jbnhz7ZldVTq96SOQRXtR08hV7RCoH
 cPRdDhiiI27IBrsHJWsgKDzE9eTSoIy4NkKO9nxRG8GALCPQjSg3Fj9QUJow8DlmfbXfncTvmeq
 7Rqo7LO/JVX98DBt9SGf8Adc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 24f60d578e23c651;
	Mon, 14 Sep 2026 15:00:27 +0000
X-Mizu-Trace-ID: 24f60d578e23c651
X-Migadu-Flow: FLOW_OUT
Date: Mon, 14 Sep 2026 23:00:24 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Kairui Song <ryncsn@gmail.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Chris Li <chrisl@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Barry Song <baohua@kernel.org>,
	YoungJun Park <youngjun.park@lge.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>,
	Wenchao Hao <haowenchao22@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <aqgMCIOFi0dKx_6L@fedora>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org>
 <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>

On 09/12/26 at 12:20am, Kairui Song wrote:
> On Fri, Sep 11, 2026 at 12:23 AM Nhat Pham <nphamcs@gmail.com> wrote:
> >
> > On Thu, Sep 10, 2026 at 3:57 AM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> > >
> > > On 9/8/26 18:45, Nhat Pham wrote:
> > > > On Mon, Sep 7, 2026 at 4:30 AM David Hildenbrand (Arm) <david@kernel.org> wrote:
> > > >>
> > > >> On 9/4/26 23:14, Nhat Pham wrote:
> > > >>
> > > >> Hi,
> > > >>
> > > >>> To Kairui, Johannes, Yosry, Chris, David, Andrew, and other (z)swap folks -
> > > >>> I need some help here.
> > > >>
> > > >> I'll mostly ignore swap-related stuff because (a) -EBUSY and (b) we have quite
> > > >> some swap experts around :)
> > > >>
> > > >> Reading below, I do wonder if the swap subsystem needs some more coordination
> > > >> and collaboration?
> > > >>
> > > >> For example, maybe having bi-weekly/monthly meetings to get everybody aligned
> > > >> and uptodate could be something reasonable?
> > > >>
> > > >> This approach has proven fairly helpful in areas where (1) multiple companies
> > > >> are involved (2) many concurrent development is happening, and (3) people have
> > > >> different priorities and requirements.
> > > >>
> > > >> Is there already something like that to organize development? Should we get
> > > >> started with that?
> > > >
> > > > Hi David!
> > >
> > > Hi!
> > >
> > > >
> > > > Thank you for your suggestions :) More collaboration and communication
> > > > is definitely needed here. Conference is a good place for this, but
> > > > it's not something we can do very frequently, and many folks could not
> > > > attend (visa issues, etc.).
> > >
> > > Right, and conferences usually don't have the capacity to squeeze too many
> > > swap-related topics in, so it would have to be side discussions or BOFs.
> > >
> > > >
> > > > A bi-weekly/monthly series of meetings sound very appealing. Swap
> > > > contributors are very spread out (China, NorAm, Europe, etc.), so
> > > > coordination will be tricky, but let us figure out something.
> > >
> > > Yes, that's an issue. I'd suggest swap maintainers take care of that if they
> > > agree. I could try as well, but it's rather tricky right now on my end ...
> > >
> > > As an alternative, we could also use on/two/ ... slots in the bi-weekly MM
> > > alignment session to talk about swap. (I'd be happy to learn more about all this
> > > as well)
> >
> > That's awesome! Thanks for the offer David - I think MM alignment is at 9AM
> > PDT Wednesday, usually right? That works for me of course, but Baoquan
> > and Kairui (and other swap folks) - would this time be convenient for
> > you?
> >
> 
> Thanks for setting this up!
> 
> Is 9AM PDT fixed, or can it be adjusted? 9AM PDT is midnight for the
> UTC+8 folks.
> 
> The time is still fine for me, though, I tend to stay up quite late
> anyway ;) so that time works fine on my end if the slot is fixed.
> 
> Is there a calendar invite or something, please send me one, I'm happy
> to do a swap sync discussion there.

Thanks for opening this up for discussion. While the time slot is a
little late for me, I am not very sure if I can attend, will see.

