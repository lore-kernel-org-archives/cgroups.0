Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9FA306B3D;
	Tue,  1 Sep 2026 03:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788234537; cv=none; b=DbUes/5lKWNiumuOBtNVwXmJr9wzhN+UTVDl4ly7CmIxISMdBQ0TRjln02nNz8sU0/0MK2p9LM93VY+TH2u7JQerAQHe2iwhbEkSjCVGQjldOKP3810M/uQIj+BrULUjAidYIzO0j7O9ZI6kcvBSdGbb/VQHTuhuXUyxDV0Rb0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788234537; c=relaxed/simple;
	bh=M1fwBcWahtrW6WxtBkmdiPaKgXrstS0ffPFc+YZQzJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DTgDIJwHiqENw2BeAlU5+q2tPC8wzwj6g1+F5rfvUPGemJHnx/ExdDTsVfN2JLhvWoqovy98S32dAIYwf03jV0ejt6WYEax0DvckF2JX4WyaeG0ujcCIeZL/iYPHQiwSi9yjtKKxxppMONs/9ZgQijLXNVBqNl+cZhZ2egZHvzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=VBr8Ic00; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="VBr8Ic00"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=M1
	fwBcWahtrW6WxtBkmdiPaKgXrstS0ffPFc+YZQzJw=; b=VBr8Ic00bAyyQ7Ywz8
	YTGoAqeYn9oy8l9t7gi8XzbezBKxeqpoywKmhEG+rWDzY2yDUWMHXm8YjvWlzDFE
	TKw0rCy6ZyY/DcDHujgIErrpO4PJ0Mg5AtbnMs8FM6LTnvo7Ncrn5Ou4/0ho1TL3
	5XenEyeF7DIWL452ipSj1lwGQ=
Received: from sky.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wBHZOn6SpZqngcxSg--.17773S2;
	Tue, 01 Sep 2026 11:48:10 +0800 (CST)
From: Junnan Zhang <zhangjn_dev@163.com>
To: zhangjn_dev@163.com,
	Ridong Chen <ridong.chen@linux.dev>
Cc: Michal Koutny <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shouxin Sun <sunshx@chinatelecom.cn>
Subject: Re: [PATCH v3] cgroup: avoid flushing global workqueue in cgroup1_pidlist_destroy_all
Date: Tue,  1 Sep 2026 11:48:09 +0800
Message-ID: <20260901034809.41778-1-zhangjn_dev@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <6322b8b3-fcf2-4052-979d-439f458d31bb@linux.dev>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBHZOn6SpZqngcxSg--.17773S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrurWfKF1fXFy3GrW8Cw48Zwb_yoWDuFX_Cr
	ZFk34Dt3y8Gr4Igr4UKFn5ArZrGw4xAryUt3yrJa92gryrGFsxJF4q9r93X3yxWay8JrZx
	Wr1Sqay3uw1DGjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7VUUqNt7UUUUU==
X-CM-SenderInfo: x2kd0wxmqbvvry6rljoofrz/xtbC7hoRpmqWSvq3bAAA3U

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

