Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793646973;
	b=IX/8bTDN/KS8/PQ96AXK2YxFad0VF92nlKypcLs4cZzVUFSZk5sfFbZU5hxvdRviH7Kk
	 7Tfr4yRq805/Ae4IUfB3JUtwIgFwWCpYHqYTHznGwT/z35z1scZTCHorM52f8+pTC7Hb7
	 pUcWVSXe9uAcrIn/csKCD12J7Dxy1lnar7EISUiKEW6xYH4Q2PfIZ1lqQazYFSdc27Xmo
	 w33yWxxWmZ8qYtEOgFXlsTmIbnTm2dkLg8rQb3x51T7wwRUGQKMgVc7NWf20b6MxORIZ7
	 3AtvKF2Pq8eG3gWWjY6FGZeXaZKQPrfA9FLBuAxORuHu8U0VlymISrtIJ/tgEQGIYyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793646973;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=xSwUt1ejfmZqGDfLTWVnhEyPBYCa77Ql8jnQXRCQM2M=;
	b=Y6N5kcf9bkduYvNHJISOA0d67eD0lQ+jfyR7DX1NV04etHcR/y000fLHofGz58tMKzdm
	 CuIQbCl7J8OBpolCfojMdgMYTHmzDuXiWlp1UrS9mKjJwzzmtN7rjviixeL3bNAfpGOAz
	 i1pjPa95WMpGdTr6mmMlvRUq980QgXprkQs/FNuXAx8/b9Whc2t0m5Ag8HlLXcu+14FM6
	 mmlgqawA3iLSpE+WruCeh//rJquc24TbalokN/qt94MNlFTFWycbf/BQGWlQQ4tqx/vFp
	 M8DG62wgkaLLE+20KBcdkbsOskxve2MLutiz/WKbEreDRDQk/K3iQ/xjbm8oBwsAt/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmpxchg.org;
	spf=pass smtp.mailfrom=cmpxchg.org;
	dkim=pass header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=UOioP1aR;
	arc=none smtp.remote-ip=209.85.128.181
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0E2606D82D
	for <cgroups@vger.kernel.org>; Mon,  2 Nov 2026 19:16:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA0E2606D82D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=UOioP1aR
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-8ab3d3c5761so32144717b3.1
        for <cgroups@vger.kernel.org>; Mon, 02 Nov 2026 11:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1793646967; x=1794251767; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xSwUt1ejfmZqGDfLTWVnhEyPBYCa77Ql8jnQXRCQM2M=;
        b=UOioP1aRX+ng7fQt90I3I7lPAuhsKrdkNHsgPY3jQrIPnM1M1whRaCshqEpYerLoVS
         Vb3sBlSgNgQNmfR2dafkirCXTn2zckbDU4vg4VWf4Bks3VJeQ3KvIq4Ac4ieWAjoC3M9
         TVHxSZF9g6Z3OAoKOyEoT6wjVd8oUJSylcA7krfbtrnBPMmmMLXFse1Z0MSvXUvGMdBy
         l09Uco5QfpGgegpgEI++HFOG/x+8gxhhQuEYB6MiwGfWow/nG6hDqWz2Jb0VRNfpOiMu
         Myq+QrSQeu4fKyiBvaJQdU+754o+ApUDj692D1MAKDanYf2on4+BhkfmAnOKcovO6BX7
         B1kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793646967; x=1794251767;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xSwUt1ejfmZqGDfLTWVnhEyPBYCa77Ql8jnQXRCQM2M=;
        b=DEfwj+WkIOD1ZixnMCXPL2QGs2/eDAZ+mhwmPc+JhWRdYqtaHbefbk/K6X/jvrUa5U
         bJ+0V8RBtjN9V9UjSdC0dxKt3qFOd/ByM6N9PPJCCzthzOiF1g91SMYv4ntlk/22M9ua
         XSHCQ2pxMuTm9FguO0t42cq+SYPjIziN8FFbP5iC2sBFre/TELWlCo/CcczXkxonnRoL
         82+Khk8mB3cGpQ23V5K6Gru4h9HYH0D3UoaPLuLOwaPNqVwXPrniUcdu7jx5w0cAp6kb
         7VgvIZadNQ7/K38SsbCSfGY6oZi7iDmlTi6qASy9Vw/Sq911OvGID3M80AM8ikeGPL7R
         eCGg==
X-Forwarded-Encrypted: i=1; AKwUvBxpFDIPUnkjQdX53cHutIC7ab9XswRQsKPb9OwrytVlwILZvUSGSSkrpBatHEqnbhywTcTlLq/6@vger.kernel.org
X-Gm-Message-State: APuU4Z+KEsNwNLfxSBWS+QY7kEFRbzWnfto7cj9wYHKqEmhWQ0u+7Jaa
	Gmyhjbmqfp/a6L8igiKr7heZ0x2Kqij0H2SB8EmO+AlXB3N+4BcwKZYS6aDeTZsZwRI=
