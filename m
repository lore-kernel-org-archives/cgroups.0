From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: Re: [Question] io cgroup subsystem threaded support
Date: Mon, 11 Oct 2021 17:34:16 +0200
Message-ID: <20211011153416.GB61605@blackbody.suse.cz>
References: <20211001110645.uzw2w5t4rknwqhma@T580.localdomain>
 <20211007133916.mgk6qb65d2r57fc2@T580.localdomain>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1633966458; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZL4FlCU5ckfxXlCQEcdiVJas2l+qPTW/K1inX6vWtpY=;
        b=ZaVEyJ2OYsHCWHcdHtNktV8SP1RE4O5Hm9uc2Y8bLSEQ8tGgVWSeMa9/vwvfVALILKo2ms
        WoTZtyamBomNpEvlr0MrPn3NnsfP0Cm46gvQwuCmllDkGxNsCG+nyP6yKr+Fq1FNHfWTDW
        XylMA3SzpDtokKMxBgtByuYAUWiDlIc=
Content-Disposition: inline
In-Reply-To: <20211007133916.mgk6qb65d2r57fc2-3Hjs5a4P6Kh82hYKe6nXyg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Odin Hultgren van der Horst <odin-KgRVb285F3Y0FkRhN5fn+A@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello.

On Thu, Oct 07, 2021 at 03:39:16PM +0200, Odin Hultgren van der Horst <odin-KgRVb285F3Y0FkRhN5fn+A@public.gmane.org> wrote:
> So mainly the writeback functionality or is it ingrained in all
> functionality like latency and priority?

What do you want to achieve actually?

> If not, is there a subset of io cgroup subsys that could easily support threading?

I'd say such a subset would be similar to what can be done with
ioprio_set(2).

Michal
