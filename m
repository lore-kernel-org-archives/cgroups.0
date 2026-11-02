Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793619637;
	b=a/RsotudmtQmAJdd0BM2Uor7Y4jqPOLIQQPjBxAZy6Zgry7oC+W/7m3UUMavV3oQDK79
	 +ic9EfexpmEGPwEcer5wm0KxRdy2yDxQbEvFD+wAJHpGOphmUsKk3rFHBn4w2U6iRQAyz
	 0Q9swodgkA2+VQQbE4AxD4XIHyIgglOVkYG0Ad0nPbO2wt2YKDpSz+QYQM9NFJFqo5X7f
	 VscxsIt+fxUn2SL0Z8DgZDAsoUSRjOcz8bd8SY1AuUqkT1aeP18lCio3ijlIvDIsnwtmW
	 6gh9WCLVC0+aHoTlDASwJjq88crVWGP9n9k0xpQGrA2yK2qqSsZpiGMU/2vBY+eVHAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793619637;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5smmWE+vGhxqhwgGmPR4F8hVHSCwizeNx+PLtfEMP9Q=;
	b=mjHAYPOVH6Xiak6LIy1qMCURkIXliFROFW/sfRIkXfV5sdP7VB2z2y5xAEG2Jrb4Ip2m
	 J8A6U66TLWc+wU65TYDScEIkxEY0dZsTn2DqRxvB5hmlFy7fY46H+oUH9UqfmXmkFboUl
	 n3TO42V2wBBr27oEy7a23z9XBYt/d5wcRrqGRVD96xOcL78A4De5VLuJ8AC2wIx06Jmuu
	 XpPiT90J+KrchRcEKb5Lgq9QbU0qnmjfQ0Mpyghg6oZBU8xQKYuy3SVw0RwQTjN+v4CXU
	 SGeJPEARp2okvvcDBiCmalK30OGbFSQ+PPEwQXdnXICnX0MLqRAt84/nwEF3Fsbjrnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iYrOIihm;
	arc=none smtp.remote-ip=209.85.214.174
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E392260A381B
	for <cgroups@vger.kernel.org>; Mon,  2 Nov 2026 11:40:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E392260A381B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iYrOIihm
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2e8da6ef7ddso16236285ad.3
        for <cgroups@vger.kernel.org>; Mon, 02 Nov 2026 03:40:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793619636; x=1794224436; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5smmWE+vGhxqhwgGmPR4F8hVHSCwizeNx+PLtfEMP9Q=;
        b=iYrOIihmmWOs9SPq4jDKL7HzWHnQCHPuGaIb0AnxDCuAklvQaLIIdwSPfsKbbLikb4
         iVpn1+fae3ccR9Ipe6bW/9aLIbIAV1/jxX5cZRlpT/OT1n/2vZEzNI3ppnTtRdxgqLhT
         NA/IT5jr6Oq3330YAtpTQX8g1euRnlTjJdNUaylITRB8ks9tEzV7IxNqhDng7LF9koWg
         OQ3PhiXWzo38nvLiyO+vUT4vSxLK0anAJko1IRxKv4Ii9vFTmExTZ8jflVfce2kSYyFE
         TCHxubALTrvkXc2hBpFpsG3pIezMuTYBbNMNi9ImFe9wHtMPHKvKQdH+Jq7UteApQJpl
         vErA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793619636; x=1794224436;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5smmWE+vGhxqhwgGmPR4F8hVHSCwizeNx+PLtfEMP9Q=;
        b=MsyjlcryMa3skaViYAf+74kvDJrV1Nh1wpH8FknQUpoVPALBaC4B4t1BoQ3TAeHYSR
         g4gF7vHODgQO927N28bcqCF4gFdFGwUiYYT8JC8HBuEAIqfQTotuCusE7Onjfb6B3TWN
         pKOYM8q1mX++or8naD5smX/FRo3/HUZkBLk6WicxqkX6y5qdoEHXBeJxpPjxB2nEN1LD
         tGesssZV8JxIzYNJtQYrqKm2Iijh+p9Wtr2BwLz/BcEXY25/bfLXiim9XXdQuO6yCKym
         jQID1lkaQA2Juw8dL7E89EB97u4fZEGb/g7pfUQc3SXjK/3f5PECH5y2K78a1B0+UDKr
         JiPQ==
