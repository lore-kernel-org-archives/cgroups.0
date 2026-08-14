Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C023546E0
	for <cgroups@vger.kernel.org>; Fri, 14 Aug 2026 05:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786685133; cv=none; b=Oh1SblxNWt8AMUxo4RP9APZ5PZDZOIrrA3EJK1ocHUNxFpvnvWASb3E8AesVIv4N15ixOKZ56yCJBF8kAyh254mVujQmlcKMCNnmlVAST6oztaodabzkdsYXjZHgT/un4zIvV7wnpwUxHjJIEBklXHUZJXAptZlfrvW/CVs3lmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786685133; c=relaxed/simple;
	bh=76aMWWGJi0FeVtyWxNDljvnpj3ukoO9JxRBuxbPbc9g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f1e2zjPGP9bT+HDJ6rKWhum4zdyZnNKoUjBn8oBqZuVc7XoObUWOIjG/05muvOhZoKSCE0VziQexPdT0dpMWyUrU+WmdPs2dhLJrvYQPvXjTgMdKf4aH6+yBbjP56IuR7F8h2CH7G1Gn0g0CTD+EIShVGkeTBpE7jJ9I1PvtQ1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HCJJqD19; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HCJJqD19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805F91F00AC4
	for <cgroups@vger.kernel.org>; Fri, 14 Aug 2026 05:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786685131;
	bh=aEi20CfO0lLOWd/hYVkbrtdPtbquzEsFzkK6Q2Nujng=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=HCJJqD19Spx5xAjtmw9K1DJE77QHct+fflslFPdzPsPuKx8TWoNsD/Qibx9KhUy2v
	 3C3KaVRIETVRji9jkfXORHpW/WSKLZ9Mc72nNXnTwE+xgiQ3/GsigTgHPWRmK7Ln0Y
	 XsIGmUS0JgnTsfVWhQKV4JB+VshXTWmonEXXZYSYzTMvuLqzg0VavEYJqA0KBUS8PA
	 /PkCE8/kZkgyU12soW8SpGYijLrvA5lN5N32TLwBavPpirj6iR3tZ2zauSF2AEbuhV
	 lXz3XtrA71YG6upoFEk7QaB9IlaDw1YG+/ajTUFtAwVxfIhIOs8w/4v8rmSf2n3ysD
	 q398Eu0rS6DPw==
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8efb708b1a0so4277156d6.3
        for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 22:25:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqlYKPUCQuAI/YwQ4YYjFByWAulH680FNkVWNjCov28L9T4dlY/xHsh4J8hvaCd07smqf3H0QZn@vger.kernel.org
X-Gm-Message-State: AOJu0YwIEQJMQmbR9PGgOsRUfPOK9egeJ8rII8m9MVat9+Ftgh7MBL7U
	Llvw1pWV4AgLCpPhUxfQ1eB6xiF/IIwSa/RUPmEY+0y/y5owTdtCUWlHv9NY62ctUNApA/LjXKv
	8tYv7K0bC4VNcTE9LO8s/ChwaivhamXA=
X-Received: by 2002:a05:6214:29c9:b0:908:949c:43a6 with SMTP id
 6a1803df08f44-90a91c69872mr34202666d6.6.1786685130856; Thu, 13 Aug 2026
 22:25:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com> <20260804-mglru-fg-v1-6-4d8dad39dad6@tencent.com>
In-Reply-To: <20260804-mglru-fg-v1-6-4d8dad39dad6@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 14 Aug 2026 13:25:19 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yBJVpHO09HNP7cRyt4NH0AX77Sz0W4ppdQcc9fY1bAZw@mail.gmail.com>
X-Gm-Features: AUfX_mzzMnQvgdbCstK5LkjY-xQ2Fpe4ooBRcNIV_EVsm8U_SmnPBE1-TTPmflA
Message-ID: <CAGsJ_4yBJVpHO09HNP7cRyt4NH0AX77Sz0W4ppdQcc9fY1bAZw@mail.gmail.com>
Subject: Re: [PATCH RFC 06/15] mm/mglru: use explicit tier range in read_ctrl_pos()
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 4, 2026 at 3:47=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> read_ctrl_pos() encodes the tier range in a single "tier" parameter
> via "tier % MAX_NR_TIERS" as the start and "min(tier, MAX_NR_TIERS-1)"
> as the end.  This is hard to follow or maintain or extend. Tier
> values 0..3 select a single tier, while tier =3D=3D MAX_NR_TIERS selects
> the full range.
>
> Replace it with explicit (tier_min, tier_max) parameters using a
> half-open [tier_min, tier_max) interval, which is the conventional C
> idiom.  The call sites become self-documenting:
>
>   - get_tier_idx:   (0, 1) for tier 0, (tier, tier+1) for each tier
>   - get_type_to_scan: (0, MAX_NR_TIERS) for the full range

