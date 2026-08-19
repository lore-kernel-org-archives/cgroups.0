Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF5526A1AC
	for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 07:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787122945; cv=none; b=V5F8Bf8oiLfllu32Ld7GUprEl/zLu/mU+fVgQqjxMmuJG3kNTl7w7KB9TIgVQUpuCtMCTGGRpf0qVYivqBV8CHKQKSfJOTJ7D620VLWD8X5KPkNOj70XpTs2/SFALe7PC8HnWbfIM/FGz8nEDQWjvKwCZfylTSNdc+u+ksIvh/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787122945; c=relaxed/simple;
	bh=DABWJkpBGy/B6Chwg3LQiA9sDnH6rH9UYRiyCrtkDos=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c7xOOVjeajE8fzZIp9ioPZInWJ8VXTQsdCsWz9afdgjFOE9Yo+WiBH7HLPGXNIlRlQz69ze75pkfTH17H4NLf4QorJwLkKoo0GhI1zyBeDXutWvoh+IzhJVMO0XHP+7b/jrW139rPKxsGGbOmVpA/9HW/lbLlyCa2qbey+MtNOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EwQR/WPt; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EwQR/WPt"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-47de0093c42so557589f8f.3
        for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 00:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787122942; x=1787727742; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DKZ7k5xuvKelkXAPGEl7SiL7VHybzzQJ3aLjy7GPMSg=;
        b=EwQR/WPtDIolAFylE7sXZMVad5i3l0rcKaZuB51A0ypRNf75eFD807B0BE/O8mxd7t
         iAzS0uy5i7FYp5dIe4fMXUETWf+JulL2P5sQE3ogZzv89uuk/+GFE81jmRHHF/3BBJ1D
         r4cDAyglUNaLXr/lz5CkqSRorfiAUBk+ir0oDpHZ2sWAgYCmUhsXwPV7HVXXiH04q+qO
         qQAbxBd+pcq8Cvh2AGPNrAr35hgnTo7m/IwAljGc6PBu36KDe2GiUl7g3n3cSLBQQOvY
         Y83aqkzAoJrsub/C4JEKZzXqfmcz2P9sBr7cIjjnTLV9+Gj4PWvzPMREGmDXQWWNALT+
         SOwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787122942; x=1787727742;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DKZ7k5xuvKelkXAPGEl7SiL7VHybzzQJ3aLjy7GPMSg=;
        b=hweASWcrGqNV32h1yCDEw8vBbUSr/HQdDXtjXe2lT/djjLFLQLBekf8toqh+ILJEdq
         0jAAl9M05ps6Fh+LV8Ns7oUnFeAcrjo4CI9aXnJIXNApSFAabnHaj7vVHv0Vu16yDu0+
         QjnwN44uhugv7erYtRJL1SKm1L5SNiAqv47n67wsEd9rlmW/FwhxBgDoMiMFbxXGrP9p
         dper6EXPRb0K2Hfmot8wyIch4Nbqhz3DaKhkytYRSNZ55sO9Kxhue91VP1zeXK5F2+/h
         FpKu9/tRrSWK65ow2WH0GJhU3yGIjJ/dKcqAirkRngPcu2lmcn+QhpkHk94TOdgaLNO7
         /vJw==
X-Forwarded-Encrypted: i=1; AHgh+RpzHohC2KKIxPCrmWfAhT/6C82vtry5t3Z67zdgOhJNAzEcvfT0r6o3njaE+td5oPBgr2/jT9UB@vger.kernel.org
X-Gm-Message-State: AOJu0Ywm9cUKL9nM2EqdU80akwhwEJ6M6lH1/R44L47q3uDE3lckzjKd
	xSKvuIblqJyPHJTt7NV3E/eaUKKqIYd1fnzDe1ajYNeWCmHYV65rnf2ZZYJMNoWz8ds=
X-Gm-Gg: AR+sD11qlRST5MuZsWE5+DpC7UPLT529BZyo4V3UBOqdq9A2UKAlx1fNCbccKxPLsEa
	ofjOPOeA9UfxokXU/t5UKQZIuSjexRup+x0o3tQ96K1tbVSShfCnU4Jm6mNgGXHAQcQUmtFCk97
	Ce+FZVU9F54VN3kVRfgTvuxnipnegMtnpNqLmjrFb4QQ3vi6uDSedJQMbaCMob0/7iIzTVz4Wtf
	1kl6ZUaWqSOWnVs54kXKhV2Q+GVEjmubbFAv5uOLIdE0DZfRjyqlgCgZIfqUY/vkPHZg5xpsUs5
	qJsteAThCIuwEPa8vo7r7Q2QgoYWJElIiThjpi15l69dtPFY7eeR2ygTTPxP361+mWjEVEmMfQW
	ab/Ov/fsDaqrhU8Kw/GKvl0zZmVUmJ3cOGMVzop8syDgjNDBwHzV16yr81Wl6QnCJoeRYb+jVbi
	tca9sAch37RmRxkS65xemvvznAkJO0gssZ3+FwpO86cpBKw14HWEAfnODpxdHzGmtR3athuFIqm
	w==
X-Received: by 2002:a05:600c:37c6:b0:499:8f9f:e9ee with SMTP id 5b1f17b1804b1-499aa173a16mr44660575e9.7.1787122942071;
        Wed, 19 Aug 2026 00:02:22 -0700 (PDT)
Received: from localhost (109-81-87-166.rct.o2.cz. [109.81.87.166])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499aa0fd7a9sm51540595e9.2.2026.08.19.00.02.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 00:02:21 -0700 (PDT)
Date: Wed, 19 Aug 2026 09:02:20 +0200
From: Michal Hocko <mhocko@suse.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Joy Chaoyue Xiong <joyxiong@yahoo.com>
Subject: Re: [PATCH] memcg: trim the per-cpu charge stock instead of draining
 it
Message-ID: <aoVU_OV777Xgascf@tiehlicka>
References: <aoQt2zKsQT-rvjd6@tiehlicka>
 <20260819041747.1111965-1-joshua.hahnjy@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260819041747.1111965-1-joshua.hahnjy@gmail.com>

On Tue 18-08-26 21:17:46, Joshua Hahn wrote:
> On Tue, 18 Aug 2026 12:03:07 +0200 Michal Hocko <mhocko@suse.com> wrote:
> > The idea is sound. I would just not increase the overall stock size in
> > the same patch. Fine tuning can be done independently and ideally with
> > some numbers.
> > Would it make sense to start with MEMCG_STOCK_HIGH := MEMCG_CHARGE_BATCH 
> > and  MEMCG_CHARGE_BATCH := MEMCG_CHARGE_BATCH / 2. That would preserve
> > the maximum stock size while preventing all or nothing behavior which is
> > indeed suboptimal and pushing charging path to a slower path way too
> > aggressively.
> 
> I like this idea and I think you meant { MEMCG_CHARGE_LOW :=
> MEMCG_CHARGE_BATCH / 2 } right?

Correct. Wrong auto-completion on my end.
-- 
Michal Hocko
SUSE Labs
