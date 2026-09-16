Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AFE93FF1AC;
	Wed, 16 Sep 2026 12:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789560150; cv=none; b=g0mwlILkrY4Vh3Z1vHfdlWpe1Dg4eLOFtIQMUfwqg/xaJVvMYGMunvRLY4AWPLE92Gh2NOSCD7mOCikD+/KcZDKRmPla4dFEie8lVq68AdnxkoV5LqthaZ6wc30ZC9U1acrcDKFQSXBh9M91z4I+X2HewQyarFGcPAAStXGWs0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789560150; c=relaxed/simple;
	bh=Ln42KI9rF7HwsZcMC6yceohUgd1k6iJD6b8wwK86SGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZeZyCxKnlTGM5Ko/EqBU+Q9BeadO8MYmOjsIg9C+OKrmfvN/C8vkko60E3Pq2L4u9IFtr6haRAYIRE6xFoFAVzYEwPnwAQLbk8Mn0we72AmT5n3r9awn7wwOTMfB/j1dgjdpIUJeeArtAlnEM7BymM58cIdDqO8cv3pkMLFs2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=F4vaEYS9; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="F4vaEYS9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Ln
	42KI9rF7HwsZcMC6yceohUgd1k6iJD6b8wwK86SGw=; b=F4vaEYS9T6K77Q6SXX
	J5MfAZEYcNJH7iXQSPBJDpJT+SXG2HL8OuREenMjijn69Ll+25+YavqcgPALaNaq
	2qzsye2wUVXTRE1KnKz1yf4kQfKC+4sW4+DYeNf1ry0qbm9n94H22/1jmfPtszu0
	zVTnKczTNCeU3OpFDAM5iPt6M=
Received: from sky.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD399YQhapqKHv3Aw--.15279S2;
	Wed, 16 Sep 2026 20:01:20 +0800 (CST)
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
Date: Wed, 16 Sep 2026 20:01:20 +0800
Message-ID: <20260916120120.145520-1-zhangjn_dev@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <aqmELUhfNg1UmeEh@slm.duckdns.org>
References: <aqmELUhfNg1UmeEh@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD399YQhapqKHv3Aw--.15279S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjTRRc_aDUUUU
X-CM-SenderInfo: x2kd0wxmqbvvry6rljoofrz/xtbCxhGqQGqqhRFz-wAA3l

Hi Tejun,

Fair enough -- the lab numbers demonstrate the coupling but don't
bridge the gap to the 120s we saw in the field, and I can't rule out
that other factors dominated there. Without the vmcore from the
customer I have no way to settle that part.

If we manage to reproduce the hung task splat itself in the lab, or
get usable field data, I'll come back with it.

Thanks to you, Michal and Ridong for the time spent reviewing this.

Junnan

