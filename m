Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A09847A0B5
	for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 16:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787071434; cv=none; b=fHxaIuiUgqTqRUzo2uRUAHA4hM4AFouPymdSXRsOpDqAOgm+8ABw8D6Q5EAC8HpW3WhG79su2bOMddJ/k0pt85jWVUBv1s2jBjqbZIMki0Yqwx1jhvbGDA1lgrCP57pnipZLGKoh1aI8tVPxLs01888WQ2anfspFnhv2rrziFig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787071434; c=relaxed/simple;
	bh=x3yO1Xhzyjwg82TfFc4FISY/jp4ChnURfQzQ6iT7l7M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o6SuB4LdDrcJBCtAaWWGHhw+eSx54HB8nlgmCN2A4sbrxfO/jblO7qtaWDaQqe5hL5G2bt2WB4/1pPYyzI3ab3PaQDvgqU8p/avU+9sTLw39X4PZMdGbflLK/niUxZ+fmZ8VtGJlBBrRDDbAa7278Kb15YiDavXDy4rOIrzoX2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OOCwQwMb; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OOCwQwMb"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-496bb7cdf51so574525e9.2
        for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 09:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787071431; x=1787676231; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hSPw/8r8Y7BIh1YcWJP4P9upFW6BW+TUQ3tuOxC68Hc=;
        b=OOCwQwMbW3gptgdjQBG3hOms5/l3scjuJiraazFIN+ej4JvnlyVKZeVQBy/hotMx0M
         Zb6HuIBliXePI0GQWXuwfMZJF4B6+UJgTCMuKVglKBqXy/ZUk6cYqwvfZ0mN0PT2dib7
         +HreEyFI7+mZ+lLsQaheGjM9O8BTXlJiITTxTP3+z2K6XSGRcey7AI9OTDGsSo5Adk+y
         CIHyJ2f8kCQcMyylH/dxyquHZAzC/RujpCST1S1PyL5DTQOly0SqfePF6oNavolkvg0a
         /pIIYgBSMi7AYrZmZOwdildzVOlIeMhCHi7ZAxOzl889Z547g/dQoKU6RPjLs8B4B+cL
         DH/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787071431; x=1787676231;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hSPw/8r8Y7BIh1YcWJP4P9upFW6BW+TUQ3tuOxC68Hc=;
        b=d/o9by9DQ4SRsnYTV+OxqtICw5kgKBGm5Xt8GeRP583Skrfw5VgNqH5K1yk608VsMx
         1YVBzppAcETACqdW3rNGd2lDXptxmbR6v/S0RAvZUdG3ARxF9OfJNHWru/uoQyvgNy2+
         0vn+A4K7iw+p/7/E8nKi4PXTm11S5yVLVgbg9jfQnC12LkE0VBNI02HMKmeFdGRlN4sO
         T2ZDZCqnqRF+BQyoPmUB/T2svCcyVcn+Kz9N7H04jo2snTMvY860trgzSSPMZX3sH5zv
         jNBSv2iKErPb7Afewyd4b2gG+QZeFfJDDZpBVcjyhFGp2riZusR/MMvbhbhkpq4oRYnk
         vlBQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrmau27iGBe1xJlmY8rUpRyUgkazi8wRhRvTGn1r4vrUR4TCl5iWeREUhpKvABTXr/worksFfqt@vger.kernel.org
X-Gm-Message-State: AOJu0YxJ/wS43YNQzqaZ78ODP5MKxqR114bNLx2u+/kF6y2PjNufLf3w
	vKShf3QBRzlLpJQBblBMLVMzF0F5hD5qxvXq4uLcwjDdU/o6ughd/esxBbFHj9YO6F8=
X-Gm-Gg: AR+sD122hvUGLJQtyz38VEnuWm43yfWv7sGfYHwCi3vSOKvv2jyckdiOamjv2f++6q1
	PYApMhLK8riIQ73BnfvoO1fdHEzD/0YHhjebDgiM+jczv7SBdBMpeP4ZNDLGfWs7TX3bXkIGLar
	p5hFQOOEny6nTlYskwgnbLF4B74iVj+zmn6uiz6rsBo2+1swy0efcDVQBKYJ/2Dskj5CyYKyoXq
	rWRCFvvlv/1LymHx+xOJgsHhfz3scUkMiab+hn8wWk9oxbRungzNGOSDAHQpDSQPEGP+8JwYzga
	Cv6Zwsszqek+v5XrIECbvaQPMelWEOtor12xZnVYlynSSyQzlbPxaAsBw0j0JaD5UE24ivPusk7
	AGHGEaWfF5anCzUrzO2iloLGonEU9RwsH3zFtE3kFDseNC3ongPs0mfO3Kj0NFOshQ9qTljAdwj
	48LUUkqRrZ9EeTu2M7fXW2omI5fbKGwFPFJeV2TS72LJPHU5UDY37UsEjFxZOTQyOKsCZf/Ks8J
	w==
