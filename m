Received: from mta1.migadu.com (out-131.mta1.migadu.com [95.215.58.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851F5374A17
	for <cgroups@vger.kernel.org>; Mon, 17 Aug 2026 17:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786989263; cv=none; b=Gdfq3MLrm1PprbHyDjA+tIvhiiTpDHOWD3yp+bpLJPUgaSDjaq2KKtBBDfTYiP+PujkNuF9zK8neM9k8BBkbItFxSfGlfn6wi79TvkySWKxct5B8Fh05+V2EafVpLxAS+b1m3xXW4ZL8Nhf7935Kb5WtRcaOspizahiMb2DBT/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786989263; c=relaxed/simple;
	bh=m1ED9yFio5Z+HXwoOeZ7XuPsrrjwmftWHlmKu2Sgup0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OBxFjIQfA8q/KvlG5YoW/SG5xBD2sAd7lnYhd+KoP759L849ubJKrKYIZfDkmtlIOdDnKe8VmCj1VBzM14aWQuI+yLO/ExHGbVGOiNCHdEwRzdnMOWzEW1JcltOxK19hOh4kDegJ4wmN3esJ0iKQ7cThlk7pH+dJtrty6+4gzUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RE0Eq1rl; arc=none smtp.client-ip=95.215.58.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RE0Eq1rl"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=m1ED9yFio5Z+HXwoOeZ7XuPsrrjwmftWHlmKu2Sgup0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786989257; v=1; x=1787594057;
 b=RE0Eq1rlYua2YPX00a/IdUGz2NVWXyNW6dnVNYqFeGZDoEjZtxkFwr5w2uvNa2UUkCiC3Mhm
 0YvLiJPzVLR7lcPmT6SUxMpTlxcWqeolSdzI8FIl4/Vuq2n5Bm/PJzLDbb0a3OcyUtjzwxiyY8+
 CNOKJd9Uny/vAqjM0fh0y3kY=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:58::)
	by smtp.migadu.com with ESMTPS id cd6362939fe0a13b;
	Mon, 17 Aug 2026 17:54:17 +0000
X-Migadu-Flow: FLOW_OUT
Date: Mon, 17 Aug 2026 10:54:16 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Usama Arif <usama.arif@linux.dev>, cgroups@vger.kernel.org, 
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mhocko@kernel.org, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	david@kernel.org, kernel-team@meta.com, kernel test robot <yi1.lai@intel.com>
Subject: Re: [PATCH] mm/memcontrol: avoid false sharing between vmstats and
 events
Message-ID: <aoNKX83dql7_kzFa@linux.dev>
References: <20260817103835.2937733-1-usama.arif@linux.dev>
 <20260817104340.c9bd2dae70d4fa31fd66b216@linux-foundation.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817104340.c9bd2dae70d4fa31fd66b216@linux-foundation.org>

On Mon, Aug 17, 2026 at 10:43:40AM -0700, Andrew Morton wrote:
> On Mon, 17 Aug 2026 03:38:35 -0700 Usama Arif <usama.arif@linux.dev> wrote:
> 
> > Moving v1 userspace eventfd handling into memcontrol-v1.c shrank
> > struct vmpressure from 112 to 24 bytes when CONFIG_MEMCG_V1 is disabled.
> > This moved memory_events_local[MEMCG_SWAP_FAIL] and the hot
> > vmstats_percpu pointer onto the same cacheline.
> > 
> > The stress-ng mremap stressor exercises MADV_PAGEOUT with swap
> > disabled, generating about 20 million MEMCG_SWAP_FAIL updates per
> > 60-second run on a 176-CPU test system.  Those writes bounce the line
> > while memcg statistics paths load vmstats_percpu.
> > 
> > Move cgwb_list into the existing alignment gap and cacheline-align
> > vmstats_percpu.  This separates the pointer from the event counters
> > without increasing the size of struct mem_cgroup in the tested
> > configuration.
> > 
> > The blamed commit reduced median mremap throughput by 4.38% on the
> > test system with one socket. The patched kernel brings the performance
> > to within 0.5% of the parent which is within the observed boot-to-boot
> > spread (up to 1.2%).
> 
> Cool, thanks.
> 
> > Fixes: ea928e9e18da ("mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c")
> 
> That's in mm-stable so I'll squeeze this fix into next week's 7.3-rc1
> merge pile.

Thanks Andrew. We should also add the following tag due to http://lore.kernel.org/aoAABX59IzUXz/Rv@ly-workstation

Tested-by: kernel test robot <yi1.lai@intel.com>
> 
> 
