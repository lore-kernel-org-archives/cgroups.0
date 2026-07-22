Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6421E352038
	for <cgroups@vger.kernel.org>; Wed, 22 Jul 2026 15:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784734429; cv=none; b=K5MvavSMnpUbb6SSUbijIdG57I+S96t0VXkjhN29Lylt7m4fCtqFxowIg6RW9LzKXiaYcM44GTCMdObgpDONfNkWJkybRUKYUSk+leDt52ZZdQmJMVwTdao5Rucv4Vir9rUlx7jj1zTSwD6/oTL/38tLP5pwk7TGrRo1hWkJzgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784734429; c=relaxed/simple;
	bh=Q3/cQt9YW6fvSON+5+t/vsljrE7mSvrKO2jr6JFSUws=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fnr8uR7DFpVX4HD4Fk57qAt1sMWRK8WC1wywudx5WbiNqCRosdqg27dG+PMhwy1CKgHSwb9+kD7hPcFBoBOEnRi1agFIa0eLsBfUWLK5Q8f8VLYlclfFCVA0O4UGu86T96mgfLBxQx/cpotuguzX5caNa0VLZmv7l1tcWPmkRCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HBMRbQS0; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HBMRbQS0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784734427; x=1816270427;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Q3/cQt9YW6fvSON+5+t/vsljrE7mSvrKO2jr6JFSUws=;
  b=HBMRbQS0FTv0M4gTwXy6IIsWjSpg+4p+Fm3rzibjjVsaT++QN7KrAnje
   mHaswdl8rgBc9Kd2WPKme8r8eAKmfv/P4nkjG/rp1C3iarsAVlvvvAnZu
   ya1unGkMdehWcCckA/6yf07tXnoYAzRJQBmGPLv4vPVNzWjUfaBaVi7wa
   nmdP50HjJNEm4s6EjKqTvo38bYSE1jTX2vTeQ9Ajj+CTlOmNz010WwGmj
   80rEY1aMFsxU0sxfL5WE6BuokgchuI1dAd9M67yEUaIa9+Vi/46D1iHe7
   iPmfZGgYxqtTn6dRMA8PPVREN0m7ngQ2HSP0OzPEkbOtFSAxJRmWNm2yK
   g==;
X-CSE-ConnectionGUID: 4/oMrEDlRpqi6uWy3WAeLg==
X-CSE-MsgGUID: bhPWiY7fRkWEnztcSDVETQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="89192907"
X-IronPort-AV: E=Sophos;i="6.25,178,1779174000"; 
   d="scan'208";a="89192907"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 08:33:46 -0700
X-CSE-ConnectionGUID: uhCBdXtISuW42P8QNMdSKA==
X-CSE-MsgGUID: cKM5e7NNQQe59wFtA1cNJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,178,1779174000"; 
   d="scan'208";a="260078267"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO [10.245.245.180]) ([10.245.245.180])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 08:33:43 -0700
Message-ID: <18f2008f7d127171f271e3462d283c6743c87c87.camel@linux.intel.com>
Subject: Re: [PATCH 03/10] ttm/pool: initialise the shrinker earlier (v2)
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org, 
	tj@kernel.org, christian.koenig@amd.com, Johannes Weiner
 <hannes@cmpxchg.org>,  Michal Hocko <mhocko@kernel.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Shakeel Butt	 <shakeel.butt@linux.dev>, Muchun
 Song <muchun.song@linux.dev>
Cc: cgroups@vger.kernel.org, Waiman Long <longman@redhat.com>,
 simona@ffwll.ch, 	intel-xe@lists.freedesktop.org
Date: Wed, 22 Jul 2026 17:33:39 +0200
In-Reply-To: <20260706052330.1110909-4-airlied@gmail.com>
References: <20260706052330.1110909-1-airlied@gmail.com>
	 <20260706052330.1110909-4-airlied@gmail.com>
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

