From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFD] Merge task counter into memcg
Date: Thu, 12 Apr 2012 13:19:28 +0200
Message-ID: <20120412111925.GA11455@somewhere.redhat.com>
References: <20120411185715.GA4317@somewhere.redhat.com>
 <4F85D9C6.5000202@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=MQ9aftVY4n/Ux4NYuUQi+34lRKTxYqFlilsyvLHxmlI=;
        b=vg2M+LVxcUZaBBFAdksNYRnNMqu68PSoVxo0u+PxfeYn5OWAFz2KZZpzHObKQkCeOS
         5nqEDCILsH2PJdlbX/FYIZ2Y0gPTs1gJ4BFne9jnSrCN00MJxAmWzARsEs/furrBmlSv
         G5moXGuvLaCjtzyXQ591jdIzcgJk2b4LCL/hLCpdTzaTl/SA+FOawcwDzMlELWt50u4v
         0qraBL9FjUtIjCQCt3akxufC+Bhd2RZzF4DwkThzr2QpeZldjdM+eeGrPd/i4RXWrTvm
         wIZjdtloOkVVp9hJ+dDB2Lp7s8F7sOn7ZethCjNTLWPL3P6Lym/zKc2CufTM4y7159NK
         LS4w==
Content-Disposition: inline
In-Reply-To: <4F85D9C6.5000202-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Walsh <dwalsh-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>

On Wed, Apr 11, 2012 at 04:21:42PM -0300, Glauber Costa wrote:
> On 04/11/2012 03:57 PM, Frederic Weisbecker wrote:
> >So if we choose the second solution, this overhead will be added unconditionally
> >to memcg.
> >But I don't expect every users of memcg will need the task counter. So perhaps
> >the overhead should be kept in its own separate subsystem.
> 
> What we're usually doing with kmem paths, like the upcoming slab
> tracking, is do not account if it is not limited. So if you are not
> limited in a particular cgroup, you jut don't bother with accounting.

So that's a good point. I can start accounting tasks and apply limits
once we write to the file only.

> 
> If this suits your need, you can probably do the same, and then
> pay the price just for the users that are interested on it.
> 
> Now, whether or not this should be considered memory, is a different
> story. You can say it is memory yes, but I bet you can very well
> find a bunch of arguments to consider it "cpu" as well.
> 
> Against the memcg, consider this: Your counter would probably be the
> first non-page based data in memcg. At least raises a flag.

Good points.
