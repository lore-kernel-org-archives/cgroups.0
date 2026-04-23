Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F5524E4A1
	for <cgroups@vger.kernel.org>; Thu, 23 Apr 2026 04:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.51.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776919143; cv=none; b=keHBzW13dtw9uedYspzXSni+Vke+cIExqE6hj3RA0ecZEgW+U67VwHnCLGu0thGh0QXi1u9MCUKIMJf4WF9nziAYWEpMsrOr7DqfAf6dqrqePqGXJXfDwURUq0sSNNA9JOy/bZ2/bLmAK565zg3coCOS0qXIIY9IvK1hCa50yhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776919143; c=relaxed/simple;
	bh=daTMw6XpEap2+GK6uFXaneQ99/KIyukquU9dvDdnaIA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KmDHS7vhUFGUANt9Q5xLfZVIyezgKMc2MpOIB+q4k0Ki3SIkUqAHJikbaWl4tUqlmYJ/bXJjO6V88/EDll3Wgm+JxiJSiOQ7RmrbZYoTeWdimqksZZeSg6C9YpKRhSztZioLj3Lsq2aI6SffxeMIokHBHuIXDslBU8PY74tmtDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.51.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 23 Apr 2026 13:38:53 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 23 Apr 2026 13:38:53 +0900
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
Subject: Re: [PATCH v6 4/4] mm: swap: filter swap allocation by memcg tier
 mask
Message-ID: <aemiXROn4MPN5H9P@yjaykim-PowerEdge-T330>
References: <20260421055323.940344-1-youngjun.park@lge.com>
 <20260421055323.940344-5-youngjun.park@lge.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421055323.940344-5-youngjun.park@lge.com>

On Tue, Apr 21, 2026 at 02:53:23PM +0900, Youngjun Park wrote:

Another low impact review from sashiko
https://sashiko.dev/#/patchset/20260421055323.940344-1-youngjun.park@lge.com?part=4

Proper concern, 
But .. it is also not needed to modify. just small optimization of code flow.
If somebody thinks differently, happy to apply it. :)

Best regards,
Youngjun Park
