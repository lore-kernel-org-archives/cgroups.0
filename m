Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322EA4A5EAF
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 17:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790010180; cv=none; b=eYCr1/wAbuXFGb7A564v6FA9ddv66DgYYZ2pPIn5SnDR4ddmcrIvZtCmCL/CL87sHJwE1VP9LCajVPwkHzAqqkBWn0NQoSM8OJEG53botdYJvEd9VyuTKQ+mOEdbfEi7ZiBYOkf9cr2wIerDSGl1Xfz3IL+n9gfu7wsUwLdg+TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790010180; c=relaxed/simple;
	bh=0oQTC/1nit8xtttyPLngZa2mAS9b958j3IlvELrn/tI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OjjGEiSyVXCp7jKZc3QTXO8/acbmBwNDZDQAMvrci6g3n6dEL3jUTHSVkgoCV20O17arsQ0jHaJ7Jod0VXjIErSSnrF3TgMuYtsNKhjrku/7y1YkqkYNqSZdP1/A42u+ljPjVVKbhf0voSTPCgndEDUL7oMerUNxpWFQqfaQbJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=IVfebPCd; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="IVfebPCd"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-52fa9c055b5so662071cf.1
        for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 10:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790010178; x=1790614978; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zam1HuieMGo4IVtIDS9XVWJbvXE11Q3uTiDlxDLMxb4=;
        b=IVfebPCdcxu7JEGtSeXhDXopipg/6dGmEihMBn6DRAhhLr93waBxOZpRz8WpFs/x6K
         tS8FuLAnwSpudbK6M9LS9GCaXFtJ1XJwjcq6FDssRMGBWp8tFZ1wvMXipcSDn8lgurFd
         p4c9oC2HiZTO3MIkFlDQIY+VeEQVkEksw1Rm1CdlS0FIJCE1m5UNcH0Kge9KgAn70p9x
         VUpZl2V8ajpitWDr6M0kg3NPC3ZRnqDm8gm0JqsjgdvpoZg9JoPvxzjRtHqhNXI12ygp
         w29whUsrb5bGAi7JO/lWjiyVBAZ2yMAFDNzZ0IqHE6Egp83TSzwEOEbRgTlbM+VxQqD3
         D30A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790010178; x=1790614978;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=zam1HuieMGo4IVtIDS9XVWJbvXE11Q3uTiDlxDLMxb4=;
        b=R6tmReN/9Uc1gpxI+DveHjQP9kcR5/vOgWivUnJlLClLSyZJAYvd4b+ErNMGNCET+D
         N7OSzUoUVoG20X8/eT5FhEEYn5o8Aqc0llfCkApyAShbWPO3ZlBP3cHqDoDsq/2xR2X2
         DibqTpcsK3vDev5F1PcNURvydnqiMwTGftHO8hdqXnBEfHY9Aj5BVtLTCeIffDFjcRON
         SN5koyU34XkOzrJAbWfo+/xGw/KISptHiRgxwpD12zFTaz4Fo48D6m0HLnwdYxXLifgn
         i9sXw+ONEea36LNPGnH/HPXxyuZUj0uGqIxNhmPHeYmhEjLLwJoV7XgsUJdZFnQJaBuF
         rgBA==
X-Forwarded-Encrypted: i=1; AKwUvBw6cOmeYcsczme4KpuJyPpp1QhPZPm4ZHrU6AIBamHRMoy9+L4U7xhjYjnvtC7K8omvaTuTmiOO@vger.kernel.org
X-Gm-Message-State: AFuF++l5p2GRpwx5rL0o5xp3YP2KlebedxVZO4pzwATtpgBUi4kcWXsf
	c3mM1iSp+Z5OFq4/KDp4LT8vXr/ezS/bJ+DSKibQ2GGPHyBlySmi0zyrWRB4EDhiSvM=
