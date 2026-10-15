Received: from mta1.migadu.com (out-151.mta1.migadu.com [95.215.58.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E953AB269
	for <cgroups@vger.kernel.org>; Thu, 15 Oct 2026 02:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792030325; cv=none; b=XcD/tP4+DKTEt3W1WqSjOJHmNlp5kX7i5w/OC5TzrF9HWYO+UNG0VB+yBHnE5G2Y08ypjOk4GVHNRflgETlQY6TgDhjqEm4/TsHbC8zD0TDkSM39XH5jAWdNvIStOh3yC+RAdXLZqkewRHe9tSctpUhCzek3KPJCeu5XmGznqgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792030325; c=relaxed/simple;
	bh=OaHjNXyKVR2ly4XZ9rh+SeN1xPX6G78FfZWEiWx20n4=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=nw2RH2wHHsnscAdkMxgCky+lHKjsNBtl3S70bDiRbuigAm4cjtTzKaPLfxVNfGUOJYfExstK8yamdJbLA0vES6ACtoS/2yVstDI7irSuYlCOLFIQRCAEYXMfVy2t0EPImuIsz5iTAYrzK07kmXSrUv7c+AYq9mOQKWjXgHB6JzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=obWgQgFK; arc=none smtp.client-ip=95.215.58.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="obWgQgFK"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=OaHjNXyKVR2ly4XZ9rh+SeN1xPX6G78FfZWEiWx20n4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792030320; v=1; x=1792635120;
 b=obWgQgFKylyRSXIAYIH/47rFfzoaJ5EnykGXq4AADvSC/ZAymcJIr/2U8t6KLbFK1LbYUps2
 xXurWVcUwK/OnifeqzavjyWNgS8hk/9e2JLM4F5r+I5j+Wo9fjs/4OE5gNvR+fKndTzPk1DdP5j
 gqO9kZpp0ZItbjiuWXKzI2RM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id cf6ef34820450841;
	Thu, 15 Oct 2026 02:12:00 +0000
X-Mizu-Trace-ID: cf6ef34820450841
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 2/2] mm: memcontrol: remove page_memcg_check()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261014-memcg-unused-page-helpers-v1-2-240b37c53831@columbia.edu>
Date: Thu, 15 Oct 2026 10:11:45 +0800
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <CFB8FDE5-CA38-4F62-8565-C94D62EB4A76@linux.dev>
References: <20261014-memcg-unused-page-helpers-v1-0-240b37c53831@columbia.edu>
 <20261014-memcg-unused-page-helpers-v1-2-240b37c53831@columbia.edu>
To: Tal Zussman <tz2294@columbia.edu>
X-Mailer: Apple Mail (2.3901.100.1.1.12)



> On Oct 15, 2026, at 01:08, Tal Zussman <tz2294@columbia.edu> wrote:
> 
> The last caller was removed in commit 90f095b816e2 ("mm/page_owner: use
> memcg_data snapshot to avoid TOCTOU in print_page_owner_memcg()").
> Remove it.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.

