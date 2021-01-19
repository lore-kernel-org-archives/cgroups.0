From: Alexey Klimov <aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH] cpu/hotplug: wait for cpuset_hotplug_work to finish
 on cpu online
Date: Tue, 19 Jan 2021 16:52:55 +0000
Message-ID: <CAFBcO+_PoXhbq+p-2z=acCpboJtOewXkp-9-3=csafoAYuNFQw@mail.gmail.com>
References: <20201203171431.256675-1-aklimov@redhat.com> <20201207083827.GD3040@hirez.programming.kicks-ass.net>
 <87k0tritvq.fsf@oracle.com> <87im7yc2bu.fsf@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611075190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HK4nAJ3T6oXK1ONWdl9zHivMWs2pVZ45ipCqU6He5eg=;
        b=RtPi40MGQUp86aKT2ckSg14hsx22rAUhg2DaaduI/jj6Canc+zO8i9MbPoJDbQiEuIC/ux
        QVEw+98Ax5N5oPETveJvuqv/UwhPm+Uv70qUT7FXDUH/7f8iCF2531ypb7R2jqIjC67G1E
        dmmULZUNZnlsqMc7K/CPhuB2uvhP4tE=
In-Reply-To: <87im7yc2bu.fsf-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yury.norov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, jobaker-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, audralmitchel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, qais.yousef-5wv7dgnIgG8@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Alexey Klimov <klimov.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Fri, Jan 15, 2021 at 6:54 AM Daniel Jordan
<daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>
> Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> writes:
> > Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> writes:
> >>> The nature of this bug is also described here (with different consequences):
> >>> https://lore.kernel.org/lkml/20200211141554.24181-1-qais.yousef-5wv7dgnIgG8@public.gmane.org/
> >>
> >> Yeah, pesky deadlocks.. someone was going to try again.
> >
> > I dug up the synchronous patch
> >
> >     https://lore.kernel.org/lkml/1579878449-10164-1-git-send-email-prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org/
> >
> > but surprisingly wasn't able to reproduce the lockdep splat from
> >
> >     https://lore.kernel.org/lkml/F0388D99-84D7-453B-9B6B-EEFF0E7BE4CC-J5quhbR+WMc@public.gmane.org/
> >
> > even though I could hit it a few weeks ago.
>
> oh okay, you need to mount a legacy cpuset hierarchy.
>
> So as the above splat shows, making cpuset_hotplug_workfn() synchronous
> means cpu_hotplug_lock (and "cpuhp_state-down") can be acquired before
> cgroup_mutex.
>
> But there are at least four cgroup paths that take the locks in the
> opposite order.  They're all the same, they take cgroup_mutex and then
> cpu_hotplug_lock later on to modify one or more static keys.
>
> cpu_hotplug_lock should probably be ahead of cgroup_mutex because the
> latter is taken in a hotplug callback, and we should keep the static
> branches in cgroup, so the only way out I can think of is moving
> cpu_hotplug_lock to just before cgroup_mutex is taken and switching to
> _cpuslocked flavors of the static key calls.
>
> lockdep quiets down with that change everywhere, but it puts another big
> lock around a lot of cgroup paths.  Seems less heavyhanded to go with
> this RFC.  What do you all think?

Daniel, thank you for taking a look. I don't mind reviewing+testing
another approach that you described.

> Absent further discussion, Alexey, do you plan to post another version?

I plan to update this patch and re-send in the next couple of days. It
looks like it might be a series of two patches. Sorry for delays.

Best regards,
Alexey

