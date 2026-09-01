Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22E936E494
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 14:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788271901; cv=none; b=mp/PC3fLpFpn/EV/GoVamXXxcOM18ozCX6y6Iq8+e5oK5B4uQo1JIsZ2gIViThLghbc+gI0wj2r6nVQ9WyuhrssGaZVA425V65oOVUXz+ZpObFpLBtQNxN/2DzGvyrYL5dbbCGsIAdGYsCmX3LQtggR3l4f2IRBd8s3T8p+EZik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788271901; c=relaxed/simple;
	bh=8+R/OeIp1ZVk/DP75Xjsd85p+yJ8w89tCQWny8G0Cs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ot1TkTu/Namv19/pdbH6pfoAtBRATFAY01sOvWesEHqMe+5vsAhsiPeWmOpigN7XG5QYyHnqn7Owrj8jlWFfJQEW2QB6geYoeWNUsLYvUtbvK9yuVBpRLEB/+bn5H7XEVPTiJGjAYFlrX+nhmwqbxM1r5bGlrojccnrELnKffb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QhozI6lU; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QhozI6lU"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-6b1b766bf01so1204971eaf.0
        for <cgroups@vger.kernel.org>; Tue, 01 Sep 2026 07:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788271899; x=1788876699; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LHkkshZ3PVxOZzqbwKcqNzDLof8u7Tm/vxYAm4UhRQc=;
        b=QhozI6lU2wAuesiwcxU/pDALzIzwY3lMI/ofJQn2yS16RlXDXJkKUyWeKGG/E2+DUf
         FA2qR1SdT33hmBHvUgwmuCj2ZNtfAOVPSRM2H4eoKGBDg23wM7K1d6s5XIzykSSc8ihx
         YaaeMLZuudD7WZ2drZeNp2ZzwLxkejLFDRPeikOTXw7f1HYgSPVQgEqKW1MzuNWFxomV
         jEWJqw5WpToc0C4GKqm9cUyo9gIuPNYCAhxrSmCjEPUd1Lf9+YjU4U57tkRfo9Q89Ymj
         FG+1eaQ5w/WQoh43d+54kwiBPCevmoYG/j/U64htniHa6IxYjSHhnMIOhDjHam8yMldy
         IMrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788271899; x=1788876699;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LHkkshZ3PVxOZzqbwKcqNzDLof8u7Tm/vxYAm4UhRQc=;
        b=VkyIi4DTYuXQi753LZKHu8Gdw5aG96v40nW6ynLu+XtPXlI89VtZuxdO7r+uQkts/J
         9FPRPP628C4xmyIaJm25NrgN8bT0lfcum4scR8094X53N4ASFAEJyS0X4Bkx4HgsXzlL
         mlOAiLaSXXZ47kPqHk2Rhi+qU66Vp8GBTP3kWQyu8QEvMtf1SCfe1YK2s/DBzV+Afv3p
         YRZcmbxMKGzQNqv5tihjDBlTnZnYDWCv4UtJgke3UJZvMv/KzhGBVy9QCX8hq12Fk8jj
         BZn+MUlIkW/QHR+75yOOuuUY+fpVVC0EdBUvAk4SMaEAJkytB9SU5nhpJPH08KoAsqZB
         iazw==
X-Forwarded-Encrypted: i=1; AHgh+RozpL3l9E5YUzLD+8DX0vYqXxSnEegG0K5AnX4P2/+oA89yd7V4D2iIyZP3bleDnd4P8HIHVsS8@vger.kernel.org
X-Gm-Message-State: AFuF++mG2kY2Z46AtsfB/bCbAbWGm3TtUfTQGpWe3CwVVOVgWmLe70eg
	o1rKILZ3CvqZPPPL9fwhwBLTEO2lxG6J3uFXad2OI4VaXpWZ8TpZerme
