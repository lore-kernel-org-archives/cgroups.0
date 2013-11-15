From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: 3.10.16 cgroup_mutex deadlock
Date: Fri, 15 Nov 2013 15:24:58 +0900
Message-ID: <20131115062458.GA9755@mtj.dyndns.org>
References: <20131111220626.GA7509@sbohrermbp13-local.rgmadvisors.com>
 <52820030.6000806@huawei.com>
 <20131112143147.GB6049@dhcp22.suse.cz>
 <20131112155530.GA2860@sbohrermbp13-local.rgmadvisors.com>
 <20131112165504.GF6049@dhcp22.suse.cz>
 <20131114225649.GA16725@sbohrermbp13-local.rgmadvisors.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=XAYOaw0CFLTPfIGyHKc1xg5th6vpXxxsb7wsSJ1UrMo=;
        b=wdCk6o/f2uO8QVnh2R7AccnHm8n9wzjxcPSIIzpSvFMw6YV4p/1s+gSkp+PXfjmelw
         5i2CWCRgLoTj56s7hXfl2SxgeCF0iwkmFPOrFJ+1V4gWTSJ0/XT3rbB4aZk9ybXcJVY/
         7T5JJq5pOoqgNAUfwrJUkjfrqmL2tc0lqdrRb4rTU/wBTCNzEVf1wV41qOMcloHkxYzW
         ZLvb7qk5Pfb9RNsiOU+38sSjprlDIGLcAoK7+YDOS7fANoYvG9XY8lj453CNWkNYNEpw
         KklliPbl4hzWffg5fargLLnkiB9H/QtXrbfdkJ7IXQ0xANOqmRavu78HkLnodxRYn+LC
         7y+A==
Content-Disposition: inline
In-Reply-To: <20131114225649.GA16725-/vebjAlq/uFE7V8Yqttd03bhEEblAqRIDbRjUBewulXQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>

Hello,

On Thu, Nov 14, 2013 at 04:56:49PM -0600, Shawn Bohrer wrote:
> After running both concurrently on 40 machines for about 12 hours I've
> managed to reproduce the issue at least once, possibly more.  One
> machine looked identical to this reported issue.  It has a bunch of
> stuck cgroup_free_fn() kworker threads and one thread in cpuset_attach
> waiting on lru_add_drain_all().  A sysrq+l shows all CPUs are idle
> except for the one triggering the sysrq+l.  The sysrq+w unfortunately
> wrapped dmesg so we didn't get the stacks of all blocked tasks.  We
> did however also cat /proc/<pid>/stack of all kworker threads on the
> system.  There were 265 kworker threads that all have the following
> stack:

Umm... so, WQ_DFL_ACTIVE is 256.  It's just an arbitrarily largish
number which is supposed to serve as protection against runaway
kworker creation.  The assumption there is that there won't be a
dependency chain which can be longer than that and if there are it
should be separated out into a separate workqueue.  It looks like we
*can* have such long chain of dependency with high enough rate of
cgroup destruction.  kworkers trying to destroy cgroups get blocked by
an earlier one which is holding cgroup_mutex.  If the blocked ones
completely consume max_active and then the earlier one tries to
perform an operation which makes use of the system_wq, the forward
progress guarantee gets broken.

So, yeah, it makes sense now.  We're just gonna have to separate out
cgroup destruction to a separate workqueue.  Hugh's temp fix achieved
about the same effect by putting the affected part of destruction to a
different workqueue.  I probably should have realized that we were
hitting max_active when I was told that moving some part to a
different workqueue makes the problem go away.

Will send out a patch soon.

Thanks.

-- 
tejun