On Mon, 2026-07-06 at 15:22 +1000, Dave Airlie wrote:
> From: Dave Airlie <airlied@redhat.com>
>=20
> Later memcg enablement needs the shrinker initialised before the list
> lru,
> Just move it for now, but also handle the list being uninitialised.
>=20
> Signed-off-by: Dave Airlie <airlied@redhat.com>
>=20
> ---
> v2: sashiko identified a problem with the list handling.
> ---

Couple of seemingly valid Sashiko issues:

https://sashiko.dev/#/message/20260706053333.AEABE1F000E9%40smtp.kernel.org

Thanks,
Thomas


> =C2=A0drivers/gpu/drm/ttm/ttm_pool.c | 30 +++++++++++++++++-------------
> =C2=A01 file changed, 17 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/ttm/ttm_pool.c
> b/drivers/gpu/drm/ttm/ttm_pool.c
> index e4dbf4c93091..f12b68812081 100644
> --- a/drivers/gpu/drm/ttm/ttm_pool.c
> +++ b/drivers/gpu/drm/ttm/ttm_pool.c
> @@ -440,10 +440,14 @@ static unsigned int ttm_pool_shrink(int nid,
> unsigned long num_to_free)
> =C2=A0
> =C2=A0	down_read(&pool_shrink_rwsem);
> =C2=A0	spin_lock(&shrinker_lock);
> -	pt =3D list_first_entry(&shrinker_list, typeof(*pt),
> shrinker_list);
> -	list_move_tail(&pt->shrinker_list, &shrinker_list);
> +	pt =3D list_first_entry_or_null(&shrinker_list, typeof(*pt),
> shrinker_list);
> +	if (pt)
> +		list_move_tail(&pt->shrinker_list, &shrinker_list);
> =C2=A0	spin_unlock(&shrinker_lock);
> =C2=A0
> +	if (!pt)
> +		return 0;
> +
> =C2=A0	num_pages =3D list_lru_walk_node(&pt->pages, nid,
> pool_move_to_dispose_list, &dispose, &num_to_free);
> =C2=A0	num_pages *=3D 1 << pt->order;
> =C2=A0
> @@ -1402,6 +1406,17 @@ int ttm_pool_mgr_init(unsigned long num_pages)
> =C2=A0	spin_lock_init(&shrinker_lock);
> =C2=A0	INIT_LIST_HEAD(&shrinker_list);
> =C2=A0
> +	mm_shrinker =3D shrinker_alloc(SHRINKER_NUMA_AWARE, "drm-
> ttm_pool");
> +	if (!mm_shrinker)
> +		return -ENOMEM;
> +
> +	mm_shrinker->count_objects =3D ttm_pool_shrinker_count;
> +	mm_shrinker->scan_objects =3D ttm_pool_shrinker_scan;
> +	mm_shrinker->batch =3D TTM_SHRINKER_BATCH;
> +	mm_shrinker->seeks =3D 1;
> +
> +	shrinker_register(mm_shrinker);
> +
> =C2=A0	for (i =3D 0; i < NR_PAGE_ORDERS; ++i) {
> =C2=A0		ttm_pool_type_init(&global_write_combined[i], NULL,
> =C2=A0				=C2=A0=C2=A0 ttm_write_combined, i);
> @@ -1424,17 +1439,6 @@ int ttm_pool_mgr_init(unsigned long num_pages)
> =C2=A0#endif
> =C2=A0#endif
> =C2=A0
> -	mm_shrinker =3D shrinker_alloc(SHRINKER_NUMA_AWARE, "drm-
> ttm_pool");
> -	if (!mm_shrinker)
> -		return -ENOMEM;
> -
> -	mm_shrinker->count_objects =3D ttm_pool_shrinker_count;
> -	mm_shrinker->scan_objects =3D ttm_pool_shrinker_scan;
> -	mm_shrinker->batch =3D TTM_SHRINKER_BATCH;
> -	mm_shrinker->seeks =3D 1;
> -
> -	shrinker_register(mm_shrinker);
> -
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0
