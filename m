Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B90D55930D
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 14:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788876809; cv=none; b=ZBSOO6On2A49ymRqCIv3bTgE8PgOHf6CB3AwKIXv4gM1lywv3hHYbggbdQTBC76XrTuOUnpySjzoMxZ0NhTfANR4iB/paKQbaKmpDCaMV3DkhsFd31fiTGohH8ui1iSWW8Nh3UgLyPb8t1rb7dmUodL3wOFwDMt+tjDUrj6TWRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788876809; c=relaxed/simple;
	bh=pC6jcGOtItS2e12mvg6Rf1hkiJ5TikWx8vGxQaaWnjY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gsQBF51bLFJGMLN/txsPSTYseDT6aLJ7YZGMlu+xhS+D6b+MucOLM9XVSVixpszSmbpKmrp03nAGMRa+a3eDg1ABgRZYfE4Hlh7epXm83+Q5OydK/HhrohkVcIcRnbfmTv/LrYRZl/DdzScHHzX0ml6IHJhg064eeIMSnUgu4IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BOs0MWjZ; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BOs0MWjZ"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-482dd6ee390so5347596f8f.3
        for <cgroups@vger.kernel.org>; Tue, 08 Sep 2026 07:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788876793; x=1789481593; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3L5oRWmTUO6yAxQOWYcTnXegO65U7Igw+Adee2Oy+KQ=;
        b=BOs0MWjZyCSQnaxc8tKqRuXPfuGP+iYYdD/CqQya0kp/tF2dl7CbRxON1DB4/YZzE8
         6JUKvrvchaz6Z05USmNp710FiKTZUOUSGnMq7OypAr08dkKhDksSF9dwav+sp887xtBF
         5WlFoDLXU/tniYPwY1dvJ8b/b4E3MwIkGkuXK4tLuy8rSlUBlg1wnH/NqluFb724qgDE
         l9XiwmO1hFfA9bg7ulNKqbbF02DzNatEJzxAyOtPQcpG2mejMvf/gkL/vJzn0oYmfQOj
         VQZHcLxH8HPD1S5wkne9p4c3iHtvB3+IHpPNiH98CtPXpAuI1yKRtWPtBy/tY73TrmvX
         +SMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788876793; x=1789481593;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3L5oRWmTUO6yAxQOWYcTnXegO65U7Igw+Adee2Oy+KQ=;
        b=rAIoQtdby/Uqqyv3rp3fy4yf2w142Zc3QibI0ctKehen7vIMgEcFG3fjUw2Ic1rY8r
         P1MHdBJj+eLBvc2EJbMw0RinNVGGG5NF2gLy2ffv5PegxPOLupmSiuoq8sA7PflLdzJh
         ClIvquD4hL+dnB5ui19eiF7YiMcDCwHpnvcBDZQKDSc5p/cit1gGBF30rzOUEmEwcfuD
         lqqWbhqUXNlk3e5ktFsQdJW3PsTmxBKtKbCAPdY2n44bt8cXS2/0jmi0St/DSvBwj7vk
         m4VrCDtjweVt4l59lH9LglhnlJqdqsXkjbnzJ7reQn+AjJ7YnBPHUetdWbqCtOZjq55b
         XOdg==
X-Gm-Message-State: AFuF++n87AMMP3A5fPfHV4v8BX1fcRvLBxFJwEl8A7eBP3wzyDUgHWCr
	U1Y/1kBdeaiI/JiIKCmaFNVZvnu4n691Gquba2qZqJj7B1PQoqCS+5yZc8iFZBzgQXE=
X-Gm-Gg: AYBFou0bmXHBcAQmxtaLXBlJ3bU+J6HdhjkxtFEmrqIRlprKALSz8nRko7Xqo5onvNj
	leckxJO/fMFjOnQo+J+tAM+5FSzgxU/c9tK0qmEzdXs/JskUuMJ+0Ww9gyUELercfNYr4uTU+Q1
	ijp8gI7T21ckqJgzlx3f19+OJGX4LpBg7DncPxPBQ+8qBvr5LhPmE5fhHauwl7uxYBD2oATm6Yb
	7ZwPwJbB6dWdWtNZUeWAbScwVjhdipa9DGuu0v8bTzlupJ4lBUZme3fgF+XaDN87g0tNEvCyqWG
	UNLhr/VbRxpqTgCxpA24fauo4GOekEHPoCCBrJmChnUn5uPILrs5msR/sBunLVBhrtW9NysYu9J
	VDFa8pF6HRVBYC7O6YAIJpTgXyUa5spBczfGfMOp2QPTNJM2pA5NjeGM93/O3cpPMabFA7wThrr
	G8YZO3UR5ErDPOY65gqw5FlLqme0C8HrXVQhSgiu0xKByaCqQE0a63c+QBiyP/jc0=
X-Received: by 2002:a05:6000:98a:b0:484:3311:af37 with SMTP id ffacd0b85a97d-48587298f26mr32655977f8f.26.1788876793275;
        Tue, 08 Sep 2026 07:13:13 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4858ac2b4cdsm35144071f8f.16.2026.09.08.07.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 07:13:12 -0700 (PDT)
Date: Tue, 8 Sep 2026 16:13:11 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Junnan Zhang <zhangjn_dev@163.com>
Cc: cgroups@vger.kernel.org, hannes@cmpxchg.org, 
	linux-kernel@vger.kernel.org, sunshx@chinatelecom.cn, tj@kernel.org, zhangjn11@chinatelecom.cn
