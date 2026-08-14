Received: from mta0.migadu.com (out-66.mta0.migadu.com [91.218.175.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12A523BD02
	for <cgroups@vger.kernel.org>; Fri, 14 Aug 2026 02:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786673553; cv=none; b=IxfqhU9/ydQUkKMftJrNTiPuAhlK3yEFvN8W/L5/17ZnWVP6JQr49PmrTWAf35oxJJt14iMlL0yPR7tsKcGs+M8wi4+C8M53VPmkmknX0XorvPLr87wTl1WaaSDKHbu7C+SXOxoqLMdwUT2oZ0pyhRqTCajYRj4hNfGiE14w6Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786673553; c=relaxed/simple;
	bh=eoFbdgYwhAPk1M0cRrN/Wp0rvLcUr3RUxy9FqUNrBDM=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=a457zYHIUYv7dSkq5wzdvIYazqOZwDUngJ9wYf6alzA1gqdGeuehOfV9fWlVj5rl3l8Ezw70rT3VdC6vjm5koyAS4ejrlK5jnKmJnnLa+cDafZO55Xmm031ZyhutMmvL1G+dlsaa94bcPkKzLPUuFBRvVbBmmXlh722U5dlQhuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kKREBeIc; arc=none smtp.client-ip=91.218.175.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kKREBeIc"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=eoFbdgYwhAPk1M0cRrN/Wp0rvLcUr3RUxy9FqUNrBDM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786673549; v=1; x=1787278349;
 b=kKREBeIc0ny6/rcS1p0HaYCh8jyBSJMYDAyMMvqEw3egeGNqNxhLy4gLDabvCSdnxf2m+uH/
 lsPET2rb7mBRn1iTRfKj4OzgS4Zs5qnRfKEaB5syXa2SG3LUw4lHj7GoAbQJG0EEZHNbMUK3oD2
 6ME1bCmI7gAsT7SWvBRiVfME=
X-Envelope-To: cgroups@vger.kernel.org
Received: from smtpclient.apple (114.251.196.105)
	by mta10.migadu.com with ESMTPS id 70dc4e336f65b7bb;
	Fri, 14 Aug 2026 02:12:29 +0000
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v3 1/2] memcg: acquire peaks_lock when reading memory.peak
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260814012924.2388613-2-ridong.chen@linux.dev>
Date: Fri, 14 Aug 2026 10:12:10 +0800
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Tejun Heo <tj@kernel.org>,
 David Finkel <davidf@vimeo.com>,
 =?utf-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>,
 linux-kernel@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>,
 Ridong Chen <chenridong@xiaomi.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <811C3A33-6B05-40D5-8448-19D5BE882A83@linux.dev>
References: <20260814012924.2388613-1-ridong.chen@linux.dev>
 <20260814012924.2388613-2-ridong.chen@linux.dev>
To: Ridong Chen <ridong.chen@linux.dev>
X-Mailer: Apple Mail (2.3864.600.51.1.1)



> On Aug 14, 2026, at 09:29, Ridong Chen <ridong.chen@linux.dev> wrote:
>=20
> From: Ridong Chen <chenridong@xiaomi.com>
>=20
> Sashiko reported that a reader can transiently observe a lower peak
> within a race window [1]. peak_show() returns
> max(local_watermark, ofp->value), but peak_write() updates those two
> under peaks_lock while the reader takes no lock. The interleaving is:
>=20
>  writer (reset on fd A)                 reader (fd B)
>  ----------------------                 -------------
>  usage =3D page_counter_read(pc)
>  WRITE_ONCE(local_watermark, usage)
>  // watermark lowered to usage
>                                         lw  =3D =
READ_ONCE(local_watermark)
>                                         // sees the lowered usage
>                                         val =3D READ_ONCE(ofp->value)
>                                         // B's value not updated yet
>                                         return max(lw, val)
>                                         // both low -> low peak
>  WRITE_ONCE(peer_ctx->value, usage)
>  // B updated, but too late
>=20
> Fix it by acquiring peaks_lock when reading the peak, so the reader =
sees
> a consistent snapshot of local_watermark and the per-fd values. The =
same
> race applies to memory.swap.peak, which shares peaks_lock and the
> peak_write() path, so take the lock there as well.
>=20
> [1] =
https://sashiko.dev/#/patchset/20260730115314.1069089-1-ridong.chen@linux.=
dev?part=3D1
> Fixes: c6f53ed8f213 ("mm, memcg: cg2 memory{.swap,}.peak write =
handlers")
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
> mm/memcontrol.c | 14 ++++++++++++--
> 1 file changed, 12 insertions(+), 2 deletions(-)
>=20
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 17da1f43b7d3..6dd8756870ff 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4713,8 +4713,13 @@ static int peak_show(struct seq_file *sf, void =
*v, struct page_counter *pc)
> static int memory_peak_show(struct seq_file *sf, void *v)
> {
> 	struct mem_cgroup *memcg =3D mem_cgroup_from_css(seq_css(sf));
> + 	int ret;
>=20
> - 	return peak_show(sf, v, &memcg->memory);
> + 	spin_lock(&memcg->peaks_lock);

Why not to use guard(spinlock)(&memcg->peaks_lock) to simplify the code.

Muchun,
Thanks.

> + 	ret =3D peak_show(sf, v, &memcg->memory);
> + 	spin_unlock(&memcg->peaks_lock);
> +
> + 	return ret;
> }
>=20
> static int peak_open(struct kernfs_open_file *of)
> @@ -5858,8 +5863,13 @@ static u64 swap_current_read(struct =
cgroup_subsys_state *css,
> static int swap_peak_show(struct seq_file *sf, void *v)
> {
> 	struct mem_cgroup *memcg =3D mem_cgroup_from_css(seq_css(sf));
> + 	int ret;
>=20
> - 	return peak_show(sf, v, &memcg->swap);
> + 	spin_lock(&memcg->peaks_lock);
> + 	ret =3D peak_show(sf, v, &memcg->swap);
> + 	spin_unlock(&memcg->peaks_lock);
> +
> + 	return ret;
> }
>=20
> static ssize_t swap_peak_write(struct kernfs_open_file *of, char *buf,
> --=20
> 2.34.1
>=20

