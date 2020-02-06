From: Mina Almasry <almasrymina@google.com>
Subject: Re: [PATCH v11 2/9] hugetlb_cgroup: add interface for charge/uncharge
 hugetlb reservations
Date: Thu, 6 Feb 2020 10:16:01 -0800
Message-ID: <CAHS8izOYB3cz+EP4G8qNJygO7Zjq6AFbpnGrjthCXKi4DHUx3A@mail.gmail.com>
References: <20200203232248.104733-1-almasrymina@google.com>
 <20200203232248.104733-2-almasrymina@google.com> <a48fbdd1-fc0e-f17d-09c2-1492c8466254@oracle.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hqXyWTPsRk1sbEhv4F9kR6Aqgito1sCOBhDIlov5OKo=;
        b=kPIbp8EjtDr3arTeSUaNQfsuunB6rDyUC15mM8xmbQzCU6cCM9dZcABgKrZu4aA4ot
         zGuPoZjW03Kp1BP9L3alLJLvShDanfAxcTC0vG5bq/BAE5FXyJVYDAKHvx5m39Yiv3MX
         3y6ca5OVMQ8AlQEMGZpuo2T9mcNKYt6EI8Z4OfEFgWzxk2cutJWG3VAKPyeJMZETw3Se
         7IhrMnmTt3fKkQ7CP84POfDcoJX7OVACnImZLwfi4pnotY7FBPiwV+g1jHcv+pYo2k/3
         zhAr8gEiBDGGaCaQ9VTVp+Kqfq3MxqzKgQw5MLl4pU9oEDHH8EUydogxSexQaL4d5J7x
         ogaA==
In-Reply-To: <a48fbdd1-fc0e-f17d-09c2-1492c8466254@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Kravetz <mike.kravetz@oracle.com>
Cc: shuah <shuah@kernel.org>, David Rientjes <rientjes@google.com>, Shakeel Butt <shakeelb@google.com>, Greg Thelen <gthelen@google.com>, Andrew Morton <akpm@linux-foundation.org>, open list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org

On Wed, Feb 5, 2020 at 2:08 PM Mike Kravetz <mike.kravetz@oracle.com> wrote:
>
> On 2/3/20 3:22 PM, Mina Almasry wrote:
> > Augments hugetlb_cgroup_charge_cgroup to be able to charge hugetlb
> > usage or hugetlb reservation counter.
> >
> > Adds a new interface to uncharge a hugetlb_cgroup counter via
> > hugetlb_cgroup_uncharge_counter.
> >
> > Integrates the counter with hugetlb_cgroup, via hugetlb_cgroup_init,
> > hugetlb_cgroup_have_usage, and hugetlb_cgroup_css_offline.
> >
> > Signed-off-by: Mina Almasry <almasrymina@google.com>
> > Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
> > Acked-by: David Rientjes <rientjes@google.com>
> >
> > ---
> >
> > Changes in v11:
> > - Changed all 'reserved' or 'reservation' to 'rsvd' to reflect the user
> > interface.
>
> Thanks.
>
> Small nit,
>
> > @@ -450,8 +496,7 @@ static ssize_t hugetlb_cgroup_reset(struct kernfs_open_file *of,
> >       struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_css(of_css(of));
> >
> >       counter = &h_cg->hugepage[MEMFILE_IDX(of_cft(of)->private)];
> > -     rsvd_counter =
> > -             &h_cg->rsvd_hugepage[MEMFILE_IDX(of_cft(of)->private)];
> > +     rsvd_counter = &h_cg->rsvd_hugepage[MEMFILE_IDX(of_cft(of)->private)];
> >
>
> That looks like a change just to reformat a line added in the first patch?
>
> >       switch (MEMFILE_ATTR(of_cft(of)->private)) {
> >       case RES_MAX_USAGE:
>

Gah, my bad. I'll move this to patch 1.

> --
> Mike Kravetz
