From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v6 0/4] Charge loop device i/o to issuing cgroup
Date: Fri, 21 Aug 2020 09:01:28 -0700
Message-ID: <20200821160128.GA2233370@carbon.dhcp.thefacebook.com>
References: <20200528135444.11508-1-schatzberg.dan@gmail.com>
 <CALvZod655MqFxmzwCf4ZLSh9QU+oLb0HL-Q_yKomh3fb-_W0Vg@mail.gmail.com>
 <20200821150405.GA4137@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=rnk64YE/7e49lqSYCrUx2r0LVtZ9PQ+VntLUaJ/gkvc=;
 b=RVvAWA+t0joC1JTRq60Ci1isPCKrtYhMWCfQu9itpw4nT48xHiIgJQkdx9jHDmtHPEje
 26KFj6ygUsNwXuutwJhLQV1y2eKlw5pxBSkTOf22sPuJrWynOd5T2AwieiSKLRdV918q
 NnZoA0BBJjGJyGCGc5vVLMle3M1Hj4VR0fg= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rnk64YE/7e49lqSYCrUx2r0LVtZ9PQ+VntLUaJ/gkvc=;
 b=Qm6V1kQnEoOiKZ8odC9WRcY0jtemDW+R+WMJq8/tFahCuDQOI3Kx39iKDum/BghBghDzWieFNtXb0ZFjrImijQWg4Vxgtpn3ZdPeR5GjPF9rtPIhfIj/g9WySPEtZvQ18S+EUIapwTNz07FGxlMbx9+n6Wa5On8EZACzyB7/Wbg=
Content-Disposition: inline
In-Reply-To: <20200821150405.GA4137@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <schatzberg.dan@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>, Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Chris Down <chris@chrisdown.name>, Yang Shi <yang.shi@linux.alibaba.com>, Thomas Gleixner <tglx@linutronix.de>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Andrea Arcangeli <aarcange@redhat.com>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, o

On Fri, Aug 21, 2020 at 11:04:05AM -0400, Dan Schatzberg wrote:
> On Thu, Aug 20, 2020 at 10:06:44AM -0700, Shakeel Butt wrote:
> > On Thu, May 28, 2020 at 6:55 AM Dan Schatzberg <schatzberg.dan@gmail.com> wrote:
> > >
> > > Much of the discussion about this has died down. There's been a
> > > concern raised that we could generalize infrastructure across loop,
> > > md, etc. This may be possible, in the future, but it isn't clear to me
> > > how this would look like. I'm inclined to fix the existing issue with
> > > loop devices now (this is a problem we hit at FB) and address
> > > consolidation with other cases if and when those need to be addressed.
> > >
> > 
> > What's the status of this series?
> 
> Thanks for reminding me about this. I haven't got any further
> feedback. I'll bug Jens to take a look and see if he has any concerns
> and if not send a rebased version.

Just as a note, I stole a patch from this series called
"mm: support nesting memalloc_use_memcg()" to use for the bpf memory accounting.
I rewrote the commit log and rebased to the tot with some trivial changes.

I just sent it upstream:
https://lore.kernel.org/bpf/20200821150134.2581465-1-guro@fb.com/T/#md7edb6b5b940cee1c4d15e3cef17aa8b07328c2e

It looks like we need it for two independent sub-systems, so I wonder
if we want to route it first through the mm tree as a standalone patch?

Thanks!
