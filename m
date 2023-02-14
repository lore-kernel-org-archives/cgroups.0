From: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 3/4] mm: hugetlb: change to return bool for
 isolate_hugetlb()
Date: Tue, 14 Feb 2023 10:21:31 -0800
Message-ID: <Y+vRK7kYP0xVZ9Ya@monkey>
References: <20230214180324.71585-1-sj@kernel.org>
 <20230214180708.71645-1-sj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=Dro3dOKPHeqN7sL7Zc/rx5HdY277Qb+t6IZXlIvMOe0=;
 b=0bjhV7TaSIAvE81V6WXqyWtlOTypAS08RzJKho8tFAqMN9+JHmu8Oj84ObFNHuGNJhAh
 pmtfxbgZL6/Kc1paIsu9RtszS2QSZ03gNrTzqhBUSIW1XPt9amaXc/JiDHpLojycxD3W
 sxrsnI6oCGeQHlnAzBJH2/ytCmHwyq4HPi/sDM8yXyXQnKEBScicsMC5hzy8wEawC9/5
 p3I3khfs3FMG6OPNnY5qI71iM2sZGDvLwJyBIzMwHf4gt+78JOlL0gwDFIYqgvQVBG67
 1Dz/8PJk48ceNzMe+S/C9n6A5BkAZ6YEstrnXmlK5PTz3g1CPktMq4j4wbc3kXK/fkt7 nQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dro3dOKPHeqN7sL7Zc/rx5HdY277Qb+t6IZXlIvMOe0=;
 b=V6oftWAtpb6pBVRvlLRtmwfXk4gawBAeAqN7oABxqq8FgEAF17F0dJoLG2XjO2c5BVcnhf/fIqFLF1BXPej2DWK3DhJaP6LdsADqdCmNpWOsCy2r79tpBl7XQ6P/fMEgzuTgBKo0mvZb/dPPdi1aIHX5Tw87rl92kjw8uXhNtvE=
Content-Disposition: inline
In-Reply-To: <20230214180708.71645-1-sj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: SeongJae Park <sj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, naoya.horiguchi-YMj9X0ASwKA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, osalvador-l3A5Bk7waGM@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, damon-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 02/14/23 18:07, SeongJae Park wrote:
> On Tue, 14 Feb 2023 18:03:24 +0000 SeongJae Park <sj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> 
> > On Tue, 14 Feb 2023 21:59:31 +0800 Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote:
> > 
> > > Now the isolate_hugetlb() only returns 0 or -EBUSY, and most users did not
> > > care about the negative value, thus we can convert the isolate_hugetlb()
> > > to return a boolean value to make code more clear when checking the
> > > hugetlb isolation state. Moreover converts 2 users which will consider
> > > the negative value returned by isolate_hugetlb().
> > > 
> > > No functional changes intended.
> > > 
> > > Signed-off-by: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> > > ---
> > >  include/linux/hugetlb.h |  6 +++---
> > >  mm/hugetlb.c            | 12 ++++++++----
> > >  mm/memory-failure.c     |  2 +-
> > >  mm/mempolicy.c          |  2 +-
> > >  mm/migrate.c            |  2 +-
> > >  5 files changed, 14 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> > > index df6dd624ccfe..5f5e4177b2e0 100644
> [...]
> > > diff --git a/mm/migrate.c b/mm/migrate.c
> > > index 53010a142e7f..c5136fa48638 100644
> > > --- a/mm/migrate.c
> > > +++ b/mm/migrate.c
> > > @@ -2128,7 +2128,7 @@ static int add_page_for_migration(struct mm_struct *mm, unsigned long addr,
> > >  		if (PageHead(page)) {
> > >  			err = isolate_hugetlb(page_folio(page), pagelist);
> > >  			if (!err)
> > > -				err = 1;
> > > +				err = -EBUSY;
> > 
> > Again, I think this is confusing.  'err' is 'bool', not 'int'.
> 
> I mean, 'err' is not 'bool' but 'int', sorry.  See? This confuses me ;)
> 

Yes,
in the case here (and elsewhere) I like David's suggestion of using a separate
bool such as 'isolated' to capture the return value of the isolate function.
Then, the statement:

	err = isolated ? 0 : -EBUSY;

would be pretty clear.
-- 
Mike Kravetz