X-Received: by 2002:a05:600c:528d:b0:499:48be:3189 with SMTP id 5b1f17b1804b1-4999fa84b7dmr197625135e9.0.1787071431027;
        Tue, 18 Aug 2026 09:43:51 -0700 (PDT)
Received: from localhost (109-81-87-166.rct.o2.cz. [109.81.87.166])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49996176b8asm225801765e9.11.2026.08.18.09.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 09:43:50 -0700 (PDT)
Date: Tue, 18 Aug 2026 18:43:49 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tao Cui <cui.tao@linux.dev>, akpm@linux-foundation.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
	roman.gushchin@linux.dev, muchun.song@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH] mm: page_counter: reject empty string in
 page_counter_memparse()
Message-ID: <aoSLxSBUPbEqimJq@tiehlicka>
References: <20260817042652.74136-1-cui.tao@linux.dev>
 <aoMzchLCCz5hiFHp@linux.dev>
 <aoQNtIRvqXRh-x4u@tiehlicka>
 <aoRz72_zdMai_RNV@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoRz72_zdMai_RNV@linux.dev>

On Tue 18-08-26 08:06:22, Shakeel Butt wrote:
> On Tue, Aug 18, 2026 at 09:45:56AM +0200, Michal Hocko wrote:
> > On Mon 17-08-26 09:16:40, Shakeel Butt wrote:
> > > On Mon, Aug 17, 2026 at 12:26:52PM +0800, Tao Cui wrote:
> > > > From: Tao Cui <cuitao@kylinos.cn>
> > > > 
> > > > memparse() consumes no characters on an empty input and leaves the
> > > > end pointer at the terminating NUL.  The only validation in
> > > > page_counter_memparse() checks for trailing characters, so an empty
> > > > input slips through and the limit becomes 0.
> > > > 
> > > > All limit write callbacks of the memory controller strstrip() the
> > > > input before calling this helper, so a script that writes an unset
> > > > variable hits this path:
> > > > 
> > > >   LIMIT=
> > > >   echo "$LIMIT" > $CG/memory.max
> > > >   echo $?
> > > >   0
> > > >   cat $CG/memory.max
> > > >   0
> > > > 
> > > > Nothing reports the mistake: the limit is now 0 and the OOM killer
> > > > goes after every task in the cgroup.  The same happens for
> > > > memory.min, memory.low, memory.high, memory.swap.high,
> > > > memory.swap.max and memory.zswap.max, where 0 silently removes the
> > > > protection or disables swap and zswap.
> > > > 
> > > > Reject the input when no characters were consumed, which is the one
> > > > case the trailing-character check cannot catch.
> > > > 
> > > > Fixes: 3e32cb2e0a12 ("mm: memcontrol: lockless page counters")
> > > > Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> > > > ---
> > > >  mm/page_counter.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/mm/page_counter.c b/mm/page_counter.c
> > > > index 661e0f2a5127..d14db705b04f 100644
> > > > --- a/mm/page_counter.c
> > > > +++ b/mm/page_counter.c
> > > > @@ -281,7 +281,7 @@ int page_counter_memparse(const char *buf, const char *max,
> > > >  	}
> > > >  
> > > >  	bytes = memparse(buf, &end);
> > > > -	if (*end != '\0')
> > > > +	if (*end != '\0' || end == buf)
> > > >  		return -EINVAL;
> > > 
> > > I wonder if someone started depending on this behavior. In that case it is
> > > better to return error instead of silently ignore, so we will hear complains
> > > loudly. This looks good to me.
> > 
> > This is backward incompatible change and I am wondering why should we
> > even risk regression.
> 
> Mainly I was wondering if this is intentional or unintentional. If this us
> unintentional, can we fix it without anyone noticing?

My guess would be this was just omission. Those happen and over years we
have learned that userspace is quite creative at using those.

> However if we are ok with this then let's make is formal and make this a
> documented behavior. I don't have any strong opinion either way but I think you
> are saying it safer to just assume this is intentional. Fine with me.

My main question is why should we even bother to change this in the
first place? Is that reason stronger than a theoretical breakage of
userspace that we might learn much later?
-- 
Michal Hocko
SUSE Labs
