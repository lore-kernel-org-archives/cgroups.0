From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] writeback and cgroup
Date: Thu, 12 Apr 2012 13:51:48 -0700
Message-ID: <20120412205148.GA24056@google.com>
References: <20120403183655.GA23106@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120404145134.GC12676@redhat.com>
 <20120407080027.GA2584@quack.suse.cz>
 <20120410180653.GJ21801@redhat.com>
 <20120410210505.GE4936@quack.suse.cz>
 <20120410212041.GP21801@redhat.com>
 <20120410222425.GF4936@quack.suse.cz>
 <20120411154005.GD16692@redhat.com>
 <20120411192231.GF16008@quack.suse.cz>
 <20120412203719.GL2207@redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=7ajfANGdqh0Kk2oj7DuMnSAHP2OLi7gBoSTZLxcOduA=;
        b=DngompzZb/tAnzIht5l5tpqV787LDR+C3STRMkMVJF7Z04aCJWvxbWiaxy7vVmNdLP
         VFjjD/bbeatvYKcx7IryydxwaLJBNCNRnqr7yXnfrG0wMVTuqYTfN9di7YfD3Y69/gFg
         6ED0Eqzkj8XvUrz/99bKqoaC+WQtI+3fx4HWuyuRv1Zdi85f83Jh2iNrOV3pAFXQtDHJ
         MXAzLIT2P+GXe0qx61M8bGCxKuMr3o7/7ezf2/UrMl33Hp+Dof+l9gSWu1+IImYrEtv4
         sxweeqXjm5BZYWq+bkMe3H8eNObF4+CXnIDjjcYDWZseQib4uLu7EVDcac+q2KB0Doyx
         FHVw==
Content-Disposition: inline
In-Reply-To: <20120412203719.GL2207@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Fengguang Wu <fengguang.wu@intel.com>, Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org, sjayaraman@suse.com, andrea@betterlinux.com, jmoyer@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, ctalbott@google.com, rni@google.com, lsf@lists.linux-foundation.org

Hello, Vivek.

On Thu, Apr 12, 2012 at 04:37:19PM -0400, Vivek Goyal wrote:
> I mean how are we supposed to put cgroup throttling rules using cgroup
> interface for network filesystems and for btrfs global bdi. Using "dev_t"
> associated with bdi? I see that all the bdi's are showing up in
> /sys/class/bdi, but how do I know which one I am intereste in or which
> one belongs to filesystem I am interestd in putting throttling rule on.
> 
> For block devices, we simply use "major:min limit" format to write to
> a cgroup file and this configuration will sit in one of the per queue
> per cgroup data structure.
> 
> I am assuming that when you say throttling should happen at bdi, you
> are thinking of maintaining per cgroup per bdi data structures and user
> is somehow supposed to pass "bdi_maj:bdi_min  limit" through cgroup files?
> If yes, how does one map a filesystem's bdi we want to put rules on?

I think you're worrying way too much.  One of the biggest reasons we
have layers and abstractions is to avoid worrying about everything
from everywhere.  Let block device implement per-device limits.  Let
writeback work from the backpressure it gets from the relevant IO
channel, bdi-cgroup combination in this case.

For stacked or combined devices, let the combining layer deal with
piping the congestion information.  If it's per-file split, the
combined bdi can simply forward information from the matching
underlying device.  If the file is striped / duplicated somehow, the
*only* layer which knows what to do is and should be the layer
performing the striping and duplication.  There's no need to worry
about it from blkcg and if you get the layering correct it isn't
difficult to slice such logic inbetween.  In fact, most of it
(backpressure propagation) would just happen as part of the usual
buffering between layers.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
