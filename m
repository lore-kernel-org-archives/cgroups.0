Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E6C3431E6
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 02:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788402145; cv=pass; b=bpVION0rqNmkx55kYVc9JTGnp9WH+J14FRXp2mY0I8Tbzog+GnjFGiJLTrtbOI5xgetYHOsQ9Hh5vx4v0vlFtd3SWV63xlmHlBJUFVwFBYeZVKhniaKhbYZYWlRLUl+Cy3bcJvCChjDqbOAAd0Ovt7KdR/zl5jIFWLnfbqQGKfE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788402145; c=relaxed/simple;
	bh=wG8yfXZMFVAt9IH9Z1c2y228HekdWYvnNtOdJZcmldo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P9HozNCnAYFhhpHC7VpXkPgjLvruT0hdr51PhwAXHt7Td1QSsyPGrVfg85J2AxhaHOOSxYq1d5rvi7KEpT6bz0dsaDzg1M5elKTMzAtqJUxnvDAPzrWyauWX6DojLL004k7a0WPWF6MWpa9GCla39ou1v70HnbA3jSR54jmGR4M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YTjUSBjL; arc=pass smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YTjUSBjL"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c160420289bso227522166b.0
        for <cgroups@vger.kernel.org>; Wed, 02 Sep 2026 19:22:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788402140; cv=none;
        d=google.com; s=arc-20260327;
        b=e3tTuWjTuM0unIBJjelyPT6n/WBUs3IYOsrtfIN2yTmpP3qtibaCah9Iwvd5E723bA
         QuU6GIks0ohfgzlarGQpds3AUyb2Ww9d1M9J/LgUrCSUI4d9YIKG9TL/cEzzATV9eXyN
         gnhhjAhsTq6sHq5iS5C9vF3+YaPGwg88fmWSfeGkHnBchmly7UHIfNUDzbWxQbeaEphc
         JAa6Rbr/9O0D95zexhPsMsEnqdy8U9EioBcUzoWBtakOV3dQcwIIg+C0BleqLtMdOTzw
         j8cbj6ZaK/AsAXsrUZDqY/8Y2R0RMSnvO89nZ9sWXNDGewvYy1NZMrRn27QijondCmwg
         uFwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uzF2akW8js1Qtl2W3U8D53PAMgePI3lJc85Uvk4KROs=;
        fh=Zq0AM6xpFDu8fiWcEt/KWlQWXL8PUJtrGRGatP3jkEE=;
        b=VCDvdiLznozSI8MPho1UabWotqzXtHRq3QJB5jeNjChyOJSH/79nJ2nSZ+YzcUDGLK
         PjTR0q/ocIw1nofMRFRVFl4MWnA94J5qfnwg4sBMATrciBLUBXHFjydPtT0FZLgxUgso
         dgNJaaQHZu7C+1K3qwgHUcjUYZGUdHVtR8JAXaVrLID3pft42ZuawUlE83hPgskRtwQC
         ETvdkfJ4+zLXhgFfpQJg+8fI5Nzz9f8hJKWwpfc0KX2+he1kt3oJ1s+o+w29TO1gp6YA
         VSQT67GWEu9du5H6pAW2uAonPcUrZLyR2uNgLaeyoTMG4byZsa9woojidoAqh9zQRJzH
         hxag==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788402140; x=1789006940; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uzF2akW8js1Qtl2W3U8D53PAMgePI3lJc85Uvk4KROs=;
        b=YTjUSBjLFLKfilsVxzaQMmK/Ywnv18Gcw0ii/xq9gTUugYWkoO3/+hPXAOd+Q7pFNM
         8/pB95vwCckYFCl8LmduNjU58U+oU8zIAuiKzgcT3ScHZGtdWog8BaXcZ7gAKCC7EjWe
         Kav1AVeERSQoeHQdhdcQlh/b98D3GKG/Gl61isZqPcG0MykmL0YPDxTzU/+h/8yGsvaS
         IVKCKDF/HmPH5pAF8kBWotyMtrY2t6SDtBRu/8DK7guCh8N4g/AiuqggEPsP3qMMMPlj
         tfqdLwpCNIxyR6XfZWvpzjudQQ9wvxli2gR2mVHhdmlqgtEaBSW5MA6ec4Z9YKoC0+ww
         GyCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788402140; x=1789006940;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uzF2akW8js1Qtl2W3U8D53PAMgePI3lJc85Uvk4KROs=;
        b=rha9CXOD9j9ex9NgZMfuDL7l8g8iXduvDDBx7ITxwDCW8OWCDlkkXNh9Igf9iiuAli
         88BW9INL8o1AuJDjqxlYZwuaT0PlCQTYnw0XQxUVmd5BcLAD6isdPUVLzlKRGKugGJSF
         w+gMb77HlAMQmPNRuRAG8FEhfeBvnMR7N4ovXed7p/s6YatFFNKfSjGAY+iV3YpUz9qg
         pnPLiRV6dxQIUKYEVS5LaqSg7AhWVpLPWimeX3v45HHW13yMkSzRsmM9CJirRdSv2uGS
         YQv2qGJnj/6R92RSEVMq0xlGMnlnRk6gP3zeOTl8oxkl+FfG2zOHOcSSKjh+A72sMXeY
         4Kbg==
