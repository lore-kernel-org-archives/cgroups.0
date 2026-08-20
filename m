Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF993976BE
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 18:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787251481; cv=none; b=V5+UQu1xb2XJ8lpRCTus3pqZJcO/A0LvhPHafmisR6oEdK5DUW4756RtuPRa0CKv+KSwecNKttJVF7WelznBwmOqyf1oqpekNBYq91QX1QhEgeECIJbbprfe/SIY8rFdv1lT/XtMl8Prvt2PlVNPLsmPHxsFYmc7EwsJJNxdET4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787251481; c=relaxed/simple;
	bh=9JBRNzkMw2Coc7qA8yiJwk2/I20m/GL1O6pTM3+vxV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YeqBFCO1Q+35FBFxtxgez/JQWd0o5N4SBXQE71vXtb01JmA1ZeXqDeZHVubtwfXckhchB+Je3OrNknvNwUmz+TQmXbyWWmqUb768+/PsPnVvEeOcshZuAbFRMr3Wq7tXJrbp4z5ymhpKibp/QOqdaZW4izBiYu3lfS+KtnvdHLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Dvu5hZVa; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Dvu5hZVa"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47fd66a094eso93760f8f.3
        for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 11:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787251477; x=1787856277; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0GLmbH5SyGlm3QykfKRyFPNaJnpHjEPWRCdCFLcGOXY=;
        b=Dvu5hZVaCYw79sIVK5EPsSQfufQIlDPo2zcnb7zTMM8cULJjGj1ar27MUc5vBDcIoB
         RNySU0VJVEaeuV25EtUzqqcF+xTz7xi+enyQ+cZlCzHz5pNZgcCLZuBB4N7eUcsZAtVn
         USSp0yKZ0phhF4b81DiTzzM+HYds0jaJgu8QQTmvbdxtC4vNkxCg2/IWJbSogBZu/kNz
         pwOgcjs3idW4eAb6hk6COfZb890Kr0zzzyjIjHoLcb12K990wtFd5yE0QEhAhtU4l0v/
         LEBX4nzBn7Wa0qncwm3ciAl+CpUwOqfLUaW/RR8u9XXLxXgyodxtLaPFg5z0XlxR5Lx3
         CoQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787251477; x=1787856277;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0GLmbH5SyGlm3QykfKRyFPNaJnpHjEPWRCdCFLcGOXY=;
        b=sAcatca/m5nG4KYVHuwe32/cjeWDAqK4Zc+kwoPl2790vC0pr130ea3VnNOwHruKOd
         fItoiHWWe4SPmZsXVB1FGSZbxD8n8Q+r6Jg0yqXzo1qUuW0dQ2T+PPpiPAO6vjqQPjph
         2QW0d/POngIFHyMSUK4DHP4o56tUt2Ya1tX23oGWyAWSjpBEzL1yYx6vJwHqcmXGruo+
         zAQRXXTi/v1/cxYe2DBTwOC/427cS7NB7oW2fvzn9wOWvVpak+cvCVWVHNl1n5B1nhTN
         k94J3NavtfXE3qhQYKF36sPW0dBiosgCwr6DyUI0kDm9sv//CK+1qXQHBQXA9yioHXgR
         Mkiw==
X-Forwarded-Encrypted: i=1; AHgh+RrYkmdrCdZK3QnDhJBJUYzz2Ke9kSNB0LyaiKTQ3x7oBG7mKYlu2/wdLSNiBkcwAWJAKC/c8vFz@vger.kernel.org
X-Gm-Message-State: AFuF++kRwDel9sE2+7m9bODNg9/h8jvNhU58wCFqVFCkwr3CG0+q6Oqw
	KnhZYTSHtKptuo8UmnKVr+49TQHKd921Jl8gZPlOz7cTjE5Il2dNTTJPdpzTDkO5HxY=
