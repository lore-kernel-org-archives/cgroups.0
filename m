Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697163126BC
	for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 15:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784561267; cv=none; b=sgXTkNd0UUBEeHP8FU229rbDqg1J8k8EwNPBbwqAZEniJfArdvLzKd4zV0APiKG+6ACr0nplLQU2/d3SjG6qEeHtZwND1f7S95w5IPdSy/T+1iGtnWY0AG1vI6puHIujCuOc5GKWBCm/sXYoEdeVNHhrTcs1DchBwz5gsDvoXLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784561267; c=relaxed/simple;
	bh=jYD4X/IrsAEK+5o07FPNmQBo3eSfFnC1skMmyy2L3Kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swcfXtFqQWHfA3KlKrTOYgr5alew88Hbry0CEx7Bn7itY46OsxlGCoxAWe1m6y0P1/wUDdpfcZOm/05zSnSXPLetkihxEjLhPiO+cB1QSdgw/8CQBzzrNNCqji5xrL/J1R48feVzJkxZZWqBTFfhnOR8hJ0OE9UYx5y3K684ryQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j8K5AavC; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j8K5AavC"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7eb64371a2aso4237266a34.0
        for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 08:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784561265; x=1785166065; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aJk23rYw9MlC3iHPJIfHt0WgssN79WwPx4RPlijn9kg=;
        b=j8K5AavC6I44diIfapvexdoHkP4f/22kWNLAMc8yyyIfzfuG9t0q6G0KanA8ARxazx
         NLjGsjbar8Z31z8lSRMdULpUmr8b3zJPxauHKWpTmvSv2SAt9AGMhSh9Ylc3jlL6jGyf
         7oPuu35n0F3IETkWlzDIa6waFvFqgLP3d7o9sD9bhaO+OhwOgzlRcXKI5Zj3Ydzw7fwZ
         uAI7sS0/AwfY1N7QeYJYw5f8YhUHkEHDNt+uQGrJ8YftyfXwnYoGOU9qL96tKsXLQTCy
         2h3hYTwNhYu8rgtJrBVT4Ba8Wvaj5hYCpFpg5coNIMDCoIqtS9KuhsLoVdFmPrjzOGRH
         FsZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784561265; x=1785166065;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aJk23rYw9MlC3iHPJIfHt0WgssN79WwPx4RPlijn9kg=;
        b=G/YTob9Eq/ZrmKpOtuXlkKnLbfoJWIrQUHFmLZdJQgyf/9VAGzPNcva3wCI0AelvnH
         HL5bPmkbS5KwZFYLPU1EN4ZiR847DVwcV0uyjTgwFX6bhY6sH/zDIS+9Ua0Q51HOGKIr
         movcZF6SlqRiNES5ccLsqV80XryrwyZwF8uezhcFfeiVMvedPMJVGz9SS7guakgs/5DH
         DoW1srStsWR105dwVVxBnMo4KvdLDxwmxhnnOValLBzoolbaCL8vgJDFZE5VVdOA9WAW
         nV+mmIG+C5/myRPuvx0bv8L30h4VI6Y5KFVrkaVXuoPMvGNEGzejbem1O1vUiU7ehbwG
         BA/A==
X-Forwarded-Encrypted: i=1; AHgh+RqZbRZ7fXtOWsd8eokGZolSwB+v7mxkm3yJz3uCkQrESgq5kQLiSEeobnMI/6VKMN0xlUlwH7Dd@vger.kernel.org
X-Gm-Message-State: AOJu0YzXGGt9oTSA0JfW62iqT53YF4hDZ91Qw8WYEb2bJRSd6eoZh3l7
	9ecKjIf9EjyGaBC8/8S4tXeWFvMdirpIrKheWmoQ+vbSpt8cpJngTQRQ
X-Gm-Gg: AfdE7clZPFE+l/jy9Zt23CYuV36YcIi9ZHzgBPt+hJJ832c2DKOb22Q4VK61kYHtgKk
	RYKRE5Lgu37Ml6rwr2BfG2NYkcFqHiYh0jLdDXBpZsINOGn87ulOrWgkb7bt/DMPk/c9juDTL1b
	dqfVuPmWjDAyYikF9GdiB7kHNe+528IOjNu/QkA9rMpNgxC+cPKfZmCPFXNP7EwP29eeb4lNoPn
	xiYxulpS4EBp54jk60iv2CL3OPMmWq9yrgcsDdaCNlVnZuWAnbDZ5Z8nnDXYTClJyF4mO1J5LqQ
	sQi1Qt4yPZmaXHMZAbI+v3FK+zlxY6CQ+O86Sp92A+dYdVvgsnCIlXlYq0W7O7ozaDukF0L1lTG
	znx9cn3c3yBsClk7/Vz2SAhPvt8DmLLfsBgR4h3pstpIz6G5O2joLVZHZ3Ua5etzWaycOxOB8uG
	Z6735iDpz4VnhceA0tnVz+rBRrGZntoGL7
X-Received: by 2002:a05:6808:180a:b0:495:f79d:8bd0 with SMTP id 5614622812f47-4a4d052058fmr8052656b6e.25.1784561265039;
        Mon, 20 Jul 2026 08:27:45 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:73::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4a4d3aade16sm7517236b6e.7.2026.07.20.08.27.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 08:27:42 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Tao Cui <cui.tao@linux.dev>,
	cgroups@vger.kernel.org,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cuitao@kylinos.cn
Subject: Re: [PATCH] cgroup/cpu: document cpu.stat nice_usec and core_sched.force_idle_usec
Date: Mon, 20 Jul 2026 08:27:40 -0700
Message-ID: <20260720152741.1226695-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <al45RUAYKgGt5IYS@localhost.localdomain>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> On Mon, Jul 20, 2026 at 08:02:26AM -0700, Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> > I have to ask, which tree is this based on? I can't seem to find a single
> > tree that contains the "(including those in descendant cgroups)" section
> > anywhere. 
> 
> It is most likely linux-next which contains a nearby modification from
> [1] (or it was based on that regardless).

Hello Michal,

Thank you, I must have missed linux-next in my searching... that makes
a lot of sense! With that, Tao, please feel free to add my review tag:

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Thanks, have a great day!
Joshua

> HTH,
> Michal
> 
> [1] https://lore.kernel.org/lkml/20260629060636.200118-1-sunshaojie@kylinos.cn/
