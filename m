From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Reorganize css_set_lock and kernfs path
 processing
Date: Tue, 6 Sep 2022 07:13:21 -1000
Message-ID: <Yxd/sUQ/NB3NlC6f@slm.duckdns.org>
References: <20220905170944.23071-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date;
        bh=42bQWA0qZBsxm3OOPTZKyEAb0lweU3co0C6JWYj3U0Y=;
        b=CAF0j+NHyujvUVorHf1g2IPoP/FNkjlA1Dm3pUNb/eAjF/7d+k+3EkfRyFx4M0jM4e
         gtoiQMCyWlfphdr+MYytsA+fF8SAg3rYUlI7O9gKyIE7MDTZcCnQV1fxz6b2C0xaPHIY
         XK4hwFkPK/pFcCD9quOMLZl8hoBj4PGHlPbR/yKJIaSJuA1Fw6TU/Fmjl+TnKU9liVyG
         TqCj1HUz36yHyLJ5Gb+XzxttyngfyKAt8GR8e9+IdqJ/8sWtGhY+Zb/crFxPScTEYsPT
         GX5sgkeoOKOexkBQ3AHKHi0LHCZqCyEduyZeal9e+DTZ+LziuzpkUZVJcTZ97dVb9WwU
         aG3w==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220905170944.23071-1-mkoutny-IBi9RG/b67k@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Hello, Michal.

On Mon, Sep 05, 2022 at 07:09:44PM +0200, Michal Koutn=FD wrote:
> I considered adding get_cgroup() into current_cgns_cgroup_from_root to
> avoid reliance on the transitive pinning via css_set.=20
> After reasoning about no asynchronous NS switch and v1 hiearchies kill_sb=
 it
> didn't seem to bring that much benefit (it didn't compose well with
> BUG_ON(!cgrp) neither).

I still think this is too subtle and incidental. If we go this way, we'd
need to add comments explaining why this obviously confusing pattern (lock,
find obj, unlock, use obj) is being used which goes into how the object is
directly pinned through the css_set which happens to be pinned also
because... and so on. Even if the code looks a bit uglier, I'd much prefer
straight-forward pinning.

Thanks.

--=20
tejun
