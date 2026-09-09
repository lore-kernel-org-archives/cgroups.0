Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442B439A07E;
	Wed,  9 Sep 2026 08:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788943631; cv=none; b=lSKcLDXQhHxfWYPG987cxtLPfrn4ec97cEjSspD8AtA7MAhbdpO7foIEQqxjR1YgigimgjQCV3C2D+k5EyzXCHnBHJ9veWjvTLbfZ61EwW1ZFfUNSjyRIjZ/f1ndhd89tV2CE7FgDrWHiPYaq15B2S5amc9ZJewQRoew+iI2BZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788943631; c=relaxed/simple;
	bh=8D/Jrs3FJYLJaC+B4zEVEdw2IHnsrFplQX0t1gVYytk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=luc+dUqn41NgVak0PBSyokRLOkvUnSbCeDnj7Uzvii2ALg/fUIRmfKlgho60lRWONN1+eR4fG2OyLyWhCq9yTY7vptF3v2S9Pjp7WEQpEgkLw8tiHB4SMw8c8vAg780AIrowT2hzA6yW9NRnzIhzlTdhh43eLwvUAhVDFxACsuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=jvPxSGq+; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="jvPxSGq+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=8D
	/Jrs3FJYLJaC+B4zEVEdw2IHnsrFplQX0t1gVYytk=; b=jvPxSGq+7E+CiSUcLE
	RtA3tgFqamq1+PIGIWxS+o3CSi7apdeRfX2UqujYCAsFGFPZl25/U/lhk2rFa9gv
	W+Qg/2jhiNJcxAgW+m2be+Tg4Lkwmrqm+ztkgnuoyXq2hXKt3MjHnLpFY9qCXzNt
	2MPsRD/05lYmeHSgWt48kw0yo=
Received: from sky.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wDnmT7dHKFqcEd0Bg--.51566S2;
	Wed, 09 Sep 2026 16:46:21 +0800 (CST)
From: Junnan Zhang <zhangjn_dev@163.com>
To: zhangjn_dev@163.com,
	Tejun Heo <tj@kernel.org>
Cc: Michal Koutny <mkoutny@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Shouxin Sun <sunshx@chinatelecom.cn>
Subject: Re: [PATCH v3] cgroup: avoid flushing global workqueue in cgroup1_pidlist_destroy_all
Date: Wed,  9 Sep 2026 16:46:19 +0800
Message-ID: <20260909084619.91579-1-zhangjn_dev@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <aqA6x_8E3Xiewoso@slm.duckdns.org>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnmT7dHKFqcEd0Bg--.51566S2
X-Coremail-Antispam: 1Uf129KBjvdXoWruFyUWr1fCFy3Gry5Wr17Jrb_yoWDXwc_uw
	10vw4vkw4fKr4kurZ2gF98uan5WrWF9w1xZrWxJrW3t340yrs0vFs0ga4SvFn7Ka97JF98
	Gas0qF1akw12gjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7VUU3ku5UUUUU==
X-CM-SenderInfo: x2kd0wxmqbvvry6rljoofrz/xtbCxR1B1mqhHN126AAA3b

Hi Tejun, Michal,

> I'd rather not touch them at all and eventually retire the whole v1
> interface.

Understood, and I have no objection to Michal's approach as the
long-term direction -- routing v1 reads through css_task_iter removes
the pidlist machinery altogether, including the destroy workqueue
behind this hang.

May I ask for some guidance on the near term, though? cgroup v1 is
still the default on widely deployed enterprise distros and will
likely remain in production use for years to come, and this hung
task was observed on a production Kubernetes node. This patch (v3)
is a pure maintenance fix: it changes no user-visible behavior, adds
no interface, and is stable-backportable. It would also remain
relevant for the cgroup_v1_sorted=true path if Michal's change
lands.

Would you consider taking it as a minimal fix? Or, if the consensus
is to leave v1 completely untouched, what would be the recommended
course for production systems that keep hitting this?

Thanks,
Junnan