X-Forwarded-Encrypted: i=1; AKwUvByPrdaLV8+sYLSmVcPBuwiDfRDBxdd0YG1JyfqXTWkqJt4PLBt5Xusvh3k8kK5dHf3/RG+pbJtC@vger.kernel.org
X-Gm-Message-State: APuU4Z+Bbkc8w1p9+8Nu9BxignZ3KffKmOpzJBaokCJZ9kSZnG5hu7rh
	/JizVezijdNPuS5FrJXimlFqD4K9q3BGDVF3qzHy8HeHJgNVA4Tn66OobAXo88JA
X-Gm-Gg: AYBFou31uux6O/NoL1Vsts8JsXSqFLHDvxtIKWRvkVhfzIdgQphsnzBJODS8dsITZ9B
	7bZIZTXqqRBBvMvLL5gtikLROA21HOu6ZNvkcNv8jxiCr/JAbtZ+F2crucI7YaBHsI1v4iNb9WX
	cKwa39zMfPxFPgtoixuIOL869xYUDGnCo85BbCYuNmPCCIK6yIeI+XvBVjRiVmMb6Sew+KbKOOi
	mbNvpcBDGmwP7FrgxjDEh7xISnMMLr0Ui9ijaCR1xGhvaO7uQdbxjnFSQ2uNgAS1dlVC9f6uZEW
	Xj19N+uE/aHxDMIq5JKURpfw/6wdwndqYLkoBSCeTzpHFG9Cwe7wfERDe2ZvGT9vatE16MT6b0e
	j3fYjFnypyGfqHKtmEd4UpW1m5rA9gBdLO/EWXjtd2sq83GjAH9dzTCJ2mFzZjiiBE/yflNS/e8
	IClzFhu7mztKSyy/UDJJFe3ibwt/dGp/L7fSaoow1qZWNoNx/J9em6TxeV1o6LwlplencQ4vPwC
	wQTZJur4uNPW4ziYxzkjIPaNqCF15gA3/CwAK3uydhODPbJyL+7aTNV/J7jKUFnb4ogOgxM9ejM
	h3b3VcY+TmQbe0EDArzba/4Ozd63eUBkc/hn0+U68ieZCJKa839ziw8riB9fEaAUfoBa
X-Received: by 2002:a17:902:f607:b0:2e9:a090:dd69 with SMTP id d9443c01a7336-2eb3646e967mr97761995ad.39.1793619636155;
        Mon, 02 Nov 2026 03:40:36 -0800 (PST)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eb39262c47sm26652745ad.38.2026.11.02.03.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 03:40:35 -0800 (PST)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: mhocko@suse.com
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	penguin-kernel@i-love.sakura.ne.jp,
	tj@kernel.org,
	mkoutny@suse.com,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	zhanxusheng@xiaomi.com
Subject: Re: [PATCH] mm: memcontrol: don't miss processes whose leader has exited in OOM scans
Date: Mon,  2 Nov 2026 19:40:29 +0800
Message-ID: <20261102114029.1259655-1-zhanxusheng1024@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <auhiGqKJeukk7t3P@tiehlicka>
References: <auhiGqKJeukk7t3P@tiehlicka>
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

Hi Michal,

This is v1. v2 [1] reworked the check, but your questions apply to
both.

On Mon, Nov 02, 2026 at 11:12:42AM +0100, Michal Hocko wrote:
> Is this a desirable/intended behavior? Shouldn't we move the dead leader
> along with the rest?

Userspace sees it too. After writing the PID of such a process to
dst/cgroup.procs:

  src: cgroup.procs = 85       cgroup.threads = (empty)
  dst: cgroup.procs = (empty)  cgroup.threads = 86 87

Moving the leader would fix that, and memcg would then need no change,
as the PROCS walk already returns a dying leader with live threads.
The catch is that the leader has already gone through
cgroup_task_dead() and is still accounted by controllers: pids, for
one, uncharges it through task_css() when it is reaped, so the move
would also have to transfer its pids charge. Tejun, would that be
acceptable in the core?

> Should CSS_TASK_ITER_PROCS iteration see all processes
> regardless leader being alive after or prior the migration?

With the leader moved, it would. Otherwise PROCS would have to pick a
stand-in thread, which is what this patch does inside memcg.

> Shouldn't this be CSS_TASK_ITER_THREADED instead of 0?

No. Walking a memcg css goes over e_csets[memory], which already
includes the csets of threaded descendants, as memory is not a
threaded controller. THREADED also walks each cset's threaded_csets,
so those would be visited twice. It is meant for walks over
cgrp->self, like cgroup.procs. 0 is also what this function used
before f168a9a54ec3.

[1] https://lore.kernel.org/all/20261027144016.2582880-1-zhanxusheng1024@gmail.com/

Thanks,
Zhan Xusheng
