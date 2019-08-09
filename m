From: Mina Almasry <almasrymina@google.com>
Subject: Re: [RFC PATCH] hugetlbfs: Add hugetlb_cgroup reservation limits
Date: Fri, 9 Aug 2019 13:57:41 -0700
Message-ID: <CAHS8izN9BFASse_pjLEhQzWwofjRv+JQ5Z=ZiR6Wywn2USLELA@mail.gmail.com>
References: <20190808194002.226688-1-almasrymina@google.com>
 <20190809112738.GB13061@blackbody.suse.cz> <CAHS8izNM3jYFWHY5UJ7cmJ402f-RKXzQ=JFHpD7EkvpAdC2_SA@mail.gmail.com>
 <fc420531-f0fe-8df5-57fe-71a686bf2a71@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oOFZs7lWd/cRN6ArflLZND+4GUEsB210O2v04GTqqFo=;
        b=oaMUzgnkhQr8vDqzN541ro79UdzcKWW6RPUgaYRCoEUrv2bw3hFwhciMuc/FZdo5rD
         vxMv49GFSKxSdt8Guqkl3Ym6D8NQAmj6ZogWqxgFOIOGN12mqRCCvqwrbBbrIFOD37y6
         M8RFhPFm8h2kqEcagvwI1ThRn2pW3BdZ4bWVhjR2aCUZMabFWTTkHEC+DlulLPsBkURQ
         J0N4hEZBmjU0BxVSkNq5NHcKLgXOHBc/TjM+c2Dd9gJEOJcM2D3+BJTM+E7rwtry6ONZ
         dZKKJ/RYUEo65s59sGogF3VXgWK0crDgh1g5Ht0zprHVMqVwqRhhHk2rQfVwWDNTQrMI
         6Lrw==
In-Reply-To: <fc420531-f0fe-8df5-57fe-71a686bf2a71@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Mike Kravetz <mike.kravetz@oracle.com>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, shuah <shuah@kernel.org>, David Rientjes <rientjes@google.com>, Shakeel Butt <shakeelb@google.com>, Greg Thelen <gthelen@google.com>, akpm@linux-foundation.org, khalid.aziz@oracle.com, open list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org

On Fri, Aug 9, 2019 at 1:39 PM Mike Kravetz <mike.kravetz@oracle.com> wrote=
:
>
> On 8/9/19 11:05 AM, Mina Almasry wrote:
> > On Fri, Aug 9, 2019 at 4:27 AM Michal Koutn=C3=BD <mkoutny@suse.com> wr=
ote:
> >>> Alternatives considered:
> >>> [...]
> >> (I did not try that but) have you considered:
> >> 3) MAP_POPULATE while you're making the reservation,
> >
> > I have tried this, and the behaviour is not great. Basically if
> > userspace mmaps more memory than its cgroup limit allows with
> > MAP_POPULATE, the kernel will reserve the total amount requested by
> > the userspace, it will fault in up to the cgroup limit, and then it
> > will SIGBUS the task when it tries to access the rest of its
> > 'reserved' memory.
> >
> > So for example:
> > - if /proc/sys/vm/nr_hugepages =3D=3D 10, and
> > - your cgroup limit is 5 pages, and
> > - you mmap(MAP_POPULATE) 7 pages.
> >
> > Then the kernel will reserve 7 pages, and will fault in 5 of those 7
> > pages, and will SIGBUS you when you try to access the remaining 2
> > pages. So the problem persists. Folks would still like to know they
> > are crossing the limits on mmap time.
>
> If you got the failure at mmap time in the MAP_POPULATE case would this
> be useful?
>
> Just thinking that would be a relatively simple change.

Not quite, unfortunately. A subset of the folks that want to use
hugetlb memory, don't want to use MAP_POPULATE (IIRC, something about
mmaping a huge amount of hugetlb memory at their jobs' startup, and
doing that with MAP_POPULATE adds so much to their startup time that
it is prohibitively expensive - but that's just what I vaguely recall
offhand. I can get you the details if you're interested).

> --
> Mike Kravetz
