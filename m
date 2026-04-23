Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52980244687
	for <cgroups@vger.kernel.org>; Thu, 23 Apr 2026 04:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.51.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776918886; cv=none; b=f2Zp7nFsEhejlyx9TkGOJpc9XMBTdHg592YksQ8NA3ByZfIZw+DsQbyVvM2FYVjlzRd4Phf0NwKCeRjFofVwuNc9Eo39eqSIQH5xHhIBVC7x+joiOagjFQYCC1Dy06+g1iGMsix85k0TRiECB3PnIvCd45tPX88FlR2vstvFm9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776918886; c=relaxed/simple;
	bh=k6pl+qt7fFZihY9OigldVZxGvH7CICXaXD40uR1cI70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hPuVNLOFIAGAHivxEXtRvx0liD/BScW3K43qxiXac/yYo14hY0pwCuLGliGO258skkBx/oVrBj0hrXRvI9lySsY4dGCQ9s/37rz5vx56xStBPxWd7M9Bq91fLQsJzBLqg9JPK6ifrC0Qex0oSWsEyS5JG4LzvQjoz8uQWaMEn6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.51.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 23 Apr 2026 13:34:35 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 23 Apr 2026 13:34:35 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, kasong@tencent.com,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, gunho.lee@lge.com, taejoon.song@lge.com,
	hyungjun.cho@lge.com, mkoutny@suse.com, baver.bae@lge.com,
	matia.kim@lge.com
Subject: Re: [PATCH v6 3/4] mm: memcontrol: add interfaces for swap tier
 selection
Message-ID: <aemhW7/etjZUo9Xg@yjaykim-PowerEdge-T330>
References: <20260421055323.940344-1-youngjun.park@lge.com>
 <20260421055323.940344-4-youngjun.park@lge.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421055323.940344-4-youngjun.park@lge.com>

On Tue, Apr 21, 2026 at 02:53:22PM +0900, Youngjun Park wrote:

There is one review from sashiko on this 3rd patch.
https://sashiko.dev/#/patchset/20260421055323.940344-1-youngjun.park@lge.com?part=3

The concern about delegation and the global lock is valid in theory.
However, I do not think a change is necessary.

memory.swap.tiers is writable only in delegated subtrees, and delegation
itself is an administrative decision.

memory.swap.tiers is a configuration-time operation and not expected to
be updated frequently. Contention on swap_tier_lock would happen in a
configuration context (tier setup/update), not in a critical runtime
path. Therefore, it is unlikely to have a significant impact on normal
system operation.

Avoiding this would require computing the mask in the runtime path,
potentially on every I/O .Keeping the cost in the rare setup path seems preferable.

Best regards,
Youngjun Park
