From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v3] mm: memcg: add THP swap out info for anonymous reclaim
Date: Wed, 13 Sep 2023 13:38:02 -0400
Message-ID: <20230913173802.GA48476@cmpxchg.org>
References: <20230913164938.16918-1-vernhao@tencent.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1694626684; x=1695231484; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FMB8mr1jou6Rc6ugTyWCVcw7o80clyz1E9xOmdaAf/g=;
        b=kTwi6NX3V/9UWzNvuUpTDpwNW0VyZNo2IExCr5YnmiInC1mQy40SbrCZyC74Foy3E+
         BQiwkLCpcA5Cenolto1lWgjYYgoDbncayWfuOIwkhWn2xQmAoMg+OWzFTUdVhJ9yR24U
         6PVpmgZKa5RNkaZaT3h31KPr6ENVlVDvMFLlFP0rAMCcfrj3eN1hlRPSg1x6e0xIjUgt
         SOvXKcr62/1fY5MGWVvVxifyyICOvC7DIfB6kyg4KXx8HU935fhHFG7RLrT9SVJk4246
         yFNBAjeIfY1/L+UlYjmE4VGuGXJHDCaWFeE08bgYXPu7uetoFeDCVYibPPKBQ1sfi5qP
         rDXg==
Content-Disposition: inline
In-Reply-To: <20230913164938.16918-1-vernhao-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vern Hao <haoxing990-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Xin Hao <vernhao-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

On Thu, Sep 14, 2023 at 12:49:37AM +0800, Vern Hao wrote:
> From: Xin Hao <vernhao-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
> 
> At present, we support per-memcg reclaim strategy, however we do not
> know the number of transparent huge pages being reclaimed, as we know
> the transparent huge pages need to be splited before reclaim them, and
> they will bring some performance bottleneck effect. for example, when
> two memcg (A & B) are doing reclaim for anonymous pages at same time,
> and 'A' memcg is reclaiming a large number of transparent huge pages, we
> can better analyze that the performance bottleneck will be caused by 'A'
> memcg.  therefore, in order to better analyze such problems, there add
> THP swap out info for per-memcg.
> 
> Suggested-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Signed-off-by: Xin Hao <vernhao-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