X-Gm-Gg: AYBFou3vWBgUoFce+fhg7hVjA2vjIl5YRwneTVofkmlMlBOOUpo1cEiuFIuJCnN1QPU
	5aIPcC2jhV9hNtECE/h7bTb5engOxnS9UdXV7R7mY0J+AAAum7pViot4FC02A17FN7cXm9YqiKS
	dzFFmigxg4H6AmG8XyYwEGhSA11BcZsajYQ+1gSk0XyUfwrNy/jpW44qnmVLe4mda0CrytjKHux
	BOV9OjOESJuwJmrp+4hpC7XsQBHb6QcVbh1WAJk4mRE9sc1AxcsstN/xTIdhYklbDfGK48tST/L
	Mmj85BJvu9ox3yOTDxCpMv5NrTJWSGybqcZRBBD7WYGQmpJFML6Py+JyybGUTQ8LVY7XAMA9nct
	HPj818yXsspewkhXxewW/3ost0geOla2Idy4wE45KUhuNhWwUO1rjSfBFb7l2X7qvS89WZel7Ad
	Ja8xjnssO3ml1j5v9rxDnlp3OTkt6XvTdpxBjMtyLr4Q8zFmbirn83LOMwEVNrKhNXPrD6lrsJV
	WkEfmzh1KkS72fGLdWvr/I9WNPkl1bAnX7N6g31+xd0SVGr7ChIQmfvJYdSAGyxBIu6I2pPRsVZ
	qCJNsKhPDmmrcT2oEm2WZxBOkPzcJvdsojMR3Z8n0fki856x
X-Received: by 2002:a05:690e:191a:b0:67b:9a76:cd0b with SMTP id 956f58d0204a3-67ba4edd88fmr8834059d50.28.1793646966752;
        Mon, 02 Nov 2026 11:16:06 -0800 (PST)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67baf147246sm5737296d50.1.2026.11.02.11.15.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 11:16:00 -0800 (PST)
Date: Mon, 2 Nov 2026 14:15:52 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tao Cui <cui.tao@linux.dev>, Michal Hocko <mhocko@suse.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, muchun.song@linux.dev,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [RFC PATCH 0/3] mm, memcg: isolate deprecated v1 state from
 struct mem_cgroup
Message-ID: <aujhaEfimB0S5Msu@cmpxchg.org>
References: <b36ab4a7-b692-49e8-92b5-1dc4d76dee00@linux.dev>
 <0BEF7489-16EC-44EE-847B-A6AA380BE11F@linux.dev>
 <32e80536-64e4-4ae3-a7da-4a37ed415f0a@linux.dev>
 <7ia41p9341lv.fsf@castle.c.googlers.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7ia41p9341lv.fsf@castle.c.googlers.com>

On Mon, Nov 02, 2026 at 04:52:44PM +0000, Roman Gushchin wrote:
> Tao Cui <cui.tao@linux.dev> writes:
> 
> > Hi Roman,
> >
> > 在 2026/10/30 14:05, Roman Gushchin 写道:
> >> I believe we want to delete this code sooner than later, why would we rewrite it before that?
> >> 
> >
> > My assumption was that v1 would still be maintained for some time
> > before its eventual removal, and the goal was to reduce the coupling
> > between the remaining v1 code and the shared core structures during
> > that period, rather than to rewrite the implementation for its own
> > sake.
> 
> I understand. But personally I don't see big issues with the current
> code caused by the v1 stuff. Maybe I miss something...
> 
> The proposed changes on the other hand create difficulties for those
> who use v1 and maintain some local changes or simple backport upstream
> fixes. Of course, it's not a reason to not change the upstream code if
> it's justified, but in this case I'm hardly convinced.
> 
> > If the expectation is that the remaining v1 implementation will be
> > removed in the near future, then I agree this work becomes much harder
> > to justify.
> >
> > Am I being too optimistic about how long the remaining v1 code is
> > expected to stay around?
> 
> Well, Idk, it was considered deprecated for quite some time already,
> so maybe announcing that it will be deleted in a year is reasonable?

That might be tougher for v1 users than the member placement :-)

My understanding is that there are still a few heavy v1 users out
there. I'm not sure they can move within that timeframe. Personally I
think the cost of the v1 code now is kind of negligible now?

> Shakeel, Johannes, Michal, wdyt?

I was a weak yes on Tao's patch. Happy to keep it out with you and
Michal not being fans of it.
