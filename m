From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 2/3] mm: Drop use of test_and_set_skip in favor of
 just setting skip
Date: Fri, 14 Aug 2020 07:24:40 -0700
Message-ID: <CAKgT0Uf0TbRBVsuGZ1bgh5rdFp+vARkP=+GgD4-DP3Gy6cj+pA@mail.gmail.com>
References: <20200813035100.13054.25671.stgit@localhost.localdomain>
 <20200813040232.13054.82417.stgit@localhost.localdomain> <6c072332-ff16-757d-99dd-b8fbae131a0c@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ggMXgX7RUq22IK8MLaR6J65bRRwoutct0090dW6uEgw=;
        b=IKlqOFJnaBfJOoWsHY8UwOXQ4vWIVHOQ9cHFWJ/Yj4+Q5myA06cA4pxzNHWNeVCEuj
         K1C032wALPmBsr7wXqR/sGzkjo5MIplBaBt2+o6hjwJ0YMNuF8k4L0vg0kgsop05Wq3t
         1VPqZHYz7U8Z2wT0h9HCgJkMoErzCNAPVxywOh5UNZ9D9tFVpSwIRLutCICVJ1At1Mx2
         DnKIzOxQ23bC10EPBpdpg91/wXpp3J9vh4lJWRJwnkNB15+DpCOAKHNafy3tRm7gQN3F
         FFRvxr8Sx/x1/7TrM1jkphLoqhfetY5yu8AE0VRah+1AJ0g/+jsjiTLSaIShPAV3qBVr
         8/xg==
In-Reply-To: <6c072332-ff16-757d-99dd-b8fbae131a0c-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>

On Fri, Aug 14, 2020 at 12:19 AM Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrot=
e:
>
>
>
> =E5=9C=A8 2020/8/13 =E4=B8=8B=E5=8D=8812:02, Alexander Duyck =E5=86=99=E9=
=81=93:
> >
> > Since we have dropped the late abort case we can drop the code that was
> > clearing the LRU flag and calling page_put since the abort case will no=
w
> > not be holding a reference to a page.
> >
> > Signed-off-by: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>
> seems the case-lru-file-mmap-read case drop about 3% on this patch in a r=
ough testing.
> on my 80 core machine.

I'm not sure how it could have that much impact on the performance
since the total effect would just be dropping what should be a
redundant test since we tested the skip bit before we took the LRU
bit, so we shouldn't need to test it again after.

I finally got my test setup working last night. I'll have to do some
testing in my environment and I can start trying to see what is going
on.

Thanks.

- Alex
