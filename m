From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 2/5] cgroup: Account for memory_recursiveprot in
 test_memcg_low()
Date: Wed, 27 Apr 2022 16:09:28 +0200
Message-ID: <20220427140928.GD9823@blackbody.suse.cz>
References: <20220423155619.3669555-1-void@manifault.com>
 <20220423155619.3669555-3-void@manifault.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1651068569; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qG8YIn3JE35g9Ne+urDhvDL4HbkCFi0xkUxB0TL6o3I=;
        b=FagGEF9266faGYZUHMQ7LBbOYJ6Buy1ny6xrAtyvD5345V/OyTl5AOYA8+hHWKvYXPZLMK
        rm8B6wrD7trua5Vddbu7bWthowMxia9peAgV7nb6c44uDpqNIvs26PjxF7HLsaI5dPeQW6
        fItKqnIsFzukl0ZnrGQUDIED8UGpC6c=
Content-Disposition: inline
In-Reply-To: <20220423155619.3669555-3-void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Richard Palethorpe <rpalethorpe-IBi9RG/b67k@public.gmane.org>

Hello David.

On Sat, Apr 23, 2022 at 08:56:19AM -0700, David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org> wrote:
> This unfortunately broke the memcg tests, which asserts that a sibling
> that experienced reclaim but had a memory.low value of 0, would not
> observe any memory.low events. This patch updates test_memcg_low() to
> account for the new behavior introduced by memory_recursiveprot.

I think the test is correct, there should be no (not even recursive)
protection in this particular case (when the remaining siblings consume
all of parental protection).

This should be fixed in the kernel (see also [1], no updates from me yet
:-/)

Michal

[1] https://lore.kernel.org/lkml/20220322182248.29121-1-mkoutny-IBi9RG/b67k@public.gmane.org/