I agree, this is a nice cleanup. The existing code is really hard to
read. The magic is in i =3D tier % MAX_NR_TIERS, but I've been bitten
by this magic a couple of times.

But could we make the range inclusive? Right now, it still feels a bit
difficult to follow.

Since tier_min and tier_max are tier indices rather than a typical
array range, would an inclusive [tier_min, tier_max] range be easier
to read here? In particular, tier, tier + 1 at the call sites still
requires the reader to know that tier_max is exclusive.

>
> No functional change.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/vmscan.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c2ea92c2b69e..a359d5a1ff41 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3192,8 +3192,8 @@ struct ctrl_pos {
>         int gain;
>  };
>
> -static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int=
 gain,
> -                         struct ctrl_pos *pos)
> +static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier_min,
> +                         int tier_max, int gain, struct ctrl_pos *pos)
>  {
>         int i;
>         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> @@ -3202,7 +3202,7 @@ static void read_ctrl_pos(struct lruvec *lruvec, in=
t type, int tier, int gain,
>         pos->gain =3D gain;
>         pos->refaulted =3D pos->total =3D 0;
>
> -       for (i =3D tier % MAX_NR_TIERS; i <=3D min(tier, MAX_NR_TIERS - 1=
); i++) {
> +       for (i =3D tier_min; i < tier_max; i++) {
>                 pos->refaulted +=3D lrugen->avg_refaulted[type][i] +
>                                   atomic_long_read(&lrugen->refaulted[his=
t][type][i]);
>                 pos->total +=3D lrugen->avg_total[type][i] +
> @@ -4805,9 +4805,9 @@ static int get_tier_idx(struct lruvec *lruvec, int =
type)
>          * This value is chosen because any other tier would have at leas=
t twice
>          * as many refaults as the first tier.
>          */
> -       read_ctrl_pos(lruvec, type, 0, 2, &sp);
> +       read_ctrl_pos(lruvec, type, 0, 1, 2, &sp);

It's still a bit of a headache when three integers are put together.
Could we somehow make the 0 more self-explanatory, such as using
TIER_MIN or a named constant?

>         for (tier =3D 1; tier < MAX_NR_TIERS; tier++) {
> -               read_ctrl_pos(lruvec, type, tier, 3, &pv);
> +               read_ctrl_pos(lruvec, type, tier, tier + 1, 3, &pv);
>                 if (!positive_ctrl_err(&sp, &pv))
>                         break;
>         }
> @@ -4828,8 +4828,8 @@ static int get_type_to_scan(struct lruvec *lruvec, =
int swappiness)
>          * Compare the sum of all tiers of anon with that of file to dete=
rmine
>          * which type to scan.
>          */
> -       read_ctrl_pos(lruvec, LRU_GEN_ANON, MAX_NR_TIERS, swappiness, &sp=
);
> -       read_ctrl_pos(lruvec, LRU_GEN_FILE, MAX_NR_TIERS, MAX_SWAPPINESS =
- swappiness, &pv);
> +       read_ctrl_pos(lruvec, LRU_GEN_ANON, 0, MAX_NR_TIERS, swappiness, =
&sp);
> +       read_ctrl_pos(lruvec, LRU_GEN_FILE, 0, MAX_NR_TIERS, MAX_SWAPPINE=
SS - swappiness, &pv);
>

Maybe we could introduce macros such as TIER_MIN and TIER_MAX to
make the intent clearer?

#define TIER_MIN 0
#define TIER_MAX (MAX_NR_TIERS - 1)

Best Regards
Barry
