Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793810789;
	b=nhJ/XzHA3NQcI8AB5CeyUmeBiWwsZlLepqhERmndlYNmTfqacMbQsGJe1PZH6Xb1UyMn
	 FRlqOBUGheg8slLiWQk5i9rtbib1pc2wxlTAKCqO72oQP4bsUC+rNB8kaAzJ4vlQ++/bN
	 ceRzBpw4hz+rpzIrE7bUgYiq0Hg2+bKjYDpzegC9o4MugIsKD2DtoSsXlBrdCVgF8eTVD
	 x+TiAWxjSnkvGLXpMhdRwKDLy1qRqfgMVZeogAKo4GxFl63OxlOn8txB1DJX+RuiHIZCl
	 C6ecnnqbit7c96jIiBqkUY0RZZ9Xw4v5PVE5XASPnJLL0eACnQdQadzRYCWMAE0q6UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810789;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Content-Type:Date:Message-Id:Subject:From:To:Cc:In-Reply-To:
	 References:Content-Transfer-Encoding:MIME-Version;
	bh=qxevzDe0ERznAZjpDl0rGSZzGbCrk7b/Nsjrdx1IHxQ=;
	b=Xd1Qw+t809gkUuR4tAxENzYw9pP6qaTK0mJYFuDZeenAeXyTWheJOHy5uoF4HCvVpzFK
	 hYo5IAajaPa8mu8ZxrG6CdqlotLh7QFFZh+FC+8oztrYYQZjFPXzwNSoC7UESfOIVHm2o
	 pKfvqbPkLO1yx50njlqzXLDZ+Fk4/RnB6WI5A6mqg0cdH8lAOIeomAnJATxE+xGFmVHVm
	 dYusGI94GONHq0zrEE1QOGFxRKWHET9Magux9fuuKIFYmQDg/+cmM/+XKyEJBDesYeWdZ
	 lpuehYFVnOKRfgoqBdBMR44k6VVjqv39CspHPrqam4gE6K26a/OTcxtt1HUEXaUaXYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ru3FEnu0;
	arc=none smtp.remote-ip=209.85.214.169
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C08D606A32D
	for <cgroups@vger.kernel.org>; Wed,  4 Nov 2026 16:46:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C08D606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ru3FEnu0
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ea7190aea1so4404895ad.1
        for <cgroups@vger.kernel.org>; Wed, 04 Nov 2026 08:46:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793810789; x=1794415589; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:cc:to
         :from:subject:message-id:date:content-type:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qxevzDe0ERznAZjpDl0rGSZzGbCrk7b/Nsjrdx1IHxQ=;
        b=Ru3FEnu0VHLR7r5u1t6YBaxmZVqC2XOTMln2xKGTlN30WyOcM34wDWgsdSO/AQAm4u
         +dGZl2Gob+iUIOb7yb5gXIjvSYs3zy4WPDcoTEqFG7Ik1b1Za/GtEzmkjCexaaygpew9
         43PwyJALhTqq7UAy/4AGtOhlQdN1pYoP7f4n62v/HgzyoOXi44egmBCSLtPc0AlEfFmy
         C1jUkrGOTL3EqjL+VqE4qnqWFk2s9B7Jof0SI62okD717EJ5yQoHCUe1i+DWLi4vYZLU
         xh0WLGugCRIJVikwM0bq+1lSL2lJZPGjPZA0Oqq4U+5xwMUIVao6etUiLTL0GeeY+Wm+
         L1lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793810789; x=1794415589;
        h=mime-version:content-transfer-encoding:references:in-reply-to:cc:to
         :from:subject:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qxevzDe0ERznAZjpDl0rGSZzGbCrk7b/Nsjrdx1IHxQ=;
        b=iIAmWi7bi/40vClxqVvYbfVtgFXr3W09VQ0yaWLUJV7uM8GrROCjLGGNJb8OAm+uAD
         yBWPZyg3OipC+7PKtTZ4QecWUuQz+QM045dXeBeaELsM0kHDFPuTC0d5xGTTSMlQlOLx
         3+uNb8Z0I1YUeNN3oQAX1RVvgTj7Bcx4+PQ6Enzzme18y9wjvNGfgbHkMGWojNqsO5fK
         HIOPusWiJRh1DpdUdA5BNQRJP9H2rSt3hme09fixs/vU9vsFmUBCPKJKCqZxsl5ucsXc
         zs2J+PvlhAFoo/zKXjp8KwhTZJYKKF+ySg4mcMHnWAIYIQm434DzeXwfLXraiBHWW3rM
         pzCw==
X-Forwarded-Encrypted: i=1; AKwUvBzXewgR7KYsAfbUQarB+uuQCNgDR/wWBU35dOXHt6wB5/LrS0gST3AD4tJGQEqszYjb9cX6drTI@vger.kernel.org
X-Gm-Message-State: APuU4Z8J7x2N9vx7VplSRb/2LmPnRhNf+89oAhvBpG1UawUeGHBRsDPD
	1G23sSPNgT+V+9lEC9m2Uwn0AuvCqc95hU2SI5Z3TvcFEFuM2WV17W4R
