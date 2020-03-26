From: Sonny Rao <sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC] cpuset: Make cpusets get restored on hotplug
Date: Thu, 26 Mar 2020 15:03:42 -0700
Message-ID: <CAPz6YkXVYJBow-6G023eaDEKFORPh3AKQb6gfrM8XX8=bdXL2A@mail.gmail.com>
References: <20200326191623.129285-1-joel@joelfernandes.org>
 <20200326192035.GO162390@mtj.duckdns.org> <20200326194448.GA133524@google.com>
 <972a5c1b-6721-ac20-cec5-617af67e617d@redhat.com> <CAPz6YkVUsDz456z8-X2G_EDd-uet1rRNnh2sDUpdcoWp_fkDDw@mail.gmail.com>
 <e9093ab2-f61f-edf1-5da7-fce5101d6dbf@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CVqQ7MESPq+AdE5FevBfn8AolxVmIzRfASYgM+H4STI=;
        b=szyVRdKUxChTizOYbqe+xujjj60j68XNY2SNyiTfGDb2FOQdOSEPl8zDMtKzEbkOEZ
         jtQCP5i4iuVP5zMrvcycKgn+qO0lKj6TLMeJBhnVXT7oeJu21WuKDaUh+y8ixfdNBFQE
         6oFyY3Q/46KVNkl3A8NeA+LMUYdpO7Slu4Tee/ERY9zUHc82YMPuRjGkqdBeKwfxRCqI
         KqUxD+S3Z4nw18kpiJmpbKA3PX2nTDSUVzJgPVy956S23Br/VEIcdC+LK3Daw9ljv9+8
         qhXItEAmwk5k03a/QD0NnuHKpqd5PPMt7j1aOKfkpLTyiT23voWFEOtliyOSwkXqS9x8
         b3Bw==
In-Reply-To: <e9093ab2-f61f-edf1-5da7-fce5101d6dbf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, Jesse Barnes <jsbarnes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, vpillai-tWEdnPwa2b6ifxm/DiOjgA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Guenter Roeck <groeck-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Greg Kerr <kerrnel-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Thu, Mar 26, 2020 at 2:47 PM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> On 3/26/20 4:05 PM, Sonny Rao wrote:
> >> I think Tejun is concerned about a change in the default behavior of
> >> cpuset v1.
> >>
> >> There is a special v2 mode for cpuset that is enabled by the mount
> >> option "cpuset_v2_mode". This causes the cpuset v1 to adopt some of the
> >> v2 behavior. I introduced this v2 mode a while back to address, I think,
> >> a similar concern. Could you try that to see if it is able to address
> >> your problem? If not, you can make some code adjustment within the
> >> framework of the v2 mode. As long as it is an opt-in, I think we are
> >> open to further change.
> > I am surprised if anyone actually wants this behavior, we (Chrome OS)
> > found out about it accidentally, and then found that Android had been
> > carrying a patch to fix it.  And if it were a desirable behavior then
> > why isn't it an option in v2?
> >
> I am a bit confused. The v2 mode make cpuset v1 behaves more like cpuset
> v2. The original v1 behavior has some obvious issue that was fixed in
> v2. So what v2 option are you talking about?

I was merely pointing out the behavior of the v1 implementation is so
undesirable that it wasn't kept at all in v2.  IMHO, it's a bug that
should be fixed, and I think it's possible to keep the old behavior if
all cpus are offlined, but since you've added this option we can use
it instead.

>
> Regards,
> Longman
>
