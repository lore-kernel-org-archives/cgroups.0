Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD423F888A
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 06:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790143869; cv=none; b=IcN9EW03XoxgBTs/HrJYbZqSr02uD3qc5oBScaRDcLJllAVJCAplJVe1aaeqWS+ZTTUJNyGoPLhY9BaKNN7AcsGBrSBUJCseHyLYwivKs4XE+tQOBVGTslkuCnnvH1NsB0Io+BeWFetbZwfikl0cyyQaXI3xIzUgrRqTRYrCeSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790143869; c=relaxed/simple;
	bh=36DkvQ40d2yR8/sYsHjVsChpTAqtkzflfa13QYZVKCI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sK+QNaMkLFj00piZUzc3FamHV7eLOj8Q8vci0PKfv4s5kin8xvaMYUw+HdPxRpqKNmOCnv1QQkLzHas1KuwxsrrPh91nZDwade+h+OguqKeceQAfjIrQfwlG3FjagIpziwO6bOLo9nd/GsUN541iUfbIgB9qsCS/T/4cvGDWrt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YsC81ZtB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YsC81ZtB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2071F00893
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 06:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790143867;
	bh=36DkvQ40d2yR8/sYsHjVsChpTAqtkzflfa13QYZVKCI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=YsC81ZtB6p7Ye8J46St0nIWpDIGBXr6BqfcMKpWBw7i7WWStGXBNu4rTz+xt2hrr/
	 DIAGBS33T1UQMR78d9BXCabEGL/VmdMdKbKAmx276njXWB+srosYnd3yS2QLyNets9
	 jqiTOmvWxS3e3PzL7oa5QfPoLa012fZUlplwW2/6VE+kD8jMTNMyQyH5julGBbVHUa
	 j09h5z94LvTKm9AAQO/XfK5gEiSXJ7nK3KQkEv1kDrtIvkoRnwmRyUzFEKkqMGKRfG
	 nP8IE5JX4twuozutakMC9Kj+bBcZZNkEA21DOYZEpPCf56PaVqtjUeIFIXOE5kOnqv
	 s6fsaaWCsL49g==
Received: by mail-yx2-f42.google.com with SMTP id 956f58d0204a3-672ce86b21aso619896d50.3
        for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 23:11:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByquhj1Kr0+czmQQkN+x9Y79KuHswVz1kBl3sOLq2UlYs8APbCU+8pnA1MMBIdkj7qog3H/ztRG@vger.kernel.org
X-Gm-Message-State: AFuF++kkieKCRRd1sKraeMw998gqzELhd3ICvs8v3SNxozZl3b5oblSC
	rXDJT+U+PFKLuKC2u9Sqm72zQy7MyKTIV/5UL/Z0RXmt2OGaMqO+RfsxG73SMBYvSRnFGc3zrKa
	wL1kzlh5Vtn3Hm411uN2eatbqBAOD8kSR1hjWJpjRbA==
X-Received: by 2002:a05:690e:806:20b0:671:4a50:cac8 with SMTP id
 956f58d0204a3-672d57377eamr504474d50.32.1790143866547; Tue, 22 Sep 2026
 23:11:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F> <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
 <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
 <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
 <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
 <a75b2eac4297ca6b238dde6f9246d2c1807b935f.camel@surriel.com>
 <CACePvbW_-6M63_a7Cp+09dTmpHeMEdj9VDQZf8g8qoYKQD=wvw@mail.gmail.com> <arKiK06mfWTw9I9a@cmpxchg.org>
In-Reply-To: <arKiK06mfWTw9I9a@cmpxchg.org>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 22 Sep 2026 20:10:54 -1000
X-Gmail-Original-Message-ID: <CACePvbWaNGKSZHdWtUw6JvaydvPqKmcUR52j+7CXt4_9w4uYuw@mail.gmail.com>
X-Gm-Features: AcwNN1V7JRD8IWTWDQf-4vF0gQsA2D-aYRiLEM1ny74LPtNp-fFSHWF5S-AZcVU
Message-ID: <CACePvbWaNGKSZHdWtUw6JvaydvPqKmcUR52j+7CXt4_9w4uYuw@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>, 
	Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 22, 2026 at 5:43=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Tue, Sep 22, 2026 at 05:23:31AM -1000, Chris Li wrote:
> > In my experiment, 100% is already way above that bound, which is why
> > I'm curious about your data point. How do you run and test your system
> > at 100%? Please correct me if I am wrong, but it looks like you
> > haven't.
>
> You're conflating machine size with workingset residency.
>
> Rik showed an example where the compressed set was twice as large as
> the anon set, and it worked fine. And why is that surprising?

Where did I say surprised? I am just saying that is not the metric I
am looking for.

> We know many applications have long tails of cold pages. Idle tmpfs
> files and shmem segments. Things that get rarely used. memcache style
> workloads have a small, hot index and a huge data segment with poor
> access locality. Even if large parts of it are in compressed space
> that's better than storage fetches.

So what is the max (%) in your fleet based on my metric definition?
>
> Your "this will thrash after 7-10%" is an average based on common
> workingsets that are actually hot. It doesn't mean there aren't cases
> that benefit from much higher overcommit.

That is what I have been repeatedly asking for regarding your
deployment setup. What is the amount of memory swapped out to zswap
relative to the total system RAM? This should be a simple query on
your end. Nobody has been able to provide a data point where that
percentage reaches 100.

> Why even get into this? Why even try to find some universal limit on
> something that just costs memory anyway, when memory containment is
> already a solved problem?

Because I suspect that if that number goes above 100 the machine is
unusable. If this statement is true, then nobody would want to zswap
100% of the RAM. I don't need to preserve that much a space. Asking
for too large a value is ridiculous.

Chris
