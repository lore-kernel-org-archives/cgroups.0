Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12E54AE102
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 15:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790005745; cv=none; b=MFUj8LxjCbmhaxG7tjkgRhtII1nAu1rcFdBMdYr5cXOVZyodGOlCWyl+LE0eJrrp3fdZvkBQkZ8FjwsuvfnDV5f/P8UPe+9P4hiV6FRNB7D+Awc5Idxj7KjOkdZGfxO/ZdNGmPv3c2yevCsfnNFWjSR/0CsN7m7yt1IaZm7BX7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790005745; c=relaxed/simple;
	bh=7X8DglpYoKyJvznThs0j4mHe4fvO4f+WYWYfsETxoTw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sFwCUA7fVfSqxUIc6xaugwQeciFCc2E9EvgL+FvJSckjyoDL+hqZdgAAu9DZ8NAyDVSVZzSdsMCZQjvi+3gK64Bcvy3AaHwjNmhgmEo4ZBrfyyNRVEYEdWpfamKfXoJK9j6KDpk3dqzUQA5yRygdVW3MzjAuwj1PSXmZF/CqWTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=BIZAXQEY; arc=none smtp.client-ip=74.125.230.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="BIZAXQEY"
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-530d8a00bcdso19890121cf.2
        for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 08:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790005742; x=1790610542; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/s9qiYogYW6WNzZt1dtpYbULGoaZUSl75Lwvowk+5Ug=;
        b=BIZAXQEY/Wt5INkxOWj6lymS27vi7/z1sa0MgKHnqBoqUzHhK8b4bl38ZaoOrKcU6A
         O1DPes8GpyzoWexQY/RMIT455kXxs/n1GFqSWa0q5JBeEKq1rqWJ6NN0TkZ6W5OE13zc
         ipNmI3SstNNExVm3Lqr0c4MDYRI69JsuSQvDyqe8hkf3GJUB4bGpk4NfKg5vIyJ1u1MI
         T52Qjsh3sAvaSJkowkdS1RRabwCSK+HxelWuvSfhcsG4dytku/EMUh4/MCfkDET3m1Z8
         b8MjxsApOlDfcpVd28m1Oy/ly6TDn7B/g6eINj3lebGSX0LUZOUlI6cHtDIckQdvKOm9
         +Gug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790005742; x=1790610542;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=/s9qiYogYW6WNzZt1dtpYbULGoaZUSl75Lwvowk+5Ug=;
        b=Lsw+p5J4lXHhwjj16t9v+G/1AI2F0BobjxnEpB/ebv2RqmJeHGMImD8FIfT6pgR3Od
         HGPF75lvgbVpGDf6PWADwvTz8Pox7uKVtvcoZoI80tD+zoB+Q7pOQR4NoRQ2qGpGGVjg
         bTAvqBL3HspyybFZq+LgQ5l9uecTNa90RK+J0N2YsAfUrUOMN410e7KZTmOi5/fLUZJO
         Z/a1JVthPRBKulXnAZqsT+UiYgPveZ6rCq11qO38iFm9iN3hIscMBaFJaJkHjDH+Ej+4
         wILLvyiA53Vwj/enJjk22q1FeoEbIkvEn7v31UJxhJwuoeJiW8uRt/ssJV+RpJ/zygCb
         0lKg==
X-Forwarded-Encrypted: i=1; AKwUvBwZLTtC5SxhkC5AutxF7B23sghLF/ndoFAb12q+51iDGdjFP2DYqGArXWlOuLgW/pxDuqCCxH1n@vger.kernel.org
X-Gm-Message-State: AFuF++lzz0J2z+ttEmAOvoTLHo2f1S2j7mY3WiBYJvg1ifLxN1zA4XM+
	I7bczfZzVhsPbHblMfvKMEmqkCGDoPw37qREvOygYHjafYg/2eTEC3h8VR8T1c5qt1Q=
