From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 2/5] cgroup: Account for memory_recursiveprot in
 test_memcg_low()
Date: Fri, 29 Apr 2022 11:26:20 +0200
Message-ID: <20220429092620.GA23621@blackbody.suse.cz>
References: <20220423155619.3669555-1-void@manifault.com>
 <20220423155619.3669555-3-void@manifault.com>
 <20220427140928.GD9823@blackbody.suse.cz>
 <20220429010333.5rt2jwpiumnbuapf@dev0025.ash9.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1651224381; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U29ZMPPzFK4uUEyUYePHiz2qlt3Ri7SCZ7aNiH026UY=;
        b=IGPyVwbIILUdzwZFwC6tg5ufsIZXP5ClacMvrcvkQiCZaeUgVRAYMM/AoNO9PpHjD/AEcL
        fOWpgPD83vJ1gjAAlqWmAdKmqOLaAsi5QlzP+Y1N3FfIUGIGGIZFJNt++GwMtNRmpzL3Rs
        N46aQwwVuCxWp71FRvxzu2n0+VXMq3Q=
Content-Disposition: inline
In-Reply-To: <20220429010333.5rt2jwpiumnbuapf-2sxDN0k4oOr/D8ZFBB3Vemm1Eemhq0z/AL8bYrjMMd8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Richard Palethorpe <rpalethorpe-IBi9RG/b67k@public.gmane.org>

On Thu, Apr 28, 2022 at 06:03:33PM -0700, David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org> wrote:
> but my interpretation of the rest of that discussion with Roman is
> that we haven't yet decided whether we don't want to propagate
> memory.low events from children cgroups with memory.low == 0. Or at
> the very least, some more justification was requested on why not
> counting such events was prudent.

I'm not a fan of that original proposal of mine anymore (to be more
precise, of _only_ that patch, there's still the RFCness reason 1) to
consider).
As I shared with the last reply there, there's a problem in the behavior
which shouldn't be masked by filtering some events.

> Would you be ok with merging this patch so that the cgroup selftests can
> pass again based on the current behavior of the kernel, and we can then
> revert the changes to test_memcg_low() later on if and when we decide that
> we don't want to propagate memory.low events for memory.low == 0 children?

I still think that the behavior when there's no protection left for the
memory.low == 0 child, there should be no memory.low events (not just
uncounted but not happening) and test should not accept this (even
though it's the current behavior).

What might improve the test space would be to have two configs like

Original one (simplified here)
	parent		memory.low=50M	memory.current=100M
	` child1	memory.low=50M	memory.current=50M
	` child2	memory.low=0M	memory.current=50M

New one (checks events due to recursive protection)
	parent		memory.low=50M	memory.current=100M
	` child1	memory.low=40M	memory.current=50M
	` child2	memory.low=0M	memory.current=50M

The second config assigns recursive protection to child2 and should
therefore cause memory.low events in child2 (with memory_recursiveprot
enabled of course).

Or alternative new one (checks events due to recursive protection)
	parent		memory.low=50M	memory.current=100M
	` child1	memory.low=0M	memory.current=50M
	` child2	memory.low=0M	memory.current=50M

HTH,
Michal
