Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792524936;
	b=SlSRDt8iAMr9/nsJ3cC2bj7/7L9OFD/zwvN7o9tQGFyw35B+u9/iqrDVmxddBJHbfwr3
	 nbt6dnFl2y6joxdSxWl3gEYn+U39hM9f1MkRIDPhXTvfAYcB4ukxxOzlloQc5qhx6aINC
	 ADinlhj6TUbcrCp8hl1xO6OB+fu35j+p35lNBKoBgeVeCkpYWabEgqbqu7Tmg6gphsNBQ
	 /8keJ8dnYG1QCvTkY/npk1R+DB7CJCLmlhTJ8VouhNZfmufx+BMvrPdV/BE+wQJL0JF8+
	 geuf02G9Q2GfOoCk9EzILA33lP3NEgLIvQtFTNJ/WXBTXmyrOf7J/PxzYBuDG6srUAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792524936;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ckZOjrI/a8l3XvmSOhJFFANe7UEtEpi/7X1L9+I2s3U=;
	b=srsx3dZYslbDpGe/AEGWx7nXvnKbyGkb2xEp0Rtje11QwEqSFGbaYPyHXkkK9K20ysYv
	 W2Zs0EWugXwzYKNY1tvSjWOJdfhqbblz1FzpKkv8Rdvvl7HPh6p3sXsdOujkgupr6+5vG
	 YGL0sUUXoVaCqQJco+Zoaa3qT+eWnGVyT8EQIp07zUHB2l+5iIK1nDQtO8IFc6PRzP0Xb
	 6zYja2Sb3G7IglWKWmHwAp715CStoOZOFSsY9bm0oMZWSsnmjXkf9Lxww8ZlJxq0Hpqxe
	 XsKNyf2fEpyxSn6ITvViDcAZjzvdtmZnwzUhaBvs5dZeWnfiUo0FcoI5wxA/uWneSOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=gmY33Id6;
	arc=none smtp.remote-ip=74.125.224.54
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A11606A31A
	for <cgroups@vger.kernel.org>; Tue, 20 Oct 2026 19:35:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22A11606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=gmY33Id6
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-67999045530so3278041d50.1
        for <cgroups@vger.kernel.org>; Tue, 20 Oct 2026 12:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792524934; x=1793129734; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ckZOjrI/a8l3XvmSOhJFFANe7UEtEpi/7X1L9+I2s3U=;
        b=gmY33Id6/YX/KAzLgWkqqt+Iuo+qPU6zhIHv75EOb/WPkSpBEVdKkVpKzpyNgu0qpf
         rb6qjzcSjfiDs1vNxrtLIpab0HP57PSi5J3JPUYt/d56lSJ5Eura8DgB3fLySeeQIyi+
         zvfsl479xaP5EM5mFLB1q0Bsse45Vo27OVmic4XjBf8ytPKKGoQOhSnhYj5WJD9oCpfl
         FFd5Hmn+3rxvVFrU82a+Zf0H5n8Fh0iiJlZOkeGHQJ/1xN1qCe/JUqKHP5VN+n6oK5ft
         SMh0PiPvNXbzRQCxvT651V1hJvsOROYLW/jHuOGi2bfPwupC2XpSevFIVtQPr9rJALVK
         xZ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792524934; x=1793129734;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ckZOjrI/a8l3XvmSOhJFFANe7UEtEpi/7X1L9+I2s3U=;
        b=bRajD3hGhz7tkBb04CeYTca4bOY71JJrBgpAOzSBWEoJlvYTViLi0sOyts1W/AsPW7
         OdMo4yyNO4yWjwrGGx/WQIe8/xFd5otGJGLcniCxONamgijmrlureyDUGMDYtshwmHEl
         36pUpod3Aaql0nVa62oFTmIBW6nbqmBp7OPuS3iWWO5IrIAB2tsK0437PHc4Im8qw7aD
         aoBr14B2XVylS0MyIgZ8LTdvOeGDlKqSA9kJ/fISWFSNm/G1ssV5aG7FK1MRdPbCot7u
         pB21mp0d6WE1lM2ZoBCptTs8+SjozuIexEy5kbNaTr8v1H144qZdup8h5Zy9+piB6Laa
         dh1Q==
X-Forwarded-Encrypted: i=1; AKwUvBxSygkkn5TI/AO/fFgzoRiYu6iO1t2Mi7UgiK4bL/eEl5Yh8vVSjEbQNljxnfEfs6mYZJWADfN6@vger.kernel.org
X-Gm-Message-State: AFq9FYKDScRJRh9QPmWdGqmbr/HNnHiNr9022aNXGHk+PCTf31vaZzN8
	tZ+omx7/+yAdYuj/W10QaPwuM/1Od5TejAkfg9XQVZq4rkmkKEOmrvVp
