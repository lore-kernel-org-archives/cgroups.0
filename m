From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 41/51] writeback: make wakeup_flusher_threads() handle
 multiple bdi_writeback's
Date: Fri, 3 Jul 2015 12:33:09 -0400
Message-ID: <20150703163309.GC5273@mtj.duckdns.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-42-git-send-email-tj@kernel.org>
 <20150701081528.GB7252@quack.suse.cz>
 <20150702023706.GK26440@mtj.duckdns.org>
 <20150703130213.GM23329@quack.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=dcjeVPRahf2G0Avc8AmkgL0qIngK4GsV+cAVr8FUNSQ=;
        b=EBwkZkcIIe+SN+4NtFeiPP5GiQFvPrtCVuZvmg4SXJjJiT4tMHp6j3D1vTwzq7A4AK
         3KC3zXXYKvJiA4cZqQ/YasNUhzWl8kSU1xZRNpjGewxVEWGMsOUtKrvIKwX3KuVX4HUI
         2UWmAOKLD1Pbu47whgaFZMm5fFA60k4lmcInrQz8cVErdSBL6E14IKD87uFnX2Nxn0vz
         R8awa7k/N7Mah04iSV3YuDfO6LDzr6wnXgY04dUvwoIity7aU+VF9mEf1qkMOtQEXX7L
         7OcbSBj2d9nqVoVcZfRMFMxSRk2NzPcHI9knkppZwDHujn+2b8Bi2/tSqpWjow3o9Q2Q
         jhBA==
Content-Disposition: inline
In-Reply-To: <20150703130213.GM23329-+0h/O2h83AeN3ZZ/Hiejyg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org

Hello,

On Fri, Jul 03, 2015 at 03:02:13PM +0200, Jan Kara wrote:
...
> OK, I agree with your device vs logical construct argument. However when
> splitting pages based on avg throughput each cgroup generates, we know
> nothing about actual amount of dirty pages in each cgroup so we may end up
> writing much fewer pages than we originally wanted since a cgroup which was
> assigned a big chunk needn't have many pages available. So your algorithm
> is basically bound to undershoot the requested number of pages in some
> cases...

Sure, but the nr_to_write has never been a strict thing except when
we're writing out everything.  We don't overshoot them but writing out
less than requested is not unusual.  Also, note that write bandwidth
is the primary measure that we base the distribution of dirty pages
on.  Sure, there can be cases where the two deviate but this is the
better measure to use than, say, number of currently dirty pages.

> Another concern is that if we have two cgroups with same amount of dirty
> pages but cgroup A has them randomly scattered (and thus have much lower
> bandwidth) and cgroup B has them in a sequential fashion (thus with higher
> bandwidth), you end up cleaning (and subsequently reclaiming) more from
> cgroup B. That may be good for immediate memory pressure but could be
> considered unfair by the cgroup owner.
> 
> Maybe it would be better to split number of pages to write based on
> fraction of dirty pages each cgroup has in the bdi?

The dirty pages are already distributed according to write bandwidth.
Write bandwidth is the de-facto currency of dirty page distribution.
If it can be shown that some other measure is better for this purpose,
sure, but I don't see why we'd deviate just based on a vague feeling
that something else might be better and given how these mechanisms are
used I don't think going either way would matter a bit.

Thanks.

-- 
tejun
