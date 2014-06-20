From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/5] cgroup: fix a race between cgroup_mount() and
 cgroup_kill_sb()
Date: Fri, 20 Jun 2014 15:35:21 -0400
Message-ID: <20140620193521.GB28324@mtj.dyndns.org>
References: <53994943.60703@huawei.com>
 <539949A1.90301@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=fdnOjmCrQmLmoFb7vj9UNHVEIZ8JAL25yre4RPpm3Eo=;
        b=fygF9nzBiWp/NflOdO9SW+UhiCxKsOYT20wbBfiimQSu3HVWs+YUabiG7vTI8SBtk+
         b4/lDuXWULBVHGi41xKP2pAU6sDyGs+hc1jVdf0PR6ka9rw6Xf4FA4vai2Ybr96ckN1a
         6WEiAAqlqro0HuOVoB8pp32ucXqxhfNLHKoqDQr3lZgPsef8pkstwX4urzeG0Fu3CbLd
         rQwHRQsLeO2G/xLgq5vg69DVmsPcu/Rfeg6qg/RlAryrjoVs3AMNbm1+89aIh83jZN/G
         I0VA1/8Hxs17EM4ddlL4q0vMpi0BcjNrYS04+NXfu6hi9LY9oKpmkLfuJKWZbGOrNcaP
         leMQ==
Content-Disposition: inline
In-Reply-To: <539949A1.90301-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Li.

Sorry about the long delay.

On Thu, Jun 12, 2014 at 02:33:05PM +0800, Li Zefan wrote:
> We've converted cgroup to kernfs so cgroup won't be intertwined with
> vfs objects and locking, but there are dark areas.
> 
> Run two instances of this script concurrently:
> 
>     for ((; ;))
>     {
>     	mount -t cgroup -o cpuacct xxx /cgroup
>     	umount /cgroup
>     }
> 
> After a while, I saw two mount processes were stuck at retrying, because
> they were waiting for a subsystem to become free, but the root associated
> with this subsystem never got freed.
> 
> This can happen, if thread A is in the process of killing superblock but
> hasn't called percpu_ref_kill(), and at this time thread B is mounting
> the same cgroup root and finds the root in the root list and performs
> percpu_ref_try_get().
> 
> To fix this, we increase the refcnt of the superblock instead of increasing
> the percpu refcnt of cgroup root.

Ah, right.  Gees, I'm really hating the fact that we have ->mount but
not ->umount.  However, can't we make it a bit simpler by just
introducing a mutex protecting looking up and refing up an existing
root and a sb going away?  The only problem is that the refcnt being
killed isn't atomic w.r.t. new live ref coming up, right?  Why not
just add a mutex around them so that they can't race?

Thanks.

-- 
tejun
