From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: Do not high throttle allocators based on
 wraparound
Date: Tue, 31 Mar 2020 18:04:10 +0100
Message-ID: <20200331170410.GB972283@chrisdown.name>
References: <20200331152424.GA1019937@chrisdown.name>
 <20200331155752.GN30449@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3MfpJb9zskhXycF6Q+P3UTVTg3zrJvxkcEUgjbQFmfg=;
        b=pZsnQlx7/55ukASiC3RMQ5r/VpGpt2sx3fZv4j1t5eR0lL10S2G4wpBjHN2OsIgtCn
         KDGVXMzzasVXuh0uhzi5yOdpNZ+vUfAIwB7wIP+I1kFSUB+EG32TYMcVi5PRnLZKPf4c
         0M7AXZdWVpu+HwUc1q3BzVJz1NqBP6gcWGb00=
Content-Disposition: inline
In-Reply-To: <20200331155752.GN30449-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Michal Hocko writes:
>I find this paragraph rather confusing. This is essentially an unsigned
>underflow when any of the memcg up the hierarchy is below the high
>limit, right?  There doesn't really seem anything complex in such a
>hierarchy.

The conditions to trigger the bug itself are easy, but having it obviously 
visible in tests requires a moderately complex hierarchy, since in the basic 
case ancestor_usage is "similar enough" to the test leaf cgroup's usage.
