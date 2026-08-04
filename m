Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768072D7DC6
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 02:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785809832; cv=none; b=quRR+7AfCeb+fkVyT+Xw5HWG65yvaIkKsrART6E9UOVG01Kl19NvB9nVBfZjlgUy5KeDbwaM0HnPXu7v8ECOLxuS6tSNEz80We2RfLRoRzCnkwT9NlIa1scXMIig7zHfXvf5TKea0MvKIdz2GRWc3L8aJMexHLUe0syHJxXzWNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785809832; c=relaxed/simple;
	bh=kO7/CU1/RtwrDy8O6WI0itaSN6z2CSqn0cb6n8MGyQc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=BaADJ74tWHVZD3ETfaNA0+sqjEn0o1tqA029sruQbljwoIIdPRUj6tm9LEQMtGnP6Yza4RJ1QpP9A7lQdIXaCYJ96cgzICzM/p0E4NS7j38wF4mm5QKZd+RzDfup6ZDEtHF15C3UbY4VEd9EvUNzdNOTcx490ElJK4wNGY2H6O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=xFI1kUYG; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="xFI1kUYG"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7eb42a2f5feso2019880a34.1
        for <cgroups@vger.kernel.org>; Mon, 03 Aug 2026 19:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1785809829; x=1786414629; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zO4To4ruNthAnXc9BweyqU2kP7hjI3Ya2Rj1EPxSfNg=;
        b=xFI1kUYGfN5IozVtFnQ2111eZCSeGCT01naaiDsD8oXZskYN78anbjNUUcJUiWrwU+
         v92Kz+53b3n+jlcpxFJUCGP8mRedHcIorAmT+JVbQ9ZavIz3N85YbMFl7qGIbKp+RT2L
         ZzpCY5XzQN2M9n5sVbHZz76emmeHQDMty1OkgjDSL+1DHptTGl83eq4i+IpI4QIIJWEa
         heg14pEh2StHDhD2WgSC7Y3euXYyNMGnGd9YCFIZfmLBvGslGdGHWiMC3jK29K07+zEL
         eNJehkL9eL+anzNoQqOjM0//v212YV/taLw+pv0ashqE+RuTgRzPu7QQ4fABepb1it9A
         cdQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785809829; x=1786414629;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zO4To4ruNthAnXc9BweyqU2kP7hjI3Ya2Rj1EPxSfNg=;
        b=TR8rjEcbsAeaJ4szZddmmu+MrgF2d7nM0fNWRaMnfG1ind9/95mu7HJyZ/YI1jMIE6
         haIYejhDjJE9EFZjnHq3Lsnd7kUWa69aocvzWPbY4nL/27R4BhqHDV4nFg7kNt/qF+p9
         nBCTuat+/3nI2w4CY+gzcIkqNx8WYpb3hu9x3bwIVwfzJZ9hJqz49xNxfOVyqCWmENVV
         UEtCqS7Ie1HkPV8O9whEFvPkANAKuFvcMzT8BQ/GzFOM4wMFYB8XHo1PjCSvyLag2U7S
         v0fHLb7kMH6jVjz7U3serMU7NsvZQeiJLAAlkX19GAFqIGmmKSyIubZo5Y2Pcg+KLGtX
         ycMg==
X-Forwarded-Encrypted: i=1; AHgh+RqxncnAZP1Hg3NJyD1SgNm6lpe1GAxXkzi6Jndrdk+0dfkKqQTflxa4GefWa3D7A05qyDj7sKnx@vger.kernel.org
X-Gm-Message-State: AOJu0YxshVhmo3qNu997OMiZYeAs/M6YSwJJha8wIUcEjbYs8bZfsWGO
	h7i990X+X6zTT4kPsKHhQ7PfOFEBxhLXv07uWavPx1dm689t8rnt3zfll44pquyx5Mq5BOyZirw
	Nw912lCmhaw==
X-Gm-Gg: AR+sD11QlRZ/qsKRu9z3YRKGXShegdwa9IUqklFyhElQgCyjfAQ2j0nks316KE0gTLi
	2W0J95/BIu2wvIbcJVeRG4QSNoqPgO3Jb7gPZk8+s4khgmKn/ZB7nEFyqXlNF2x3p7QQ7fuFGGV
	i1vbDYvAEP4Da0jdzSQ78izk3fB7lAO3tiIv+tVI410pDTJFuuLDI5OuQ3U2Kk/Bz065LqtkT3F
	28n4JaDSohmw/BLRWu+SkBtwRkECPu5Q57c/1p6jvQ4dFZ4w1lq1q0ADrZe1Pm5wcTGVhYaewBl
	s5Y4pit2FL7up5GOoQWJR5gyCFpokaBuCdR9UxBupt/vTlrvdjv5hg1EKc9J9bBPLWtCbcjcKZU
	WOnVT5netXnFdhB1q+fynsvMOJnTII3bifr2EmxFSNI53x2dnNByRxenMjFJ9fzQPfPmXboSM52
	sra6x6mgmAvrJFerQhzYOuKaaFu7KkLk8aUUroRSu74FzBUb9FbrqSZgA0X+lQc5gDkbBizEasQ
	XI8amPv5uFcrHoAynEaPW93nmaJ6CrAnB+cusuxdQ==
X-Received: by 2002:a05:6830:440f:b0:7eb:3af8:8c03 with SMTP id 46e09a7af769-7f196f0d6ccmr20363818a34.11.1785809829046;
        Mon, 03 Aug 2026 19:17:09 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f18f07a55asm8914812a34.13.2026.08.03.19.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 19:17:08 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Tao Cui <cui.tao@linux.dev>
Cc: tj@kernel.org, josef@toxicpanda.com, yukuai@fygo.io, 
 cgroups@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
In-Reply-To: <20260803133400.137906-1-cui.tao@linux.dev>
References: <20260803133400.137906-1-cui.tao@linux.dev>
Subject: Re: [PATCH v2] block/blk-cgroup-rwstat: use data_race() for online
 test
Message-Id: <178580982757.518281.5036620938854770535.b4-ty@b4>
Date: Mon, 03 Aug 2026 20:17:07 -0600
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Mon, 03 Aug 2026 21:34:00 +0800, Tao Cui wrote:
> blkg_rwstat_recursive_sum() reads pos_blkg->online without the queue
> lock that its doc comment requires, since blkcg_print_blkgs() stopped
> holding it in 56cc24f59c14.  Concurrent blkg_create/destroy flips
> ->online, tripping KCSAN.  The race is harmless (RCU-protected, stale
> online only causes minor stat noise).  Use data_race() to annotate
> the intentional lockless read.
> 
> [...]

Applied, thanks!

[1/1] block/blk-cgroup-rwstat: use data_race() for online test
      (no commit info)

Best regards,
-- 
Jens Axboe



