Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793239506;
	b=AzfONpV+5TijouVloUPgPnNWazrFcVzWqnX9fLwjtza7QYHXe7/ykqokvOXMiBbR8rUr
	 1s9wAtfPxmrbOxHHbWKHp68xEGNeFdni0zk0Ib8pdlGCvRuLI3pJUBhvNrT+KiX4dBFyX
	 pJx6Xc8F1b5cUfzSaZshpshCEOO9VlD2LYsApWDb16CNk7Ur7MqgIz00t1sk58iVd8AXV
	 KboxEYDb9oMOICT3IJu4W0TWHUbChDNStPE4rP8nM7nRCy70jDr12B3L2sdmELrERe1fx
	 gnLUAlUnoCbcBBwbx6CS+tuv1a2dzTADpUUk9ez30dXR1XOn5INabFwzUtumedmtSWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793239506;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rK99wOe5YgzPR+1j3EODIxuynwC2Z4XRQXrPwpcj2BU=;
	b=I6lrt1YTu/kBkh6kjmY7vIpLYQY3DSpvaYoBkzaNwwPZzqDmaCYLJl16N42hpQI4d/AI
	 TW6tz9BOFirsmcre+QYbEeyZmQYHYL9KNxL91CaLUWYAl8Hh/Y0i8pMWOV+WJoB3/lA60
	 VJ/j+PXQjzyD4jARWc/XEthoahLKWrrRN/obVRs+i6YLEHejR9PvIGQX5qeAvibaNY0fz
	 Yf3aAeWX6XAWceoBS+H9ZAPDam/Z7W6LUCEx/PNuFrFV3EBSivxV43N23zT+gzmZBcRir
	 V3B0iBOOJclJAB0Tiz0R30d5alyIAaODvwFGMcjxJ8lZgW4jssvYoH7mFc+hutcZi7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=q34FXj52;
	arc=none smtp.remote-ip=209.85.214.180
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE93606A31C
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 02:05:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7DE93606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=q34FXj52
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2e99b1e5b4cso10573175ad.0
        for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 19:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793239506; x=1793844306; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rK99wOe5YgzPR+1j3EODIxuynwC2Z4XRQXrPwpcj2BU=;
        b=q34FXj52+FMW5ERh61n8jdeyaSUvxeJ2Gii7cZfzYmcczYbLwcRQx34TwxQflDVIGd
         o23JqHDm6sQ9V36qbaXt+jbYX5afy0u/uQvzOWk0gyieIobG7T4d3+SXeb/1y9xbh3vV
         xWMGLEHpjdkv9ApfLhnW2rTrBTWKaZac2GKXHkOYOD16h40pt9BhLSgPaKz/n0gWWt1n
         2cI8fQMyWRfD9ZMpeqKhsJ34BcFInz5M1ujzi6wqwCeQwED/aXAHHhvbWBEbbXbSzfN1
         wDRejzF+bB0MkKEtEEAgylLcMhuWtW+rq4B2nQ2M6FFVPmfLvKrkeOk6592/YZlRyaDf
         f+qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793239506; x=1793844306;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rK99wOe5YgzPR+1j3EODIxuynwC2Z4XRQXrPwpcj2BU=;
        b=bax5Rb8X9bCjAZYGdiu7GawsN8Lwov6uvhUJ5HuC0llMgu02Znz+pWETBYim12AO42
         TaexgWmyBSaBPSVLzAG9qO+pz3RWKu97+65DqSDpyzxndY4g8Sa9YxPn+OQQmzXdzAJ0
         q7A4Hs0+NLcIFK62jUFwvlW3TEwc1PHtHdbhhdVFI3cYSsOnUikPvpII03PEq3eFq01W
         eN8/vOcnp13eGeGHOTzTuzlKyxIdnnziiHxrqQBPw/tdibUr3kfb2WbNmalBvBZVHSjs
         yqHS2jL1Ps8y/4lU6uBjXQoSdQzNYWndrgq+o2P1UPRootqD5w5s5wDjIi/6QhEf03oW
         Xpmw==
