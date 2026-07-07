Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59313ACF15;
	Tue,  7 Jul 2026 07:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783408853; cv=none; b=TUD7CkaRSSa8FFS9zBuonznE4N0/H4/rwY41hEW0P75pMXvq2lULA3Wg857iYmTtBznOQnKsjKwo+INvGF21ubV3fykl7ahC3uOsyWm4TTLrcvbLrVEIOxN4ZPePxclhAH39XjKiWbjKFZluFu1yoLKlI1bIpsSa7gVe8E5BelY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783408853; c=relaxed/simple;
	bh=oCzQj6mzYMWn7iqnEq+ZWs0O8xxcgsd/5YisJkPeUmU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UBevYk/oehQqaby7qHbcZozSipEc0xdPzRz/kESNyndlEfR+kZZzhToo6sajZ0NGehA7YU47wSPfhIYOJLfDNdU68VOwT912mFEt8q72p235QPE0rUCj0jWF2bJiSTtlaBvtPTVrPbRQog3vuH6eF8dnCwc181La/zGTSpxtfI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dcEeV0Ot; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dcEeV0Ot"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783408847; x=1814944847;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=oCzQj6mzYMWn7iqnEq+ZWs0O8xxcgsd/5YisJkPeUmU=;
  b=dcEeV0OtYuI7ZU1XFDztIzV463xieAEfj2jZHu/xSgbWgiYNQlSIkWAY
   QPRaCAqIx8lwosKzIkPisJKoPMqbIavloIA3Sa8c4mUCCXEh89BcQzwbt
   Jnu2NlNQESmuLVd57sBVcf6dOWMB+uVzpPxIPaRaGy0ttCvXSDtBWKNvk
   tt+fyRX2zwR75idrxmDTJhIK/yNDbjLe8A45HbTZLZMsC5ifqIrpYlLto
   4LsqWhiEp/seY+IDu0w9OhKpEBgliqmR5tsH3Wu9i6VyQ9WQ+8vDKI1H/
   SBzEuKPmMetKKA/DBvwyvwINNi4iPk6dgEKD9OhjuuVCLna2eIfvRpN9U
   A==;
X-CSE-ConnectionGUID: IB11W8l8SBqpxafQYXVBOg==
X-CSE-MsgGUID: DYOBWlleRuWAcvjUVlixlg==
X-IronPort-AV: E=McAfee;i="6800,10657,11839"; a="87962856"
X-IronPort-AV: E=Sophos;i="6.25,153,1779174000"; 
   d="scan'208";a="87962856"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2026 00:20:42 -0700
X-CSE-ConnectionGUID: A4GgYyZLTeC5yKEPCVStcA==
X-CSE-MsgGUID: 0oqI3gtaRSmRaXZoccMrKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,153,1779174000"; 
   d="scan'208";a="250570814"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO [10.245.244.199]) ([10.245.244.199])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2026 00:20:37 -0700
Message-ID: <67ffc76ee6d1aa4e9ef5f4c393304914359eeaab.camel@linux.intel.com>
Subject: Re: [PATCH v7 3/6] cgroup/dmem: Add reclaim callback for lowering
 max below current usage
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: intel-xe@lists.freedesktop.org, Natalie Vock <natalie.vock@gmx.de>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal =?ISO-8859-1?Q?Koutn=FD?=
 <mkoutny@suse.com>, 	cgroups@vger.kernel.org, Huang Rui
 <ray.huang@amd.com>, Matthew Brost	 <matthew.brost@intel.com>, Matthew Auld
 <matthew.auld@intel.com>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann	 <tzimmermann@suse.de>, Simona Vetter <simona@ffwll.ch>,
 David Airlie	 <airlied@gmail.com>, Christian =?ISO-8859-1?Q?K=F6nig?=	
 <christian.koenig@amd.com>, Thadeu Lima de Souza Cascardo
 <cascardo@igalia.com>,  Alex Deucher <alexander.deucher@amd.com>, Rodrigo
 Vivi <rodrigo.vivi@intel.com>, 	dri-devel@lists.freedesktop.org,
 amd-gfx@lists.freedesktop.org, 	linux-kernel@vger.kernel.org
Date: Tue, 07 Jul 2026 09:20:35 +0200
In-Reply-To: <akwBFlw8MwhrwsRu@slm.duckdns.org>
References: <20260703130541.2686-1-thomas.hellstrom@linux.intel.com>
	 <20260703130541.2686-4-thomas.hellstrom@linux.intel.com>
	 <akwBFlw8MwhrwsRu@slm.duckdns.org>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi,

On Mon, 2026-07-06 at 09:25 -1000, Tejun Heo wrote:
> Hello,
>=20
> On Fri, Jul 03, 2026 at 03:05:38PM +0200, Thomas Hellstr=C3=B6m wrote:
> > Also honor O_NONBLOCK so that if that flag is set during the
> > max value write, no reclaim is initiated. The idea is to avoid
> > charging the reclaim cost to the writer of the max value.
>=20
> Is this really necessary? I'm not necessarily against it but this is
> trivial
> to work around from userspace and feels like a gratuitous addition.
> What's
> the use case?

This was something that was added at the request of Maarten. The idea
is to mimic the memcg behaviour. For memcg, the use-case was to avoid
having the reclaim cost (I assume in terms of cpu time) land on the
next allocator instead of the process writing the new max value.

I think there are more details in the memcg commit history, but the
presence here is solely to mimic memcg WRT this.

Thanks,
Thomas=20

>=20
> Thanks.
