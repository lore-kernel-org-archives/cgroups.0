Received: from mta0.migadu.com (out-154.mta0.migadu.com [91.218.175.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206BB4B53FB
	for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 19:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789155388; cv=none; b=QJ7D6nyehCDQtwoQ4HMFXhlCPBgrrjUvqYKnNwdhsN7x4OyqAPsth1t58JltjfTLJxCQ7smR9R/A3RTllMB+09GMkd1vEaqbWm5W4zJ1NgZxJP26S4U8lsB5BAP4Cnfp6EiKFiMBQ7VIZnggI5AU6HM/YepgMgOpgIo+q1zhJ64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789155388; c=relaxed/simple;
	bh=5axUg2fGvQSR87hlCNMrBXF6myPM/7xQ+ipU/f5bq9M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tvfXz5ZOZW93JBkOVnoID+bOE8o5LXbDyKNvgEG4Pq+GfYT2zMXJ6eWRPIIyv2YVsCihJcaVpJ5qkB2MBAgbLr4Ju+cPXoQuKG95rtiPMV8+O5a24z33rRZgnKSUuuqoElPTzU3e/5/rnLNEr86RFxPYLDEvjwz3p/2006ZoTNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=I/QUrGAl; arc=none smtp.client-ip=91.218.175.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="I/QUrGAl"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=5axUg2fGvQSR87hlCNMrBXF6myPM/7xQ+ipU/f5bq9M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789155374; v=1; x=1789760174;
 b=I/QUrGAlUsfm1o9sIX9LcW4TYrrzzwwBJdUBskLmhCtzevu5HOF7uQP6GeE+VGc7+TqLN7Kp
 Tv8xQHLwB2Jwm2ByZuP9NL4Hm6E6B4EUtg/c5b4n7D+6fljv1Ktv2YXDJwchl54c8y8yYSUxxSP
 KJk4FGdymXlIzuOEUTgyahaA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 199cd7cb081f703c;
	Fri, 11 Sep 2026 19:36:14 +0000
X-Mizu-Trace-ID: 199cd7cb081f703c
X-Migadu-Flow: FLOW_OUT
Date: Fri, 11 Sep 2026 12:36:12 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Runli <mingyu.he@shopee.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, littleswimmingwhale@gmail.com
Subject: Re: [PATCH] memcg: keep propagating stats updates to ancestors
Message-ID: <aqRXqcynCx88D2QK@linux.dev>
References: <20260911032905.63683-1-mingyu.he@shopee.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911032905.63683-1-mingyu.he@shopee.com>

On Fri, Sep 11, 2026 at 11:29:05AM +0800, Runli wrote:
> memcg_rstat_updated() stops walking the ancestors when a memcg exceeds
> the flush threshold. A concurrent flush can leave an ancestor below the
> threshold, so the early exit prevents it from receiving further updates.
> 
> Consider root and leaf on a 4-CPU system, with a threshold of 256.
> CPU 0 is flushing another CPU's stats after CPU 1's stats have already
> been flushed. The counts below are shared stats_updates counters:
> 
>   CPU 0 (root flush)                CPU 1 (leaf updates)
>   ------------------               --------------------
>   clear leaf->stats_updates
>                                    add 64 to leaf and root
>   clear root->stats_updates
>   finish flush
>                                    leaf = 64, root = 0
>                                    4 more batches of 64:
>                                      leaf = 320, root = 256
>                                    next update:
>                                      leaf > threshold
>                                      break; root is not updated
> 
> Root remains at the threshold, which is insufficient to trigger a flush,
> while further leaf updates keep taking the early exit. The periodic
> forced flush restores progress, but until then the root's aggregated
> statistics can fall far behind. For example, page cache grows at rate of
> 1 GiB/s, a two-second wait can leave the reported usage about 2 GiB below
> the actual usage.
> 
> Skip only the flushable node and continue walking its ancestors, so each
> ancestor can accumulate updates until it exceeds the flush threshold.
> 
> Fixes: 60cada258dfe ("memcg: optimize memcg_rstat_updated")
> Signed-off-by: Runli <mingyu.he@shopee.com>
> ---
> Testing:
> Based on commit 893e11787f78, with and without this patch,
>   using 32 concurrent instances of:
>   netperf -H 127.0.0.1 -p 12875 -t TCP_STREAM -l 60 \
>           -T <client_cpu>,<server_cpu> -P 0 -v 0 -f m -- -m 1024
> 
> Both netperf and netserver ran in the same leaf memcg, directly below
> root (root -> leaf), with memory bound to NUMA node 0.
> Each kernel was tested for five 60-second runs after a 10-second warmup.
> 
> Median aggregate throughput decreased from 107.26 to 105.23 Gbit/s
> (1.9%) with this change.
> 
> I think fixing the correctness issue is worth the roughly 2% throughput
> cost.

Do you have any real world or production data to show that this is an issue? I
would not change anything unless there is real data. Also we have periodic flush
which will fix this (I have not looked deeper into this to see if this is a real
issue). In addition we have bpf interface for the stats for users who really
care about accuracy and efficiency.

