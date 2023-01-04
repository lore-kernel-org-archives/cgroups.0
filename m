From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 00/10] docs: cgroup-v1: formatting improv for "Memory
 Resource Controller" doc
Date: Wed, 4 Jan 2023 11:27:39 -1000
Message-ID: <Y7XvS5LJK01lWq48@slm.duckdns.org>
References: <20221219042209.22898-1-bagasdotme@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xdMyQrIHWeXBS5vaDhN2cRckBSGcEP38oOfunYml57w=;
        b=iX1y43d8OBGxLwGmJscAlBFVnoWSPofv9iXyHsuaXj45BXH9vjeirS5X7+rIV9ZZhI
         kgmsMBU1MysDrFbe5rtEWFt3D2dmZmvt2X51oLkbTZJaWB5ewxlLnwJhiMW7BreTmtfW
         gUO9PK9xlkX5hzeZQafxvgzJNW1B/yl2HD4O0wLbybwd/pYpO6kvt2y4c332bDDpWc17
         buMOo5EORzykQc5P1bAlU++s1JKjLPniSHO9H1zEkv4emgaz3yQe4kJPFanSwrCTgIK3
         /Q+NYDb2RAQraD1dbEv0ycfBtTFyFeBCuk0miK7rATtvKPXxIMcj5DbUXdFZIDn6+JSO
         5q5w==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221219042209.22898-1-bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Mon, Dec 19, 2022 at 11:21:59AM +0700, Bagas Sanjaya wrote:
> "Memory Resource Controller" CGroup v1 documentation has been in reST
> since 99c8b231ae6c6c ("docs: cgroup-v1: convert docs to ReST and rename to *.rst"). The current doc look is kinda ugly, so improve the formatting (only
> htmldocs is tested).
> 
> The first patch is a fix for recently reported htmldocs warning, which can
> be pickup separately from rest of the series.
> 
> Bagas Sanjaya (10):
>   docs: cgroup-v1: extend underline of section 8
>   docs: cgroup-v1: replace custom note constructs with appropriate
>     admonition blocks
>   docs: cgroup-v1: wrap remaining admonitions in admonition blocks
>   docs: cgroup-v1: use code block for locking order schema
>   docs: cgroup-v1: fix footnotes
>   docs: cgroup-v1: move hierarchy of accounting caption
>   docs: cgroup-v1: use bullet lists for list of stat file tables
>   docs: cgroup-v1: use make swap extension subsections subsections
>   docs: cgroup-v1: add internal cross-references
>   docs: cgroup-v1: use numbered lists for user interface setup
> 
>  .../admin-guide/cgroup-v1/cgroups.rst         |   2 +
>  .../admin-guide/cgroup-v1/memory.rst          | 290 ++++++++++--------
>  2 files changed, 158 insertions(+), 134 deletions(-)

Patchset doesn't apply. Can you please rebase on top of linus#master and
drop reference to the commit in -next?

Thanks.

-- 
tejun
