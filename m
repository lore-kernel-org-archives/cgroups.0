From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 00/10] docs: cgroup-v1: formatting improv for "Memory
 Resource Controller" doc
Date: Wed, 4 Jan 2023 06:53:59 -1000
Message-ID: <Y7WvJzquc8r81X9u@slm.duckdns.org>
References: <20221219042209.22898-1-bagasdotme@gmail.com>
 <87a630h5mv.fsf@meer.lwn.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bbOBQVb3RdLyfUHgOO8SrdRe73a4J3V0VjVeqsiIMyg=;
        b=EA3IfsuvB4+ngQcFgXazs9up+BHg+GXLXmIVafCOFWXPSUT8axBmcCc1JLrx5b6W1g
         siIkRYQTpey+yElpHtfv87wOzTxE1v0zyYy3Ex6tm3thIOOa4gDPySQs03+yg6balCQx
         qNCujaog5PzmZaRXHveJ3HYnAXxfGp/cPKgwa3pVXzBDvE03j9DPoc3cObdHkE9krfiE
         vD/7euCAVa13V48VfRFiUeNVkDMFrV0BEofVemxwLx5Iry3H/bmcrseymZRPP1F+yyPW
         PNFU4dOkcT52xQ3eLLHRLdsJZRRT/fAIt8ug5+5mwBK9th/QDNdlPXPJ61BMzrsAauOP
         vTZw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87a630h5mv.fsf-K7Oyngvb+qHk1uMJSBkQmQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Cc: Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Mon, Jan 02, 2023 at 04:35:20PM -0700, Jonathan Corbet wrote:
> Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
> 
> > "Memory Resource Controller" CGroup v1 documentation has been in reST
> > since 99c8b231ae6c6c ("docs: cgroup-v1: convert docs to ReST and rename to *.rst"). The current doc look is kinda ugly, so improve the formatting (only
> > htmldocs is tested).
> >
> > The first patch is a fix for recently reported htmldocs warning, which can
> > be pickup separately from rest of the series.
> >
> > Bagas Sanjaya (10):
> >   docs: cgroup-v1: extend underline of section 8
> >   docs: cgroup-v1: replace custom note constructs with appropriate
> >     admonition blocks
> >   docs: cgroup-v1: wrap remaining admonitions in admonition blocks
> >   docs: cgroup-v1: use code block for locking order schema
> >   docs: cgroup-v1: fix footnotes
> >   docs: cgroup-v1: move hierarchy of accounting caption
> >   docs: cgroup-v1: use bullet lists for list of stat file tables
> >   docs: cgroup-v1: use make swap extension subsections subsections
> >   docs: cgroup-v1: add internal cross-references
> >   docs: cgroup-v1: use numbered lists for user interface setup
> >
> >  .../admin-guide/cgroup-v1/cgroups.rst         |   2 +
> >  .../admin-guide/cgroup-v1/memory.rst          | 290 ++++++++++--------
> >  2 files changed, 158 insertions(+), 134 deletions(-)
> 
> Tejun, do you have an opinion on these?  I'm not really sure we need to
> be tweaking the v1 docs at this point, but I don't see anything in here
> that seems harmful either...

One of the patches doesn't apply because it's against -next (it's
referencing -next sha1 too) and the series feels a bit overly elaborate but,
I mean, why not? I was planning to pick up the series after the holidays
unless you wanna route it through the doc tree.

Thanks.

-- 
tejun
