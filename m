Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793281485;
	b=VUxh1O2YAGGdnCPLieaAZ8TEcrIZBrpT12iaNuZzf9xqydI0yOiczdb59/KfJmDQm6jm
	 vWOlc58kkFODrxnQUV8mj1MYPL2R/pppJaSqngB3LyIhqI7uR7K1lnQvqNXWItsRwybPz
	 UuyOT8e0WxW+JTDWzIt7l7w2onTorkgRw/hjeEnn6BQ9oNRHVmQ/jfrSVSfgsDcDzN8Ra
	 PFzXOf1ud3VnLjLCgpP1aHXa2xEMo47PgxTUwE8POq46p1BI2CgXOHOl/pID8YmYUJuEp
	 6I9g0PoDyiTo/7KhPTwo6/L/Bfb/rAaeu1EcxEIY6cFM47Y6VMr+7XoszrrtT2fhYEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793281485;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-Mailer;
	bh=r9Yjn03pj845I6dvouQuyeLdqWNVyS+hRwAp++oHECs=;
	b=o9t0EiJVkydCk8fHxUESHKmkmrIDEe2gGp4Wr5okiC7WaXk9o+m1i1xxtEwvkdksEFKU
	 umz+LtpiO2B45sNhPlwh9XVG/Xq4uo27VUUBfk/g0hwG5gl0gDku9dvVuj/C/+qgYtlHj
	 rtTnzbdgZcWASp88E/GbHLbKYAJEwTERrMiZ3u0tzv7rcaBNuH023qN/8vgB6cAvjPzRu
	 bGpYXrNQOBjuxVhmeGcuhzjSiXNtq5bRXMWGGmds0FYMeipepZySXs2mjCpbXtWadlKoM
	 fbexMobK97VUIdBhQeOh6jgHg2lksgYDfjdQlxl/rDLyYGHQnkK/rZmTlUN+Lbkhy8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kernel.dk;
	spf=pass smtp.mailfrom=kernel.dk;
	dkim=pass header.d=kernel-dk.20260707.gappssmtp.com header.i=@kernel-dk.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=t1jGd2wP;
	arc=none smtp.remote-ip=74.125.82.174
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602C8606A31A
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 13:44:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 602C8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel-dk.20260707.gappssmtp.com header.i=@kernel-dk.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=t1jGd2wP
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-36a18fc7a38so4296051eec.1
        for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 06:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20260707.gappssmtp.com; s=20260707; t=1793281483; x=1793886283; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r9Yjn03pj845I6dvouQuyeLdqWNVyS+hRwAp++oHECs=;
        b=t1jGd2wP7FlHqhzmTXGMAvuTeVcRzBygvgwkK6YYcGJy//C+hGySWO7TU8DaNDK4S8
         l0flg4KDDpWc8i4IhrrKvC4w+jUb14sMNyjEzTOr0DONkCQzbgK9+8BbKYuGiXXD+Aom
         iJzZhvniayMx5de3s22t6ZyFplh3tR5zb+VEVSKx8hd7VlKyuAFiK+05SA5+wOwbH3KR
         8+01y4WGIUcgwBDY+K5Xek0IFb2Ih32teGQ3smyx6oF2EKVhxectETtW9wNRfLuR53Jo
         wUnYUQyU6/kcrUMZYTwYR5LoTFkyk54tbOoCOzlPzm9a/gZmFWawqN2VXML4AFDfUxJp
         JQRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793281483; x=1793886283;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r9Yjn03pj845I6dvouQuyeLdqWNVyS+hRwAp++oHECs=;
        b=UNdl9CCgCsO99SO96wgEwd+FJNqVm8nTAuj04uuDqULjMTdzi4cRLSBVRJH2RJKI11
         ice77OsP4OlQZScl9UisaAfNaDBJxtiynPL9nocch6RaNOD7WFkigmS8vZrCy4qs1gRo
         cxThnv6OwQTB28P/Xg14m0EXa7qWg8x61QkN523FjYNhupg43LYbPWxw6OLOI5OlwmRn
         XZM3NIOMDET9swHu6x5teQYPljhnyvcktdCR9eF2USVVbDj10Nl4hjK9L9lcP5YiS2Zx
         PkV892GVHUBgrRR2pltDLxT2uoApgg82rW0kZyTYmwvw2iUAdQun07TqNzcBNqVdLgOY
         sdAw==
