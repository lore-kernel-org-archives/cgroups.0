Received: from mta0.migadu.com (out-228.mta0.migadu.com [91.218.175.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFF44AC16F
	for <cgroups@vger.kernel.org>; Tue, 13 Oct 2026 06:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791872304; cv=none; b=MTllDg5/4lvOKGnh3ufeNs6y7mBCPz++HPLdDM/jFI6OBLXRsFG1tqbmEhC21zrVBvuQDrt8Q01zbVfJM9+uZZsAmLhxWXHDZlcXhsNEvCjYtLtZauvuKwwsto2Zgb0FW84RtC//I0GBmyDcQt9IBsd/8bEWuAJhW2TDVNlRzrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791872304; c=relaxed/simple;
	bh=sILqVf6vf2c7wxEo7EF7BwyGO93H6KbwkBm9lngJlDI=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=kM7fXxsd5Koi5OhobQzK2ZArllpL8ZbM7LyDIAk3tMUl/nTFKEVorZxb63AJ0XPczgtxQAJ4hsI/tQ4qcBW5z7dKRZyIBawinctztPF2vZ3mTQZRhxbfYQOxAKXE5GWCM5Sjwhd5ETUfmfthzhXT1SiN6knuaZNmME0ihLs9d1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VJD2Xkb5; arc=none smtp.client-ip=91.218.175.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VJD2Xkb5"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=sILqVf6vf2c7wxEo7EF7BwyGO93H6KbwkBm9lngJlDI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791872301; v=1; x=1792477101;
 b=VJD2Xkb5iPjNVTQQT86PnpZrSqwCJhrf3AyrLsUtmueIyYhYVwYwhrBhlRWiRZQQRu/kbim/
 DtYFw+AUOX0BmvSFsDkHALXLVg78FKmexZsLhkRVfApS3wsL5+uD8wh5qB0SNW8Fm70pqD5c2Uw
 EsJ8rxIH3D9SlRNLocVw0rxM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id da02f3bab437fe5c;
	Tue, 13 Oct 2026 06:18:21 +0000
X-Mizu-Trace-ID: da02f3bab437fe5c
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 1/2] mm/shrinker: size shrinker_info_unit to a power of
 two
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261012-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v1-1-5a7608393b7a@virtuozzo.com>
Date: Tue, 13 Oct 2026 14:18:01 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <EDF08D88-7AD8-4697-A1EE-F20BB1F83AF6@linux.dev>
References: <20261012-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v1-0-5a7608393b7a@virtuozzo.com>
 <20261012-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v1-1-5a7608393b7a@virtuozzo.com>
To: Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)



> On Oct 13, 2026, at 03:02, Konstantin Khorenko =
<khorenko@virtuozzo.com> wrote:
>=20
> Every memory cgroup allocates, per NUMA node, one shrinker_info_unit
> for every SHRINKER_UNIT_BITS shrinker ids up to shrinker_nr_max. The
> unit holds BITS_PER_LONG atomic_long_t of deferred work, a power of
> two, plus the one-word bitmap of shrinkers with objects charged to the
> cgroup. That word takes the unit just past the power of two, to 520
> bytes on 64-bit, so every unit comes from kmalloc-1k and almost half =
of
> it is padding.
>=20
> The units are allocated when the cgroup goes online and freed when it =
is
> freed, so a dying cgroup keeps them until the last reference to it is
> gone. Their number is the number of memory cgroups, times the NUMA
> nodes, times shrinker_nr_max / SHRINKER_UNIT_BITS. shrinker_nr_max is
> the peak number of memcg-aware shrinkers registered at once, and every
> superblock registers one, so a host that mounts many filesystems and
> runs many cgroups carries the padding as unreclaimable slab, and keeps
> paying it for new cgroups after the mounts are gone.
>=20
> Let a unit cover one id less than a word holds. The bitmap still fits
> one word, and nr_deferred[] plus that word add up to BITS_PER_LONG
> longs, so the unit fills a power-of-two kmalloc slot exactly and, on
> 64-bit, the memory taken by units halves, for about one unit more in
> BITS_PER_LONG.
> round_up() in expand_shrinker_info() needs a power-of-two step and
> becomes roundup(); the other uses of SHRINKER_UNIT_BITS are divisions,
> modulos and multiplications that do not care. Assert the unit size at
> build time, since the layout depends on it.
>=20
> Assisted-by: LLM
> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
> ---
> include/linux/shrinker.h | 9 ++++++++-
> mm/shrinker.c            | 2 +-
> 2 files changed, 9 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
> index 1a00be90d93a9..c250ab68d346c 100644
> --- a/include/linux/shrinker.h
> +++ b/include/linux/shrinker.h
> @@ -7,7 +7,11 @@
> #include <linux/refcount.h>
> #include <linux/completion.h>
>=20
> -#define SHRINKER_UNIT_BITS BITS_PER_LONG
> +/*
> + * One id less than a word holds, so that nr_deferred[] and the map =
word add
> + * up to BITS_PER_LONG longs: a power of two, which fills a kmalloc =
slot.
> + */
> +#define SHRINKER_UNIT_BITS (BITS_PER_LONG - 1)
>=20
> /*
>  * Bitmap and deferred work of shrinker::id corresponding to =
memcg-aware
> @@ -18,6 +22,9 @@ struct shrinker_info_unit {
> DECLARE_BITMAP(map, SHRINKER_UNIT_BITS);
> };
>=20
> +static_assert(!(sizeof(struct shrinker_info_unit) &
> + 		(sizeof(struct shrinker_info_unit) - 1)));

This assertion is not straightforward. I'd like to use =
is_power_of_two().
Like:

  BUILD_BUG_ON(!is_power_of_2(sizeof(struct shrinker_info_unit)));

Muchun,
Thanks.

> +
> struct shrinker_info {
> struct rcu_head rcu;
> int map_nr_max;
> diff --git a/mm/shrinker.c b/mm/shrinker.c
> index 7ec2a9704f6f2..a9418072a509e 100644
> --- a/mm/shrinker.c
> +++ b/mm/shrinker.c
> @@ -159,7 +159,7 @@ static int expand_one_shrinker_info(struct =
mem_cgroup *memcg, int new_size,
> static int expand_shrinker_info(int new_id)
> {
> 	int ret =3D 0;
> - 	int new_nr_max =3D round_up(new_id + 1, SHRINKER_UNIT_BITS);
> + 	int new_nr_max =3D roundup(new_id + 1, SHRINKER_UNIT_BITS);
> 	int new_size, old_size =3D 0;
> 	struct mem_cgroup *memcg;
>=20
>=20
> --=20
> 2.43.0
>=20