X-Gm-Gg: AYBFou1652YTfh/sZ7G6ymMy2cctqu4ye/jTIJnDCimGX1qCnCe8V/32jtKwzQFDxgS
	uvvoMjbWCXqbyLaISvcPLbA4cKcjirA24VwXk4u1rfYKF9kq0G8V3udRjS5lbAnJUHLnLABd7XY
	gBvvGUd/4/KHvHgQIq+W7vcS+pRP22wB4AqQOLALCUVQUfecluttob9hNRaJwU8KHm5uQ86RmW0
	hJpa/a8QNs0FJWaCe6I9C442Z23IfXwMdzXkHr2wvrJStsuqzvyaye1NP/2r7u+sDmr7LrcPCSg
	gdy1hr1T0HBFzOEY0EbeV5TMFodBAYk1duG97CzS2eAOBLbnULhyze+uBHEjDXACdtdchYT+f/v
	3INnrl7bHame9tAmtEgtPz+uoMQHfev450InR68YoDqKEccP7aK5pzGgoqcy2V4PPRnCS/+5Zn7
	53Fpswv9vZMKJYgDRqYpib31dD5S82yNr76X+rnI3rKj7OadNaJKFE/8kum/sJpjhdlD+LiUBsP
	G2nDVk2qY4=
X-Received: by 2002:ac8:5a8b:0:b0:532:a5f4:df25 with SMTP id d75a77b69052e-532d8e4f628mr13379251cf.57.1790005741711;
        Mon, 21 Sep 2026 08:49:01 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([50.193.156.113])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532ae512550sm66992481cf.1.2026.09.21.08.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 08:49:01 -0700 (PDT)
Date: Mon, 21 Sep 2026 11:48:57 -0400
From: Gregory Price <gourry@gourry.net>
To: Rik van Riel <riel@surriel.com>
Cc: Kairui Song <ryncsn@gmail.com>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arFP7YNzB1RMUKuc@gourry-fedora-PF4VCD3F>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora>
 <aqLi6cIjD2wJwk0B@cmpxchg.org>
 <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
 <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <CAMgjq7CJBHkoZmg9oKNgGA8czL0djyBTCAkPz8ETm-tX=Qci4g@mail.gmail.com>
 <arEotFqE7ZZoxMHd@gourry-fedora-PF4VCD3F>
 <f3af5902412b9ff1c1a37211eeeb9c0ffc22f814.camel@surriel.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f3af5902412b9ff1c1a37211eeeb9c0ffc22f814.camel@surriel.com>

On Mon, Sep 21, 2026 at 11:27:53AM -0400, Rik van Riel wrote:
> On Mon, 2026-09-21 at 09:27 -0400, Gregory Price wrote:
> > 
> > In short:
> > 
> >   memory.swap   = logical swap       - workload/SLO limit
> >   memory.pswap  = physical swap      - storage limit
> >   memory.zswap  = compressed memory  - RAM limit
> > 
> > This would preserve the existing memory.swap semantics while allowing
> > both backing resources to be constrained independently.
> > 
> My first thought was "this is confusing", but
> after a minute I realized that most users will 
> never set those options to anything other than 
> "0" or "max", and the few who do only need to
> touch one of them.
> 

In practice, at most two (zswap + pswap) with swap=max.

There's not much of a reason to set swap to anything other
than max if you already have zswap and pswap limits.

But for existing users where they're using it as an SLO
signal, they could continue getting the existing behavior
by just using swap.max.

That said:

I'm not convinced this is actually required, because the swap
counter was never an SLO mechanism - it is a physical swap
provisioning mechanism.  If it's being used as an SLO mechanism,
those users have misinterpreted its documented meaning.

memory.min / memory.low already provide you this logical limit
mechanism - so I would argue the parties that want such a split
(rather than treating zswap / swap *as* the split) need to prove
their use case cannot be supported by existing counters.

~Gregory