Subject: Re: [PATCH v3] cgroup: avoid flushing global workqueue in
 cgroup1_pidlist_destroy_all
Message-ID: <ap_3u9i1n8mQrObY@localhost.localdomain>
References: <apU1sXYP_QhsQFcB@localhost.localdomain>
 <20260901033923.40420-1-zhangjn_dev@163.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="i6d4qd4oqwkj5vkb"
Content-Disposition: inline
In-Reply-To: <20260901033923.40420-1-zhangjn_dev@163.com>


--i6d4qd4oqwkj5vkb
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3] cgroup: avoid flushing global workqueue in
 cgroup1_pidlist_destroy_all
MIME-Version: 1.0

Hi Junnan.

On Tue, Sep 01, 2026 at 11:39:23AM +0800, Junnan Zhang <zhangjn_dev@163.com=
> wrote:
> Thanks for the review.
>=20
> > a) a single reader taking more than hung_task_timeout_secs (that'd be
> >    a softlockup earlier),
> > b) starvation of cgroup1_pidlist_destroy_all() by many (queued)
> >    cgroup_pidlist_start() callers which goes against the second-long
> >    caching of pidlists,
> > c) there is large number of nr_cgroups * nr_pidnses which makes the
> >    caching ineffective
>=20
> An honest caveat first: this was reported by a customer on a production
> Kubernetes node. A guest memory dump was taken at the time, but it
> couldn't be analyzed with crash, so I can't give you the exact
> nr_cgroups/nr_pidnses.
>=20
> That said, I believe c) alone is sufficient, and neither a) nor b) is
> needed to explain the 120s stall, because the flush latency is
> backlog x per-work latency rather than the latency of any single work:
>=20
> - backlog: flush_workqueue() waits for all works already queued on the
>   shared wq, which drains serially (WQ_PERCPU, max_active=3D1). Container
>   churn constantly runs cgroup destruction, and each destroyed cgroup
>   queues one work per cached (type, ns) pidlist, so the queue ahead of
>   the flusher grows with churn rate x nr_cgroups.

flush_workqueue() should only block for items present at its invocation
(not later added). I assume large amount of rmdir's in short succession
may build up the queue as a one-off event.

>=20
> - per-work latency: each destroy work must acquire the owner's
>   pidlist_mutex, contending with readers (kubelet/cadvisor/runtime
>   scraping cgroup.procs). pidlist_array_load() runs entirely under
>   that mutex (css_set walk, kvmalloc, sort), so on a node with frequent
>   scraping each work can sit tens of ms behind a reader.

OK, lets (over)estimate 100ms per pidlist_mutex passthrough, that gives
lower bound of some 1200 cgroups removed together. (That's a lot but
borderline still practically possible.)

> A few thousand queued works each delayed by tens of ms already exceed
> hung_task_timeout_secs -- no single reader needs to hold the mutex for
> that long (so a) doesn't apply), and each individual work does get the
> mutex eventually, so it's not sustained starvation either (so b)
> doesn't apply).
>=20
> More on b): the second-long caching only helps readers that re-read
> within that 1s window (e.g. a single `cat` doing several seq_file
> iterations). Periodic scrapers like kubelet/cadvisor, with typical
> intervals of 10-30s, never hit the cache at all: every scrape round
> rebuilds the pidlist under the mutex and queues an expiry work 1s
> later.

So one reader produces ~0.1 items/s, with the latency number above
around 10 items/s should be dispatched. Or ~100 (parallel) scrapers
should be manageable.

> So heavy reader traffic and the existence of the cache are not
> in conflict -- the cache is simply ineffective for this access
> pattern. It also means the wq steadily carries ~nr_cgroups expiry
> works per scrape round, on top of the works queued by churn, which is
> what the flusher ends up waiting behind.

I understand that an abprubt removal of thousands of cgroups may stress
the pidlist_destroy workqueue.

> On nr_pidnses specifically: containers typically share the pod/host
> pid namespace, so in the common case the multiplier is really
> nr_cgroups x scraping frequency rather than nr_pidnses. I can't confirm
> the customer's pidns usage for the same reason as above.
>=20
> > OTOH, I'm surprised this v1-issue popped up only now
>=20
> cgroup v1 is legacy but still the default on widely deployed enterprise
> distros, and per-node cgroup density plus metrics scraping frequency
> have grown a lot in recent years, so the backlog needed to trip this
> only became common recently.

I remain somewhat reserved whether only the mere density would cause
thise (as there are other bottlenecks that may start blocking with these
numbers).


> It still serves the normal path: the deferred expiry that makes the
> pidlist cache work, and process context for freeing. The patch only
> removes the flush from the cgroup-removal path where, as you noted,
> the orphan list guarantees the pidlists head won't be used after cgrp
> removal.

Your patch looks correct to me, although, I'd rather not nurture the
venerable code at all. And I've never liked pidlists, so I'd like to
take the opportunity to retire them a bit:

https://github.com/Werkov/linux/commit/8c3d45be95841ede16ceac29d48be59e59ec=
5a82

Opinions?

Michal

--i6d4qd4oqwkj5vkb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaqAX8xsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AiCNAEAuH4tNak/UWWRTrr33e1Y
/LNO4CkrwG5PfwH7cMDM8bEA/R5qVFuVBf/N8JAqUJg5KzBs1LoIvZVOFsWODqGT
bpQC
=VMSf
-----END PGP SIGNATURE-----

--i6d4qd4oqwkj5vkb--
