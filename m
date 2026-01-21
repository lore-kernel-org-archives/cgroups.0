Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2A04DC550
	for <cgroups@vger.kernel.org>; Wed, 21 Jan 2026 14:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769007528; cv=none; b=Gua4tcfV8ac8o2MBqHsTrBqOc2hrGDgSjRcI1yKPImFrHNYXKHHRGo5sv56E723wstYloXwqAz6BvqCI8X2FaDCbIk8qdDtOKLvs0bv8cNHO+PzNBO9sjiy/qLKu/HZbjtUmdVPbSnYCqH57wE90jJKT9wZsJoqJBv2eOtwb/44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769007528; c=relaxed/simple;
	bh=TSpaqslXVbGZxXGpTfz+xXfUztuJXIMpy7+cNgi5/Mw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i89ccrmRMtf6L0ARJYk2H/39KHVaYoyNWLMPtS/dBEMW4oxh5l6h1CFp2W26GHn30Q7IoL+C6vPKKQLMoP5ywlISVv/McGvtgxsejJxJTrMn1AnC67i+tX6apF4uuevbZs9dYC6w9InTZnYNEasd8LKop5UzivpK5W7kve/XBZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=MXYU2Nvb; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="MXYU2Nvb"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-88ffcb14e11so87904856d6.0
        for <cgroups@vger.kernel.org>; Wed, 21 Jan 2026 06:58:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1769007524; x=1769612324; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=11H3Sl0B2LnnaUo00s74ciXm10QbO4phXHCmMu1QEis=;
        b=MXYU2Nvb232qVeGQias07zTPbmhVWmf6xAgDWwOrQ5tv66iPqo7nt51kFov0pXfGXv
         +ntwUAa5R+T4+WPvyr68VVwOoxZ5lgKd/z/+7VXqg7Eds23I6bEEKwBkJvZiiqvC+i9Q
         QYz48cIm1weuEHRnJaTtczah2r7q/3HB38Mg+XetvnMCH+iMs3x70ldBwWHll9ktEH27
         30LVHUzGLOZ8TVSTndBWVn3PEc+Bw0BGEszlmy7ozMdFmLGWGyFW/0q7NzmA1w5v9xKP
         T/fnPlyHyCZhmU2UYUpgBnTAj9xMawXStdJxcdcPZK+zXDOqk1dKzbdxuL+bGG/lKlok
         v59A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769007524; x=1769612324;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=11H3Sl0B2LnnaUo00s74ciXm10QbO4phXHCmMu1QEis=;
        b=t+NaeZah+2UIVoKtYy3jAmCA9aAyc98CjzcTB2s5a/oCHkK3J0/uSAvSF0fZVtLcV3
         ilf0KOFjsVAFI02cUs20zPwHa6xTr2mDJav5QQUu/e1qrMty1hL0AlSz+ESXqEVXOI8A
         g4IuIaUjegsLbLv8d5r0vrH3L56EFJjaVe9zjkCzzTwbk2aeM5B8/1Hlw1Q7LpLYI7q+
         A03kfKR/hXAkSW4K8ww5H9QB41ceal6Y6V1iHzV5qvV9EB0cuvHN7Cc3kTKF9USVVC7j
         K2qMhyIa41TA8kWS8RE48YL9Myq8ZKjo2G0HAlD1p66ho8w40b0J9WTcyB+cX2Xco6bW
         kdiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYjnuu84cDFlqIpg8I2Xeua8+bYOtwoSate3YZk9tlEtq5g4ALCCJlOB1h/k80jj/C92AHd5X+@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+y/BPp8IBx3Yz4QuMrnt1b9I62/tNvGKyvB9eaT6mhHZoJzqz
	ncJsxHDuae0zTTfT9Z3nGeh2PHwRs9EoFwqm+wraCTznbZXvfrPnDS/5+PwKaqiLzKA=
X-Gm-Gg: AZuq6aKw/6rV1pungUTubRkyTFgGZp3n0j8siB/stNx1wYfofn+wvw+x1+ow4CRyEe7
	fUSLFNEykcV22aOJ4zOaZwfvsqIJxZ1gkQjK5/36o6H/Weof9lfLgOQhTyRo3pUYx9x6hShUwh8
	K3iMP/MCG9aGvu+OL5IT8CJ93oeGBqH6CPUYCnClrPVOxhKs/SNO/X1zLULFjPt5sek8MY/oCfc
	sevI37/82+qp6MeTQTNsUImyMRpQVdgJizL/ZNqugYWVQo/ohuQ6buK/OdJKCV4NC0YSSXMMowV
	/3ACFs+Vw7hHncbqwlN+N/n4ad3Sn61baiopJq/FoAk//XZR3UjTnBoVQq3c8Xm11q+T2xtm7oZ
	JSpKn2HyyUH7TWjA9y/9mf7xSdy+kMl0HjetReQ+8487DpjRGC7QnLhMPnnw6n6VeSsV7CTuETA
	2GeaizFVZ5TQ==
