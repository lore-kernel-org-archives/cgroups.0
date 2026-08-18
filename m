Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A93D3A9D9C
	for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 07:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787039163; cv=none; b=H9I5gX7apZVKnPK6GW8fYxbFaITinM3nITk5U6nP61buEdWp2FUkN9b/TeiCgmGldll4noM+y7p230drLPK7N5uy8MLy5QzKeLUBVv4/+HNGtKNYg13DyWoUNMR4rXTZEhC1inIc914F4bZqVKHYfQaE5ulW5chksAOSKeG1SWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787039163; c=relaxed/simple;
	bh=bohRl9TUaRTqMRjXrawVRxnM/0uh7YvaAyzKfG4nqLY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PphPJzeATi9JoUaQ9yXsHgnKE+E6GXDHXiGp0QZoDwGorc3kjvSmOl3s6kKXPe7sjbVpyb8SUc1G0KNR3QrORlVR9deNQx6taPhhlWsN1Hz1BNv/Qy4OvTH1fWSGj+5q+10QBsyTHdf3BLFl1hFBC6yNO9eMMh+5weSVWFhFieQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FFuDYEKf; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FFuDYEKf"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4954dff6536so31543225e9.0
        for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 00:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787039158; x=1787643958; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Y8DtTDcSzfGuvLMZ1kDSosdRxVmDTPGGThapUM2N22w=;
        b=FFuDYEKfibV4+DMORliNvP13R44rv3u7rYIWWvwbVEaDfdVXaItosni/vCfPYNWP5+
         EQNN0pzFofXDWgYgk7xf/abPA018bnCG+wJ0XLlQog9wFJ9j1Rh+r+1r4VX/ybtFE2LL
         orcM8fumXclzJnz111jKFtUUhSnHoKHgOm7yMzyiVH+eVc/ZvBAVVmdYR+xW0lZQKsmW
         cnE9pv2SDicoCgbfWZn++xvc6O8Yisx28YXAEm2URA2OCdUtfeEtwDnUhcTPwtHUAshu
         jKEO+2v86yNXkQNXSKvWbp2fpFwauP1tGMs+zhhuXHQCYI4FhStmTVNbCXLGREnkJv2/
         Al5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787039158; x=1787643958;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y8DtTDcSzfGuvLMZ1kDSosdRxVmDTPGGThapUM2N22w=;
        b=G3fUICdV5sGejo0+qIqRzk9H3LaAh2BfdAHpQIvcf6NKduGwqNn+PrTBQG0akG+yMp
         yE3GHZdESyo19yzO29HmZoim1Gb1GR1FAX5dmipohbxB/QwaSXKBZUkTT2jrvmXO0wYt
         abFWGCrNSQ+jRDcJDnvJ534y3SGYqAR2leqxurpkCpTl585Yadl+W1WGWcJnCLo8o90E
         OgYuWOFEQxRyVUxrOC3tTNFmQAJvFdjVv7w5qQnJBa1TJPucgr4amI1PSIGsV+uird5o
         oFFQrlNhYtlxdXtyY66zIHraV9hjt0BYiLTZkeBd/2XLugvVKIi7GKBL5BA3erIsK0HV
         pkHw==
X-Forwarded-Encrypted: i=1; AHgh+RrEUd+AqjQQD/W6eTzUV6wQxM6M56skPiYClcEk7jxckxOoVIgcQ8+MQ9M01ZQbOLlcRyhH7fnL@vger.kernel.org
X-Gm-Message-State: AOJu0YxlYOivxXJMA9yeOgL2pqINIYARdCWiVvEOV0l6NEEigA2pxwg1
	z/Ngj1JDxHtHdHk0mO85fc2nXU+yg+E1HtdEN1kU7RrwXlaxpOFdt50BO2gMfkXM0S8=
