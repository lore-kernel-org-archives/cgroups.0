Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD29442FB2;
	Tue,  1 Sep 2026 03:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788234759; cv=none; b=FdDFQ1bO+R9stvud5NWy3BazCvXMZuCbdVf7u1PmAKkNtNgAMyz/toQzv0RbAYy3tcjHy6kFRHZDXymeCvntieJwypA92Tj5bWO3qRJj93yv2JQY+pSEnXnyu4T+TfgrfmQzHqE4rtZZItefuFM0UAGUX+9e4TVcDwXZgIwQkqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788234759; c=relaxed/simple;
	bh=M1fwBcWahtrW6WxtBkmdiPaKgXrstS0ffPFc+YZQzJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3mEIv4uDpkFVz4ZCTQZRsV5KjHWf96xqYpQemAR3bAu3b9ZNa4cfCn2kjCrHq2/XLwuv2tyFLKQFXgA5PPN3L9//LlOH1mgsSUAX4j+xrqO4idcms34oCc9wN7h/V5tEqElXQ/n5WFrakGTgl5bUSd6PWShLnyONYIAY2iRDe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=caQ3PEZ1; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="caQ3PEZ1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=M1
	fwBcWahtrW6WxtBkmdiPaKgXrstS0ffPFc+YZQzJw=; b=caQ3PEZ1CliEfACmfo
	EU9q83uZ2s3BmOSfDqsrX/ALaJDxfH48Ourqv5vqkWShqlOzoaEYD3m2Xx0IbbP1
	INOyRQnS4pMVQ0GA5MuGn7/z6pP6F60g4Lp3Hg4z1ksroAvo9Y5WMRE+SR61QJHl
	HMwrZnnI0eLbKgjfTfM3wblJA=
Received: from sky.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgDnFJTIS5ZqHnYLOA--.32379S2;
	Tue, 01 Sep 2026 11:51:37 +0800 (CST)
From: Junnan Zhang <zhangjn_dev@163.com>
To: ridong.chen@linux.dev
Cc: cgroups@vger.kernel.org,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	mkoutny@suse.com,
	sunshx@chinatelecom.cn,
	tj@kernel.org,
	zhangjn11@chinatelecom.cn,
	zhangjn_dev@163.com
Subject: Re: [PATCH v3] cgroup: avoid flushing global workqueue in cgroup1_pidlist_destroy_all
Date: Tue,  1 Sep 2026 11:51:35 +0800
Message-ID: <20260901035135.42145-1-zhangjn_dev@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <6322b8b3-fcf2-4052-979d-439f458d31bb@linux.dev>
References: <6322b8b3-fcf2-4052-979d-439f458d31bb@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgDnFJTIS5ZqHnYLOA--.32379S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrurWfKF1fXFy3GrW8Cw48Zwb_yoWDuFX_Cr
	ZFk34Dt3y8Gr4Igr4UKFn5ArZrGw4xAryUt3yrJa92gryrGFsxJF4q9r93X3yxWay8JrZx
	Wr1Sqay3uw1DGjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7VUj-J5UUUUUU==
X-CM-SenderInfo: x2kd0wxmqbvvry6rljoofrz/xtbCxglF2mqWS8nOxwAA3n

Hi Ridong,

> Shouldn't we first figure out why flush_workqueue() waited 120s? Was
> it because there were too many pids, or because someone held
> pidlist_mutex for too long?

That's the same question Michal raised; please see my reply to him in
this thread for the full analysis. The short version: it's neither a
single long mutex holder nor oversized pidlists per se -- the wait is
backlog x per-work latency. flush_workqueue() waits for every work
already queued on the shared wq, which drains serially
(WQ_PERCPU, max_active=1). Container churn keeps queueing destroy
works, and each work must take the owner's pidlist_mutex behind
readers whose pidlist_array_load() runs entirely under that mutex.
A few thousand queued works each delayed by tens of ms is enough to
exceed 120s.

Unfortunately the guest memory dump captured at the incident couldn't
be analyzed with crash, so exact queue depths aren't available; I've
offered to build a synthetic reproducer with measured latency data if
that's needed to move this forward.

Thanks,
Junnan