X-Gm-Gg: AR+sD1098duZ6MVTGTCwlV06476phFI077BemNkjssReD9TuziEvtVdNNGss2rb1fYX
	ZOnG7Iks+WOH+0nu+swRXrmgtJVYmqtYbkv7l1XUN5hWRGCYgw6u7rrlHNWdseMqW4Qu9kgwmE1
	DmgsY6EChXy4nI8wX4vvOwnCMbEpTmz3qL/KHcow2KcdSuiebw9ypp4VYSwKdUbXu9gf087KG9X
	5+MlHKH4pspoV0VRTpQJqsTkoegZwkvvd3LRzRxFusOVSqZbComGeOkReFHkv0xkfv9X+8bppDF
	ssQdYs8EiijJhVmxrhy8y83HrL1mItO3fn7aeDakTFCwpmmq1LmrdsSvTKmo0agfAoZrz5NUuPt
	zQ+a21jtqriypwMdJpwjLC7A56QbKvo4oESHWc2xiRXePHDra5VfiM8E3y5Ol+iOkaa0Jsp0c6N
	EJBxn3m1BSyCLBumOe/e66M7Smkq/8DkPRGwD3f1l1s3DkdwwbE9CH3EgqNiZP/h5fRklTDpkvc
	HG8XkiXBp+iVENGZU0=
X-Received: by 2002:a05:6820:160e:b0:6b1:464d:4d1d with SMTP id 006d021491bc7-6b1c65bfcd0mr34936183eaf.11.1788271898644;
        Tue, 01 Sep 2026 07:11:38 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:49::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b1ce359f82sm13402124eaf.14.2026.09.01.07.11.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 07:11:38 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	dev@lankhorst.se,
	mripard@kernel.org,
	nat@pixelcluster.dev,
	tj@kernel.org,
	osalvador@suse.de,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	kernel-team@meta.com
Subject: Re: [PATCH v5 7/7] mm/memcontrol: add stock to the memsw page_counter
Date: Tue,  1 Sep 2026 07:11:35 -0700
Message-ID: <20260901141136.1871423-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <apaZdbM_l3kJIiyK@localhost.localdomain>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Tue, 1 Sep 2026 11:40:31 +0200 Michal Koutný <mkoutny@suse.com> wrote:

> Hello Joshua.
> 
> On Mon, Aug 31, 2026 at 09:37:51AM -0700, Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> > Before this series, each memcg had one stock shared by all its
> > page_counters (memory + memsw). Now that the memcg stock was folded
> > into the page_counter level, give memsw its own page_counter_stock
> > so that it can benefit from caching charges as well.
> > 
> > Note that while the allocation is conditional on do_memsw_account(),
> > the freeing is not; the freer will only free non-NULL stocks. This
> > matters because do_memsw_account() could have changed in between the
> > allocation and the free.
> 
> (Just a passerby comment, I have no remarks to the overhaul.)

Hi Michal! Thanks for taking a look at the series.

> The change of do_memsw_account() is because of re-attaching the memory
> controller between v1 and v2 trees. That's not so common operation (but
> not ruled out), pre-condition for that is that there's only a single
> online memcg, namely the root memcg. So it needs treatment especially at
> memcg offlining (which is what drain_all_stock() (also) does).

Wow, that's good to know. To be completely honest I dont have much
experience with cgroup v1. I didn't realize it wasn't a "switch whenever
you want" type of operation. Good to know that there is some more
guarding there.

> I don't know how expensive page_counter_drain_stock_async() is going to
> be [1] but the v1 parts here could could be guarded with
> !cgroup_on_dfl(memcg->css.cgroup).

The function itself should be pretty quick. It just frees one CPU's
stock, but the rest is just scheduling a job item.

> Regards,
> Michal
> 
> [1] Now, I see in 5/7 that there's the counter->stock check which should
>     be quick bailout on v2 (maybe quicker than the cgroup_on_dfl()
>     I proposed above).

I'm not entirely sure, it's probably similar : -)
I think they should achieve the same goal, and hopefully it wasn't too
difficult to understand why we don't have the cgroup_on_dfl() there.

Hopefully the rest of the code looks good to you too. Thanks again for
taking a look Michal, I hope you have a great day!
Joshua