X-Gm-Gg: AR+sD12db54HNIlg0JQsnma+R9L5LH+PSjsmMSpO4w6hWsv+lvoOzKLwSkqqKhlg6E8
	CcZYbUOcpp8AXto+9lroTx/eV26Go7PwGID+AWec+Aj9eX7A3VNC2BAm9W0AAMQe4/rgv1p8QtT
	AVqLhXLNeMDY2LaNA5P8bCnQJvd47XzaQ2ysNWMJ5QW9S8/gJpXvye9SqN78C6YAl53tWIYFwCC
	yixQgVOpGjVZM+QoYI6EzUDtLs4BsLf/flU61QWUYnreg2+r1jCp2T9OVunLhx/4nm188QmqLqu
	X8ljwQfyGxk8NsScuxjc2N8Iqg3rFkl0kp4Ujlh2kMwPPL1b1n/pRMx0x0aT79Zis5infia9C9L
	LOoig+EPLcHPJUgCtEVLEivk2ctxrhsNAukV2s72cKDH9jzMy9no/42clUidEm/CEjPXVfpYMqm
	Y64ZpVPnaQkTY6UtmrWKcuUOjcMQpqIQKzWvSExKxwT4exvCKahOAdvC9ViI6qGwCQdNsg3rgVB
	gCfGQS8Dw==
X-Received: by 2002:a05:600c:8714:b0:499:8704:242c with SMTP id 5b1f17b1804b1-499878ca13bmr557228035e9.0.1787039157680;
        Tue, 18 Aug 2026 00:45:57 -0700 (PDT)
Received: from localhost (109-81-86-48.rct.o2.cz. [109.81.86.48])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4998ca63e5csm129781225e9.2.2026.08.18.00.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 00:45:57 -0700 (PDT)
Date: Tue, 18 Aug 2026 09:45:56 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tao Cui <cui.tao@linux.dev>, akpm@linux-foundation.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
	roman.gushchin@linux.dev, muchun.song@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH] mm: page_counter: reject empty string in
 page_counter_memparse()
Message-ID: <aoQNtIRvqXRh-x4u@tiehlicka>
References: <20260817042652.74136-1-cui.tao@linux.dev>
 <aoMzchLCCz5hiFHp@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoMzchLCCz5hiFHp@linux.dev>

On Mon 17-08-26 09:16:40, Shakeel Butt wrote:
> On Mon, Aug 17, 2026 at 12:26:52PM +0800, Tao Cui wrote:
> > From: Tao Cui <cuitao@kylinos.cn>
> > 
> > memparse() consumes no characters on an empty input and leaves the
> > end pointer at the terminating NUL.  The only validation in
> > page_counter_memparse() checks for trailing characters, so an empty
> > input slips through and the limit becomes 0.
> > 
> > All limit write callbacks of the memory controller strstrip() the
> > input before calling this helper, so a script that writes an unset
> > variable hits this path:
> > 
> >   LIMIT=
> >   echo "$LIMIT" > $CG/memory.max
> >   echo $?
> >   0
> >   cat $CG/memory.max
> >   0
> > 
> > Nothing reports the mistake: the limit is now 0 and the OOM killer
> > goes after every task in the cgroup.  The same happens for
> > memory.min, memory.low, memory.high, memory.swap.high,
> > memory.swap.max and memory.zswap.max, where 0 silently removes the
> > protection or disables swap and zswap.
> > 
> > Reject the input when no characters were consumed, which is the one
> > case the trailing-character check cannot catch.
> > 
> > Fixes: 3e32cb2e0a12 ("mm: memcontrol: lockless page counters")
> > Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> > ---
> >  mm/page_counter.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/mm/page_counter.c b/mm/page_counter.c
> > index 661e0f2a5127..d14db705b04f 100644
> > --- a/mm/page_counter.c
> > +++ b/mm/page_counter.c
> > @@ -281,7 +281,7 @@ int page_counter_memparse(const char *buf, const char *max,
> >  	}
> >  
> >  	bytes = memparse(buf, &end);
> > -	if (*end != '\0')
> > +	if (*end != '\0' || end == buf)
> >  		return -EINVAL;
> 
> I wonder if someone started depending on this behavior. In that case it is
> better to return error instead of silently ignore, so we will hear complains
> loudly. This looks good to me.

This is backward incompatible change and I am wondering why should we
even risk regression.
 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

-- 
Michal Hocko
SUSE Labs
