From: CGEL <cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: support control THP behaviour in cgroup
Date: Wed, 11 May 2022 01:59:52 +0000
Message-ID: <627b1899.1c69fb81.cd831.12d9@mx.google.com>
References: <20220505033814.103256-1-xu.xin16@zte.com.cn>
 <YnUlntNFR4zeD+qa@dhcp22.suse.cz>
 <6275d3e7.1c69fb81.1d62.4504@mx.google.com>
 <YnjmPAToTR0C5o8x@dhcp22.suse.cz>
 <6278fa75.1c69fb81.9c598.f794@mx.google.com>
 <Ynj/l+pyFJxKfcbQ@dhcp22.suse.cz>
 <6279c354.1c69fb81.7f6c1.15e0@mx.google.com>
 <Yno3pNQOn1lAMPnu@dhcp22.suse.cz>
 <627a5214.1c69fb81.1b7fb.47be@mx.google.com>
 <YnpqYte2jLdcBiPg@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=ygRJwU53ypBYWb0ipajvfg9wu8BsJDcxou4i7b0FONY=;
        b=AC0/bjCtvdumOBQpoatC2IVwm5A2dJuUre1XwUktN/jPod+nsh1Qg7qpzwCPVU6ilk
         abDUXuerlgxYt8a4AVPN3MTA5VcA8x5Q++NxwSevkqbdTbpdVIKJLQ7zFOf5vo7BohOj
         ev5UZepOZO/gSCuseNeREznvCgsHrov54w7j+92CDKqhK3q/fenS0pRYjexAGiZDs7wi
         QrQG65AnY78uCLRmGQUM24zwdctL84RC1o1+iqaXVI432IWUbOP5J0GbIFCPlb2OJ87n
         lxVk5K8DgOLb7QJHbPC/9sARdOUrI9NmPh9NE8beeIBmSx9CABeUVdN73Ne0QhbjhfAy
         KYzg==
Content-Disposition: inline
In-Reply-To: <YnpqYte2jLdcBiPg-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, william.kucharski-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yang Yang <yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

On Tue, May 10, 2022 at 03:36:34PM +0200, Michal Hocko wrote:
> On Tue 10-05-22 11:52:51, CGEL wrote:
> > On Tue, May 10, 2022 at 12:00:04PM +0200, Michal Hocko wrote:
> > > On Tue 10-05-22 01:43:38, CGEL wrote:
> > > > On Mon, May 09, 2022 at 01:48:39PM +0200, Michal Hocko wrote:
> > > > > On Mon 09-05-22 11:26:43, CGEL wrote:
> > > > > > On Mon, May 09, 2022 at 12:00:28PM +0200, Michal Hocko wrote:
> > > > > > > On Sat 07-05-22 02:05:25, CGEL wrote:
> > > > > > > [...]
> > > > > > > > If there are many containers to run on one host, and some of them have high
> > > > > > > > performance requirements, administrator could turn on thp for them:
> > > > > > > > # docker run -it --thp-enabled=always
> > > > > > > > Then all the processes in those containers will always use thp.
> > > > > > > > While other containers turn off thp by:
> > > > > > > > # docker run -it --thp-enabled=never
> > > > > > > 
> > > > > > > I do not know. The THP config space is already too confusing and complex
> > > > > > > and this just adds on top. E.g. is the behavior of the knob
> > > > > > > hierarchical? What is the policy if parent memcg says madivise while
> > > > > > > child says always? How does the per-application configuration aligns
> > > > > > > with all that (e.g. memcg policy madivise but application says never via
> > > > > > > prctl while still uses some madvised - e.g. via library).
> > > > > > >
> > > > > > 
> > > > > > The cgroup THP behavior is align to host and totally independent just likes
> > > > > > /sys/fs/cgroup/memory.swappiness. That means if one cgroup config 'always'
> > > > > > for thp, it has no matter with host or other cgroup. This make it simple for
> > > > > > user to understand or control.
> > > > > 
> > > > > All controls in cgroup v2 should be hierarchical. This is really
> > > > > required for a proper delegation semantic.
> > > > >
> > > > 
> > > > Could we align to the semantic of /sys/fs/cgroup/memory.swappiness?
> > > > Some distributions like Ubuntu is still using cgroup v1.
> > > 
> > > cgroup v1 interface is mostly frozen. All new features are added to the
> > > v2 interface.
> > >
> > 
> > So what about we add this interface to cgroup v2?
> 
> Can you come up with a sane hierarchical behavior?
>

I think this new interface better be independent not hierarchical anyway. Especially
when we treat container as lightweight virtual machine.

> [...]
> > > > For micro-service architecture, the application in one container is not a
> > > > set of loosely tight processes, it's aim at provide one certain service,
> > > > so different containers means different service, and different service
> > > > has different QoS demand. 
> > > 
> > > OK, if they are tightly coupled you could apply the same THP policy by
> > > an existing prctl interface. Why is that not feasible. As you are noting
> > > below...
> > > 
> > > >     5.containers usually managed by compose software, which treats container as
> > > > base management unit;
> > > 
> > > ..so the compose software can easily start up the workload by using prctl
> > > to disable THP for whatever workloads it is not suitable for.
> > 
> > prctl(PR_SET_THP_DISABLE..) can not be elegance to support the semantic we
> > need. If only some containers needs THP, other containers and host do not need
> > THP. We must set host THP to always first, and call prctl() to close THP for
> > host tasks and other containers one by one,
> 
> It might not be the most elegant solution but it should work.

So you agree it's reasonable to set THP policy for process in container, right?
If so, IMHO, when there are thousands of processes launch and die on the machine,
it will be horrible to do so by calling prctl(), I don't see the reasonability. 

> Maintaining user interfaces for ever has some cost and the THP
> configuration space is quite large already. So I would rather not add
> more complication in unless that is absolutely necessary.
> 
> > in this process some tasks that start before we call prctl() may
> > already use THP with no need.
> 
> As long as all those processes have a common ancestor I do not see how
> that would be possible.
> 
For example:
1) userspace set THP policy to always
2) then one unrelated processe A may launch automatic by a script maybe
3) call prctl() to disable THP for A
process A may already use THP with no need.

> -- 
> Michal Hocko
> SUSE Labs