X-Forwarded-Encrypted: i=1; AKwUvBz8oUG0CcuT2nIy+1rduCV453bzAjCqclv2SI/yytb0G5FYKzijmNasMbv7T9LSLf4yEzNjiByu@vger.kernel.org
X-Gm-Message-State: AFuF++n5YS5hwAA+BPVoI87dY3gWaI4dOu3JrvteJhUP3+sN+ZfT4mXb
	MdzPNDs05CR8v134oSpHGx5x2KhW8zoUew/FUht5oKmGWlNha4cm8Gf4x7NMweAE60MGOzqP+F7
	ejQiJvTQhW+zrA0y5cfa7YJNy8QrXcyU=
X-Gm-Gg: AYBFou1ACHv8eN/i762RSSBB3U8yvOTVRa6hzYBGR8eokfYjnuJfrWVYRigizwGQwkl
	sYEYNn3Sf7w1ltSKFF30T4z69DWPb9Zz8bP0C7o3v0IfL1c+lMTm2WVkI6EkZtRzF3MelzJTGTG
	8lzwVTDVTRVrgmmcMjx/d6uxk9f2J20p4pPYHGwJNgAWjV7HvTvzcPC5k12CzV0d9xva2RhqEno
	PiZ/I9WwS1jckoAiV6DNWFSESwvPwz6NCp/pChLTsnb2ApO/8TzWkDmDygBuWQNuaIICBYsQJwA
	nJ5JtcxK+I2zJIn6TisgA3taExzZmt8a/Ltn4WWP+1UKqwIGwGFNeat8AoUi/5G3SYgWkoKFzWo
	j
X-Received: by 2002:a17:907:940d:b0:c16:84dc:9607 with SMTP id
 a640c23a62f3a-c25d5509043mr579045666b.19.1788402140304; Wed, 02 Sep 2026
 19:22:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260902-mglru-flags-cleanup-v5-0-9db761d779ef@tencent.com> <20260902141153.93b932ba572b1d3375216cc4@linux-foundation.org>
In-Reply-To: <20260902141153.93b932ba572b1d3375216cc4@linux-foundation.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 3 Sep 2026 10:21:43 +0800
X-Gm-Features: AcwNN1VaXdfXwDwuHgeUlK13sDpqUXHJ071CJYvST4lMD2Ml0BFv40TbHBDM9GM
Message-ID: <CAMgjq7BoNJMxZ0DSCyJHZ+KHTP0pwOp8C9298PTYZK1OBv7sFA@mail.gmail.com>
Subject: Re: [PATCH v5 0/6] mm/mglru: clean up folio counters and flag usage
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>, linux-mm@kvack.org, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 3, 2026 at 5:11=E2=80=AFAM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Wed, 02 Sep 2026 17:50:53 +0800 Kairui Song via B4 Relay <devnull+kaso=
ng.tencent.com@kernel.org> wrote:
>
> > This is a cleanup series separated out from the MGLRU-FG series [1]. As
> > that series is getting too long in following updates, seperate out the
> > clean up part for easier review and merge.
> >
> > No feature change is intended, except one bugfix. It mostly replaces
> > the open-coded bit operations scattered throughout the MGLRU code with
> > new helpers, with proper kdocs, sanity debug checks, and hardens a few
> > MGLRU functions.
> >
> > A subtle generation counter leak is also found during the refactoring
> > and the fix is included.
> >
> > Also collected review feedbacks on the cleanup part from the posted
> > series.
>
> Thanks.  I hit a non-trivial reject in [2/6] presumably thanks to
> mm.git (mm-new) race conditions (appended).
>
> The patchset comes nicely review by humans, but AI is less happy:
>         https://sashiko.dev/#/patchset/20260902-mglru-flags-cleanup-v5-0-=
9db761d779ef@tencent.com
>
> So please take a look at all that and retry in a few days?

Right, I checked both already, sashiko has beem compalining about the
same issue again and again since V2:
https://lore.kernel.org/all/CAMgjq7BheDgQZa0=3DKiRnxVwky9by5LA=3DiaexfPfT0W=
ftgfL=3DqQ@mail.gmail.com/

It's safe to ignore: not introduced by this series, and not a real
problem either.

The refs part is also fine, it barely has any real effect.

Should I just rebase on top of mm-new? I also saw Barry's rebased
version of Patch 2, that looks good to me.
