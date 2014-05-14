From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: iterate cgroup_subsys_states
 directly
Date: Wed, 14 May 2014 12:21:25 +0800
Message-ID: <5372EF45.8060701@huawei.com>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1399671091-23867-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org

Hi Tejun,

On 2014/5/10 5:31, Tejun Heo wrote:
> Hello,
> 
> Currently, while csses (cgroup_subsys_states) have ->parent linkage
> too, only cgroups form full tree through their ->children and
> ->sibling fields and css iterations naturally is implemented by
> iterating cgroups and then dereferencing the css for the specified
> subsystem.
> 
> There are now use cases where controllers need to iterate through
> csses regardless of their online state as long as they have positive

What use cases are we talking about here?

> reference.  This can't easily be achieved by iterating cgroups because
> its css pointer array needs to be cleared on offline and there may be
> multiple dying csses for a cgroup for the same subsystem and there's
> only one pointer per cgroup-subsystem pair.
> 