X-Forwarded-Encrypted: i=1; AKwUvBzRPWDVCj03Hx5+KlVQOnR8LTu/NDpz7YzmJEWLn8smn4KeA7OIxBmTlYeDV1RVuR2tnsal292V@vger.kernel.org
X-Gm-Message-State: AFq9FYL1Izt3EkDkR4EvVg3eSfpvpNz5e8+rn70oNuyyK/FbxALdcSmC
	/+S/xvOhpfpnz+UI3JyJfKQFg1GYCf7VZj/GDttb1u12hlLmRGYTq+2SZBlxJXz0Ojg=
X-Gm-Gg: AYBFou0JrH4xWuoUg6yvQKsfsGKSjzAgP7qZSUTUh9qk4RLHq9H8bCmYHgAILp7xdDR
	rKWiXbeSJaNeHALl56Q0d4+ZGbZvOMEJ39x+jqM036nm7fdtoeP1Esyv0J+/cb0pgoG0i+aeGXN
	xTL94/KGZQc6uAd6zu15tCT6FgyYMic0qZc4w0awy1GLm0+/WDJntysVE5SKxYtvaV+mRT0fQTZ
	jQVWD3NgX/GbQYyIsJOKZVPQ6GW2m45lwQHy1kaERyeLJEUn2wNLIqv98Hbboou/ZeiqQjWjIxC
	1zO9w1fRdaXfZNaeVaVD8r3SGPsmfatm5V3ocwGIU9O8CXBTZRq34/VRA6O2rYqo7maQseWcK7E
	/07Bzj80SI/iltaNZq0JVhhb8C55Jyas2UY6BoREPhgtYn66sIDkuPDk/GkyckltMllSGcMB8eA
	fZ6dYja1U6QhEv4Wt0/VZPzHie86WfYSqj7Nif1izJ6UyvXmSx+/UCZubDtsKzV0R3DCMnwMQPd
	o2wMlnPag30Q3Hgc69sW3/jdixqO6qoAI/+lkp7h39QL8p2aGVoMRD8jfEvR3si9536+fgWWi5U
	yzBt5Qf4nZRHh6E4YOkLfScqZOmWLcRZsewPma8UWEUJRYrST3rYx1JiEcU0Ng311sP+/t7/eLz
	/LJ0DZuUVdd3m
X-Received: by 2002:a05:693c:41d7:10b0:356:b370:a0ee with SMTP id 5a478bee46e88-36a2044d2a0mr7712963eec.20.1793281483283;
        Thu, 29 Oct 2026 06:44:43 -0700 (PDT)
Received: from [192.168.1.106] ([198.8.77.135])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a2390929asm21976894eec.12.2026.10.29.06.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 06:44:41 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: tj@kernel.org, Kunhai Dai <daikunhai@didiglobal.com>
Cc: josef@toxicpanda.com, yukuai@fygo.io, cui.tao@linux.dev, 
 cgroups@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, rostedt@goodmis.org, mhiramat@kernel.org, 
 mathieu.desnoyers@efficios.com, linux-trace-kernel@vger.kernel.org
In-Reply-To: <20261019125412.3123895-1-daikunhai@didiglobal.com>
References: <20261019125412.3123895-1-daikunhai@didiglobal.com>
Subject: Re: [PATCH v2 0/2] blk-iocost: fix hweight cache publication and
 donation fail-safe
Message-Id: <179328148122.1447413.1375912231299331612.b4-ty@b4>
Date: Thu, 29 Oct 2026 07:44:41 -0600
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Mon, 19 Oct 2026 08:54:10 -0400, Kunhai Dai wrote:
> This series fixes the blk-iocost hweight cache publication race and adds a
> fail-safe for invalid donation weights.
> 
> Previous version:
>   https://lists.openwall.net/linux-kernel/2026/10/15/1954
> Replies:
>   https://lists.openwall.net/linux-kernel/2026/10/16/1431
>   https://lists.openwall.net/linux-kernel/2026/10/16/2798
> 
> [...]

Applied, thanks!

[1/2] blk-iocost: abort weight transfer on invalid donation weights
      commit: c810ee88cdab27f443c32270dc7c0eaad2cca3f8
[2/2] blk-iocost: publish hweights as one atomic value
      commit: 0150554a3f38e1850d5964102eb89a720c5fe789

Best regards,
-- 
Jens Axboe



