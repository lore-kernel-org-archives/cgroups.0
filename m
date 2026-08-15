Received: from mta0.migadu.com (out-151.mta0.migadu.com [91.218.175.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF35517B50A
	for <cgroups@vger.kernel.org>; Sat, 15 Aug 2026 00:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786754319; cv=none; b=pXwBv4/XEMNeKqogAasL2NXkK6/uAj5iORcB7xfThgC6zf0X+J11aR74sppiNqDw+dS3xjFICWYxAHYcPRGC8H23f36/u9EEAHykKNxe6YukKx0X4qgNteLbO9nCZK4TPKQtPuhLPg9baHrpdCxRbBbxlbEmvGPunNH5KGrFFGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786754319; c=relaxed/simple;
	bh=sM7q98Dlk5XbykTDQiACBDmjl2R/gtu/mzNUYNNIq/w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gjp/TDCJBqg2g+NGisoekeBVn8Lz+sOgssAEe68edxS7THZNbzjtQdGAssuTl0AwhnBhSTwIEdjDQCAt6+lOTCVy6VsH/UTSgqW68Yha1MNkyGBd+Qlro3vwzCdmVwqQRvxAq/PpPwX3eq4Ze8/szZdDwPWTRUvXnNfFNnpohdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tWfwiQO6; arc=none smtp.client-ip=91.218.175.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tWfwiQO6"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=sM7q98Dlk5XbykTDQiACBDmjl2R/gtu/mzNUYNNIq/w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786754315; v=1; x=1787359115;
 b=tWfwiQO67aZItcVWXNy4V8/jTq4Mzo8GJnnmRKvlHYY3uLIyOrlbPkSmQDR3nW8jiCLEIkXw
 RQLWjQXBpiWmH62OgXfhGrFBwmYE1k2aZzAiWCQKW5BXOv5zDUI/ndqksUAQcp6SA5kmrwOAyrk
 uBKhbNPMRX4HgZXE+mRhTCAk=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:5::)
	by smtp.migadu.com with ESMTPS id de1cbddc7a5009cc;
	Sat, 15 Aug 2026 00:38:35 +0000
X-Migadu-Flow: FLOW_OUT
Date: Fri, 14 Aug 2026 17:38:30 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, David Finkel <davidf@vimeo.com>, Tejun Heo <tj@kernel.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>, linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>, 
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v4 2/2] mm, memcg: fix memory.peak reset clobbering other
 fds' watermark
Message-ID: <an-073JtSRWeyhr8@linux.dev>
References: <20260814033005.2481920-1-ridong.chen@linux.dev>
 <20260814033005.2481920-3-ridong.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260814033005.2481920-3-ridong.chen@linux.dev>

On Fri, Aug 14, 2026 at 11:30:05AM +0800, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> Writing to memory.peak resets the peak for that fd only. Each fd is a
> watcher and reads back max(its own value, the shared local_watermark).
> 
> peak_write() resets by lowering local_watermark to the current usage.
> To keep the other watchers' peaks it then walks the watcher list, but it
> stores the current usage into them instead of the old watermark. So once
> usage has dropped from a peak, a reset on one fd wrongly drags every
> other fd's peak down too, even fds that never reset.
> 
> Reproduced on 7.2.0-rc5-next under QEMU, two fds A and B on one cgroup:
> B sees the peak (410624 KB), usage drops, then A resets -- and B's peak
> collapses to 1060 KB although B never reset. With this patch B keeps
> reading 410624 KB.
> 
> Fix: save the old watermark before lowering it and use that to floor the
> other watchers, so a reset only affects the fd that issued it.
> 
> Fixes: c6f53ed8f213 ("mm, memcg: cg2 memory{.swap,}.peak write handlers")
> Closes: https://sashiko.dev/#/patchset/20260807090000.1532495-1-ridong.chen@linux.dev
> Assisted-by: Claude:claude-opus-4-8
> Acked-by: Tao Cui <cuitao@kylinos.cn>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
