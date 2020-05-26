From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH mm v5 RESEND 2/4] mm: move penalty delay clamping out of
 calculate_high_delay()
Date: Tue, 26 May 2020 10:36:19 -0400
Message-ID: <20200526143619.GB848026@cmpxchg.org>
References: <20200521002411.3963032-1-kuba@kernel.org>
 <20200521002411.3963032-3-kuba@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gSMxkbANh+XLN6PP/4ucZuGEACp8kUKlkMdq6GXfIvM=;
        b=U+0g7ZbyD4qZebQ9Yr1Tde+o7I3mql3aPxL8sWDvzlxU5cmn3t+uZbtx6mIDzprHCt
         2C1fQt0QvnAPRBhgLV1A3bTwEtphKN0Lc25f0vKTBeBo2MSRgY/a7fkL6Pa7k6lRb8ZM
         94e45AvYbveRYbGHyWuW2Njv/RRLthFzznzNwqkkTSBAhWQdyICWRSo5fZ3SIx4kGrU0
         mNrFMJNxiRIop05HbW3bdvfcWD+GC1x8BjbP9We1hQ/lH+EkPK6bs2I7dwerFkfHRpxL
         iYavJ0KJ10REHmnxvLdjnI4beMn21lvjWSTncPsPsjtGSDIS0L6UPtmAoe3Qu8OSCfol
         CYYw==
Content-Disposition: inline
In-Reply-To: <20200521002411.3963032-3-kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On Wed, May 20, 2020 at 05:24:09PM -0700, Jakub Kicinski wrote:
> We will want to call calculate_high_delay() twice - once for
> memory and once for swap, and we should apply the clamp value
> to sum of the penalties. Clamping has to be applied outside
> of calculate_high_delay().
> 
> Signed-off-by: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