X-Gm-Gg: AYBFou1ZzuSp9q06mvP7zcnvjT6WHUMYAGw608wjW3WhSzk3zt96J1a/sdO/kZN+dxj
	BUyHE1R1wfZHftw/ffOkdsUcGoJV3QXgmwVfgSsZlkC/QEtrC7DQ5umEbf0u4nbo6a37HWEeUTs
	k1PMD7nqdt4Zy6hFGbfGX28d7g9fjbSj6Tg+WQGeTLYGLH11O2l2P1+WSKoEx02fDQ+fg5b51A6
	pBg3V57v6GM/MHxQbSSIb2jNi2z7Iq+axw/FailN3PlFVarza6ic7zBSmMXbjQxqAgC9NE6jb78
	nYbzZMjoF+NhHQA2phPJyLF6Qg8dxzEO+ZFuVH6GaHEA+9x+no8MWEDBPKpMr26DLgN8pjEbfjl
	hKWKWECJwByXKYPnE0jxgt4T2u/fSQ95ITZ/wcmMWqeKTUFRrNH4XpQyKxh1HnMw063/6evEAeO
	i4vlC77q6ww7+r398lAutfO9BjwDESGTbCweUgiBQcCtQMhTOEy4Txxrdv4w9YAHLHHTqPDSPCb
	lUf2ows+Qmzj9NrROZ0qAHlx02PlfvtbQ4DLM6+wESnajXPF5owWxS+ul07Ydd9DMl/SHRE8YBl
	cSytlrAYm+m7s8IYWPOsWnksTuLB2/YT+C/r52Z/jlm8IlY+Ly5H3hI3rTQHTfAht6DZoP2uM4B
	ImHrSy3OnE5TIS5ToaxR4pQEn8D4spT+7FMQ=
X-Received: by 2002:a17:903:4b0e:b0:2e9:9a19:c54 with SMTP id d9443c01a7336-2eb3646ee38mr139469995ad.50.1793810788339;
        Wed, 04 Nov 2026 08:46:28 -0800 (PST)
Received: from localhost ([153.61.198.251])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed08bd4a3csm9983805ad.11.2026.11.04.08.46.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 08:46:27 -0800 (PST)
Content-Type: text/plain; charset=UTF-8
Date: Wed, 04 Nov 2026 16:46:26 +0000
Message-Id: <DMMKUQVDEM0N.322USN1ZSYMCU@gmail.com>
Subject: Re: [PATCH for-next-fixes v2 4/5] mm/slab: fix a deadlock in
 memcg_alloc_abort_single()
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, "Harry Yoo"
 <harry@kernel.org>
Cc: "Johannes Weiner" <hannes@cmpxchg.org>, "Michal Hocko"
 <mhocko@kernel.org>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Muchun Song" <muchun.song@linux.dev>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Hao Li" <hao.li@linux.dev>,
 "Christoph Lameter" <cl@gentwo.org>, "David Rientjes"
 <rientjes@google.com>, "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
 "Clark Williams" <clrkwllms@kernel.org>, "Steven Rostedt"
 <rostedt@goodmis.org>, <kernel-team@meta.com>, <cgroups@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-rt-devel@lists.linux.dev>, "Sashiko" <sashiko-bot@kernel.org>
In-Reply-To: <6441429b-eff2-485b-acf3-26c3034910ae@kernel.org>
References: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org> <20261103-kmalloc-nolock-fixes-v2-4-19167cfe4779@kernel.org> <DMLSN9VHK0P3.2A97046A4YXGY@gmail.com> <auo5G__ac1qA9JRs@thinkstation> <DMLVUTB5J1RJ.2QKOUW6UB04ZM@gmail.com> <6441429b-eff2-485b-acf3-26c3034910ae@kernel.org>
Content-Transfer-Encoding: 8bit
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Wed, Nov 04, 2026 at 07:35 AM Vlastimil Babka (SUSE) <vbabka@kernel.org> wrote:
>> I don't insist on kfree_nolock() there,
>> but can we try free_to_pcs() before defer_free() ?
>> Like:
>>
>> 	if (likely(allow_spin))
>> 		__slab_free(s, slab, object, object, 1, _RET_IP_);
>> 	else if (!can_free_to_pcs(slab) || !free_to_pcs(s, object, false))
>> 		defer_free(s, object);
>
> Why not try free_to_pcs with allow_spin as well then, and improve
> memcg_alloc_abort_single() for both contexts?

yep. Even better.
The bulk side does that already.
Like:

	if (likely(can_free_to_pcs(slab)) &&
	    likely(free_to_pcs(s, object, allow_spin)))
		return;

	if (likely(allow_spin))
		__slab_free(s, slab, object, object, 1, _RET_IP_);
	else
		defer_free(s, object);
?
