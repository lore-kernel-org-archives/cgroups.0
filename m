Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1403B14D0
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 14:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788272762; cv=none; b=FOU7uQlFvGVniT3hGY/ZKcShH39HsNVKgrm90MpC3aowmlE+NG+oiN/izhmy0tLqVxCNhVrPAZrvj6F/McURA2n8dukMqdSYl7lT67f1t5YepVNQcrM+AV7RXbaxFcWIuFqEAa2ZgvDCpD5tuJcraK8Fn4yIaecO4K3e/aSPjbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788272762; c=relaxed/simple;
	bh=MmFoOapeEcD+F5LezzyHUgFm6Fe9hraEDdFCntGtNkY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MO54oQlz17X50q5XX3smIhSwNbKCP3OalJrSTH0d6IoriI5KP/5MmAPzpXHnyk7LpHgyVJAMIfRBo37cJyaKjM8FqzyvPyG6mniLG55kuSouYycUjLmYKzgmQtZIq+t+wnEb5ioReEk7zm2fh5Nrb3n1fXlSjpQtXnWA3cK+h8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=r0aNNtRh; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="r0aNNtRh"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-8588583a7c3so12110127b3.2
        for <cgroups@vger.kernel.org>; Tue, 01 Sep 2026 07:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788272757; x=1788877557; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ObgpNp4xsh/An8XTcvl4h2cgfsJnES05kTjlUzeTPjo=;
        b=r0aNNtRhATXto7Y6PsAXlPZcePGUKaaB1oQP0a4waq7LEj3BOm1adNFqbAP+lZUZwz
         +t9H5E8MzweIfwjrHPdM+Zf+w3pRTpEUW1IugcsqdkDi5GoQK5GSWvkjTIDYFFuc2PAI
         NhPviayUfQB0Cwx6NEs/q+QHNvlorGBvOZgjOZs8R3dqKJIk5029WzsyMTJklga7xWu2
         L2JqRvgH/iz50Worq41OIIBx21RGB8xXh+TmuH53V5Dvb6mTYwmiOzbrz37T/fePMdOq
         YIUT6HBcxxEBei7XgIPUOFqsZxj9r8bwjcl5he+cTVSUU5jBBMKPBtGl/2HJwx8z5mz0
         2j5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788272757; x=1788877557;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ObgpNp4xsh/An8XTcvl4h2cgfsJnES05kTjlUzeTPjo=;
        b=JXHMf0T60ZhGtTWHDpMBmeD5KqEYHEihf2kwE/hDCBrn6foEn7sQxFxNet5nZ4CAaz
         8GcstZBwx3ZTUpwKhO+hnOKEVbNpHUUHll0cazwvgmAFOGUNOFAlzPQ/kTT/p02MVv2d
         L+BQ+vAzBotpi7wYJHRNhEfwGPeKY7Ler79UaB6D3MdODzgasihw7Z3PbWESqVmvStPL
         N1VYFwMgZp4i2G7IsYKRVEhJ2vN6sDSoXzFkznemVr3wl/k2Tb/pHJb4WPaMHAITtUGu
         hDli3lUfVZ1BSLF2etvMqiUyjzaRRgTqdniyARI514SLrVFSvWD6Zqg3OG49GTnHms8r
         G5Eg==
X-Forwarded-Encrypted: i=1; AKwUvBwPj2+//gAWC6/LlkTfYYul2lnNwnQ9nmBw6ObCc+53iosJ9E6IG3fXY0hXTjo/vBbhNRh7bmMO@vger.kernel.org
X-Gm-Message-State: AFuF++nG7M1Tm5vsF/9kM1ZTpQo2ey2cLfOX2HQ6xlRLZhxhWIhlW25v
	sEYwc/MhnOFJisNqoHYUnnQ5jafjCiPHulQ4BppLG8mWsqoXsL/+nYAZCLegkw9zmMU=