X-Gm-Gg: AYBFou3hPb/0xCDzZ6DH+dajLUPzkfF2nl3rdEAgjWuTQhzmYl7ee9koAE2lNgRMtDM
	WbKqUjLOfOFQ9wM7tARz8qfGAa5ZDBNuQ7E5F7rvbfJVofpKgjXjkAePdV4XpUYmuihdTmH49I/
	8gVX4c2whjCk744wwr47lVNXyARbeyK6SoUYOCmWVhrBIJ3pKZHyVc9OTE7MyUBtSYg+uGBKbsV
	6RIkbw1iFM1RA8G3hgwNhufqzzc32Dbz0Xtyorbl88/JMuRh93GX+H6z0atqul0K+rCxiaTyetZ
	KgslEAv8t6DiDV82twgyXvcKjb1OWtsN9MEkP6KknOKdWw8YPfHt47m1/J7puKKrIaQRiR8ZEUj
	1oPYlDV1VPmQ1Wv+CkR1fLDtCLHbHqFtFC6xgCpzKldYvTnAhVLy9tzw6h06vqtdOGGA91JsXim
	k7j0TsmmDpgYmEd5ZeBwxcTyGfC4PZiHeh8Hl5YmtYAusdaB1GJ0Frc7p8M1QESHEbbzaGyyw4o
	wN9t1RrtUPbjPEWcrVrqE8Or8gCgQ==
X-Received: by 2002:a05:690e:1201:b0:674:1968:4194 with SMTP id 956f58d0204a3-67a0e02e652mr126937d50.2.1792524933795;
        Tue, 20 Oct 2026 12:35:33 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:71::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a0e5779ddsm89200d50.20.2026.10.20.12.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 12:35:33 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/memcontrol: publish null pointer before dropping css reference
Date: Tue, 20 Oct 2026 12:35:31 -0700
Message-ID: <20261020193531.181318-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261020190336.3754557-1-joshua.hahnjy@gmail.com>
References: 
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 20 Oct 2026 12:03:38 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> On Tue, 20 Oct 2026 11:13:27 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> > On Tue, Oct 20, 2026 at 09:56:26AM -0700, Joshua Hahn wrote:
> > > struct memcg_stock_pcp hold references to cgroups that it tracks to make
> > > sure that the memcg never gets freed with unaccounted charges still
> > > living in the stock. The cached stock can be cleared either via
> > > drain_stock() or consume_stock(), which drop the reference if the
> > > stock goes to 0, and then clears the pointer from the stock.
> > > 
> > > If that was the last reference, the memcg is freed after an RCU grace
> > > period, but this can happen while the pointer still points to the
> > > to-be-freed memcg. Then a reader that enters its read-side critical
> > > section after the grace period has started is not waited for, and then
> > > can dereference it after the memcg gets freed.
> 
> Hi Shakeel,
> 
> Thank you for the very quick review! : -D
> 
> > These are per-cpu fields and are accessed within local_lock. How can there be a
> > reader where a cpu is still between css_put and WRITE_ONCE and within
> > local_lock?
> 
> I think there is a case where a different CPU can actually access the
> percpu stock. drain_all_stock walks every online CPU's memcg_stock
> and calls is_memcg_drain_needed, which reads the value with READ_ONCE
> with no local_lock. So I think there can be a concurrent reader that
> doesn't need the local lock. 
>  
> > > In practice, this is very rare and I have not been able to reproduce
> > > the issue in my own testing.
> > > 
> > > Switch the order of the reference drop and the publishing so that
> > > we first publish the NULL pointer, then drop the reference.
> > > 
> > > This is based on a report from Sashiko, who found this pre-existing
> > > issue in my page_counter_stock series [1].
> > > 
> > > [1] https://sashiko.dev/#/patchset/20260928192349.3432886-1-joshua.hahnjy%40gmail.com
> > > 
> > > Fixes: e1a366be5cb4 ("mm: memcontrol: switch to rcu protection in drain_all_stock()")
> > > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > > ---
> > >  mm/memcontrol.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index e7d7db5718f9a..a05d9a8baa1b6 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -2172,8 +2172,8 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
> > >  			stock_pages -= nr_pages;
> > >  			WRITE_ONCE(stock->nr_pages[i], stock_pages);
> > >  			if (!stock_pages) {
> > > -				css_put(&memcg->css);
> > >  				WRITE_ONCE(stock->cached[i], NULL);
> > > +				css_put(&memcg->css);
> > 
> > This css_put can not be the last reference for the memcg from this path as the
> > caller of consume_stock() (above the stack) should be holding a reference to the
> > memcg.
> 
> Ah right, that's true!
> 
> > >  			}
> > >  			ret = true;
> > >  		}
> > > @@ -2209,8 +2209,8 @@ static void drain_stock(struct memcg_stock_pcp *stock, int i)
> > >  		WRITE_ONCE(stock->nr_pages[i], 0);
> > >  	}
> > >  
> > > -	css_put(&old->css);
> > >  	WRITE_ONCE(stock->cached[i], NULL);
> > > +	css_put(&old->css);
> > 
> > Here this can be last reference but I don't see any concurrent readers of stock.
> 
> So for drain_local_memcg_stock I agree, since FLUSHING_CACHED_CHARGE
> is set, so you can't have it concurrent with drain_all_stock since it
> will skip that stock. But refill_stock also calls drain_stock when
> it evicts the slot but the flag isn't set, so is_memcg_drain_needed
> can read it at the same time.
> 
> What do you think I should do? I think reordering makes the intent more
> obvious and maybe it's just me but I did find it a bit misleading at
> first that we were dropping the reference and then publishing. 

Oh and just for clarification, my page_counter_stock series actually
gets rid of this codepath and switches the order when moving it anyways.
I just thought I would pull this out early and send it as a fix to see
if it would be worth the effort!

> Thanks again Shakeel. Have a great day!!
> Joshua
