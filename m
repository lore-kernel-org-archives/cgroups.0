From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH 3/4] selftests: memcg: Adjust expected reclaim values of
 protected cgroups
Date: Fri, 13 May 2022 11:52:52 -0700
Message-ID: <Yn6pBPq+lAXm9NG8@carbon>
References: <20220512174452.tr34tuh4k5jm6qjs@dev0025.ash9.facebook.com>
 <20220513171811.730-1-mkoutny@suse.com>
 <20220513171811.730-4-mkoutny@suse.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1652467979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c9TRybVbhOQgUFxoQemhb4nS3icLR/En8Zxu0EkRFzs=;
        b=UKCdjVRdCBUCF0VJzs6bgU0WyPR3VyI60/PJnQpwECHSSCbZD9gieB07JA0/lDp7vEtGX3
        tbsyD/Nsy4xjtX15B1/yCq3rz1O6uKYdhfoaXVv9QiXwEeGX2ny9G0ZntrBO0/ppJPLtN/
        YA0km8jz4BreLxE7GMpTSF1HMy7iv/Y=
Content-Disposition: inline
In-Reply-To: <20220513171811.730-4-mkoutny-IBi9RG/b67k@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Richard Palethorpe <rpalethorpe-l3A5Bk7waGM@public.gmane.org>

On Fri, May 13, 2022 at 07:18:10PM +0200, Michal Koutny wrote:
> The numbers are not easy to derive in a closed form (certainly mere
> protections ratios do not apply), therefore use a simulation to obtain
> expected numbers.
> 
> The new values make the protection tests succeed more precisely.
> 
> 	% run as: octave-cli script
> 	%
> 	% Input configurations
> 	% -------------------
> 	% E parent effective protection
> 	% n nominal protection of siblings set at the givel level
> 	% c current consumption -,,-
> 
> 	% example from testcase (values in GB)
> 	E = 50 / 1024;
> 	n = [75 25 0 500 ] / 1024;
> 	c = [50 50 50 0] / 1024;
> 
> 	% Reclaim parameters
> 	% ------------------
> 
> 	% Minimal reclaim amount (GB)
> 	cluster = 32*4 / 2**20;
> 
> 	% Reclaim coefficient (think as 0.5^sc->priority)
> 	alpha = .1
> 
> 	% Simulation parameters
> 	% ---------------------
> 	epsilon = 1e-7;
> 	timeout = 1000;
> 
> 	% Simulation loop
> 	% ---------------------
> 	% Simulation assumes siblings consumed the initial amount of memory (w/out
> 	% reclaim) and then the reclaim starts, all memory is reclaimable, i.e. treated
> 	% same. It simulates only non-low reclaim and assumes all memory.min = 0.
> 
> 	ch = [];
> 	eh = [];
> 	rh = [];
> 
> 	for t = 1:timeout
> 		% low_usage
> 		u = min(c, n);
> 		siblings = sum(u);
> 
> 		% effective_protection()
> 		protected = min(n, c);                % start with nominal
> 		e = protected * min(1, E / siblings); % normalize overcommit
> 
> 		% recursive protection
> 		unclaimed = max(0, E - siblings);
> 		parent_overuse = sum(c) - siblings;
> 		if (unclaimed > 0 && parent_overuse > 0)
> 			overuse = max(0, c - protected);
> 			e += unclaimed * (overuse / parent_overuse);
> 		endif
> 
> 		% get_scan_count()
> 		r = alpha * c;             % assume all memory is in a single LRU list
> 
> 		% commit 1bc63fb1272b ("mm, memcg: make scan aggression always exclude protection")
> 		sz = max(e, c);
> 		r .*= (1 - (e+epsilon) ./ (sz+epsilon));
> 
> 		% uncomment to debug prints
> 		% e, c, r
> 
> 		% nothing to reclaim, reached equilibrium
> 		if max(r) < epsilon
> 			break;
> 		endif
> 
> 		% SWAP_CLUSTER_MAX
> 		r = max(r, (r > epsilon) .* cluster);
> 		% XXX here I do parallel reclaim of all siblings
> 		% in reality reclaim is serialized and each sibling recalculates own residual
> 		c = max(c - r, 0);
> 
> 		ch = [ch ; c];
> 		eh = [eh ; e];
> 		rh = [rh ; r];
> 	endfor
> 
> 	t
> 	c, e

This is a cool stuff!

How about to place it into a separate file and add a comment into the code
with a reference?

Thanks!
