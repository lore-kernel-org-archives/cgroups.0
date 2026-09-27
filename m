Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D46D381AF0
	for <cgroups@vger.kernel.org>; Sun, 27 Sep 2026 06:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790490207; cv=none; b=T5ixBS2zzCXtgOA8mVYZ+iVsfMwOu1zCZpBteEOJ/qR4UbcKUeS51Cx9FFJ0oPkUBDI6yqBJatyttYd5KeWEx5E2ZxC80q79HucPh+06FXP3Gydmwjfy7fPa+Tv9FQh5PO6qHOu6tmDmhmUjIR0oKQmHrWc37TXmcQrBg0jA8AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790490207; c=relaxed/simple;
	bh=abQ20sTrkthDKubL8xH9f1qWTFEmLog2Xb7FTeV5HhQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hm72dLbb18xvNHNJCynJTo+zBGJPxhDN22WQAFGhpkYRwDlAW+G83XxprPnP//BxRiGJ7BM/x1LmAK/kwVwyoUmvqsnefv/UsW1yg82NIc2hxHr86/rMKJeN3avdUEcWp5BNcNzoHAmHTIbk7ILKR4b27kKZFKqY2zmDJSuicro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MgjDRlH+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MgjDRlH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9A81F00899
	for <cgroups@vger.kernel.org>; Sun, 27 Sep 2026 06:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790490206;
	bh=abQ20sTrkthDKubL8xH9f1qWTFEmLog2Xb7FTeV5HhQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MgjDRlH+sYmzPaCjMSbcE3B7aimF1q17Fn2czcyRyuRVJvOzNSF8TW+yv5wT+RqVw
	 +as3k2Liyt0WODzu2xA+ywYIuPUStXP1ftIHnpEO1ihWgyMUvRrTaDEy83uwIWflSE
	 yazikBOTHeYgknkYOEjPgxXexwFhLUtOFJiSQRg1QmO6RDSWDco07eJ6BtSvuapDfP
	 ZTSKUxftQ5D/UMB4DkBvI0EEoXYn0mvU2SQpYmZgggkdd+IQcjPDDHKhwkVKv2RgNY
	 PLcnJUUbx+/g9aIvUufLV3c0kyfnzvA/9tirNo/F0zZ1+IdGDBo/f9wnneb7cwi0Pu
	 ErqEqM5pQjFlg==
Received: by mail-ej2-f42.google.com with SMTP id a640c23a62f3a-c2afd63c3e0so163930366b.0
        for <cgroups@vger.kernel.org>; Sat, 26 Sep 2026 23:23:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxfdco2R5z9vl3xHlpLk57eNvDyVhU1A6CdXnvqsSKrHmLL1SEAuHA0yhGt+skv/BlF3sDtHe+T@vger.kernel.org
X-Gm-Message-State: AFuF++nRxJviMfVl6I5qyIihFvIt7mB9gzzEf1+Sx+Qwm8gRbwlesxfc
	T6ZHJoRdN8py52TbwcQu1xfzW0o3HaAx/Ohuh/ZcwcLsbkEFJvc9oUqr/cXbvh7dIdEGkaNbiya
	fyz2J1BVkoKl43YjDqcPclowRmYRZngon8oeKTJRC+A==
X-Received: by 2002:a17:907:d408:b0:c29:3821:ae6c with SMTP id
 a640c23a62f3a-c2ac2606943mr866958866b.37.1790490204956; Sat, 26 Sep 2026
 23:23:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aqjcFb6MFNiA6n4V@fedora> <aqjpYHbZ14A8xRtK@fedora>
 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
 <arUcil9kxUPiymXI@KASONG-MC4> <araWKyJ5MENBwXCL@cmpxchg.org>
 <CACePvbV0Z3OhxkEn-MiMrxpSmtbt1YwCt2N2_ZW3jbdh87jgFA@mail.gmail.com> <9499bc084e30df4d10bc069ed26d576e4dd3de80.camel@surriel.com>
In-Reply-To: <9499bc084e30df4d10bc069ed26d576e4dd3de80.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 26 Sep 2026 20:23:13 -1000
X-Gmail-Original-Message-ID: <CACePvbWdJSUDuEbR2FXczbeWwvxP86WDGHTL-eO0A8WwMDoNRQ@mail.gmail.com>
X-Gm-Features: AclHuK9XVPbdEdRuFYnT3RhuHd6CxK6iuGG39DZDVhwy7Jj_A42gkqdamTqXRIk
Message-ID: <CACePvbWdJSUDuEbR2FXczbeWwvxP86WDGHTL-eO0A8WwMDoNRQ@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Rik van Riel <riel@surriel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 26, 2026 at 2:59=E2=80=AFPM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Sat, 2026-09-26 at 11:27 -1000, Chris Li wrote:
> > On Fri, Sep 25, 2026 at 5:41=E2=80=AFAM Johannes Weiner <hannes@cmpxchg=
.org>
> > wrote:
> >
> > >
> > > (2) The use case we have. Use memory.swap.max to divide a finite
> > > space
> > > in storage. We only have so much space on disk, and we need to
> > > manage
> > > fair access. Note that this isn't about speed. We have a mix of
> > > containers where some use writeback and others do not. The ones who
> > > write back to the swapfile need to be able to get their fair share
> > > -
> > > not more, not less. Including something that doesn't actually
> > > consume
> >
> > Just want to make sure I understand correctly. Do you mean the fair
> > share of compressed memory used in the zswap case?
> >
> Compressed zswap memory is already accounted for
> under cgroup.memory.max.

Ack.

>
> Compressed zswap memory sits under memory.max
> together with anonymous, file, and slab cache
> memory.

I understand that.


> We do not need or want another limit there,
> though I understand other people do.

Ack.

> The fair resource use from memory.swap.max
> is to control how much of the fixed swap file
> (or swap partition) space each cgroup gets.

That is the part I am not sure I understand correctly. Fair in what
sense? Using the swap file proportional to the memory limit of the
cgroup? Do you have an example of perfectly fair swap file usage for a
cgroup with an 8G memory limit versus one with a 1G limit?

Sorry I am a bit slow grasping what exactly the fair behavior is.

Chris
