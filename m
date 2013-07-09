From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC] fsio: filesystem io accounting cgroup
Date: Tue, 9 Jul 2013 06:45:58 -0700
Message-ID: <20130709134558.GD2478@htj.dyndns.org>
References: <20130708100046.14417.12932.stgit@zurg>
 <20130708170047.GA18600@mtj.dyndns.org>
 <20130708175201.GB9094@redhat.com>
 <20130708175607.GB18600@mtj.dyndns.org>
 <51DBC99F.4030301@openvz.org>
 <20130709125734.GA2478@htj.dyndns.org>
 <51DC0CE2.2050906@openvz.org>
 <20130709131605.GB2478@htj.dyndns.org>
 <20130709131646.GC2478@htj.dyndns.org>
 <51DC136E.6020901@openvz.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=FjpvOdfjOyDW4OjEuhcbmtryQ7wo1V2Dl5iK+QiWyrg=;
        b=hRR2ecy0zX1DY3YKF/RCl4y+fEvVWzI5tTRtMJApyKkSKJ+xXfHveSflQBZtKksAAp
         RYV955f6vw0MduDPuPl6Q444vTunF3/rZFSCy5QY03EVUMTnAmDHz8bzSLQmE8wZEG9+
         bhVVorCrvvmGVYc1rgCoasU3tCCVjumHyMzayeT06j0NnaguGTB6jpvIxGBevFrDX3tL
         RQxK++i0RyBRZa626YBS6tq22Wi1cZDYdu3B9oytew+oI1DWx8mpuZMP2/pMZvrnHTih
         QVIYvYL3Zn+/yWyoqyx/X6Dm7p5Sygey5t+LSbFOnJ0ZCC2mAMiLAATekTSzDMO4TVRo
         cVgw==
Content-Disposition: inline
In-Reply-To: <51DC136E.6020901@openvz.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Sha Zhengju <handai.szj@gmail.com>, devel@openvz.org, Jens Axboe <axboe@kernel.dk>

On Tue, Jul 09, 2013 at 05:43:10PM +0400, Konstantin Khlebnikov wrote:
> My concept it cgroup which would control io operation on vfs layer
> for all filesystems.  It will account and manage IO operations. I've
> found really lightweight technique for accounting and throttling
> which don't introduce new locks or priority inversions (which is
> major problem in all existing throttlers, including cpu cgroup rate
> limiter) So, I've tried to keep code smaller, cleaner and saner as
> possible while you guys are trying to push me into the block layer
> =)

You're trying to implement QoS in the place where you don't have
control of the queue itself.  You aren't even managing the right type
of resource for disks which is time slice rather than iops or
bandwidth and by the time you implemented proper hierarchy support and
proportional control, yours isn't gonna be that simple either.  The
root problem is bdi failing to propagate pressure from the actual
queue upwards.  Fix that.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
