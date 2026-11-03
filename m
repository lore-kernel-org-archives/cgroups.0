Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.128.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793666069;
	b=ExQEH1Ba3Hs8rIADpWJGV0Cg46KXR2rrgSZfvAv+oiywteicEzD5+sgwYvPeftrNjlPz
	 5VT2MKCgq7JHm4lxcKn8mwlu20kPQN2SRW0TuZC34BVeJiNKOJNhewAYWauHw/eju6wCS
	 Rr+rwYR9pW4lG/Z9/23umtIf7NGzNBQ1Pg+iTF/JB2llZZOan5bW7rbAYdKOngvJmlYX/
	 Ca36j+jxoranOYGWh9xJ0t9iH8AuRgPJyJcHSgw34LvxOvS9ngMPH8E07vw5h8szznk3D
	 Taxk5aXCdXasdvsWInXLrY8TwyDj8ilwI/6ksL9gN0GpcFpiCtypxrTSoMsJoVxBKJA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793666069;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=XRINIeGwYTp4FrvxpE2WlXAbCO4jFumeYsCTIBvLXl0=;
	b=UlCgyer1AdpekPezGp4H4rxnjQ91hS52dF2LwBmZoIt5EsZ+ciDQcohLB6K7W3+iIvwd
	 sIz48NAPtL97znkl6XBeXHlCicHG/sA5OsWMLX2idqC6ZpqajJbxRp039E1UbDAxHu+c2
	 VQZubibzPmlFaSxtgwlbN0SfB5JjGEORHk+HpNoeTwfsLNXbsE70Bj7C8ZxH8/aEbbCD+
	 I+8eyuzsyaNxeGAJjwszyGgdA2CUoc6LGTObWkhlbWLYAO7fmSCm4CzcUrHEbUKb/K7vJ
	 R6SKskviUKKvHKRSKRD3zWe+DONl+C3Ihz9cNLjdQqg7Y1EJdmozl0O1vcy/uvdANMQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bbzHk3Mj;
	arc=fail smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F55606A324
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 00:34:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96F55606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bbzHk3Mj
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a5177d78c7so36181365e9.2
        for <cgroups@vger.kernel.org>; Mon, 02 Nov 2026 16:34:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793666067; cv=none;
        d=google.com; s=arc-20260327;
        b=iu62WtfbYdXYqGV9kjZ5PiXbYAaJIrXbotFWatDzgyaxOO41E+6wgyAn8YadndTPZM
         a/AA69cUzcVh20Et4t7tt503FXrfTYU/K32r+TIVa9jBzLmO8HoDcf3NF1WqXRzDZGrO
         BsWQqItxerKl4QR254MD+6N7FYCq+0z6SmRT/I/Rd1sjaU4kWTICURaN1q2nxGytXxXu
         oDXzXJ6IWm1LftJBYMqCe8eLM3sG9nK2GpdzDWY1797xRBFLNlF2ywgWPWWJy0V3TxcS
         FNE6sU1H/ocLX04h58bN6QYlif/ZDgptcp6R/ktK1nBccBQxzmRYn9qaCdzs5svvACGF
         p3dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XRINIeGwYTp4FrvxpE2WlXAbCO4jFumeYsCTIBvLXl0=;
        fh=194kNon0fJqf733l+CE/B+I2Or5emURAe2ZOGi87fJM=;
        b=KhPnWJeUdPRlfUGFuLkbKTE++NPxHf4RgydcVxLGv2dqITiPTL10K1Y/c4V+/6446W
         EKo1K4Ne+fo+P1t53tEkbbiXUuyRCA0Gwpa7OmjCCfTuxUr9+eLSncroai/jEHAdBkcf
         LhecWUZhiQtRwT39xClNJanrzAmGMaoQerYQMl7c0TKtZVyPir7yC3z1ylyrdq9w6SEh
         SnMoAp28Ms/YnoUkyB29rBRDFuPNT56kVmtwrUSrUWpwwo+bSctWyFWZHhdfvs22xXfr
         KqkHVsNCDcZkkuNwn8g6CzgmafNe8v2x0RaaeTvJU2lNOJ6Jm2mHSNp+GC/qqTuOeC4B
         q+Lg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793666067; x=1794270867; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XRINIeGwYTp4FrvxpE2WlXAbCO4jFumeYsCTIBvLXl0=;
        b=bbzHk3Mjh7fIhE4luXlSjWmREfilPqabLaA6I0cOsuNwkyXGgVYGhzJqlngdSuL2UW
         a/JlHJDdAnfLr+cO/hoRKmxNGbnnRvJcVWW6cwAuSsXoARJNGPH5YZQzgnWJh4ROIn6M
         y82gKUjBoLYq6b8JJ3EIROexYOHy9Okpu7T8uSgDhB5h+jYU4T3gsapO7vUV770kIi0q
         0je6Vl4uWCbk3W053o7JHBGinceefQmdnEQ1KE4+whzDMNJhfBKm/+TSeXZOVP7sDAUt
         zC8TB6A4zIaBpVPDZd33Q0kHCawbuS13hg4BF8MsYQcqKLFjyKrhIVID15K458Qz/ZtY
         //TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793666067; x=1794270867;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XRINIeGwYTp4FrvxpE2WlXAbCO4jFumeYsCTIBvLXl0=;
        b=wz436A3dRVtt3YP9/gX4/wBu6F06KO4ujCoaefdrqISuLeVs4EKBtkTtFABNenkpQ4
         Bi8dJL513gbCUZJ1IrfgDWL6EV4yi36mKWib/31XXt4SyhmYfHsv/sZeaQjw4aGLXEzU
         4YGB+yvYZubGkgcwum78WvykazCE45MtVMaGGamhq1WTjnCMmlOzN4iImxKmoVrClk0L
         0VgCau/L5U3VExrKnCTxfBsjYxJsPgiKmqZTGq9CtmCJJJnpULjUMzs2gaBZa/vq5qii
         NNfU74DGwqoqDKfnbNCC33fnV6rBPyqRIqmtSnAsJROKRmYdhA+l9uWlDg4kX2cMCOJ7
         CndQ==
