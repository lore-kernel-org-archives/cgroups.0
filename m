Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5060D2D0C7E;
	Tue, 18 Aug 2026 01:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787017320; cv=none; b=fesuXuMi0Oab22nKNToIL4y0oSuBLSz5+Ec4s1cuLkFY9dSPZu6PAwkMGwcsioOrntNXmqQc54OQYRfVZnD6H9x2b/FSUtuHN4jPrHKVdCQxa1EQ54fZZ3nS5bX4PY+XiHu+uxRMu5uZ9tUQY3E03+LBw2lRoJo7J//N1ndnL9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787017320; c=relaxed/simple;
	bh=v2fauqke2SQrmkXTrhfLHGLNXgRlfN8UIwbLfSyh9uI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nqd/73DNNJK2tDEjoMcy77kKWNc08fZPKFlspN6+ZbngZgIAMZxF5rR69f+7sUHXrIQrn71hcCdgRYbuxg/YIkAOy86fX3UyrJ0tQorVsFN0glAKLB7z7nQysooHL//tE0ie+KSo7/BK2JOFw7Bdvf/VHV84tmA8krnkeof/MZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=xiaomi.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=A01H37QD; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=xiaomi.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="A01H37QD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=mV
	d1wQKoqHI28CRDRlJL1+LVPbYT19FBeIKKZuHT1zU=; b=A01H37QDBAkloONm1F
	9JkR4Nia6hbpav299jFElRThfUApXovf7dK8hZobSOXeuB3KgTEbavuhGYhmf4Ua
	yHSNdfo4cEDfkXUTjrLrunEm0POI0GbmHhOsPi9kEoDU4aVXl3gDsZ4OSwU26UJd
	uC7gAkAGuA9fIV7g0f61Xh3So=
Received: from localhost (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgCXUo4SuINqCOZDLA--.5364S3;
	Tue, 18 Aug 2026 09:40:35 +0800 (CST)
From: chenxin <chenxinxin@xiaomi.com>
To: sashal@kernel.org
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	cgroups@vger.kernel.org,
	chenxinxin@xiaomi.com,
	david@kernel.org,
	david@redhat.com,
	gregkh@linuxfoundation.org,
	hannes@cmpxchg.org,
	hughd@google.com,
	jose.fernandez@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mambaxin@163.com,
	mhocko@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	shakeelb@google.com,
	stable@vger.kernel.org,
	syzbot+e12bd9ca48157add237a@syzkaller.appspotmail.com,
	v-songbaohua@oppo.com
Subject: Re: [PATCH] mm: swap_cgroup: fix NULL deref in lookup_swap_cgroup_id on swapless host
Date: Tue, 18 Aug 2026 09:40:34 +0800
Message-ID: <20260818014034.2632872-1-chenxinxin@xiaomi.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260817150000.4@kernel.org>
References: <20260817150000.4@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgCXUo4SuINqCOZDLA--.5364S3
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jw1UKr1DuF1DKFyDCFWUtwb_yoWDXrc_u3
	9Ivrn29w1rCa1kAFWxKr90krW7KrW8W3yUArW8urnFgryrWF13XFsFgrn3Zw1kt395Xr1D
	C3sYqayrur1ftjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU1DUU5UUUUU==
Sender: mambaxin@163.com
X-CM-SenderInfo: xpdputx0lqqiywtou0bp/xtbCwhOtt2qDuBPmUgAA39

> > Yes, we would like to backport this patch to the 6.6.y stable tree.
> > We have encountered the same issue on a product running the Android GKI 6.6 kernel.
>
> This is not a 6.6.y fix. The NULL deref is only reachable through the
> batching added by bea67dcc5eea ("mm: attempt to batch free swap entries
> for zap_pte_range()"), which is v6.12 and newer. 6.6.y has no
> swap_pte_batch() at all, so the exit_mmap -> zap_pte_range ->
> lookup_swap_cgroup_id path you are hitting does not exist there and the
> guard would be dead code.
> 
> Your oops is on Android GKI 6.6, which carries the batching backport
> downstream - that is the tree that should carry this fix, alongside the
> commit that makes it reachable.
> 
> -- 
> Thanks,
> Sasha

Thanks a lot for clarifying, as you noted, this commit was backported
to GKI 6.6 by Google, which is what makes the NULL deref reachable there.
I'll follow up with Google to get the fix backported onto the GKI kernel.

Thanks again for your help.

--
Thanks,
Chenxin

