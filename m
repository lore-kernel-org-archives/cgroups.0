From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH] XArray: handle XA_FLAGS_ACCOUNT in xas_split_alloc
Date: Fri, 27 May 2022 10:47:46 -0700
Message-ID: <YpEOwrBe2UzJZr9E@carbon>
References: <348dc099-737d-94ba-55ad-2db285084c73@openvz.org>
 <YpAnqqY/c3Y5ZkPG@casper.infradead.org>
 <CALvZod7iyO5Ti5xhzq36UjDFNAmfEyPk1MQv_t4kUHKuPCeNng@mail.gmail.com>
 <d4e81087-d057-4edb-5df0-47d99a1c72d9@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1653673673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GyZxhrFIbciyaIa9/uGSSo/bdh7XAme4AdSjV5SMRRg=;
        b=ZqRzG1adM/lY8etIuMIydjIQZ2VDwDQ5EbKSiqF0cCHyjgI7PSsx0GyLAGXqymvqrQRzFy
        m6d0oBpA7fhs0ygGeSr6RnfWTd1tWH9vTAM0+lt4j3iZs9fDLjDmE6+9DdMx46FFB12loF
        fpzD0JKuyQ8nOhyDo8hiz7eW4QtIg5s=
Content-Disposition: inline
In-Reply-To: <d4e81087-d057-4edb-5df0-47d99a1c72d9-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, May 27, 2022 at 02:22:19PM +0300, Vasily Averin wrote:
> On 5/27/22 04:40, Shakeel Butt wrote:
> > On Thu, May 26, 2022 at 6:21 PM Matthew Wilcox <willy-wEGCiKHe2LqWVfeAw=
A7xHQ@public.gmane.org> wrote:
> >>
> >> On Wed, May 25, 2022 at 11:26:37AM +0300, Vasily Averin wrote:
> >>> Commit 7b785645e8f1 ("mm: fix page cache convergence regression")
> >>> added support of new XA_FLAGS_ACCOUNT flag into all Xarray allocation
> >>> functions. Later commit 8fc75643c5e1 ("XArray: add xas_split")
> >>> introduced xas_split_alloc() but missed about XA_FLAGS_ACCOUNT
> >>> processing.
> >>
> >> Thanks, Vasily.
> >>
> >> Johannes, Shakeel, is this right?  I don't fully understand the accoun=
ting
> >> stuff.
> >>
> >=20
> > If called from __filemap_add_folio() then this is correct.
> >=20
> > However from split_huge_page_to_list(), we can not use the memcg from
> > current as that codepath is called from reclaim which can be triggered
> > by processes of other memcgs.
> Btw, Shakeel, Johannes,
> I would like to understand, when Xarray should use XA_FLAGS_ACCOUNT ?
>=20
> From my point of view, this should be useless:
> a) if Xarray stores some index (idr?) - his memory is quite small,
> and his accounting can be ignored.
> b) if Xarray stores some accounted - the size of the corresponding Xarray
> infrastructure is usually significantly smaller than the size of the stor=
ed object,
> s=D0=BE his accounting can be skipped too.
> c) if Xarray stores some non-accounted objects - it makes no sense to acc=
ount=20
> corresponding Xarray infrastructure. In case of necessary it makes much m=
ore sense
> to enable accounting for stored objects (and return to case b).
>=20
> Am I missed something important perhaps?
>=20
> I looked for the description of 7b785645e8f1, but o be honest I'm still n=
ot sure
> that I understand correctly why XA_FLAGS_ACCOUNT flag solved the describe=
d problem.
>=20
> Could you please explain this in more details?
>=20
> Was it because the non-accounted Xarray kept a reference to the stored ob=
ject
> and thus prevents it from being reclaimed?
>=20
> If so, was it some special case, or should it affect all such cases,
> and my b) statement above is not correct?


It's all about shadow entries, which are small, so b) is not true for them.
There is a good description on how it works on top of mm/workingset.c