X-Forwarded-Encrypted: i=1; AKwUvBwjFg6othjya+cXaK2pP/ABc+Bq5Wldc1gHA2nVUwM2OT58c3WG9cnaQrKwNNgwp4I4ADUYjzIL@vger.kernel.org
X-Gm-Message-State: AFq9FYJ2NqorRBWUGglpErRqw0WZ+6Fn0oCPUWT5akpC6wNU6n1a2t9z
	TK4qtMTjW+ooL47xgGouM9MPxfeFJU/iUv+HliRB49tqXsQkuiXUXeR+
X-Gm-Gg: AYBFou3xsZQbtHcq4BSpvCw6GoM3haN6JN32h4+hyHQ3aPGV+Gq3VzHOky/Hfqh/3Wp
	eNcO7GyCCGZ3KNj4P2iznV4eFNIXnp+PtY076M6VBWAjPluRbFZMRF7WG7YvK6phBE3X00Q8vul
	nKQ13MmXwAhiviKgHGeqTtpNDdArs6M4YLON6jf3fxUZC0U6I1LkEyKt22aza/bG/JjREmeaUV7
	Ma3G14Wd4gJ1GU8zS2xrYozsoKq1J1YOz9BlMHkEiD1N776S4KXbO/GvdzSU1PxWPUvfBPKs03m
	KCVJMD3Po3KsJaHWZQR60oA4VvGmbFU5CqJY1QgLuPjbOY3j1kcwbVtTlzqI+5nNzUCnEQ58l/4
	8mJNEZvhCkfUx+SCE33PK4OhX8qher36KUnFxserRz/VkprPUggDe+Kw9d2+1CWXWqlDzRYkHOE
	+4CzkEU7Qg/5Uvo5e5n9daCioxPuvKHnCYrZ4n/ocgfxRQnYBUrV+QUsXphhLyjh7cvEkT3ZsBi
	Y9Ye+dhQGq7fWEh7uow7sKqZJ0dm1rvBuriUCxyfSC2RGEGNIoo3Vlc9RvGr2+5akElFpWKiqiK
	N/LEOCMoeAzkoFRD25txN0h++7b3aTzyvteoPqvwvrqi6Ys=
X-Received: by 2002:a17:90b:574b:b0:3ab:be66:ddc7 with SMTP id 98e67ed59e1d1-3ae580a82f3mr3038446a91.10.1793239505712;
        Wed, 28 Oct 2026 19:05:05 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae55d1650csm2351887a91.1.2026.10.28.19.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 19:05:05 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	penguin-kernel@I-love.SAKURA.ne.jp,
	tj@kernel.org,
	mkoutny@suse.com,
	cui.tao@linux.dev,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com
Subject: Re: [PATCH v2] mm: memcontrol: don't miss processes whose leader has exited in OOM scans
Date: Thu, 29 Oct 2026 10:04:59 +0800
Message-ID: <20261029020459.3335597-1-zhanxusheng1024@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-188003@kernel.org>
References: <sashiko-outbox-188003@kernel.org>
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

On Wed, Oct 28, 2026 at 02:40:35PM +0000, sashiko-bot@kernel.org wrote:
> - [High] mm: memcontrol: missing CSS_TASK_ITER_WITH_DEAD in mem_cgroup_scan_tasks()

css_task_iter_advance() drops PF_EXITING tasks with !signal->live before
it looks at CSS_TASK_ITER_PROCS, so the current code doesn't see such a
victim either.  The patch keeps that.  The changelog's "until it is
gone" should read "while signal->live is non-zero"; I'll fix it if there
is a v3.

> - [Medium] mm: memcontrol: mem_cgroup_scan_skip() exposes left-behind exiting threads

That needs every remaining thread to be past exit_signals() while
signal->live is still non-zero; once it drops to zero the iterator hides
the left-behind thread too.  Without the patch, the left-behind leader
exposes the moved process to the source memcg's scans until then.

Thanks,
Zhan Xusheng
