Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E33F3890E5
	for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 21:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787607092; cv=none; b=P3lB8g1y4BtcjQb5kjpR1MhdvkL3b4XmbNfdHA6OuawKvrN4o9Pekwgn1pNl6kfE84qTJHeXAEYmoiOs+a5kqCcYPaQ1Amh91V5VvUC0xAlIoPeXT4GpUiqC27BuaZchlqTz9ISEwn++dMhB+mHYgUpKulsezLYyFhfAI9ykAxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787607092; c=relaxed/simple;
	bh=wZY3CZQXf2ac8DYGwJxJJwhkYcTevE4ky5EalI+ry2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oYJbaTs8PfKtUob5RVXAAbf2bli7gUXCI4h+80cL9hBrFhMPHoR1E6otn0dMxlecXqd25lHwRa+jyQdAasSuL47CaUjHJKZYZKEX4+KEiyfvi3WkZarL1hnJoNsvzTicZBjnWenHVAAGbYOaelKvPIJbu10fz+KrGf/ygzCLKfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lFHGvc1B; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lFHGvc1B"
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-4ab89cff9c7so1602461b6e.2
        for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 14:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787607090; x=1788211890; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FwuBEBnZB8YTVmGcPOdxFw7ZwLMAxP26w8gq8guPh/o=;
        b=lFHGvc1BnYhs5er9RJ8gfNpRUTrso7wRH2CilyO5IEZcKQp3qKsL/twDY2hfwE4oTw
         Hl11izCopIR07U33KvW8vA7iJq06y1pcMrxrCLfYOZfwd3KsbszCV3eBRFUuWXw0XbFz
         HcrUORn+Y7GRl5so/TQbwG3/kYsOXhlg0eKDcxuoL6cJmXNpMmw8WuKzN+wf+z9gFnxV
         PqXJawMWhGROWOZO+RPfQktHNvm5iQneVnJGYZmoHT6RMk6rfsU9GklQ3YtlfbpyR4Y8
         kCxp+1p6t68Xcv41xr9C5byZ2202/kl9x5DImoD04XnshuMxiqyeDUzbNO4b5uON7G+1
         oiaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787607090; x=1788211890;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FwuBEBnZB8YTVmGcPOdxFw7ZwLMAxP26w8gq8guPh/o=;
        b=hoQQjnuiGuHpkHI7Swy49a8jtn/HomamjQSwv8od8hFtFgv/pDNb+eMFGpfsL/TrSA
         Hv+PYzOqBp60VM/fy8SbvPd4ozPXG0zKxpCKhlwszVtBGM1uQoaW70GHR9wb0YDFWVNd
         x/Oi5Y3Re6S0LSYusR91WtEVYcY+unq7EMJvsYBb1pRXKGU61wET2s/xuNu9DxonoOJn
         u53+dFDLMLZUVaLNJVc6ozxKCjK50kk2P7hbQxhyhRqzzUhNtDbA2HgPWNDlL1jR9XeD
         kCaFkzRtkbU6jg8GrbKNsVtRElvxV5nbQnbhappDQupzkT4F3Kn306mOrdsqyF9wjRZf
         r/nw==
X-Forwarded-Encrypted: i=1; AHgh+RpVTPhQz2rOWTHrHW2tW99qbyqsTtJGsNizVAKU/UuWav0wRTeco8JssvlVk007InIH3EmX8Bvm@vger.kernel.org
X-Gm-Message-State: AFuF++kflTW1vwZe5qc9i2ZRyxq+pzHOXCKNDNiYvEERm5Jp2/fI2ZK5
	CcMiHomlhHRV0cTi6QZicMwNMp6ZQ0JFPJvwOAODQyzR53Wc9aVzg0IUupg0JQ==
X-Gm-Gg: AR+sD12CWxhVxP7C7cySKpswDFiUutY6a9jPKZNiP8SsdnwT1wQIA6j5AaQQDudPf3c
	pgbA9qOXWI2lveApOqZvhwsf+apm3oO0vrybXNiwBa0NDuFEKkT4IbhJXGgkSPIeF67stbXLoeK
	cIeuZah6c0SbauFNk48RrfFKnV81Faq244MKqrMiTCOE21fzpJUy080XjzlDI8N9AoK1a+96nwu
	qCtfgk2E76woUEW7KWc0mHuTWhw80AGgW4TOGCwGnm6EY4P0B3OKeLzRr9EfBgmdGQpcRgN+Vwe
	39ImUAOIfrMz6WynXHWUsCKAYJVeZiRcL3vN5i/J+9m4Acv2pkIumsfyvlPWqs1tFHGu3i+UC8+
	P+YehVqlvi5Qua4pisc3bPdFt7ZXMotmQ+nPHHDQen5f86FsiiEonQVVhROwJgVPhFElEdyGOwQ
	YOfra++tcABkKQYnYxtueHoeHnxvr8zNRfyKJePrGi7N9js7Gn8XpF68QUzS0wplu0g7v3huYA8
	I9GWmBscpla3hnkYGY=
