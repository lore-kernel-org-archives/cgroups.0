From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: Do not high throttle allocators based on
 wraparound
Date: Wed, 15 Apr 2020 00:39:11 -0400
Message-ID: <20200415043911.GA147015@cmpxchg.org>
References: <20200331152424.GA1019937@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=T0ov2Qm19NGfhDx7kb+Qpp+SBwZz53FIlhxAVVfKxI4=;
        b=ohUd4ClmbLBtja20CTalUO+WoLl1ve/CYr2CKbobL6GFJjNAc/LB440d9rYAIaczm+
         Kh1RiX35n8e3voiqIitcaGFBnH91SfJlcl57iEyZB4hlEhvesoMX2eOXRdntSRzr+hkH
         dOgBVJDAi3bFtryful1Kxe6qHJjkhz8LI+/jrG88Tceh+0BEVEYbpFpYF0ghcHG85Bds
         xGbea9oZ/UqbxOf2r/VOb2z4UXNriOnt8vLpgXJTQ3e/vG7ky2SV4TLQSwKYnh7deLwR
         oAwhiU7x7YTEH6UiJ6nFbWPhGeJ7/i28lQNYphRYEI0IgJ7Lpo8+wtqijJbG7rp5t8sG
         Io+w==
Content-Disposition: inline
In-Reply-To: <20200331152424.GA1019937-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Mar 31, 2020 at 04:24:24PM +0100, Chris Down wrote:
> From: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> 
> If a cgroup violates its memory.high constraints, we may end
> up unduly penalising it. For example, for the following hierarchy:
> 
> A:   max high, 20 usage
> A/B: 9 high, 10 usage
> A/C: max high, 10 usage
> 
> We would end up doing the following calculation below when calculating
> high delay for A/B:
> 
> A/B: 10 - 9 = 1...
> A:   20 - PAGE_COUNTER_MAX = 21, so set max_overage to 21.
> 
> This gets worse with higher disparities in usage in the parent.
> 
> I have no idea how this disappeared from the final version of the patch,
> but it is certainly Not Good(tm). This wasn't obvious in testing
> because, for a simple cgroup hierarchy with only one child, the result
> is usually roughly the same. It's only in more complex hierarchies that
> things go really awry (although still, the effects are limited to a
> maximum of 2 seconds in schedule_timeout_killable at a maximum).
> 
> [chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org: changelog]
> 
> Fixes: e26733e0d0ec ("mm, memcg: throttle allocators based on ancestral memory.high")
> Signed-off-by: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 5.4.x

Oops.

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
