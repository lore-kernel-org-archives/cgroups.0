Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912EF3BB135;
	Thu, 10 Sep 2026 06:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789021034; cv=none; b=STxpswzehNT8FBQQ3gc3tjOpaeyEafUngJZUtECikGSuhQ08LF62JE1fUzlMsytK6Mr53YBSLNGD9khu82UdhjwBHRcEx+CcdHBDr4Z6qlpBBkYmR8nZV0oDhua6IOTB7diGwHr5Z4JsgkBjpcvmBrNZsok5k8mu6v0RCmEmHT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789021034; c=relaxed/simple;
	bh=W5n1szKTlD2UUANHlXzPnHSKm2VVYA14OjCDAdDsGfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNXtGZKEua2DoiOyh6aX9r0ueg3mt9A+/zBxMQfFnyCh/WCaKhyHe6xd2HBTC59snT8HMSm5ZMfvKGOE5A67zKuptrnDKl4Qb+CWaoNywIG3q08YL4fMzwwaLwYBkvxQGeTWpPbGx0JdUMu4Wvl7qH3g9KHduHbd+UkZscJQu+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=MyEFahQy; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="MyEFahQy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=W5
	n1szKTlD2UUANHlXzPnHSKm2VVYA14OjCDAdDsGfo=; b=MyEFahQymaFAFSk6Zp
	ZXIFTwPjpqXBMJUriw7hN4naGzL4bh97QwEQaREyyJsRJqg5VJ6QnoznPJkg4ABU
	Mj/JpwWyNq/IjLWzZixhyV3lUWzxZXpfnmWUhCt7FV6wGsElqPjilCLaw5Q71Tj9
	n1AGYQ9wJRmtM/lDAzxEEgtd4=
Received: from sky.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wD3_5krS6JqpT+PBw--.37361S2;
	Thu, 10 Sep 2026 14:16:12 +0800 (CST)
From: Junnan Zhang <zhangjn_dev@163.com>
To: tj@kernel.org
Cc: cgroups@vger.kernel.org,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	mkoutny@suse.com,
	ridong.chen@linux.dev,
	sunshx@chinatelecom.cn,
	zhangjn_dev@163.com
Subject: Re: [PATCH v3] cgroup: avoid flushing global workqueue in cgroup1_pidlist_destroy_all
Date: Thu, 10 Sep 2026 14:16:10 +0800
Message-ID: <20260910061610.91209-1-zhangjn_dev@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <aqGsrY9Vj57CsVeb@slm.duckdns.org>
References: <aqGsrY9Vj57CsVeb@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3_5krS6JqpT+PBw--.37361S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjTRRc_aDUUUU
X-CM-SenderInfo: x2kd0wxmqbvvry6rljoofrz/xtbC7QwhtmqiSywFxQAA3Z

Hi Tejun,

Thanks for the clarification -- agreed that the 120s stall needs to
be convincingly attributed before this can count as a minimal fix.

I'll put together a reproducer that drives only cgroup churn plus
cgroup.procs readers on an otherwise idle machine, with measured
cgroup1_pidlist_destroy_all() latencies (and a lowered
hung_task_timeout_secs to catch actual splats), and report back with
the numbers. It'll take me a few days to set up.

Thanks,
Junnan

