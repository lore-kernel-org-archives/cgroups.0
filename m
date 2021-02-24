From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] memcg: cleanup root memcg checks
Date: Wed, 24 Feb 2021 15:41:44 -0500
Message-ID: <YDa6CPuLBPwclYp6@cmpxchg.org>
References: <20210223205625.2792891-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EwNM4IQrP65m3pBxQdPq3PIkStWcpBTasxWsf7+C0lo=;
        b=oynA0tAUXRRCGRxkmQGoFtzMRLvf+22xVNOkpXfaZ3ShiECJzsBik78xQsBCe2C7Ey
         uv/GVxd8ChE9O5nHMvqVZBh+PuvvYDYAENDW5HjbHyecOl9ca+i361mperXkFpE/ckHp
         AbJGwXquplMfFHdrnYcGkVAYrgUneo/hCd91ApPj9Fe/mDlLz3fNjPoou6lbl+UPqc26
         LoT5jV/vczsQTsBXcNmR1HX7Xqu3ITA//sVu5lz8AM1TIivwA9pWY1IrRD+of6J0s4lE
         SRKdT2CGdxuUGNRCrXK5YBk4EyH3UAVXqS/agvlVNAUqVFt2Q9cT27TzExcL7mR0aJFt
         je4A==
Content-Disposition: inline
In-Reply-To: <20210223205625.2792891-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Feb 23, 2021 at 12:56:25PM -0800, Shakeel Butt wrote:
> Replace the implicit checking of root memcg with explicit root memcg
> checking i.e. !css->parent with mem_cgroup_is_root().
> 
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