X-Forwarded-Encrypted: i=1; AKwUvBzdrthRo0HShB0t4GkCXwpCAFoR7WNOJp4WPCR3Y7S4y7vQLcqHOmH4xteunMf+rqn2Qhinl6U2@vger.kernel.org
X-Gm-Message-State: AFq9FYJ6dGJOm57UjGeboK8m1SvqQ/vO3kjFQM0H3g5V55mKW0qySyC0
	039lz+KdPWamsB4108WlNpnyWrYl9OaaPdEIj+TRw02Zc/CqhgqkqCWEPygHKq4zJI7NGkUEWX2
	QMSgFqu0PpEMEnyTFpQnvB9E/qczuGDM=
X-Gm-Gg: AYBFou3zvH+h/8t+KgpDjJS5IWg26E6F5lwR0fDJDjTbO0eMT1CL5onsCYhY9J9LeMv
	ESNT2uO9Uf5OIHIPmXfJ5dH7XtoroLWJWLKUFJoekFUq58AW+mAbAUlKlFwWd4nqfEGT/NKbUtV
	N7O1hDntN+jdZJ5LBfbJ5TOZwb/o/EnlJLBPSVtPaI+0QX9uoWWhmlpwZ8G1hEAKqs1Irg6GtRa
	f65BYBeWaxgRtIf1QZ6+hCF8GM0pRgKrDkX9qD4CcmF1j/ezbiJUTuayjsY9Grzt4041nL79eW8
	7a72wI9bYwPhOqLPksZqbeW8IkXnKmIIjGXSEc1noVBe0zLP2FT6J4knI7BOlpFepGfffgEw1rU
	phMN0wIMx4YjTglSZwGXTqsSv36oiDrY7+mSYIadkLhTxFTmetpaH8o9rigRbb+tpyiu1xRoRmc
	jGtswXfQ+yoe4sM1hclA==
X-Received: by 2002:a05:600c:83c5:b0:4a1:f377:5c75 with SMTP id
 5b1f17b1804b1-4ac19329ea4mr232160515e9.33.1793666066806; Mon, 02 Nov 2026
 16:34:26 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261102225030.2743129-1-joannelkoong@gmail.com>
 <20261102225030.2743129-3-joannelkoong@gmail.com> <CAO9r8zP87zRuoFqeKFcAJoCrOG8M+7HCtX6hvxwdLzuHUXD0Gw@mail.gmail.com>
