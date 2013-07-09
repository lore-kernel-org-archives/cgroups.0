From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC] fsio: filesystem io accounting cgroup
Date: Tue, 9 Jul 2013 07:29:08 -0700
Message-ID: <20130709142908.GE2478@htj.dyndns.org>
References: <20130708175201.GB9094@redhat.com>
 <20130708175607.GB18600@mtj.dyndns.org>
 <51DBC99F.4030301@openvz.org>
 <20130709125734.GA2478@htj.dyndns.org>
 <51DC0CE2.2050906@openvz.org>
 <20130709131605.GB2478@htj.dyndns.org>
 <20130709131646.GC2478@htj.dyndns.org>
 <51DC136E.6020901@openvz.org>
 <20130709134558.GD2478@htj.dyndns.org>
 <20130709141833.GA2237@redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=W+lfG8ELLBYARQPh9VxiNJeUx1BZlNF0S8vDmevKVgI=;
        b=gifCPcL63ICbobA6HzESgmzlNUqYOPfdRbDbXBeLJmHbpPEHz3ewevaNcJ4iia8Jg1
         lWXUzZaR8GFVnrOuEr1NlE/yTxHwVy914beV2iEFSvayOY5uBiRPFagv9WebQRGRZGJj
         hMv77LtIOAq5xfy9QIlxvnaVyBVZiNvtBjL6h2eXveqR1gKxpePxFpYzfWh3gykOgHam
         5hqTIfAm79/Jr9bHrqgOVoLS4Z6f1SaLO3s/69lxFGzKWFS1P2qzehMI+lf8ZI2tBP0i
         DWbEAr21WUlgDwxWm9fgfVlwGl0iwwRfSexYnn3RDN5Zyu/dIDtRAMagaGXW+mGuqUXp
         +ydg==
Content-Disposition: inline
In-Reply-To: <20130709141833.GA2237@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Sha Zhengju <handai.szj@gmail.com>, devel@openvz.org, Jens Axboe <axboe@kernel.dk>

On Tue, Jul 09, 2013 at 10:18:33AM -0400, Vivek Goyal wrote:
> For implementing throttling one as such does not have to do time
> slice management on the queue.  For providing constructs like IOPS
> or bandwidth throttling, one just need to put one throttling knob 
> in the cgroup pipe irrespective of time slice management on the
> backing device/network.

We should be providing a comprehensive mechanism to be used from
userland, not something which serves pieces of specialized
requirements here and there.  blkio is already a mess with the
capability changing depending on which elevator is in use and
blk-throttle counting bios instead of merged requests making iops
control a bit silly.  We need to clean that up, not add more mess on
top.

> Also time slice management is one way of managing the backend resource.
> CFQ did that and it works only for slow devices. For faster devices
> we anyway need some kind of token mechanism instead of keeping track
> of time.

No, it is the *right* resource to manage for rotating devices if you
want any sort of meaningful proportional resource distribution.  It's
not something one dreams up out of blue but something which arises
from the fundamental operating characteristics of the device.  For
SSDs, iops is good enough as their latency profile is consistent
enough but doing so with rotating disks doesn't yield anything useful.

> So I don't think trying to manage time slice is the requirement here.

For a cgroup resource controller, it *is* a frigging requirement to
control the right fundamental resource at the right place where the
resource resides and can be fully controlled.  Nobody should have any
other impression.

> > and by the time you implemented proper hierarchy support and
> > proportional contnrol, yours isn't gonna be that simple either.
> 
> I suspect he is not plannnig to do any proportional control at that
> layer. Just throttling mechanism.

blkio should be able to do proportional control in general.  The fact
that we aren't able to do that except when cfq-iosched is in use is a
problem which needs to be fixed.  It's not a free-for-all pass for
creating more broken stuff.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