X-Gm-Gg: AR+sD10ka2RBOwB32RCKmraBFa3J7G0YP4UusfETrp32QXno6047I1sJu8czUDCv4Za
	T2r2vlZn3ofO5h2nzeBhbcK3aC+v69yUKIVRq1EkjjWhkdivPc/AsjR036iWigNiQB4FVUPZkSr
	Z6X05gAGzTURcYf9WLLJI0W+6YSD96anayc1lIi/72jx3MNsrYigqXdlZHTZ+TvXHSqCjkzahkN
	U7SrNZlc0JPeIQWy2GddDlSC9BifIZlX1NaUJKPXQOapdchU5MOddUR1RoGFnjZFJU9WYpXcxa+
	J01kraInn4JBtgUHL2mywhxG1/CYfR1mgvIgvIFgg0a3IA2z0FK3mKZSvTRqELy7PdCmtX8PtPa
	9SyarzZUx43wnIm+JanBFV8/iYQPZmFoZPptg/HA9jY4ELtXTU7KHiPzilJ13ucS152giMXBAYl
	iY+iR2AwEXyUr67x3H+/H5+SmduxkYtAyCIKVkRAGqezAfKl8NL4wwDrncVty7/PGpKeKPXdpub
	Q==
X-Received: by 2002:a05:6000:605:b0:47f:9096:3ef1 with SMTP id ffacd0b85a97d-482c0b62092mr1209538f8f.9.1787251476739;
        Thu, 20 Aug 2026 11:44:36 -0700 (PDT)
Received: from localhost (109-81-81-112.rct.o2.cz. [109.81.81.112])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482b1441748sm15311174f8f.8.2026.08.20.11.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 11:44:36 -0700 (PDT)
Date: Thu, 20 Aug 2026 20:44:34 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Joy Chaoyue Xiong <cxiong@meta.com>
Subject: Re: [PATCH v2] memcg: trim the per-cpu charge stock instead of
 draining it
Message-ID: <aodLEmCg76oRHY2j@tiehlicka>
References: <20260820012010.2016086-1-shakeel.butt@linux.dev>
 <aoanalsTiGmL69LN@tiehlicka>
 <aoclMssJAyYw2aCn@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoclMssJAyYw2aCn@linux.dev>

On Thu 20-08-26 09:06:29, Shakeel Butt wrote:
> On Thu, Aug 20, 2026 at 09:06:18AM +0200, Michal Hocko wrote:
> > On Wed 19-08-26 18:20:10, Shakeel Butt wrote:
> > > @@ -2254,9 +2264,12 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
> > >  			empty_slot = i;
> > >  		if (memcg == READ_ONCE(stock->cached[i])) {
> > >  			stock_pages = READ_ONCE(stock->nr_pages[i]) + nr_pages;
> > > +			if (stock_pages > MEMCG_STOCK_HIGH) {
> > > +				memcg_uncharge(memcg,
> > > +					       stock_pages - MEMCG_STOCK_LOW);
> > > +				stock_pages = MEMCG_STOCK_LOW;
> > 
> > I would find it easier to read to keep the update in sync with
> > memcg_uncharge, i.e.
> > 				stock_pages = WRITE_ONCE(stock_pages - MEMCG_STOCK_LOW)
> 
> Sorry I am not sure I understand your suggestion. The WRITE_ONCE() is throwing
> me off.

Sorry, brainfarth on my end. I meant to say that stock_pages should be
updated by the uncharged decrement rather than capping it at MEMCG_STOCK_LOW.
So in fact I meant this
				stock_pages = stock_pages - MEMCG_STOCK_LOW;
but then shortcuted it to a nonsense.

> > > +			}
> > >  			WRITE_ONCE(stock->nr_pages[i], stock_pages);
> > > -			if (stock_pages > MEMCG_CHARGE_BATCH)
> > > -				drain_stock(stock, i);
> > >  			success = true;
> > >  			break;
> > >  		}
> > > -- 
> > > 2.53.0-Meta
> > 
> > -- 
> > Michal Hocko
> > SUSE Labs

-- 
Michal Hocko
SUSE Labs
