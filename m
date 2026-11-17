Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794942733;
	b=wes9yn3MJXcONxWBYTgnBOUM7H1BaIgkUtB/fBuubn/zgG5cssxeSvweX9nnS6CK9O3q
	 o2NARcrk9mt8kCgnjS+AWYDpSAdMoENbX+KWRqvsre6/BnndcAXqvrKD67nJDPN6tlkXC
	 qcSCYGsGV4bulli6TJGvhFlcNWWPnEoVXS7RkoUCNL5YN0Krhx2ZC2mJf3SwRSrEbOrtZ
	 A4QJdXGKk8KZV5a6MiNKI3he6HUIOMKjmQ7XMwnMUTfTV8foFv3PpApD1I7aiQ7JW8Yv/
	 WKv7jkoU2gPhcvq9ldWaVEnPM5i226pAlhS5iXApx2nvKuieyV4dkIhmRL3CeigJnmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794942733;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SoGTYtJjdTBlgzzjEp2BKIQvSbp+BHYyIKXNcsaV2lA=;
	b=hBjJfC58HNIOT26ZUEhwJ8uu30M1DE01kHIBg8No3fnBUDZDzwJN3f63w0cvH9JzqaaH
	 G4bBOn2zQ68g7oYjxk1r04XP9awh//3eq9n/yy1knJxd7Jbvx3Pt2BzIDDYKtGyqfdEkY
	 c95ZYOsCGK/YHgSDPAwxpKKOQ+jlM8VGBRNs0g6E/HUUArqN8AjyUWkP04TBYvzIVizfC
	 ZDt5e/7Fwi16PkQY322B4Tk2NuKfFhoExDoBwITskxoXQp5EPh+ICPRJyPeciDuSjJltQ
	 9NdVUoMkMXs5etPLUlGCzWGbH/FyJKmhONuGLM3OUGGMbHQ2HYXQ56++VspxIBm3wcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=x2vQuJGZ;
	arc=none smtp.remote-ip=74.125.82.49
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C4C606A31C
	for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 19:12:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46C4C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=x2vQuJGZ
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-1b3acec6677so286762c88.1
        for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 11:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794942732; x=1795547532; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SoGTYtJjdTBlgzzjEp2BKIQvSbp+BHYyIKXNcsaV2lA=;
        b=x2vQuJGZ54C9oxn43e2SKTDVrCHxnZsTb2Nz+4rjP8P9AWZSWaINhFdHQjLy9qWy05
         slxVXMlS/vbaX3wotLMGWguEUeHvTmWRu00mRMuGYIRSTFnmB7+yb9QaZv6dZ30pGUu2
         /tNoZfltefDP2TDHvV8ReLDpXOgaEJa1gvelSfXMya+O1kYnRep/nOKRIB0h32ptZJej
         mM9r/eyLpEOO7h6oMowvj1Q5GsEoi7hmDgr5zVZxLRdIqNc9/NLhNthqRzvOp2SyJ+Ge
         uufeu2ePceUjr+rNPTT6PaQCpZRr2V/TnuxRYPwITWmlhqGt+fbxvbilfrMAGIqZLrvK
         gDNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794942732; x=1795547532;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SoGTYtJjdTBlgzzjEp2BKIQvSbp+BHYyIKXNcsaV2lA=;
        b=YIFAN2iR2rIYWgWSWY6xRgZQnvsYlk8uQhX53oyDGPmDb37hc4qiOaPukTOF1X4stq
         6eY9erlInW9DH4jPEpEFY3qhvxbJ6CvWsBmLeLmUPsLlv5wGrXskwXd2n5X0aHGKubR4
         Z0EwzHS5HaTucTNyQbvxWOwHUC0Vh1SrFyXhhzoXhkuHk9b5bkLn8MXzM9q/OD/76e73
         JHn6Wyk1zMI2sijIKnq4PDvs/1V190/0zseQkxWT34smqYdA4BvG/wkX2ZCjNhCfeFPz
         VyV7UBhsUCrDpueuCqCIcQnxyXsUplPV3KlkpkO1mmahBPPvx17miRemTtFtgK2AfwdD
         Ie/w==
