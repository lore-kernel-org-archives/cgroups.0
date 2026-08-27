Received: from mta1.migadu.com (out-152.mta1.migadu.com [95.215.58.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC0A35DA5D
	for <cgroups@vger.kernel.org>; Thu, 27 Aug 2026 03:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787800122; cv=none; b=LT3yAXZS0MBVxOTjgyI51h4Al4evgwlgTVr/KRlrWoBe2S0EbFyh7V3DloWd7rTipefR5wDtk5Z/rBbp5Fi6LbEasypAeSS45nel6oF5TH7FcVAQBX9kI9KsHFNKUsIQHMFsPQW4B5bTCs1pFFqnAIN/Y1qdG9KdwqFNPh8Zrm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787800122; c=relaxed/simple;
	bh=TBTevkLtBQYfBGrZL7q8D98wBgw40SCkpQHlduNMoPI=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=d5Z9BvTWA/dQaixnXDmSrUnMsGRt3UJrJLrkz9Y2r0gJO2pSDav/yW4Lnfi8MMPS/gmAhHMEaUYFte0mjFXMLtKpef/4UF3xUaxOtKZIRpI23U+Mx0a+ibmfsMC6eXVh9TKndqKRIRuU8DTfGxF+GSfG+j19R7T0joXU59hQ01Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tLIWahFZ; arc=none smtp.client-ip=95.215.58.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tLIWahFZ"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=TBTevkLtBQYfBGrZL7q8D98wBgw40SCkpQHlduNMoPI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787800119; v=1; x=1788404919;
 b=tLIWahFZd5r7cgmWL3RR7N2eFLVUQvS/eO7RRo64IOZlLgQ4u4BZRXlmnmEjuIXdOSq8VlVR
 3t4mdR7o8KDvjwo11aYWN9ui6CiO2l3h84CLTWiazXxk6s7QF82+uOkLQIsU1j0KUu+OiPNt9m6
 D7QfgpjWe+myCMkH6bsIiPCc=
X-Envelope-To: cgroups@vger.kernel.org
Received: from smtpclient.apple (2408:8606:1800:501::1:d)
	by mta10.migadu.com with ESMTPS id 6175ff980d4bddf9;
	Thu, 27 Aug 2026 03:08:39 +0000
X-Mizu-Trace-ID: 6175ff980d4bddf9
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] mm/memcontrol: fix data-race on reading jiffies_64
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260827025457.116191-1-jiayuan.chen@linux.dev>
Date: Thu, 27 Aug 2026 11:08:20 +0800
Cc: linux-mm@kvack.org,
 stable@vger.kernel.org,
 syzbot+ced4d9a8cadb5ef3adae@syzkaller.appspotmail.com,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Yosry Ahmed <yosry@kernel.org>,
 Chris Li <chrisl@kernel.org>,
 Jens Axboe <axboe@kernel.dk>,
 Jan Kara <jack@suse.cz>,
 Tejun Heo <tj@kernel.org>,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <73260DE5-E87A-41BD-BF5F-37163DDD25B4@linux.dev>
References: <20260827025457.116191-1-jiayuan.chen@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
X-Mailer: Apple Mail (2.3864.600.51.1.1)



> On Aug 27, 2026, at 10:54, Jiayuan Chen <jiayuan.chen@linux.dev> =
wrote:
>=20
> KCSAN reported a data-race between tick_do_update_jiffies64() updating
> jiffies_64 and mem_cgroup_flush_stats_ratelimited() reading it =
directly.
>=20
> Unlike jiffies, jiffies_64 is not volatile, so raw reads are plain
> accesses and can even be torn on 32-bit. Use get_jiffies_64() instead,
> and fix the same pattern in mem_cgroup_flush_foreign().
>=20
> Cc: <stable@vger.kernel.org>
> Fixes: 508bed884767 ("mm: memcg: change flush_next_time to =
flush_last_time")
> Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty =
flushing")
> Reported-by: syzbot+ced4d9a8cadb5ef3adae@syzkaller.appspotmail.com
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.