X-Received: by 2002:a05:6214:400c:b0:888:498e:5a3a with SMTP id 6a1803df08f44-89463d16ca5mr80297446d6.68.1769007523747;
        Wed, 21 Jan 2026 06:58:43 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8942e6c9a9dsm132520486d6.43.2026.01.21.06.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 06:58:42 -0800 (PST)
Date: Wed, 21 Jan 2026 09:58:42 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot <syzbot+079a3b213add54dd18a7@syzkaller.appspotmail.com>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, syzkaller-bugs@googlegroups.com,
	Muchun Song <muchun.song@linux.dev>,
	Minchan Kim <minchan@kernel.org>, Kairui Song <ryncsn@gmail.com>
Subject: Re: [syzbot] [cgroups?] [mm?] WARNING in memcg1_swapout
Message-ID: <aXDponX2AQoACOaI@cmpxchg.org>
References: <696b56b1.050a0220.3390f1.0007.GAE@google.com>
 <20260117165722.6dc25d72fd58254cb89e711b@linux-foundation.org>
 <CADhLXY6ACKeyLrjARTTdfWyrvUdLbtD-wXiQvsvhsbGjwmUqDA@mail.gmail.com>
 <CADhLXY7FJqRLjX7X2yJfa0=iDbUAMwhS35cOEExW+qBJWAnt+A@mail.gmail.com>
 <20260118125311.e1894f598e2a8ef626f47f25@linux-foundation.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260118125311.e1894f598e2a8ef626f47f25@linux-foundation.org>

On Sun, Jan 18, 2026 at 12:53:11PM -0800, Andrew Morton wrote:
> On Sun, 18 Jan 2026 12:31:43 +0530 Deepanshu Kartikey <kartikey406@gmail.com> wrote:
> 
> > > >
> > > > That's
> > > >
> > > >         VM_WARN_ON_ONCE(oldid != 0);
> > > >
> > > > which was added by Deepanshu's "mm/swap_cgroup: fix kernel BUG in
> > > > swap_cgroup_record".
> > > >
> > > > This patch has Fixes: 1a4e58cce84e ("mm: introduce MADV_PAGEOUT"),
> > > > which is six years old.  For some reason it has no cc:stable.
> > > >
> > > > Deepanshu's patch has no reviews.
> > > >
> > > > So can I please do the memcg maintainer summoning dance here?  We have a
> > > > repeatable BUG happening in mainline Linux.
> > > >
> > >
> > > Hi Andrew,
> > >
> > > I checked the git blame output for commit 0f853ca2a798:
> > >
> > > Line 763: memcg1_swapout(folio, swap);
> > > Line 764: __swap_cache_del_folio(ci, folio, swap, shadow);
> > >                     (d7a7b2f91f36b - Kairui Song, 2026-01-13 02:33:36 +0800)
> > >
> > > Kairui's reordering patch appears to have been merged on Jan 13.
> 
> Eek, there are many patches, it helps to identify them carefully.
> 
> I think you're referring to
> https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer-fix.patch

This was supposed to be the replacement for Deepanshu's patch below.

> > > The syzbot report is also from Jan 13, likely from earlier in the
> > > day before the reordering patch was merged.
> > >
> > > So this report is from before the fix. The warning should not appear
> > > in linux-next builds after Jan 13.
> > >
> > > Thanks,
> > >
> > > Deepanshu
> > 
> > Hi Andrew,
> > 
> > I tested with the latest linux-next in sysbot. It is working fine
> 
> Great, thanks.  But we still don't have review for this one.

IOW, this is not necessary anymore. Kairui's (cc'd) fix which you
picked up fixed the syzbot reported problem.

> For some reason I don't have cc:stable on this - could people
> make a recommendation?

So this:

> From: Deepanshu Kartikey <kartikey406@gmail.com>
> Subject: mm/swap_cgroup: fix kernel BUG in swap_cgroup_record

can be dropped.

Please correct if I'm wrong.