In-Reply-To: <CAO9r8zP87zRuoFqeKFcAJoCrOG8M+7HCtX6hvxwdLzuHUXD0Gw@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 2 Nov 2026 16:34:15 -0800
X-Gm-Features: AclHuK-wLxIuA5jPEmYu8qdZs5cxSk24od2LIZMBLDhfUz5W71RVH8v1q8qN5MA
Message-ID: <CAJnrk1bv-P_TQztAGiHYdfg=5hbj4GREML2M0Uxp5oC1R9J-Mw@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] mm: memcg: read root lruvec LRU stats from the
 node counters
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, shakeel.butt@linux.dev, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, sj@kernel.org, david@kernel.org, 
	ljs@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 2, 2026 at 3:29=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrote=
:
>
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index ac6c43ea8c5a..938843346571 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -587,6 +587,50 @@ unsigned long lruvec_page_state_local(const struct=
 lruvec *lruvec,
> >         return x;
> >  }
> >
> > +static bool lruvec_is_root(const struct lruvec *lruvec)
> > +{
> > +       return !mem_cgroup_disabled() && mem_cgroup_is_root(lruvec_memc=
g(lruvec));
> > +}
> > +
> > +/**
> > + * lruvec_lru_page_state - read an LRU stat of an lruvec
> > + * @lruvec: the LRU vector to read from
> > + * @idx: the node_stat_item to read
> > + *
> > + * Like lruvec_page_state(), but for the root memcg the node counter i=
s read
> > + * instead. For stats that only track memory charged to a memcg (LRU s=
izes,
> > + * workingset, rotation and reclaim writeback counts), the root memcg'=
s
> > + * hierarchical value equals the node counter. The root memcg can just=
 read the
> > + * node counter directly instead of going through rstat, which require=
s
> > + * flushing. Flushing the root memcg flushes every cgroup in the syste=
m.
> > + *
> > + * Use lruvec_page_state() for other stats (eg slab).
> > + */
> > +unsigned long lruvec_lru_page_state(const struct lruvec *lruvec,
> > +                                   enum node_stat_item idx)
> > +{
> > +       if (lruvec_is_root(lruvec))
> > +               return node_page_state(lruvec_pgdat(lruvec), idx);
> > +
> > +       return lruvec_page_state(lruvec, idx);
> > +}
> > +
> > +/**
> > + * lruvec_lru_page_state_monotonic - lruvec_lru_page_state() for delta=
 sampling
> > + * @lruvec: the LRU vector to read from
> > + * @idx: the node_stat_item to read
> > + *
> > + * See lruvec_page_state_monotonic() and lruvec_lru_page_state().
> > + */
> > +unsigned long lruvec_lru_page_state_monotonic(const struct lruvec *lru=
vec,
> > +                                             enum node_stat_item idx)
> > +{
> > +       if (lruvec_is_root(lruvec))
> > +               return node_page_state_monotonic(lruvec_pgdat(lruvec), =
idx);
> > +
> > +       return lruvec_page_state_monotonic(lruvec, idx);
> > +}
>
> Why not do this directly in lruvec_page_state() and
> lruvec_page_state_monotonic()? They already fallback to node stats if
> memcg is disabled, why not do the same for the root? Are there cases
> where the node stats are not the right thing to do?

Hi Yosry,

Thanks for taking a look at this series! I don't think we're able to
do this directly in lruvec_page_state()/lruvec_page_state_monotonic()
because I think there's still some places where the node stat and the
root memcg stat are not guaranteed to be equal.

The stat I was looking at last week was slab's NR_SLAB_RECLAIMABLE_B
and NR_SLAB_UNRECLAIMABLE_B where for those, the node counter value
can contain memory/stats that wasn't actually charged to any memcg,
which I think means for these cases, the node counter values can be
larger than what reading the root memcg rstat value would give. The
functions I was looking at were account_slab() and
memcg_slab_post_alloc_hook() where the logic adds every new slab page
to the node counter but the memcg stats only get updated if specific
criteria are met (eg the cache had SLAB_ACCOUNT set or the allocation
had the __GFP_ACCOUNT gfp flag set and the allocation was not from a
root memcg).

Thanks,
Joanne
