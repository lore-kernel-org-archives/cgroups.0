Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B88E26D4CA
	for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 01:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790299221; cv=none; b=IUvvg/j2t0akANhHwM+IztWzMVgL1hDeC6iKFDI022u4AJVSIFnfrXThS4m90HaFkh4iMaPJL2+Eg2zUajrJ10ltEBUgPG2lxVEBYqpRH1jAy1+WipfzNt/mK7w8tnOjfXcXDxj4uKwe3AfZJbTq3M08VwQcRbiU2ZIqWmqtqNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790299221; c=relaxed/simple;
	bh=MXTKsI2Rsvq9x6jxxmZAAixjI3Oi6YwBiX+NqIKH+Ic=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o64Wz+b/M4wvjxrdism4RPrP8gQh3m+JJdJ3T6gfH9SiiWtdgTVvaGMIkd5/rAMalny/Gglz3pcH9mHq8+MDiL1Nd2YHKtnAFNSKimjNrTpbvg1sq8tilMshu9pqZ05YxvjxuqmvZhcHtdYhsQvqArvFDCO8PH42LPKoJs4qfTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cm52eBOE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cm52eBOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997A71F00900
	for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 01:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790299219;
	bh=MXTKsI2Rsvq9x6jxxmZAAixjI3Oi6YwBiX+NqIKH+Ic=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cm52eBOEOJyH7FvFAuC+pcmxCDoa5HbOoVxLQYrg/lSVdMMvHPGEmpg3ysTiKhuAn
	 zcOKVc2kQyEQ+i5wXn/NbKzSPTkIhl1V7yJKi1kXsnttWQ9mw0RyKgr/ga2s/43R8q
	 cT9IYsS59y9b6pSWqOKy6dFKZhB2ilO/kj9aBY578FnxaWRwEcl/yRbl6jVsohfuyE
	 1d524GBrPFZ1pgSgjmuQdoepwcaMAUvzYuODLSz54RoagXXFAJFv9ekniaYYZ5sYUo
	 k/jwBUQwZ0bXXKUA99VtKfoDou9RCOzK0HZXLCUuj+tvvETvq4ynIAPWG+ySqtN3mJ
	 90oWGINpNMqCQ==
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-670fee39d73so565853d50.3
        for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 18:20:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBw9RTBaRZp4+Lkvvud+7O/he6U+hJk9Dpjpww66d/QKBix6nsduXTawWhH4u3eNwHwo6+nazXjQ@vger.kernel.org
X-Gm-Message-State: AFuF++lmWl85Ln2M/yc3lhpqnk0M+0lweaohXqqiyPquAXUkTH9ARy/y
	UZ5QzLL4iXtSL4ButD3uGNBdmiGu7Kr933cdZ3so2pw0V4uq/Neufh4IAjtSULvgW/369lHvAHM
	MDWCBVZxMmyIbzYDn+SZ72w1vJCT3WvCZwFo76mPWmA==
X-Received: by 2002:a05:690e:1243:b0:672:a52c:daf9 with SMTP id
 956f58d0204a3-672ed5799f7mr2394820d50.108.1790299218900; Thu, 24 Sep 2026
 18:20:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260918180241.3424851-1-nphamcs@gmail.com> <20260918180241.3424851-2-nphamcs@gmail.com>
 <CACePvbVaDNspMDSw_qAcapKAzXj3JGV-KMYmow7aePa0POHpSg@mail.gmail.com>
 <CAKEwX=OP3Gb9sVOvch+p4j7quzgy-rUY=UTZau5ztMj7heJJoA@mail.gmail.com>
 <CACePvbVQsHXt4=+qfKz-KTar9CG+3OiAfLd1EZgnRE-1gyoKOQ@mail.gmail.com> <12541da81f59db27af46096db8da5d425135a162.camel@surriel.com>
In-Reply-To: <12541da81f59db27af46096db8da5d425135a162.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 24 Sep 2026 15:20:08 -1000
X-Gmail-Original-Message-ID: <CACePvbWMd+SVgriqB=ZU=kmAL80kc+iJ5x4TMc3=gn7py4Ly7g@mail.gmail.com>
X-Gm-Features: AclHuK9gGTk5UE8ppsRyrlKYwHfPhyGpjyyw313XzdHKkR1g0LFZou0vHIdSdx8
Message-ID: <CACePvbWMd+SVgriqB=ZU=kmAL80kc+iJ5x4TMc3=gn7py4Ly7g@mail.gmail.com>
Subject: Re: [PATCH v5 01/11] mm, swap: add virtual swap device infrastructure
To: Rik van Riel <riel@surriel.com>
Cc: Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, yosry@kernel.org, david@kernel.org, 
	muchun.song@linux.dev, shikemeng@huaweicloud.com, baoquan.he@linux.dev, 
	baohua@kernel.org, youngjun.park@lge.com, chengming.zhou@linux.dev, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, gourry@gourry.net, 
	haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, 
	baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, 
	skhan@linuxfoundation.org, kunwu.chan@linux.dev, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 24, 2026 at 3:15=E2=80=AFPM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Thu, 2026-09-24 at 14:43 -1000, Chris Li wrote:
> > On Thu, Sep 24, 2026 at 6:20=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> w=
rote:
> > >
> >
> > > It is needed because vswap *is* a special device, with its own
> > > requirements. If you don't special case-it, you'd get undesirable
> > > behaviors.
> >
> > Ack, that is why I am against making it a special device. That is the
> > whole idea behind xswap. It is just normal swap device implemented
> > via
> > swap_ops just like ext4 is a file system implemnet on top of VFS.
>
> The filesystem layer is relatively clean because
> it has a VFS.
>
> Are you saying it is time we have a similar
> abstraction layer on the swap side?

Yes, you understand me well. The swap side VFS already started as
swap_ops. I give a LSF/MM talk on it as well. It is already cleaning
up some ZRAM special cases in the block layer. That is what xswap is
building on top of.

Chris
