From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 0/4] memcontrol selftests fixups
Date: Wed, 18 May 2022 18:27:15 +0200
Message-ID: <20220518162715.GD16096@blackbody.suse.cz>
References: <20220518154037.18819-1-mkoutny@suse.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652891237; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XLTN/Tyn39JkGpccdAmra/lF39sYZV7UHDSVbCDu1pc=;
        b=nQNr7q5XIBVXWZ116vtSd5c5aic11kH5TURBVUDGlRg9dy5U/qjciTyPzRdccf2D75d6Yy
        P4inQtN7tVXPlNqL+yMiXOpRZ3JbQ+14erX3eLjbG4AQUJ8nSsTGZzK3AjI15fLP66/+pf
        pAhAb8TN+XNUM4L8TtuQXguOtzQ1cNA=
Content-Disposition: inline
In-Reply-To: <20220518154037.18819-1-mkoutny-IBi9RG/b67k@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Richard Palethorpe <rpalethorpe-l3A5Bk7waGM@public.gmane.org>

Apologies for spam due to botched sending.
Please disregard this (old) series.
The replacement should come in

https://lore.kernel.org/r/20220518161859.21565-1-mkoutny-IBi9RG/b67k@public.gmane.org

(That one is also not 100% correct, it's missing a Subject: therefore
may not be pass through some filters.)

The 1st patch of that v2 series is at
https://lore.kernel.org/r/20220518161859.21565-2-mkoutny-IBi9RG/b67k@public.gmane.org/

And I copy the cover letter here to be sure (and not to spam even more).

---->----
Subject: [PATCH v2 0/5] memcontrol selftests fixups

Hello.

I'm just flushing the patches to make memcontrol selftests check the
events behavior we had consensus about (test_memcg_low fails).

(test_memcg_reclaim, test_memcg_swap_max fail for me now but it's present
even before the refactoring.)

The two bigger changes are:
- adjustment of the protected values to make tests succeed with the given
  tolerance,
- both test_memcg_low and test_memcg_min check protection of memory in
  populated cgroups (actually as per Documentation/admin-guide/cgroup-v2.rst
  memory.min should not apply to empty cgroups, which is not the case
  currently. Therefore I unified tests with the populated case in order to to
  bring more broken tests).


Thanks,
Michal

Changes from v1 (https://lore.kernel.org/r/20220513171811.730-1-mkoutny-IBi9RG/b67k@public.gmane.org/)
- fixed mis-rebase in compilation fix patch,
- added review, ack tags from v1,
- applied feedback from v1 (Octave script in git tree),
- added one more patch extracting common parts,
- rebased on mm-stable bbe832b9db2e.
----<----
