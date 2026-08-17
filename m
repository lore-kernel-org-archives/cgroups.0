Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC42429CD8
	for <cgroups@vger.kernel.org>; Mon, 17 Aug 2026 13:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973363; cv=none; b=LBo8pi05ZN9JhwX0TQFCdYP7ZH/T44WQNiwI7JUY9g8Ctj49c1cLqogMbHS0nRWJyWFiy6OFSiKeW2LEr4iXz4hzcpaGEIcjRI/McW/SONn4Qkql5ndXxuNBgdf05yC6qPAkA1HodO0Ohy/9AC/OLQFN51MWWp7AXzRhqGG4ymM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973363; c=relaxed/simple;
	bh=+0Rws5qYqVIW7NwWsmWi/o4ix79UOI8toQnHWkrkhgk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iPE14vCr3lx6H0vF8rSGEMgmdHsPMRVcLyUTNbFr/fx3X1vnMVBgj8qrK/1eplIouE5a6YFq9rLl5l1R62YUyq2CCb/P3Ii0jhN3iKMm6GR/TSBTfQKnEWW8rrNk0iVZSNVXcEAsZBLFNq1+IvP1rosc0F/Cicnp12HbcALRNxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GPiuWCvF; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GPiuWCvF"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4798bea72f9so2196760f8f.1
        for <cgroups@vger.kernel.org>; Mon, 17 Aug 2026 06:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786973360; x=1787578160; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UnfYmqxVfrOcWeieqowIf9SlkMC6J9el3UG+ajVf3ts=;
        b=GPiuWCvFLiHQaJFKYhh1WyAl/wsfFKwEG661/hYbhUtwHKKnbiIdv6xNV2Gy2w4V8j
         2JISFG2EAcH5dPOgWXAJcK7+zrTTy7Tis8GaVgcSoCHFJy/GdJtc035LeXb4K/OQyKU4
         eVPN3FuT6X41cjCPOwDjeN4vKDrM+U+TQVPJOfl8FDRHTB4Ig3kjZsIXnaTsp6W6OuUY
         Z22ephwFSQ2dd/J2u8Q94TdvXF9cZPY3V20z3Pzx62TeUUldMcf9N+qaaMh7fA3R/4O1
         /VnJVGDT5SR4b8HcFpr+gMHWMVWPfmZGHXrt5FxHkrD3p4+ppLZf03BihO3I7YtV82C6
         nCeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786973360; x=1787578160;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UnfYmqxVfrOcWeieqowIf9SlkMC6J9el3UG+ajVf3ts=;
        b=bYyVNGDrb9KI/bfkOLxQ/5prtqWFFibVPwjk3LVemIu1yffFqYArycfCoDQNMjkwva
         zKLvhl16QRU5uLsE1Ptgfpjwesl1a6W5LP5s8lS9Diofm23+ZA/LUmQhYeo6iyP6XbQk
         ZnLoC1qFH09EjAzBLSqqY+7crANvkEPgrGbV5xkpJ9QbHwZQn7KZ8ObECdJxikxvIeYF
         DqQ+k4N1fXU2hTpalp9kphsPNz6coIBXGVvnvg6yK/aUb//2FtOF5XpvgXxCT/B/gJLs
         g0CK/wS6qLcVZ6kQT3vmdOIEz20tdLc51nuGBPIGMDV6NZRKcypE3hxBve6O8Yy+l3kJ
         rvJg==
X-Forwarded-Encrypted: i=1; AHgh+RqKaMp/EOnMF4WnHGR3QNCwMmO2lSWMkDAHzQ6lqYU82SCbudD2krPAGQWRvM9DfwPjuQiiiqeZ@vger.kernel.org
X-Gm-Message-State: AOJu0YwpZeDt9rvOPJdpotw21Tg+hRNuLixFHoUNdlexbdr8yvOsTcNQ
	CfaaQ9If42DSdzrRDLJa4vkXTMJv+gQJQhg1DQSfjaryrpPeJt4Z9VBXk8+gs+j9NZI=
X-Gm-Gg: AR+sD12f37QM8tavIqQYTVaebQHUFr3E0a2XZY57uFDTTWguN9Son/icWIuHfuoKBcg
	cp85VPM+bdSSCtgm011wxJ/VR0XYW5SoG5CzP70YZz4+2fUik0s9nW7kCaRkLb9L7fNudfsSIf6
	3aUN09gc+JYDKS8BVBOPBNDirUrrADZoygxgWutLJeWRiQ4MdFU/4qQZqGG+5ABvsQZIS4+zFfC
	sY25WUfzNQTkF9nR/INpTJHHVwyjiLd0jsAbNlzk+g+ooinP123uY9PSuJFM0Gt9x32aQF4r8+x
	H04kXU6WGjLec1pSHWHs2NamzstmOD7E7jKSh1rQe+0xOPPJuqeNLOWn0Gby4TzqEYZg1vzRBaz
	5fUXBO686nZDnNfpOK1DJbJWfeQZbyNHxm8eLn/lMMrsnRSsQBbzTxtH24DQUIZ3TvYpJnJPxy2
	DnIkc+tqA6lBQgJppuR570cxUxi5fLJHHWFvf18o3+rW4PYSBhum0syojbsOCJ6gdZ2v2axMI=
X-Received: by 2002:adf:f84f:0:b0:47f:eb22:4d9a with SMTP id ffacd0b85a97d-482a90e80aamr58867f8f.22.1786973360523;
        Mon, 17 Aug 2026 06:29:20 -0700 (PDT)
Received: from localhost (109-81-86-48.rct.o2.cz. [109.81.86.48])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482a5b77f41sm3794755f8f.27.2026.08.17.06.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 06:29:20 -0700 (PDT)
Date: Mon, 17 Aug 2026 15:29:19 +0200
From: Michal Hocko <mhocko@suse.com>
To: Song Hu <husong@kylinos.cn>
Cc: akpm@linux-foundation.org, audra@redhat.com, bingfangguo@tencent.com,
	cgroups@vger.kernel.org, hannes@cmpxchg.org,
	joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, muchun.song@linux.dev, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, zhuhui@kylinos.cn
Subject: Re: [PATCH] mm: memcg: flush empty per-cpu stock slots on memcg
 offlining
Message-ID: <aoMMr6kEX7pW1dSF@tiehlicka>
References: <aoLGzZHS8kj53-ey@tiehlicka>
 <20260817131221.44761-1-husong@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817131221.44761-1-husong@kylinos.cn>

On Mon 17-08-26 21:12:21, Song Hu wrote:
> On Mon 17-08-26, Michal Hocko wrote:
> > Is there any specific reason why the memcg stays in the cache slot
> > without any pages?
> 
> consume_stock() doesn't release the slot when nr_pages hits zero.  It
> is kept for the next charge of the same task and only gets displaced
> by a charge under a different memcg or by CPU hotplug.  The problem is
> that the offlining drain skips empty slots, so the css reference they
> hold is never dropped unless something unrelated displaces them.

This doesn't answer my question, really, does it? Is there any good
reason for this implementation? Why do we need to drop references
remotely when we can do so when the last cached charge is consumed?

-- 
Michal Hocko
SUSE Labs
