From: Tim Hockin <thockin@google.com>
Subject: Re: Protection against container fork bombs [WAS: Re: memcg with kmem
 limit doesn't recover after disk i/o causes limit to be hit]
Date: Tue, 29 Apr 2014 09:06:22 -0700
Message-ID: <CAO_RewYZDGLBAKit4CudTbqVk+zfDRX8kP0W6Zz90xJh7abM9Q@mail.gmail.com>
References: <20140418155939.GE4523@dhcp22.suse.cz> <5351679F.5040908@parallels.com>
 <20140420142830.GC22077@alpha.arachsys.com> <20140422143943.20609800@oracle.com>
 <20140422200531.GA19334@alpha.arachsys.com> <535758A0.5000500@yuhu.biz>
 <20140423084942.560ae837@oracle.com> <20140428180025.GC25689@ubuntumail>
 <20140429072515.GB15058@dhcp22.suse.cz> <20140429130353.GA27354@ubuntumail> <20140429154345.GH15058@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=4BD0Vh9xUZlCcubD8lCNkoUeDj6XXJLKwPEVGJ3rpsQ=;
        b=nG8qFtlq4hs10AQ4VXkR1Zb6VVK2Y2q8qngn2+1adESXhNE2K8wsFwc2Lih6D1kjsd
         nI7w/LfX0zO+k8IUKjfXreNQB/ZCkoZrUmmzXaXOsqaOPznx1i/tcpjE/1aoen0i9yqC
         0YmK7FbEQrcbm8ixkAj+QnjsAXByeqDSIAtY1d0XOp1shP7Ktb4XITGAZjH/hnc6fxyu
         daTUOljjSyaygRTcpUEd9RXnabRklGEAg88/RKReZHbT5TGQVeC+AjN0By0Oym8HGCbX
         YuUdwwxaKQTCs0H72ZBFdzGEG1btjoUA0UL0w5iXvGSfJVEDySvXpuqa8cxCH7lY6oze
         pl9Q==
In-Reply-To: <20140429154345.GH15058@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, Richard Davies <richard@arachsys.com>, Vladimir Davydov <vdavydov@parallels.com>, Marian Marinov <mm@yuhu.biz>, Max Kellermann <mk@cm4all.com>, Tim Hockin <thockin@hockin.org>, Frederic Weisbecker <fweisbec@gmail.com>, containers@lists.linux-foundation.org, Daniel Walsh <dwalsh@redhat.com>, cgroups@vger.kernel.org, Glauber Costa <glommer@parallels.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, William Dauchy <wdauchy@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, David Rientjes <rientjes@google.com>

Why the insistence that we manage something that REALLY IS a
first-class concept (hey, it has it's own RLIMIT) as a side effect of
something that doesn't quite capture what we want to achieve?

Is there some specific technical reason why you think this is a bad
idea?  I would think, especially in a more unified hierarchy world,
that more cgroup controllers with smaller sets of responsibility would
make for more manageable code (within limits, obviously).

On Tue, Apr 29, 2014 at 8:43 AM, Michal Hocko <mhocko@suse.cz> wrote:
> On Tue 29-04-14 13:03:53, Serge Hallyn wrote:
>> Quoting Michal Hocko (mhocko@suse.cz):
>> > On Mon 28-04-14 18:00:25, Serge Hallyn wrote:
>> > > Quoting Dwight Engen (dwight.engen@oracle.com):
>> > > > On Wed, 23 Apr 2014 09:07:28 +0300
>> > > > Marian Marinov <mm@yuhu.biz> wrote:
>> > > >
>> > > > > On 04/22/2014 11:05 PM, Richard Davies wrote:
>> > > > > > Dwight Engen wrote:
>> > > > > >> Richard Davies wrote:
>> > > > > >>> Vladimir Davydov wrote:
>> > > > > >>>> In short, kmem limiting for memory cgroups is currently broken.
>> > > > > >>>> Do not use it. We are working on making it usable though.
>> > > > > > ...
>> > > > > >>> What is the best mechanism available today, until kmem limits
>> > > > > >>> mature?
>> > > > > >>>
>> > > > > >>> RLIMIT_NPROC exists but is per-user, not per-container.
>> > > > > >>>
>> > > > > >>> Perhaps there is an up-to-date task counter patchset or similar?
>> > > > > >>
>> > > > > >> I updated Frederic's task counter patches and included Max
>> > > > > >> Kellermann's fork limiter here:
>> > > > > >>
>> > > > > >> http://thread.gmane.org/gmane.linux.kernel.containers/27212
>> > > > > >>
>> > > > > >> I can send you a more recent patchset (against 3.13.10) if you
>> > > > > >> would find it useful.
>> > > > > >
>> > > > > > Yes please, I would be interested in that. Ideally even against
>> > > > > > 3.14.1 if you have that too.
>> > > > >
>> > > > > Dwight, do you have these patches in any public repo?
>> > > > >
>> > > > > I would like to test them also.
>> > > >
>> > > > Hi Marian, I put the patches against 3.13.11 and 3.14.1 up at:
>> > > >
>> > > > git://github.com/dwengen/linux.git cpuacct-task-limit-3.13
>> > > > git://github.com/dwengen/linux.git cpuacct-task-limit-3.14
>> > >
>> > > Thanks, Dwight.  FWIW I'm agreed with Tim, Dwight, Richard, and Marian
>> > > that a task limit would be a proper cgroup extension, and specifically
>> > > that approximating that with a kmem limit is not a reasonable substitute.
>> >
>> > The current state of the kmem limit, which is improving a lot thanks to
>> > Vladimir, is not a reason for a new extension/controller. We are just
>> > not yet there.
>>
>> It has nothing to do with the state of the limit.  I simply don't
>> believe that emulating RLIMIT_NPROC by controlling stack size is a
>> good idea.
>
> I was not the one who decided that the kmem extension of memory
> controller should cover also the task number as a side effect but still
> the decision sounds plausible to me because the kmem approach is more
> generic.
>
> Btw. if this is a problem them please go ahead and continue the original
> discussion (http://marc.info/?l=linux-kernel&m=133417075309923) with the
> other people involved.
>
> I do not see any new arguments here, except that the kmem implementation
> is not ready yet.
> --
> Michal Hocko
> SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
