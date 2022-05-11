From: CGEL <cgel.zte@gmail.com>
Subject: Re: [PATCH] mm/memcg: support control THP behaviour in cgroup
Date: Wed, 11 May 2022 09:47:47 +0000
Message-ID: <627b8645.1c69fb81.5f934.3086@mx.google.com>
References: <6275d3e7.1c69fb81.1d62.4504@mx.google.com>
 <YnjmPAToTR0C5o8x@dhcp22.suse.cz>
 <6278fa75.1c69fb81.9c598.f794@mx.google.com>
 <Ynj/l+pyFJxKfcbQ@dhcp22.suse.cz>
 <6279c354.1c69fb81.7f6c1.15e0@mx.google.com>
 <Yno3pNQOn1lAMPnu@dhcp22.suse.cz>
 <627a5214.1c69fb81.1b7fb.47be@mx.google.com>
 <YnpqYte2jLdcBiPg@dhcp22.suse.cz>
 <627b1899.1c69fb81.cd831.12d9@mx.google.com>
 <YntkEUKPquTbBjMu@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=Cf/PeTJbEoBsfw/lhXYoJEgURdTIh89gvchfxAGn2nU=;
        b=PzYHM/ViCEy70BYdoGBxCtT6atNffiFaFydDfkT9aQJb3pJgXdtSnHgdGvWy7Uiay4
         R6fKLsYJogAA+dypr6QjY4Q2APT1hsrAHTm3bDEMpjsKH8DEzhgCHpcqtdyDDjMD0fKg
         TEVnRqgRsKbPHPWih2+gslNFAbxkM5zVmYqROc9Wpa1J0Zsed+Bz2urej8u7YIhqgGMK
         erY9/DBsHjK6vvcEJxTlMdYfsXuL7FD+T4Bp9vZ4k2C/XjOfjHpFLuY1SWsdL+uJtR/F
         iICE50NHXZCjlIoxVP67SYAHpA97TPWG/wh/kcNNL7PUJlUc0ZeDTTtZihv7+bx5t4Mv
         8B9g==
Content-Disposition: inline
In-Reply-To: <YntkEUKPquTbBjMu@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, willy@infradead.org, shy828301@gmail.com, roman.gushchin@linux.dev, shakeelb@google.com, linmiaohe@huawei.com, william.kucharski@oracle.com, peterx@redhat.com, hughd@google.com, vbabka@suse.cz, songmuchun@bytedance.com, surenb@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, Yang Yang <yang.yang29@zte.com.cn>

On Wed, May 11, 2022 at 09:21:53AM +0200, Michal Hocko wrote:
> On Wed 11-05-22 01:59:52, CGEL wrote:
> > On Tue, May 10, 2022 at 03:36:34PM +0200, Michal Hocko wrote:
> [...]
> > > Can you come up with a sane hierarchical behavior?
> > >
> > 
> > I think this new interface better be independent not hierarchical anyway. Especially
> > when we treat container as lightweight virtual machine.
> 
> I suspect you are focusing too much on your usecase and do not realize
> wider consequences of this being an user interface that still has to be
> sensible for other usecases. Take a delagation of the control to
> subgroups as an example. If this is a per memcg knob (like swappiness)
> then children can override parent's THP policy. This might be a less of
> the deal for swappiness because the anon/file reclaim balancing should
> be mostly an internal thing. But THP policy is different because it has
> other effects to workloads running outside of the said cgroup - higher
> memory demand, higher contention for high-order memory etc.
> 

Higher memory demand will be limited by memsw.limit_in_bytes right?
And cgroup really cares about high-order memory usage? At least for
now there are no cgroup limit for this.

> I do not really see how this could be a sensible per-memcg policy
> without being fully hierarchical.
>

Thanks to your patient discuss, as Roman said, I will try to realize this
with bpf.

> > 
> > > [...]
> > > > > > For micro-service architecture, the application in one container is not a
> > > > > > set of loosely tight processes, it's aim at provide one certain service,
> > > > > > so different containers means different service, and different service
> > > > > > has different QoS demand. 
> > > > > 
> > > > > OK, if they are tightly coupled you could apply the same THP policy by
> > > > > an existing prctl interface. Why is that not feasible. As you are noting
> > > > > below...
> > > > > 
> > > > > >     5.containers usually managed by compose software, which treats container as
> > > > > > base management unit;
> > > > > 
> > > > > ..so the compose software can easily start up the workload by using prctl
> > > > > to disable THP for whatever workloads it is not suitable for.
> > > > 
> > > > prctl(PR_SET_THP_DISABLE..) can not be elegance to support the semantic we
> > > > need. If only some containers needs THP, other containers and host do not need
> > > > THP. We must set host THP to always first, and call prctl() to close THP for
> > > > host tasks and other containers one by one,
> > > 
> > > It might not be the most elegant solution but it should work.
> > 
> > So you agree it's reasonable to set THP policy for process in container, right?
> 
> Yes, like in any other processes.
> 
> > If so, IMHO, when there are thousands of processes launch and die on the machine,
> > it will be horrible to do so by calling prctl(), I don't see the reasonability.
> 
> Could you be more specific? The usual prctl use would be normally
> handled by the launcher and rely on the per-process policy to be
> inherited down the road.
>
> -- 
> Michal Hocko
> SUSE Labs
