From: 'Tejun Heo' <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] block/blk-iocost (gcc13): cast enum members to int in
 prints
Date: Wed, 2 Nov 2022 06:43:42 -1000
Message-ID: <Y2KePvYRRMOrqzOe@slm.duckdns.org>
References: <20221031114520.10518-1-jirislaby@kernel.org>
 <Y1++fLJXkeZgtXR2@infradead.org>
 <Y2AMcSPAJpj6obSA@slm.duckdns.org>
 <d833ad15-f458-d43d-cab7-de62ff54a939@kernel.org>
 <Y2FNa4bGhJoevRKT@slm.duckdns.org>
 <2b975ee3117e45aaa7882203cf9a4db8@AcuMS.aculab.com>
 <Y2Kaghnu/sPvl0+g@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IjILPpgQCkdJ4ZJ00jqJd+jDzKRU2FaGMqk858NL3dc=;
        b=dmYqXsN8lNSxDB0uXZQ6rsGrA/k+VAfEyFqeOxCavCTGaiakcfSobJRaJXd2d44clP
         vePC8myNAyorRGZlHkyKFDWfDtHP5piVxFEmd2RIXh2alwwo5zzXbMM0gVYAB240ufeC
         BgwRQpvEbW5ci641cMKU9oeO0uy5YHwABAcwhS+tW9+uFasjdpHBw5kBn4hlu+yvhexy
         zYdekQFPfwwqLUoR4mMgJ+pjdSLT6VTwv8IL2TQMfn6TVQtNqv5voIx3cG1/YBxQ60Xo
         X1/4W/XW8zPw9QTSfFsoZeywYppP3uQCxwbKM76sSytyCSMZqvIX5bYdoFsGDSQ29g0O
         OSDg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Y2Kaghnu/sPvl0+g-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org>
Cc: Jiri Slaby <jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Martin Liska <mliska-AlSwsSmVLrQ@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Nov 02, 2022 at 06:27:46AM -1000, 'Tejun Heo' wrote:
> On Wed, Nov 02, 2022 at 08:35:34AM +0000, David Laight wrote:
> > I think the enums have to be split.
> > There will be other side effects of promoting the constants to 64bit
> > that are much more difficult to detect than the warnings from printf.
> 
> idk, I think I can just add LLU to everything and it should be fine.
> 
> > I'm also not sure whether the type is even consistent for 32bit
> > and 64bit builds.
> > Casts are (sort of) horrid.
> 
> Yeah, I don't think casts are the solution either. Lemme add LLU to
> everything and see how it works.

So adding LLU to initializers don't make the specific enum's type follow
suit. I guess type determination is really based on the value range. Oh man,
what a mess.

If we end up having to split the enum defs, that's what we'll do but this
doesn't sense to me. It's one thing to make one time adjustment when we
adopt -std=g2x. That's fine, but it makes no sense for the compiler to
change type behavior underneath existing code bases in a way that prevents
the same code to mean the same thing in adjacent and recent compiler
versions. Even if gcc goes for that for whatever reason, there gotta be an
option to keep the original behavior, right?

If so, my suggestion is just sticking with the old behavior until we switch
to --std=g2x and then make one time adjustment at that point.

Thanks.

-- 
tejun