X-Gm-Gg: AYBFou0tOE1dUmHwDSWutJmzSe8ltHJ9NyMelr7bZT92wfQFqUbLI/tWbSAvJf8T3Ey
	E3zgyA0qnx6YN9KEO7OQdCRKlCqqeXmBGiyRx40fsToDCPy2FnHqXtgmkbCVz5KMKtgJOF/Y4aE
	lmXYq1Nog6gvwr6Irx/peCszd4wS0dBYU1qFwAGp7xXXkrLEamJLm8nRMtpL7mCI8PtT/8Y5Hv7
	jmZYrQWWjlPQmaJRneNuLjGxbQONZH7S8AUg7nA5Zjwi1vQigpwGfotXimr3yfjoj9u1TdmeKQl
	dsk38i/fQ+SIFClyDxc/lp6Q/I5X8OtZSLbJxSigC9qebcDFTEc1MPnR9Dyz7W07DHIhotGq/NI
	d3QrLarBswJoynygJQSRSYqKlWUSFpegqZg9p+3pvtTRxWUm1aQWpUYZGkAlZaykeGjeEYlKNk4
	3DA7mAtSfDF+qkkdlozVAwj+UX1PTl2qsuPitMEW2R+Xy8bq+8t/34J8R/yNQXhKQ5UM6SKMI=
X-Received: by 2002:a05:690c:c619:b0:854:d9d0:467b with SMTP id 00721157ae682-85d6cfc160fmr112291277b3.22.1788272757290;
        Tue, 01 Sep 2026 07:25:57 -0700 (PDT)
Received: from localhost ([2605:8600:200:1a83:fe59:7385:2855:8588])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-85e65f146dcsm75394907b3.23.2026.09.01.07.25.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 07:25:56 -0700 (PDT)
Date: Tue, 1 Sep 2026 10:25:52 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: David Stevens <stevensd@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: Don't call schedule_work when no spinning is
 allowed
Message-ID: <20260901142552.GG3004@cmpxchg.org>
References: <20260831234339.280376-1-stevensd@google.com>
 <apYXCL_GJs9Ovu0v@linux.dev>
 <CAOiLmNEV8b3TW_Q7+h5mYrZ1Nw73XcPFPUsapeYObLYajq_PJw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOiLmNEV8b3TW_Q7+h5mYrZ1Nw73XcPFPUsapeYObLYajq_PJw@mail.gmail.com>

On Mon, Aug 31, 2026 at 06:04:57PM -0700, David Stevens wrote:
> On Mon, Aug 31, 2026 at 5:10 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > On Mon, Aug 31, 2026 at 04:43:39PM -0700, David Stevens wrote:
> > > Memcg charging can be done from any context, but calling schedule_work()
> > > isn't safe from an NMI. If memory.high is breached from a context where
> > > spinning isn't allowed, use irq_work to schedule the reclaim work.
> > >
> > > Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")
> > > Signed-off-by: David Stevens <stevensd@google.com>
> >
> > Did you hit this issue or just code inspection? I assume this is the
> > done_restock code path.
> 
> I just found this via code inspection. I spent a little bit trying to
> trigger it for real, but the only way I managed was by writing a hacky
> driver absuing alloc_pages_nolock().
> 
> > > ---
> > >  include/linux/memcontrol.h |  1 +
> > >  mm/memcontrol.c            | 12 +++++++++++-
> > >  2 files changed, 12 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > > index 8170bb8066a2..036d973ceca6 100644
> > > --- a/include/linux/memcontrol.h
> > > +++ b/include/linux/memcontrol.h
> > > @@ -219,6 +219,7 @@ struct mem_cgroup {
> > >       spinlock_t       peaks_lock;
> > >
> > >       /* Range enforcement for interrupt charges */
> > > +     struct irq_work high_irq_work;
> >
> > Instead of adding more complexity, let's just return if we can not spin on
> > done_restock path.
> >
> 
> There would be no guarantee that memcg reclaim would ever be
> triggered, which also would also stop MEMCG_HIGH events from being
> generated. Overall that seems a more serious than just dropping
> userspace notifications like is done for MEMCG_MAX.

I'm leaning that way too. It's an indefinite error, and it's a freely
programmable surface.

IMO, a few lines of relatively straight-forward, self-explanatory code
is better than code that needs a comment and leaves a problem that
somebody in the future might run into.