X-Forwarded-Encrypted: i=1; AL+hErF9LnIuB4Odt9lBh4hTjFJd0Sd6w4bWsrysSEdPGAa6kORi3D77pC+pvRIOgVU/ivLaZF4jlIR+@vger.kernel.org
X-Gm-Message-State: APuU4Z/OF0wwfYk4vCyfSibwbYwKIDcH/YulcNdSBEg8b3qa5CnOiLrL
	xAA5c6yCqGWynoYAX9opagW3EqExjCJEyu7xB1j7rulBm209WTQsmvRc
X-Gm-Gg: AYBFou03McaEjUoW9Kdt/rBtKTnHJ2tX9B3ebQIWSD2ykZoib+XAgvlsoHP4734RpgK
	C+M8Mnk8M3hHu4oC42w2R9ANdzH5nqGVyeFBzP2ePJVvXgpFGYSvu0ProSsLCSSAyog1mc8+jsY
	+cU0lHV22f9rwvxMNlnQ7S9v4gDg7n2qjk7KafyZLI7jqa3u2VCybpufbcD33abhPRgp2khSDJa
	Cfz3y9QyVsld9w1U0WSrdKASIXwIlMacRY4ZtFqtinFh9TLMWfoFHymY7jK0UtlHlsXO/fO3d0I
	IRdMNRWy/RXqQ3nBeYs2JOEd8wfjRCs8zRxE+YLO6zNgDp6+P4Rwc9ZYXMWKBUiQvJoz4YMh1fu
	Ke7ABfBN2SgN0uAzZ14pp1bcNU8K14hcjX8JiB0CwuToZxc53B1FTYt2VuvONKer0jdWRYKHqzv
	GkqnINQjLYjOYl55W99qwSc9JIrTwePyQ2Sr0EanVBLvw1kgBRwkH7c0AtXyCoy6CpsVVJQsuza
	twx05BmpRgdwljQGDWYQe/cyHaEJ+/6Pv9w21evFbYJWeVmV7x4ipZ2mttX1cz0s8dbjXehxmdV
	s+7GfkPtraHxRISUOL08RLDLR10UnboWtLp0W4QL+24tBaE=
X-Received: by 2002:a05:701b:2718:b0:1b2:6a1d:bf58 with SMTP id a92af1059eb24-1b543d4b410mr474902c88.38.1794942732411;
        Tue, 17 Nov 2026 11:12:12 -0800 (PST)
Received: from naki-PC.localdomain ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5447c5b02sm211610c88.6.2026.11.17.11.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 11:12:11 -0800 (PST)
From: nakixii <nakixii@gmail.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Barry Song <baohua@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [RFC PATCH 00/16] mm: add in-memory compression of reclaimed pages
Date: Wed, 18 Nov 2026 03:10:04 +0800
Message-ID: <20261117191004.1289281-1-nakixii@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAMgjq7B=F7grQqhUP1wGPG5uYHL44QNS023Lg4Zw0ycQEr_C0A@mail.gmail.com>
References: <CAMgjq7B=F7grQqhUP1wGPG5uYHL44QNS023Lg4Zw0ycQEr_C0A@mail.gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Kairui,

On Wed, Nov 18, 2026 at 12:27:51AM +0800, Kairui Song wrote:
> Posting a mega-sized chunk of LLM generated unreviewable code is not
> helpful for anyone.

Yeah, that was a mistake. Sorry for the noise.

> So in mainline, the win you measured is no longer there.

Thanks for actually testing it and posting numbers, that helps a lot.
I'll drop this series.

> you didn't bypass swap, you just re-invented it.

Fair enough, that's a better way to put it.

> One thing to keep though: patch 1 (UFFDIO_MOVE exclusivity) seem
> valid?

Yes, mm-unstable still has it. I reproduced it in a VM (fork, child
exits, parent write-faults one page of a 64K folio, then moving that
page gets -EBUSY), and the fix makes it work. Will send it separately.

The part I still want to try is packing several compressed objects
into one swap slot on zswap writeback, so writeback doesn't need to
decompress. If I do, it'll be a small series on mm-unstable, with
numbers under sustained pressure. Any concerns with doing that on top
of the swap table?

Thanks,
nakixii
