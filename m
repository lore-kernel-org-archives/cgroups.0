From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v2 5/5] mm: Split move_pages_to_lru into 3 separate passes
Date: Thu, 20 Aug 2020 10:15:17 -0700
Message-ID: <CAKgT0Ueibb_MBvq4CeOO2ZkQfigv5SOC4=13Bfdzdj_9zt4O7Q@mail.gmail.com>
References: <20200819041852.23414.95939.stgit@localhost.localdomain>
 <20200819042738.23414.60815.stgit@localhost.localdomain> <084c58a7-7aac-820c-9606-19391c35b9b5@linux.alibaba.com>
 <CAKgT0Ud3CZ8KHLXCrWNGJAX85x23-EWLnAV63-NMmJ+5vD1JAA@mail.gmail.com> <87ded438-e908-117d-ecfb-1af7224d46da@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MOQmfZn9DA4QXnKxyQeBWYBG/mA3vxQqGH4PKhYLc5o=;
        b=OfBzuLHZ2eSHGCtzyhVtTLqGYyG1Up4rJEWA0nr8ye40oTw8lvfrlQJXFRysqMYoDt
         eOGvCWmxBFoWGMLHQXoBHqnzSy4h2NC9VOv3VeXXQu1kI/PhBB+F+2MKDFp1BIXr78HS
         Vk33HZ2ECIEDzTQu95hzffvCTm5bzMONFui3vlVPtr7YAlnSkn55SMJ1RCht2TTIMMOh
         zEeiOHkWMWGWHZdpzhItd55aQryuPukj72Ij6RXsM2UGmfaFWCtz7UAePAj3B/nHqWRt
         7Dat4Z8Yb74jW1xR4XiSMT9Ho29VZs0MO7r5ePNd999lahMd89om26IvTh5fLLk0Dctf
         AWvQ==
In-Reply-To: <87ded438-e908-117d-ecfb-1af7224d46da-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>

On Thu, Aug 20, 2020 at 2:58 AM Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote=
:
>
>
>
> =E5=9C=A8 2020/8/19 =E4=B8=8B=E5=8D=8810:42, Alexander Duyck =E5=86=99=E9=
=81=93:
> >> It's actually changed the meaning from current func. which I had seen =
a bug if no relock.
> >> but after move to 5.9 kernel, I can not reprodce the bug any more. I a=
m not sure if 5.9 fixed
> >> the problem, and we don't need relock here.
> > So I am not sure what you mean here about "changed the meaning from
> > the current func". Which function are you referring to and what
> > changed?
> >
> > From what I can tell the pages cannot change memcg because they were
> > isolated and had the LRU flag stripped. They shouldn't be able to
> > change destination LRU vector as a result. Assuming that, then they
> > can all be processed under same LRU lock and we can avoid having to
> > release it until we are forced to do so to call putback_lru_page or
> > destroy the compound pages that were freed while we were shrinking the
> > LRU lists.
> >
>
> I had sent a bug which base on 5.8 kernel.
> https://lkml.org/lkml/2020/7/28/465
>
> I am not sure it was fixed in new kernel. The original line was introduce=
d by Hugh Dickins
> I believe it would be great if you can get comments from him.

When I brought this up before you had pointed to the relocking being
due to the fact that the function was reacquiring the lruvec for some
reason. I wonder if the fact that the LRU bit stripping serializing
things made it so that the check for the lruvec after releasing the
lock became redundant.

- Alex
