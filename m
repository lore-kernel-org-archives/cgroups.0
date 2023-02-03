From: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cpuset: Fix cpuset_cpus_allowed() to not filter
 offline CPUs
Date: Fri, 3 Feb 2023 11:50:46 +0000
Message-ID: <20230203115045.GB5927@willie-the-truck>
References: <20230131221719.3176-1-will@kernel.org>
 <20230131221719.3176-2-will@kernel.org>
 <6b068916-5e1b-a943-1aad-554964d8b746@redhat.com>
 <Y9otWX+MGOLDKU6t@hirez.programming.kicks-ass.net>
 <83e53632-27ed-8dde-84f4-68c6776d6da8@redhat.com>
 <a892d340-ea99-1562-0e70-176f02f195c2@redhat.com>
 <Y9rVVldS19oyIZ+g@hirez.programming.kicks-ass.net>
 <773e2f22-211e-163f-64bb-15ae29ad161b@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675425051;
        bh=PXEna3R+6kpChu3+xAiwe71pF38XzueJzaRSerG6yiA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XZvioM8ZgWnnY66Z2DxMSsyhYUl/s3h+wcmd7rfp9w0kdvLVjMdMQ1NI7jnq4kLLJ
         c5kqwvtnYs1pqSVdIOKD9Q0Xp2Z+egXzOccUafPGmYN72SVtst66VY3ZDHQvBxFw2x
         G9gQCtwU3YnypoqHRiaGoc5JjgpLrxN2FQe/h/URS6pPswcuQWt1knPxEO/o3i6aoP
         xOOLpay/TmYln4bOLiNbZEYdUIPabWrvh5r3w6yZ1Hth8OLZ/mTWtpQG6ac5qkdfZB
         Ue8yrGnisrDu6AHN8HEn4dKGsndV3xVYEcwAqIQw9OB/AQa+/9ynnSYsFEyBfPn5pm
         zTXLzADbTPxXQ==
Content-Disposition: inline
In-Reply-To: <773e2f22-211e-163f-64bb-15ae29ad161b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Feb 01, 2023 at 10:34:00PM -0500, Waiman Long wrote:
> On 2/1/23 16:10, Peter Zijlstra wrote:
> > On Wed, Feb 01, 2023 at 01:46:11PM -0500, Waiman Long wrote:
> >=20
> > > Note that using cpus_allowed directly in cgroup v2 may not be right b=
ecause
> > > cpus_allowed may have no relationship to effective_cpus at all in some
> > > cases, e.g.
> > >=20
> > >  =A0=A0 root
> > >  =A0=A0=A0 |
> > >  =A0=A0=A0 V
> > >  =A0=A0=A0 A (cpus_allowed =3D 1-4, effective_cpus =3D 1-4)
> > >  =A0=A0=A0 |
> > >  =A0=A0=A0 V
> > >  =A0=A0=A0 B (cpus_allowed =3D 5-8, effective_cpus =3D 1-4)
> > >=20
> > > In the case of cpuset B, passing back cpus 5-8 as the allowed_cpus is=
 wrong.
> > I think my patch as written does the right thing here. Since the
> > intersection of (1-4) and (5-8) is empty it will move up the hierarchy
> > and we'll end up with (1-4) from the cgroup side of things.
> >=20
> > So the purpose of __cs_cpus_allowed() is to override the cpus_allowed of
> > the root set and force it to cpu_possible_mask.
> >=20
> > Then cs_cpus_allowed() computes the intersection of cs->cpus_allowed and
> > all it's parents. This will, in the case of B above, result in the empty
> > mask.
> >=20
> > Then cpuset_cpus_allowed() has a loop that starts with
> > task_cpu_possible_mask(), intersects that with cs_cpus_allowed() and if
> > the intersection of that and cpu_online_mask is empty, moves up the
> > hierarchy. Given cs_cpus_allowed(B) is the empty mask, we'll move to A.
> >=20
> > Note that since we force the mask of root to cpu_possible_mask,
> > cs_cpus_allowed(root) will be a no-op and if we guarantee (in arch code)
> > that cpu_online_mask always has a non-empty intersection with
> > task_cpu_possible_mask(), this loop is guaranteed to terminate with a
> > viable mask.
>=20
> I will take a closer look at that tomorrow. I will be more comfortable
> ack'ing that if this is specific to v1 cpuset instead of applying this in
> both v1 and v2 since it is only v1 that is problematic.

fwiw, the regression I'm seeing is with cgroup2. I haven't tried v1.

WIll
