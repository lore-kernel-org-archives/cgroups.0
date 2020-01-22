From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v9 3/8] hugetlb_cgroup: add reservation accounting for
 private mappings
Date: Wed, 22 Jan 2020 13:40:53 -0800
Message-ID: <CAHS8izOj7s+UnMvGzFAC6ympjfxvxybQk7Z_BVRyjj3Z4a1q+Q@mail.gmail.com>
References: <20191217231615.164161-1-almasrymina@google.com>
 <20191217231615.164161-3-almasrymina@google.com> <dec1ccd5-5973-c498-f2fe-390c1c51b2d0@oracle.com>
 <CAHS8izMzXpNMCmFh_SD7n+4+rj3QTqyRfeWQyXAhFo1-qV4iEQ@mail.gmail.com> <0ea993b0-af18-cee8-527e-f6df7e76b0be@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qOzfGqLG1EaX/BWFSgUwOINS0Jq9ooncgkzx4R9Fkjs=;
        b=Uy+ZTjJfUlZLEz9nBqJA+AJ5BgXd3gd9QKk3PWvXePIqFK+wVr304OtF1bJDyP2N7g
         mS7cLdycg8D73Dp03VE3E7oDA3DYW3pNzAZ1yx241PRvXI3pE3DtGl8nplDnFzl4YUFr
         LcruTZ1svCVSRyH3T74SE6O2PMp9S3dooiQq5KivdjnFqIctU1uarYLle986EgnqUzb0
         bc1JZCPNUvlyWEqBlM5Bz4eheeVNabuK8ZAELah3ChGuDRMORFJL3S52sJHiVc+HakJj
         Y0C4jtiflOEdNn84T0us+pv/W2wsUGxcuq+DH/aNBJaG4MihkgPIMUkexpaEWku4D+OP
         sPPg==
In-Reply-To: <0ea993b0-af18-cee8-527e-f6df7e76b0be-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aneesh Kumar <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>

On Fri, Jan 17, 2020 at 2:09 PM Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>
> On 1/14/20 2:52 PM, Mina Almasry wrote:
> > On Mon, Jan 13, 2020 at 4:55 PM Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> >>> +#ifdef CONFIG_CGROUP_HUGETLB
> >>> +     /*
> >>> +      * Since we check for HPAGE_RESV_OWNER above, this must a private
> >>> +      * mapping, and these values should be none-zero, and should point to
> >>> +      * the hugetlb_cgroup counter to uncharge for this reservation.
> >>> +      */
> >>> +     WARN_ON(!resv->reservation_counter);
> >>> +     WARN_ON(!resv->pages_per_hpage);
> >>> +     WARN_ON(!resv->css);
> >>
> >> I was once again wondering if these were always non-NULL for private mappings.
> >> It seems that reservation_counter (h_gc) would be NULL in these cases from
> >> these early checks in hugetlb_cgroup_charge_cgroup().
> >>
> >
> > You are right. I'm fixing in v10 the code and comments to account for
> > h_cg potentially being NULL, but I'm having trouble testing. Looking
> > at the code, I'm a bit confused by the checks. Seems to me
> > hugetlb_cgroup_disabled() is the same as #ifdef CONFIG_CGROUP_HUGETLB;
> > I can't find a way to enable the Kconfig but have that return false
> > unless I hack the code.
>
> What about the boot options?
>
> cgroup_disable=
> cgroup_no_v1=

Thanks, cgroup_disable=hugetlb does it. I ran the the libhugetlbfs
tests with patchset v10 and it passed, so it seems the latest version
of the patch should be fine. Of course my hugetlb cgroup tests fail
outright when hugetlb cgroups are disabled so those don't say anything
useful.
