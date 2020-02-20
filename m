From: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: asynchronous reclaim for memory.high
Date: Thu, 20 Feb 2020 14:55:35 -0500
Message-ID: <20200220195535.7xblt45akld6eftj@ca-dmjordan1.us.oracle.com>
References: <20200219181219.54356-1-hannes@cmpxchg.org>
 <20200219183731.GC11847@dhcp22.suse.cz>
 <20200219191618.GB54486@cmpxchg.org>
 <20200219195332.GE11847@dhcp22.suse.cz>
 <20200219214112.4kt573kyzbvmbvn3@ca-dmjordan1.us.oracle.com>
 <20200219220859.GF54486@cmpxchg.org>
 <20200220154524.dql3i5brnjjwecft@ca-dmjordan1.us.oracle.com>
 <20200220155651.GG698990@mtj.thefacebook.com>
 <20200220182326.ubcjycaubgykiy6e@ca-dmjordan1.us.oracle.com>
 <20200220184545.GH698990@mtj.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Oeqn/msELu44gc9TzxVpdR7IAGtxbC8EWYVF6nQT3jA=;
 b=k3zCKzyqek3pblqv98woSoLvFhc6jomamI50XiH6WcMl8o/NKBWg5FP45OC9wyyrA8DZ
 ewFwmrXB+/8Y/yEIhisarEHRnQCQ+Ugt/IOlO3UjjyzBotUQYa6Ih8LpO+fW45LQGa3h
 PHPNVxuiiUTWkbYIFAgC45rzzcmR3+1pqy4kfOevEf5bAxFt41h/4rAI53vYFRVikvpG
 M+C0OyuOz2qtmZkavplVeLA9HFE9h4AsybtU8FmZCOqN2ZGwoD4vg4dzehCeYnUH75I2
 wPiJuEOFoOAwFaH5ry2l8yosH4bV1KBA8GxHwjjrqJJ12nR6424UoBgU0LYqbtR/f09o 4Q== 
Content-Disposition: inline
In-Reply-To: <20200220184545.GH698990-146+VewaZzwNjtGbbfXrCEEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Thu, Feb 20, 2020 at 01:45:45PM -0500, Tejun Heo wrote:
> The setup cost can be lazy optimized but it'd still have to bounce the
> tiny pieces of work to different threads instead of processing them in
> one fell swoop from the same context, which most likely is gonna be
> untenably expensive.

I see, your last mail is clearer now.  If it's easy to do, a pointer to where
this happens would help so we're on the same page.

thanks,
Daniel
