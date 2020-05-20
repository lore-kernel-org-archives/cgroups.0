From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: unify reclaim retry limits with page allocator
Date: Thu, 21 May 2020 00:49:56 +0100
Message-ID: <20200520234956.GA892595@chrisdown.name>
References: <20200520163142.GA808793@chrisdown.name>
 <20200520164037.e3598bc902e39415f4c263e7@linux-foundation.org>
 <20200520164243.56133fa135f65cc708e70ec0@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RUfnz+3+Nkh58pbHAS8sjZcUPVeApODwUMmXr4NI2ZY=;
        b=cVDVhHg2q1D6nCUuevO4L9GrF42LCXBhesqGp2oqY+Szm4s6/HGyDkVnnMedHOHVZK
         LykgwAJlryPBcvuXF2ra2GGQUtGGoixKRuBRkoY1hdDKfDap9f7d9cIDRAT5LFl2IHF2
         KeOEFtHXVSe0jQ+iHUDUT/yqM7+JGeJa+akrM=
Content-Disposition: inline
In-Reply-To: <20200520164243.56133fa135f65cc708e70ec0-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hey Andrew,

Andrew Morton writes:
>Ah, my habit of working in reverse time order sometimes does this ;)
>
>I suggest that "mm, memcg: reclaim more aggressively before high
>allocator throttling" and this patch become a two-patch series?

Sure, they can do (sorry, I meant to add a comment mentioning the dependency, 
but forgot). I just didn't want to conflate discussion for both of them, since 
they are separate in nature :-)

I'll hold off on sending v2 until the discussion with Michal is finished.
