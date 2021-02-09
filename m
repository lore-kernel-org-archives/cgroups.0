From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH stable 4.9] mm: memcontrol: fix NULL pointer crash in
 test_clear_page_writeback()
Date: Tue, 9 Feb 2021 16:19:46 -0500
Message-ID: <YCL8cnXFtpdnAAUj@cmpxchg.org>
References: <20210209202616.2257512-1-f.fainelli@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=E+GwgIRGKbJyN6BMx9osGrabexMLPqEhC8h9yJvwcPI=;
        b=qVg6eWt/p+mtaLHMJ3UMS3pa7cP8tRdSZltmlPVvywtYM1Xz2GgR7lvaILGqsvNc5q
         vYrdlEDpJ6LAExkiYJ+B2vgDJ4ic2ZFx3wDChTDEaZfGBOTtJtLCbFQKoE4/Vk9+CRMe
         /MncFu/kd8cMm7K8t7NNOuyjR2eP2G5CTovSmA03FmKDfH7k80wPNw51QigLDkuqVVoO
         9Jsosv3nlBPAAyWAq3Pt67mVcQfjR5jY5YDPEDWGyqd4Kp1yax1q4OadysJ422FdpCbt
         WX/JTNoTftwxDefcRi52Porkf9IdP/D/O6sbzPHti4g2tYZ9YwaiO2XPK1xOKsZWKK6h
         TUWw==
Content-Disposition: inline
In-Reply-To: <20210209202616.2257512-1-f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Bradley Bolen <bradleybolen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Prakash Gupta <guptap-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Tue, Feb 09, 2021 at 12:26:15PM -0800, Florian Fainelli wrote:
> From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> 
> commit 739f79fc9db1b38f96b5a5109b247a650fbebf6d upstream

...

> This patch is present in a downstream Android tree:
> 
> https://source.mcwhirter.io/craige/bluecross/commit/d4a742865c6b69ef931694745ef54965d7c9966c
> 
> and I happened to have stumbled across the same problem too.
> 
> Johannes can you review it for correctness with respect to the 4.9
> kernel? Thanks!

Looks good to me.
