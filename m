Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793652522;
	b=oDriXkcgx7SmVcg5TBkI/Hd/DP1KckT32+DA2m1nI+B2gfNvDpQU96OYKhWfHOU4UT2Y
	 0rTxjlsxoIG67UIsM5ZwnNLSfwX/SnQKfahmWMf6jB4bNkdPo7tdvOEqpHkhqw/QTdeDu
	 J5T3/jFAd1E+CY4v/bN3Tz11HYn3eMdjMwyLhey2rqRh7ETCc2Hv6ad17NTPweYdaAZ+b
	 0nVmRuKq/jFWnwG221+91fLNK6YfaN+dYTi5KXVGWonHMU8SPisYFQGHpPDfVe01ukc4M
	 ETnckiLw4Mg49//lSTF7XQFKwizvMVP7pPUAsEe8VGvvUhnpgmguKZNigLYrCW2QALQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793652522;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=Tqk8hLSfa24lrMQkcg/49BjZeHEkNKhCmyNnUdkMSKA=;
	b=3VPlMPTWdBuf+R629sP/bhz6SGM02PjpEfB6pt0UuA+zwPiLBeLrckTaE9mnH20/m0bW
	 4fdUJxF+nBin36WCM2W5/Gxl7s2jJLQPkE9AkcMaGk+csPSp41ETn/B2aNXaHz9G6/7dX
	 +QCXFXCkGBiIwdBK6cDGu7KTvzvJ3KCb6HnxDhdlHZtq/lxwZpyvcL4MoNUs1y5aweVLt
	 nrXJ0gbHGuF4aeYP+sJoiy/KRm9UfvGJk5l232jibbtfdqM4HfIQSy1zGTHuSORUM7sat
	 L3xkTbUHdf4z5tfZ1dl+EEk8fRLGwFSh8KxU9l9kdWPXbcOrj6lr3gVEhJc8DLFXOQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b="Jmv0Fc5/";
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BEA8606A326
	for <cgroups@vger.kernel.org>; Mon,  2 Nov 2026 20:48:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2BEA8606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Jmv0Fc5/
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48b001cd92bso1871386f8f.2
        for <cgroups@vger.kernel.org>; Mon, 02 Nov 2026 12:48:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793652520; x=1794257320; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Tqk8hLSfa24lrMQkcg/49BjZeHEkNKhCmyNnUdkMSKA=;
        b=Jmv0Fc5/nYljQwlrG6yZXHbmK/vOygjMgH9V+ln0loEIT4Mj9avnQAT/Tp2Vjx0Yxf
         mC6bHTNlyXApzspb4edfjQ8jfA4fVnDyEDObcW1s3f9uFnPxqZvBAGMWDbhPMrRJrdJB
         DKO6VuBGo8URIw722ulFAEd+Tb25uRngvoeGuc/c8VzWzB1KSEGrKy6kl9u4TWtN0XHw
         wWLRNoAGvC/MZy+HdKh0r/HEluDJe9WySLhESDlUfb+CPRTTplh0t616k5f767guUtGl
         0SMoZ/9/6anudRuc1ktioORbXsKy/bZfEg8l708Uml0eAAyjVyC54mhI22iO3c8ZwLBy
         AVEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793652520; x=1794257320;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Tqk8hLSfa24lrMQkcg/49BjZeHEkNKhCmyNnUdkMSKA=;
        b=NXlHeBggGci8wj+JGItBZ92qSW+RjKLiv+i/8Ty22qrKoXCnt/NFfvnKkX+dw7u2SQ
         IIQhVjJQ+gnuErGIGN48zrPoE6UlXfvJ5qqLJwr8lu6+u2LvbV9BJdPxN0DL9Wa1e22D
         ZZ76z3HKHkPV3HAcd93nzAx/OqAxCR5HRHBE2wncMN+9PFEbozsnD61Bexk4XcWa1u0w
         cpqRUuAItEtKzQ3gzRgzvhqEnotrz+aUnyme89FpTIWq/F6SKwnVHwrjYJrck3y8CyoW
         PnUCT4uVdLsBGjF4VR5+XG/FdOTC8VAoJ5Lg69xBuhi/+L3LsMDJ/3pQ/1hC8P1UCvcz
         l39w==
X-Forwarded-Encrypted: i=1; AKwUvBwD+gPmFLJBoEBXGAdOi3n62Hvrq50eVAmX/rTImq1FYBllA+mC9a1DpkDn6BXDNt95XxXBTHts@vger.kernel.org
X-Gm-Message-State: APuU4Z+Pn/+Vx3B/SEguQB8yfsQkWVZIby5CgEynrGzyOXkfO4TDiuDf
	2S/wKJNz5Y4UwB7tkEFTgrp5yc6lYbskfSotf/ou6joHxqAyo7JpMP8XUkulnINpdfw=
