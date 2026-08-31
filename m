Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2297D3BED18;
	Mon, 31 Aug 2026 07:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788161979; cv=none; b=pR31wv2rZOWuZOzgrkcy6GtetzxBOyyGusEh/VvFjX7L6rLVw8TF58TGTKBvyCnginHpGUJostmZVatA1U4pFKqXy1AHkGhwFLZ6wKqKVpNvz7X3xGiuEdturnsasbeiKxL0bC5IhQC1tfMH8Aw0wZkuGluL30/wvHI1l+9rCfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788161979; c=relaxed/simple;
	bh=1SCbikh+VWbJrnsGtdICumH2cNfJrVnLK1XpeKkoSSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pF+NX4h6unC4RdiEXUY2YdbKTVMejrN64mY3CjbcT600ojCGu18M5oWV+8QelftkaYyV2r3wmagc/D9LLpb+tFyqIVdkvtN6x2jhFhKqwHR1k09Lo+svRgKwP93SqHS22x6WfI5Ip8OW3p840GJ3hHWguyjZC+BUES/zyYWaZ90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=RWF9KmQA; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="RWF9KmQA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=1S
	Cbikh+VWbJrnsGtdICumH2cNfJrVnLK1XpeKkoSSc=; b=RWF9KmQAmqW8F/QJB5
	xUbPXW/G7axwI/zoxmD+QuYfVSmEs/GhPIALFFaYhQZCuw/rVozQPAXlshCD9tJo
	r4/qC839ao9RZcCTbCuoquS0VmNbrUResHj5S4wRl+KrQ8UCXuINqfn+qzjx83dn
	Qgk0BMRFwJQ4yE0e45KvsGBYk=
Received: from sky.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgB3+BeWL5Vqi0FLPA--.19728S2;
	Mon, 31 Aug 2026 15:39:03 +0800 (CST)
From: Junnan Zhang <zhangjn_dev@163.com>
To: zhangjn_dev@163.com
Cc: cgroups@vger.kernel.org,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	mkoutny@suse.com,
	sunshx@chinatelecom.cn,
	tj@kernel.org,
	zhangjn11@chinatelecom.cn
Subject: Re: [PATCH v3] cgroup: avoid flushing global workqueue in cgroup1_pidlist_destroy_all
Date: Mon, 31 Aug 2026 15:39:04 +0800
Message-ID: <20260831073904.42297-1-zhangjn_dev@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260814102052.147408-1-zhangjn_dev@163.com>
References: <20260814102052.147408-1-zhangjn_dev@163.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgB3+BeWL5Vqi0FLPA--.19728S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjTRRxRhUUUUU
X-CM-SenderInfo: x2kd0wxmqbvvry6rljoofrz/xtbCxRfwhmqVL5fiGwAA3a

Gentle ping.

It's been a couple of weeks since v3, and there hasn't been any
maintainer feedback yet. Could you take a look when you have a
chance? Happy to address any comments or rebase if needed.

Thanks,
Junnan

