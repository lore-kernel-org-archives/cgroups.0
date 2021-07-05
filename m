From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 2/6] cgroup/cpuset: Clarify the use of invalid
 partition root
Date: Mon, 5 Jul 2021 07:51:15 -1000
Message-ID: <YONGk3iw/zrNzwLK@mtj.duckdns.org>
References: <20210621184924.27493-1-longman@redhat.com>
 <20210621184924.27493-3-longman@redhat.com>
 <YNcHOe3o//pIiByh@mtj.duckdns.org>
 <6ea1ac38-73e1-3f78-a5d2-a4c23bcd8dd1@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=iv2nR+uj4xQxZ4tCMvQYMiE0wQetmZ91ILl8EX15Wlw=;
        b=EeGtltBktucg1k4suU5HNN4w+e8yeW36q6weYKjBvxMEcvRsfrhRT1yISdYUaBu2r1
         dTqkZ6p0l9RHE5TB2cy2N7FJJ+dOYYvaSPEnv4lDG3dcZ4sqGpu/xldKxi6XsF94K5jq
         Zc5GmH61GWNKCanYeewDmydcUNSWATDwSf7dBPG7SCf5tSb7yhvezm+XcOFiAY2LU7WR
         p2Lfs15n5dXngmIp4fHgTLZ1qyrbleITvq/83+JJWWJ2kpSvWfxUnw52GkTzvWRlL+om
         FDnJyXvshDr759FOozCbkEmEHtN1Xoll7JIOA1JDhTIUq1NuoHNaUpbzvQqLFiobQnv5
         Zw7w==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <6ea1ac38-73e1-3f78-a5d2-a4c23bcd8dd1@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Waiman Long <llong@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>

Hello, Waiman.

On Mon, Jun 28, 2021 at 09:06:50AM -0400, Waiman Long wrote:
> The main reason for doing this is because normal cpuset control file acti=
ons
> are under the direct control of the cpuset code. So it is up to us to dec=
ide
> whether to grant it or deny it. Hotplug, on the other hand, is not under =
the
> control of cpuset code. It can't deny a hotplug operation. This is the ma=
in
> reason why the partition root error state was added in the first place.

I have a difficult time convincing myself that this difference justifies the
behavior difference and it keeps bothering me that there is a state which
can be reached through one path but rejected by the other. I'll continue
below.

> Normally, users can set cpuset.cpus to whatever value they want even thou=
gh
> they are not actually granted. However, turning on partition root is under
> more strict control. You can't turn on partition root if the CPUs request=
ed
> cannot actually be granted. The problem with setting the state to just
> partition error is that users may not be aware that the partition creation
> operation fails.=A0 We can't assume all users will do the proper error
> checking. I would rather let them know the operation fails rather than
> relying on them doing the proper check afterward.
>
> Yes, I agree that it is a different philosophy than the original cpuset
> code, but I thought one reason of doing cgroup v2 is to simplify the
> interface and make it a bit more erorr-proof. Since partition root creati=
on
> is a relatively rare operation, we can afford to make it more strict than
> the other operations.

So, IMO, one of the reasons why cgroup1 interface was such a mess was
because each piece of interaction was designed ad-hoc without regard to the
overall consistency. One person feels a particular way of interacting with
the interface is "correct" and does it that way and another person does
another part in a different way. In the end, we ended up with a messy
patchwork.

One problematic aspect of cpuset in cgroup1 was the handling of failure
modes, which was caused by the same exact approach - we wanted the interface
to reject invalid configurations outright even though we didn't have the
ability to prevent those configurations from occurring through other paths,
which makes the failure mode more subtle by further obscuring them.

I think a better approach would be having a clear signal and mechanism to
watch the state and explicitly requiring users to verify and monitor the
state transitions.

Thanks.

--=20
tejun
