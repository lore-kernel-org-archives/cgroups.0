Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0839055D86F
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 15:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790091821; cv=none; b=CahcwVhfMIhAs90ZToqlS2J8X3GmXBVCCUHw1vvDKh6PNlkP6pgXaJENMlTBY9CjupoLwPXSDf0pJZP27IyQtOgt7gNYdIR6Nge1d7Rbr+RbBSCAWT0yY2rIVY8l74gQBZsYuxPparfZE7CEKazoqzBIXSx5w81CrrTOFDZW88s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790091821; c=relaxed/simple;
	bh=eXb5panfjbrUpOfjgoXRyzfr/sWGLaAL5VGTjs3AvaE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BZTM3J72A1PeB2FdGPKSP1IUHrR192hpebFdRgWqZSydmceSZDr1ZZ3XFSYAQtIZPoJGaiyZCLaSJW+DZdoEy+PFbdjmCZYOv3y2Yk0fn3THsQxZcCRKTe/WmQjnktXJoZi8AWsqML1rOtom4yNr//5F1/UeX0AFvmIl7RtXMC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cTmg7Cc0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cTmg7Cc0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F20C1F008A7
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 15:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790091817;
	bh=qdq6bVtlrkkiQi4IDEjon7IDDJY8jFCGab3SsYEo73k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cTmg7Cc0+6HxSo1jMfkeoa+5FPL4PXaP/ncU52vkdZZbFAZmD7oWRRwEmCZzshPq0
	 Uc+BiLrTNPohDmaQcZuCSagXyfrhBbnrjOmMzn3GNSO33NiGG2lkv4fforhEKEY1mX
	 HUSs++fVKrqmFwDhUCLqx0h3KNzpGVWlh7Mxk8w79ljkQtwMY99Ukk0LSfRK6ZVixq
	 tiGw0tiw59YRq2IoQmfNGovI1M9UHITJp5B52ZLQ/IuwxLyFwCZtIZJMihLrTB6G0C
	 Vshr3muH/z8gjrH5nILPSMeATYdoQTMTsimyv+a4UMBUCUOMCj4zZWinrFYFhWQWJU
	 Vnr6PtfDcChEA==
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66e4aac929eso3816363d50.0
        for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 08:43:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzBLH0BTWqLIcOPJ2U+QuCrJG1T/NBvshTjdJ9pnCSlp5ZTzUr13XjwCbnWtqOWsp14WPZ0asZo@vger.kernel.org
X-Gm-Message-State: AFuF++lrLbrurpSMof7YlU3dXoiEml2lMOfFIB2vGrHx1cbDXPDsOh1k
	Qn+z2v1mGpg/CUDUzEq1BhiuzDj2hO7ey83fugqvFNPijDrgg0wavt2Ur2PYdcyw8y2dBEWbj4a
	B9wprA3v1WRa+F/jSiQUVGFZJdcKPtkxUcb1o1c2iaQ==
X-Received: by 2002:a05:690e:1301:b0:672:9b54:d7c1 with SMTP id
 956f58d0204a3-6729b54d93dmr3865124d50.96.1790091816612; Tue, 22 Sep 2026
 08:43:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F> <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
 <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
 <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
 <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com> <arKbXe1Qe-FDCTMM@gourry-fedora-PF4VCD3F>
In-Reply-To: <arKbXe1Qe-FDCTMM@gourry-fedora-PF4VCD3F>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 22 Sep 2026 05:43:24 -1000
X-Gmail-Original-Message-ID: <CACePvbWW4avTV2WB6iRU+LN5zqkMTg3UhBrq41R0iw91-7Ni0g@mail.gmail.com>
X-Gm-Features: AcwNN1WZ0XbjHIE5x89rohnZw7rb7RJygKYMLdbeXm0v4OERizBpCrDBDyGcRdY
Message-ID: <CACePvbWW4avTV2WB6iRU+LN5zqkMTg3UhBrq41R0iw91-7Ni0g@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Gregory Price <gourry@gourry.net>
Cc: Rik van Riel <riel@surriel.com>, Johannes Weiner <hannes@cmpxchg.org>, 
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

On Tue, Sep 22, 2026 at 5:20=E2=80=AFAM Gregory Price <gourry@gourry.net> w=
rote:
>
> On Tue, Sep 22, 2026 at 03:32:44AM -1000, Chris Li wrote:
> > > Right now it has 64GB of memory.
> >
> > That is exactly my point. You are running 1/8 =3D 12.5% system ram.
> >
>
> Chris you are missing the point
>
> Zswap:           8812236 kB
> Zswapped:       24927876 kB

I am well aware of the point. The 7%-10% data I provided is before
compression. After compression, the real saving is about 1.5% - 2%.

>
> To support this, you'd need to know you were going to get a 3:1
> compression ratio and allocate 24GB of storage (24GB of swap slots).
>
> An hour from now he might run a workload that's 4:1 compressible and
> there would be 32GB zswapped - but if he'd only allocated 24GB of swap
> he'd be limited to 24GB arbitrarily.
>
> On a 1.5 TB server, that number is oppressive.  It's 192GB of
> potentially dead storage space.  At 1 million servers that up to 183
> Petabytes of pointless provisioned flash if you know that most of the
> memory is zswappable.
>
> You're focused on the wrong problem.

You are not listening. The boundary was set due to feedback from the
application SLO. Those are real deployments not imaginary usage.
Please respect the user.

Chris
