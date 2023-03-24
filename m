From: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/5] cgroup/cpuset: Find another usable CPU if none found
 in current cpuset
Date: Fri, 24 Mar 2023 14:32:50 +0000
Message-ID: <20230324143247.GA27199@willie-the-truck>
References: <20230306200849.376804-1-longman@redhat.com>
 <20230306200849.376804-4-longman@redhat.com>
 <20230314181749.5b4k6selbgdhl3up@blackpad>
 <58a1a878-fa0b-285d-3e43-2b5103d3c770@redhat.com>
 <20230317122708.ax3m2d4zijkfdzjq@blackpad>
 <ca664da8-0f47-06b2-a94c-82b2f9a1c3aa@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679668377;
        bh=yxz8D2Zg0ZMCZt9HGM8J7hviWBLk56ggtJ1KZ+DkDGY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TW4X/v31+XvxigTPEeFIQrSpqf1C0wg34BEJL4Ewk0hehRrW2ZKZsQjnGXXStCEQp
         5VkteDkPv+sdJn+wnCp00Q7ts0BXFvbvpUPoz/O9ozOkHdjO4LnSzaJvy2Lfehdi0r
         o0bbmMBhVD3QDLkFyY4APnSyWtyO3ymDaEdHiB8QpljXQXoAKlvYNlSVeZg+pwPPZe
         sPryW8AHtsYhf36NHIPB0QmnPAT7HBQXA41oQKclKF0ESgsa5b9KAsNfg7nYmJrsRX
         ucNevYIcTADp3ZgDhRMyA4mplhSlroJWECB9XeRhBSBgNHFndzP4dipMvgK5XNtnz6
         OfNZPsFUIN1Wg==
Content-Disposition: inline
In-Reply-To: <ca664da8-0f47-06b2-a94c-82b2f9a1c3aa-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Fri, Mar 17, 2023 at 10:59:26AM -0400, Waiman Long wrote:
> On 3/17/23 08:27, Michal Koutn=FD wrote:
> > On Tue, Mar 14, 2023 at 04:22:06PM -0400, Waiman Long <longman-H+wXaHxf=
7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > > Some arm64 systems can have asymmetric CPUs where certain tasks are o=
nly
> > > runnable on a selected subset of CPUs.
> > Ah, I'm catching up.
> >=20
> > > This information is not captured in the cpuset. As a result,
> > > task_cpu_possible_mask() may return a mask that have no overlap with
> > > effective_cpus causing new_cpus to become empty.
> > I can see that historically, there was an approach of terminating
> > unaccomodable tasks:
> >     94f9c00f6460 ("arm64: Remove logic to kill 32-bit tasks on 64-bit-o=
nly cores")
> > the removal of killing had been made possible with
> >     df950811f4a8 ("arm64: Prevent offlining first CPU with 32-bit EL0 o=
n mismatched system").
> >=20
> > That gives two other alternatives to affinity modification:
> > 2) kill such tasks (not unlike OOM upon memory.max reduction),
> > 3) reject cpuset reduction (violates cgroup v2 delegation).
> >=20
> > What do you think about 2)?
>=20
> Yes, killing it is one possible solution.
>=20
> (3) doesn't work if the affinity change is due to hot cpu removal. So that
> leaves this patch or (2) as the only alternative. I would like to hear wh=
at
> Will and Tejun thinks about it.

The main constraint from the Android side (the lucky ecosystem where these
SoCs tend to show up) is that existing userspace (including 32-bit binaries)
continues to function without modification. So approaches such as killing
tasks or rejecting system calls tend not to work as well, since you
inevitably get divergent behaviour leading to functional breakage rather
than e.g. performance anomalies.

Having said that, the behaviour we currently have in mainline seems to
be alright, so please don't go out of your way to accomodate these SoCs.
I'm mainly just concerned about introducing any regressions, which is why
I ran my tests on this series

Cheers,

Will
