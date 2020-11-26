From: Aaron Tomlin <atomlin@redhat.com>
Subject: Re: [PATCH] memcg: add support to generate the total count of
 children from root
Date: Thu, 26 Nov 2020 11:02:20 +0000
Message-ID: <20201126110220.k4o6s32er5jy2mdk@ava.usersys.com>
References: <20201124105836.713371-1-atomlin@redhat.com>
 <20201124112612.GV27488@dhcp22.suse.cz>
 <CANfR36hyrqXjk2tL03GzCk6rn6sCD7Sd811soBsZC3dHY0h9fQ@mail.gmail.com>
 <20201124133644.GA31550@dhcp22.suse.cz>
 <CANfR36hw8iSSszSt4sNh+ika3vTdXQnXHPLj5t2iLL=5-nzZZw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606388547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8cvGV8OUthTmjmbY5oJ7mRxJLMMwznOKcyuaPUff3ek=;
        b=VezbIcJalAdt/otNdxYgQil5QVSdbXlehicqEyhGBWBCVCiJzLL0t8enPJIlyr35Cchr2a
        nzZXjjyxclHMD639PRhxITSS3o/dSbOwkfB/MxNBsYLGLTjXuL4bYQXKHKR39jIc08qYEZ
        mrHxatGwzRXg07yudk4mrJJSGfZXrgI=
Content-Disposition: inline
In-Reply-To: <CANfR36hw8iSSszSt4sNh+ika3vTdXQnXHPLj5t2iLL=5-nzZZw@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, hannes@cmpxchg.org, vdavydov.dev@gmail.com, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm <linux-mm@kvack.org>

On Tue 2020-11-24 13:47 +0000, Aaron Tomlin wrote:
> On Tue, 24 Nov 2020 at 13:36, Michal Hocko <mhocko@suse.com> wrote:
> > This like any other user visible interface would be a much easier sell
> > if there was a clear usecase to justify it. I do not see anything
> > controversial about exporting such a value but my general take is that
> > we are only adding new interface when existing ones are insufficient. A
> > performance might be a very good reason but that would really require to
> > come with some real life numbers.

Michal,

> Fair enough and understood.
> 
> At this stage, I unfortunately do not have such supporting data. This was only
> useful in an isolated situation. Having said this, I thought that the
> aforementioned interface would be helpful to others, in particular, given the
> known limitation.

Furthermore, I can see that this is already provided via /proc/cgroups
(see proc_cgroupstats_show()). As such, another possibility:
the proposed interface could reliably produce the difference between the
maximum permitted memory-controlled cgroup count and the used count
(i.e. the remaining memory cgroup count, from root); albeit, I doubt that
this would be particularly useful to others i.e., the use-case would be
rather limited.


Kind regards,

-- 
Aaron Tomlin

