From: Tejun Heo <tj@kernel.org>
Subject: Re: memcg: softlimit on internal nodes
Date: Sat, 20 Apr 2013 18:53:12 -0700
Message-ID: <20130421015312.GD19097@mtj.dyndns.org>
References: <20130420002620.GA17179@mtj.dyndns.org>
 <20130420004221.GB17179@mtj.dyndns.org>
 <CAHH2K0aeNke1NzcnyeeyHH1XvGLGxFG0_fXKAi3JH+HMtYjV=Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=PmmReHiLB0cC3qalby9eGTONVDHdxzq2nS5GjJrSIPQ=;
        b=aeL1d32rVUhrs1YOdH8lRiD0SgFcTznRGTHofUc2ViSO/JO3uiV4b25toBzTHOI1If
         QEap3qjWMp63XK4ZQqdajCGAXm7xN4rXiVPNdHQbrtNIgV7OFFnOuPo6zWYG4w+Yn1vQ
         8snLh48DT27LPzgMd7CGjFyztqMHG3i1qc/c+bW4U1SscbysW5rCUAPJgKd9P1MdW1Lv
         SzG01LF+jvJWSFIqJixKXiiLYvgVAULFxi6naAe42mmth00Jp/feZonw9KYNXxGZ/ywi
         5xg7hYVp5DbppRhxFjZBI8BvF9umWHbOLO43qllMlNCvQREN3SZ8oPb71WbBYtZd4QZi
         SyjA==
Content-Disposition: inline
In-Reply-To: <CAHH2K0aeNke1NzcnyeeyHH1XvGLGxFG0_fXKAi3JH+HMtYjV=Q@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Thelen <gthelen@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, cgroups@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>, Hugh Dickins <hughd@google.com>, Ying Han <yinghan@google.com>, Glauber Costa <glommer@parallels.com>, Michel Lespinasse <walken@google.com>

Hey, Greg.

On Fri, Apr 19, 2013 at 08:35:12PM -0700, Greg Thelen wrote:
> > As for how actually to clean up this yet another mess in memcg, I
> > don't know.  Maybe introduce completely new knobs - say,
> > oom_threshold, reclaim_threshold, and reclaim_trigger - and alias
> > hardlimit to oom_threshold and softlimit to recalim_trigger?  BTW,
> > "softlimit" should default to 0.  Nothing else makes any sense.
> 
> I agree that the hard limit could be called the oom_threshold.
> 
> The meaning of the term reclaim_threshold is not obvious to me.  I'd
> prefer to call the soft limit a reclaim_target.  System global
> pressure can steal memory from a cgroup until its usage drops to the
> soft limit (aka reclaim_target).  Pressure will try to avoid stealing
> memory below the reclaim target.  The soft limit (reclaim_target) is
> not checked until global pressure exists.  Currently we do not have a
> knob to set a reclaim_threshold, such that when usage exceeds the
> reclaim_threshold async reclaim is queued.  We are not discussing
> triggering anything when soft limit is exceeded.

Yeah, reclaim_target seems like a better name for it.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
