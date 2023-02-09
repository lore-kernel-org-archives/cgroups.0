From: Kairui Song <ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] sched/psi: iterate through cgroups directly
Date: Thu, 9 Feb 2023 23:30:58 +0800
Message-ID: <CAMgjq7BQ4qAwQ3Obb=7Ytm5tOvWjA0kbfLrwkE=u0PpU2gM+GA@mail.gmail.com>
References: <20230208161654.99556-1-ryncsn@gmail.com> <20230208161654.99556-3-ryncsn@gmail.com>
 <Y+P0wLTdZcOPiKPZ@cmpxchg.org> <Y+QcJ2OvTmJzrObn@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HEWeZKg/Hf192mvRWbg97mTukvlnybaYyRe3tKZfeeo=;
        b=DCoQZ6yFdzTNXWtXD1+O5ROyMvIuQO54tjjNhalWJMnw8ZuJAGBdQEiZu08ampMLix
         oOx9upeX6NxT2bMwAfNc+cMB/+oUPRCc0d+49Htlgcd2q+gmyIBh/ds28GhsRBIV6bg7
         p6UAC330wJM7XOAmGpYo5x4vMGYoR5eo52ipbEtkFJ8zrCJO+4g8+xG1cvxXvOYzX2VG
         eBP+unM4Zyso8zXjynu27I/D9lm7r/HAcW+frImd60C3OJFKlAUK55rb9XI6d/VYH/Dk
         o+Mp0uB2MB/5561XZUNQJvuWEUq9wlNHiGHK1SpOhEWw3ai17YUCPeaa4g/1UpyxpYhr
         oQ7w==
In-Reply-To: <Y+QcJ2OvTmJzrObn@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> =E4=BA=8E2023=E5=B9=B42=E6=9C=889=E6=
=97=A5=E5=91=A8=E5=9B=9B 06:03=E5=86=99=E9=81=93=EF=BC=9A
> On Wed, Feb 08, 2023 at 02:15:12PM -0500, Johannes Weiner <hannes@cmpxchg=
.org> wrote:
> > Please name these psi_groups_first() and psi_groups_next().
>
> One more suggestion: s/next/parent/ to avoid impression of (sub)tree
> iteration and consistence with cg-related iters.
>
> Thanks,
> Michal
>

Thanks for the review, I'll update the patch with using this new name.
