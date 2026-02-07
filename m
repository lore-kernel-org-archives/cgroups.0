Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA771A316E
	for <cgroups@vger.kernel.org>; Sat,  7 Feb 2026 03:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770436794; cv=none; b=ZcDgTeKvn6CTbGoJptGFVU5iR0bFH1taL6RHtUK4zPwZm29wNTf9xS05pC1bu0xVvukgZ+7uw2oylJhScd/S58PSTs3q1yA0hCdr5NoPmo4hKJ8lXQPSVD0I+k11zLe2Z6P/23OYeFJR5aKKH4niOfQwX7OuGhdWIVnOIOUX0MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770436794; c=relaxed/simple;
	bh=MaN3TuTYfXt9x1N8hQtGW0+/FfXjGeP4pIPAXUH8IvY=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=QXhfTmWSH//ZzU+pivGdQ1ASAkgTnGvAtekYugIGvgUy47VCDEo5O4NtbnNc768oZzll1+OJ76blnMVeYlm3OPIS8iI0AyfCg7/HRA79ID/LZhEvuDpGHxDoMXyN1Vky1oq1B8Xn2J7psWTAZLvC6v5EgI1u0V9d7SHrzbQigUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JHAFMgOn; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JHAFMgOn"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770436781;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pd+StOZsAu6fC+1g82N+eCSmEnozr9RvP50eoDaUH6U=;
	b=JHAFMgOnZKV2EYoeyz98TDhbPMZYZppyZzQG8N/YUBFHowmXjASI8MByzrIMZ9cC6NmW8U
	1QTFxs+4xVcnuge6hiA5OZ0w3PpXQ27xOJHQUGAN+WLjYXRDgJOFP3P7v8X8/++o5hsiye
	AKHtWqDoFLN06dcGGRsGYVWgDBDK7Rk=
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v4 28/31] mm: workingset: use lruvec_lru_size() to get the
 number of lru pages
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <f3a8fe43c0d8572ad942354cf649c9f25ae762bc.1770279888.git.zhengqi.arch@bytedance.com>
Date: Sat, 7 Feb 2026 11:59:01 +0800
Cc: hannes@cmpxchg.org,
 hughd@google.com,
 mhocko@suse.com,
 roman.gushchin@linux.dev,
 shakeel.butt@linux.dev,
 david@kernel.org,
 lorenzo.stoakes@oracle.com,
 ziy@nvidia.com,
 harry.yoo@oracle.com,
 yosry.ahmed@linux.dev,
 imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com,
 axelrasmussen@google.com,
 yuanchu@google.com,
 weixugc@google.com,
 chenridong@huaweicloud.com,
 mkoutny@suse.com,
 akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com,
 apais@linux.microsoft.com,
 lance.yang@linux.dev,
 bhe@redhat.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
Content-Transfer-Encoding: 7bit
Message-Id: <15E46432-D329-40E7-927D-D999551DE865@linux.dev>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
 <f3a8fe43c0d8572ad942354cf649c9f25ae762bc.1770279888.git.zhengqi.arch@bytedance.com>
To: Qi Zheng <qi.zheng@linux.dev>
X-Migadu-Flow: FLOW_OUT



> On Feb 5, 2026, at 17:01, Qi Zheng <qi.zheng@linux.dev> wrote:
> 
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> For cgroup v2, count_shadow_nodes() is the only place to read
> non-hierarchical stats (lruvec_stats->state_local). To avoid the need to
> consider cgroup v2 during subsequent non-hierarchical stats reparenting,
> use lruvec_lru_size() instead of lruvec_page_state_local() to get the
> number of lru pages.
> 
> For NR_SLAB_RECLAIMABLE_B and NR_SLAB_UNRECLAIMABLE_B cases, it appears
> that the statistics here have already been problematic for a while since
> slab pages have been reparented. So just ignore it for now.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Acked-by: Muchun Song <muchun.song@linux.dev>