X-Gm-Gg: AYBFou2hwQBE2ZFQis9IZN8wTGFjeSaogyzyRU7F4Lm+8Fc0H4RXRP8Xz3poJBe6nPr
	HymZAy+o4zmf8CepMrivF+4W83dgLotom6vk1S+ZIqvidQ+HHbdLpMnUHnfvI5I3I4Sx+RrML2P
	Bja0BYEK6vRfqg/etxVtc3H8BEagV5yhm3B1d9Ajbq+JAwqVGiCCv3LwGSn6LyivdtE3pjAI9Qs
	qycLmpkOlGVSrMynAtTm2Lta7GUdNzKocQInz7rIPyWAv2W/t5xO+W29vTH6Bvxfl/K+jUe/BGx
	Ga/lpVZQZ5i3hXCNt/CiNcxpUqJOdLPEFi5iKeK4iFS5w0FTuiWh2NC7WpAEXurR1WDDVgalCLj
	5fyGPPD6PlUKpFJrj4B1J/wIIqiUZ3cea8p1rLEnAD1KM7UxF1mxdGJW1P7XwtcgzRGU5P/mu3h
	20L524IQqNsKTr6/UeWa5vc7+jzKngoEk0hdKZKoXMrghSWNYBM7MG71UaCSvdH0hW4K1TPv3s1
	tmSBdYPb+JJeotaMEGJnNU8hqCaOAXcUn7/9XHX/FgWQzMHJrc0I6OO5I98H9csRcCpBhI7AogX
	yrlgPZcJW85nE3/FE8Xdq77IhdojrR0hzQDGRXU=
X-Received: by 2002:a05:6000:2889:b0:48e:f10:ceb8 with SMTP id ffacd0b85a97d-48e6e2e769amr23073454f8f.11.1793652520570;
        Mon, 02 Nov 2026 12:48:40 -0800 (PST)
Received: from localhost (109-81-32-81.rct.o2.cz. [109.81.32.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b80ecbsm22252091f8f.35.2026.11.02.12.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 12:48:40 -0800 (PST)
Date: Mon, 2 Nov 2026 21:48:39 +0100
From: Michal Hocko <mhocko@suse.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Tao Cui <cui.tao@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>, muchun.song@linux.dev,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [RFC PATCH 0/3] mm, memcg: isolate deprecated v1 state from
 struct mem_cgroup
Message-ID: <auj3JyE47UjKa3ek@tiehlicka>
References: <b36ab4a7-b692-49e8-92b5-1dc4d76dee00@linux.dev>
 <0BEF7489-16EC-44EE-847B-A6AA380BE11F@linux.dev>
 <32e80536-64e4-4ae3-a7da-4a37ed415f0a@linux.dev>
 <7ia41p9341lv.fsf@castle.c.googlers.com>
 <aujhaEfimB0S5Msu@cmpxchg.org>
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
In-Reply-To: <aujhaEfimB0S5Msu@cmpxchg.org>

On Mon 02-11-26 14:15:52, Johannes Weiner wrote:
> On Mon, Nov 02, 2026 at 04:52:44PM +0000, Roman Gushchin wrote:
> > Tao Cui <cui.tao@linux.dev> writes:
> > 
> > > Hi Roman,
> > >
> > > 在 2026/10/30 14:05, Roman Gushchin 写道:
> > >> I believe we want to delete this code sooner than later, why would we rewrite it before that?
> > >> 
> > >
> > > My assumption was that v1 would still be maintained for some time
> > > before its eventual removal, and the goal was to reduce the coupling
> > > between the remaining v1 code and the shared core structures during
> > > that period, rather than to rewrite the implementation for its own
> > > sake.
> > 
> > I understand. But personally I don't see big issues with the current
> > code caused by the v1 stuff. Maybe I miss something...
> > 
> > The proposed changes on the other hand create difficulties for those
> > who use v1 and maintain some local changes or simple backport upstream
> > fixes. Of course, it's not a reason to not change the upstream code if
> > it's justified, but in this case I'm hardly convinced.
> > 
> > > If the expectation is that the remaining v1 implementation will be
> > > removed in the near future, then I agree this work becomes much harder
> > > to justify.
> > >
> > > Am I being too optimistic about how long the remaining v1 code is
> > > expected to stay around?
> > 
> > Well, Idk, it was considered deprecated for quite some time already,
> > so maybe announcing that it will be deleted in a year is reasonable?
> 
> That might be tougher for v1 users than the member placement :-)
> 
> My understanding is that there are still a few heavy v1 users out
> there. I'm not sure they can move within that timeframe. Personally I
> think the cost of the v1 code now is kind of negligible now?

Fully agreed. 
-- 
Michal Hocko
SUSE Labs