X-Received: by 2002:a05:6808:1b0c:b0:4a4:744:a4ff with SMTP id 5614622812f47-4b30998976bmr18801430b6e.4.1787607089949;
        Mon, 24 Aug 2026 14:31:29 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:23::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b32c64a07bsm3949888b6e.4.2026.08.24.14.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 14:31:29 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>,
	Song Hu <husong@kylinos.cn>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	yunzhao@cloudflare.com
Subject: Re: [PATCH] mm: memcg: use ratelimited stats flush in obj_cgroup_may_zswap()
Date: Mon, 24 Aug 2026 14:31:25 -0700
Message-ID: <20260824213127.2783019-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAJnrk1bFq7J7K0=X67voeZVkAb0dmiLkqomuQ+VcXBLyP5hMVg@mail.gmail.com>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Thu, 20 Aug 2026 15:18:39 -0700 Joanne Koong <joannelkoong@gmail.com> wrote:

> On Tue, Aug 18, 2026 at 11:35 AM Yosry Ahmed <yosry@kernel.org> wrote:
> >
> > On Mon, Aug 17, 2026 at 6:53 PM Song Hu <husong@kylinos.cn> wrote:
> > >
> > >
> > >
> > > 在 2026/8/18 00:04, Shakeel Butt 写道:
> > > > On Mon, Aug 17, 2026 at 09:18:43PM +0800, Song Hu wrote:
> > > >> obj_cgroup_may_zswap() runs on every folio swapped out through
> > > >> zswap.  For each ancestor with a non-max zswap.max, it flushes the
> > > >> cgroup rstat hierarchy synchronously with force=true, which skips
> > > >> the ratelimit inside __mem_cgroup_flush_stats().  In a swap storm
> > > >> with zswap.max configured, a container takes the global rstat lock
> > > >> on every swapped-out folio.
> > > >
> > > > Any reason you are limiting zswap through zswap.max?
> > > >
> > >
> > > Mostly fairness on a shared pool: zswap.max_pool_percent is global
> > > only, so on a multi-tenant host one cgroup's cold anonymous memory
> > > can soak the pool and crowd out the others.  zswap.max is the only
> > > per-cgroup control over that share; memory.max bounds the total
> > > footprint, not the share of the pool.
> > >
> > > >>
> > > >> zswap_shrinker_count() had the same pattern and switched to
> > > >> mem_cgroup_flush_stats_ratelimited() in commit ea80da363a1f
> > > >> ("mm/zswap: use ratelimited stats flush in zswap_shrinker_count()"),
> > > >> where the same flush on the shrinker side showed up at 2.88% of
> > > >> kernel cycles under osq_lock on a 96-core machine.
> > > >>
> > > >> Measured on a KVM guest with a swap storm under a cgroup with
> > > >> zswap.max set: obj_cgroup_may_zswap() was entered 198,977 times
> > > >> before the patch and 198,968 times after, while
> > > >> __mem_cgroup_flush_stats() was entered 281,017 times before and
> > > >> 80,445 times after.  The removed 200,572 flushes match the store
> > > >> attempt count almost exactly; the remainder comes from other stats
> > > >> readers in the swap path.
> > > >
> > > > This is a known issue. Using ratelimited interface also comes with a drawback
> > > > that the kernel may react on stale information and the consequences might be
> > > > unneeded oom-kills.
> > > >
> > > > There was orthogonal discussion on moving zswap limit enforcement away from
> > > > rstat. Yosry, any updates on that?
> >
> > I am not actively looking into that, but Joanne was looking into
> > AFAICT. I will respond to the thread there and CC Song as well.
> >
> 
> For this zswap stat, I ran some benchmarks comparing 4 approaches
> (switchable behind a runtime knob [1]):
> a) rstat + forced flush       (baseline aka what the tree does today)
> b) rstat + ratelimited         (Song's proposal)
> c) hierarchical per-CPU   (Yosry's idea from [2])
> d) page counters              (following what all the other memcg limits do)

Hi Joanne,

I hope you are doing well! Thank you for running all these experiments.
I'm not biased in any direction but I was curious what you did for the
page counter implementation. The reason I am asking is because I am
working on making page counters more scalable / performant by pushing
the memcg stock down to the page counter level [3]. I wonder if the
caching that stock provides can give (d) an upper hand over (c).

This is just an idea though, and I think this would depend on how your
(d) implementation looks like.

Sorry that I joined in this conversation late : -(

Thanks again, Joanne!
Joshua

[3] https://lore.kernel.org/all/20260623180124.868655-1-joshua.hahnjy@gmail.com/
(It's been a while since v4, I got a little sidetracked working on the
tiered memcg series. I have a v5 ready to go, just waiting on some
running some tests before sending it out.)
