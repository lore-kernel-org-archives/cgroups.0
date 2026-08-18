Received: from mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A877367F4D
	for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 15:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787067126; cv=none; b=K4SIVr6Qzw0VYyZzo/z0yZ1ti3aMhOps8UGlVE94r7069klHK9cYNModeWaqD6AVO9uzVdnwifgwjxZ1Wgw/5DcDYDa7AYxmWn/C/j1xV9R1nA69WVjZvgA9nAByXBvNuSlnzXB24n5nFdNNrKmtfwGgY+LscSoZZXv1D5UJhe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787067126; c=relaxed/simple;
	bh=Kdeaan5Dwfb7aQWrsouCyJljKgsAlowShmaivBol4+s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JSjiPwBwtkt1jBaXlkbOqBzxKhkYolAjAzm4ycK7D+wJHHUX2Nis65102yPQJUXOD5vSGDHbTbIgyCVAyv2oydebiRYU571jaT7oqUtu60X++2TlpaGygcnJvRN2H3dJCPVDgS2mvPZbasL4qYHZDzgdMuz22QgCMdoM2mOtnno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xpGECiu5; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xpGECiu5"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Kdeaan5Dwfb7aQWrsouCyJljKgsAlowShmaivBol4+s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787067122; v=1; x=1787671922;
 b=xpGECiu58ZauucXAimebjAa1m93WIrd63a/gHWMOzRy9ErAkQ/lY+ciGGk3W4Yh1HKvdV1k/
 yWH4POFIb6rXZAX/DS/lXgv2rIBe4bwTd8kbPrP44MV8C/DANW0lOd6jFLA/+zhf+VAuCN1TZZM
 r8SdaYt74UCVXKu578fa6lJg=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:48::)
	by smtp.migadu.com with ESMTPS id 4162ff370782c189;
	Tue, 18 Aug 2026 15:32:01 +0000
X-Migadu-Flow: FLOW_OUT
Date: Tue, 18 Aug 2026 08:32:00 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: liuqiqi@kylinos.cn
Cc: linux-mm@kvack.org, tj@kernel.org, mkoutny@suse.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, akpm@linux-foundation.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/8] mm/memcontrol: introduce per-tier memory
 accounting and control
Message-ID: <aoR6jxTrIjCujq7S@linux.dev>
References: <20260818023121.100613-1-liuqiqi@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818023121.100613-1-liuqiqi@kylinos.cn>

On Tue, Aug 18, 2026 at 10:31:13AM +0800, liuqiqi@kylinos.cn wrote:
> From: Qiqi Liu <liuqiqi@kylinos.cn>
> 
[...]
> 
> This series takes a different approach from Joshua Hahn's toptier RFC [1],
> tracking a separate page_counter per (memcg, tier) for N-tier support and
> exposing writable per-tier limits under a cgroup mount option.

Please don't duplicate the effort. If you have concerns regarding Joshua's
series, comment on his series and work with him to push the work through.