X-Gm-Gg: AYBFou1iNUuypfv3v9DU22Q0fiDxthCA/1xaGUqOUaUrYPJxXUL+1qs2jDDDFe3+AOU
	eGmcbmanYrKhWdqIKC8QbBbXtDqK3ebmJui1oAuaQJAM5UCrZK434iPRD4ROjilcW7YDaeiCWH6
	ZPmdWQd1QqkxFKENce7T5rgL1QyyQtUAMvKU9Pv+s1tKyZ2K+rxEm5OIkBkAV5WPAnX9Glm6Wxm
	0GEw+QLPK9ossPA/CtOVprTb6VSm2Xzr1COcMlpOgYh3F/leNbcJNBZQ0gfPLbWAkHtSCWyN1lI
	JhVZ/WPcPRKtsF1Pe1oLEnZE0dDcpClPkNkFyeonC45Hi25itCl0wPS8dbqJgsv/+Uoyj3Y6FoQ
	aCJjWN273s/8hJcyUfdCHM2u/7Upnsx9gtDF68c58jyK+8YcNVa0hxmbFe1ScQCLSEoPL4CKQPd
	ZkCddUEKPbzi6mqZSd5R5vVPPnDzANGHccOmfH8Wojnp515mU9XfaFx4RNPcgyAVYOs9GObMdyG
	Id2qL681bUxRcTFVF0fyFI=
X-Received: by 2002:a05:622a:6110:b0:530:fbd3:2038 with SMTP id d75a77b69052e-532db89fda7mr2849411cf.26.1790010177750;
        Mon, 21 Sep 2026 10:02:57 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([152.186.177.174])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532ae618698sm68095611cf.16.2026.09.21.10.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 10:02:57 -0700 (PDT)
Date: Mon, 21 Sep 2026 13:02:10 -0400
From: Gregory Price <gourry@gourry.net>
To: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arFe215hUcjLhvmS@gourry-fedora-PF4VCD3F>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora>
 <aqLi6cIjD2wJwk0B@cmpxchg.org>
 <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
 <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <CAMgjq7CJBHkoZmg9oKNgGA8czL0djyBTCAkPz8ETm-tX=Qci4g@mail.gmail.com>
 <arEotFqE7ZZoxMHd@gourry-fedora-PF4VCD3F>
 <CACePvbXb1WLz=OAAzVawf3oc3+dE3Z7qfPdagQ2dYuf3OALc2g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbXb1WLz=OAAzVawf3oc3+dE3Z7qfPdagQ2dYuf3OALc2g@mail.gmail.com>

On Mon, Sep 21, 2026 at 06:32:56AM -1000, Chris Li wrote:
> On Mon, Sep 21, 2026 at 3:27 AM Gregory Price <gourry@gourry.net> wrote:
> >
> > This would preserve the existing memory.swap semantics while allowing
> > both backing resources to be constrained independently.
> 
> It sounds like you want memory.tiers have limit enforced.
> 
> I suppose it is possible. Again I want to see how people would
> actually use this feature.
> 

Possible, but arguably not needed. the swap and zswap counters already
work for this existing interaction.

As I pointed to in my response to Rik, in every reasonable use of
pswap+zswap the global swap counter is pointless.

So then pswap=swap and we're left with zswap and swap.

And I'm not convinced your reading of the swap counter as a limit on the
*logical* memory allowed to be swapped out is actually accurate.

  memory.swap.current
        The total amount of swap currently being used by the cgroup
        and its descendants.

  memory.swap.max
        Swap usage hard limit.  If a cgroup's swap usage reaches this
        limit, anonymous memory of the cgroup will not be swapped out.

There is no documentation I can find that has ever documented these
counters as "the amount of memory requiring a fault".  If you put a
compression system in front of physical swap - the counters as-described
would still be accurate, while your reading would be broken.

"swap" here is highly implied to mean "storage" as opposed to memory,
which is why "zswap" defines its limits in terms of memory.

  memory.zswap.current
        The total amount of memory consumed by the zswap compression
        backend.

  memory.zswap.max
        Zswap usage hard limit. If a cgroup's zswap pool reaches this
        limit, it will refuse to take any more stores before existing
        entries fault back in or are written out to disk.

If you're presently using swap.max to mean the "logical amount of memory
allowed to be swapped" - then your usage does not meet the definition of
the knob.  You need to justify that your use case cannot be expressed
via memory.min/low controls:

  memory.min
        Hard memory protection.  If the memory usage of a cgroup
        is within its effective min boundary, the cgroup's memory
        won't be reclaimed under any conditions. If there is no
        unprotected reclaimable memory available, OOM killer
        is invoked. Above the effective min boundary (or
        effective low boundary if it is higher), pages are reclaimed
        proportionally to the overage, reducing reclaim pressure for
        smaller overages.

That's an SLO interface.  memory.swap is a provisioning interface.

As it stands, I'm left viewing zswap's counter inclusion in swap as more
of a bug than a feature - they account for different things (memory vs
storage usage).

~Gregory

