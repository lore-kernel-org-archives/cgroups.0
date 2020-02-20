From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: asynchronous reclaim for memory.high
Date: Thu, 20 Feb 2020 15:54:16 -0500
Message-ID: <20200220205416.GI698990@mtj.thefacebook.com>
References: <20200219183731.GC11847@dhcp22.suse.cz>
 <20200219191618.GB54486@cmpxchg.org>
 <20200219195332.GE11847@dhcp22.suse.cz>
 <20200219214112.4kt573kyzbvmbvn3@ca-dmjordan1.us.oracle.com>
 <20200219220859.GF54486@cmpxchg.org>
 <20200220154524.dql3i5brnjjwecft@ca-dmjordan1.us.oracle.com>
 <20200220155651.GG698990@mtj.thefacebook.com>
 <20200220182326.ubcjycaubgykiy6e@ca-dmjordan1.us.oracle.com>
 <20200220184545.GH698990@mtj.thefacebook.com>
 <20200220195535.7xblt45akld6eftj@ca-dmjordan1.us.oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BiE+rct0rry2pArV3gigMdzlZiS1+memMy+VBdXCC0g=;
        b=oHWDw6RCZdv06TZrh3Qj3gsEIXivcxE3uXPCbkcJ2m2UdQNHxxKuovATMPLuouJjWG
         /7xptXQ03FED86Sla82047upyBEwI7HZBrTJXMer3p1NaCTwIpl16i4cOA7FPSFwwncS
         RUIp1/jottGogriZOzdHOi3HyT61dDWUWxDebE8ZiGPJ2NkCjmgm+shlmh5wd83Qzy3Z
         30286SGALzQD8SzVxnEet57ytjDAmy8YcnYLI48M4clrruxKdKnmO6MIgs507n5itrye
         6TpiJZ0fBNrb2OL9NGL+NJLlTWEAMfP3nSPcOxps//7VAMRGHfh2t/E95u0WyPTdwj5R
         ChBw==
Content-Disposition: inline
In-Reply-To: <20200220195535.7xblt45akld6eftj-S51bK0XF4qpuJJETbFA3a0B3C2bhBk7L0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Hello, Daniel.

On Thu, Feb 20, 2020 at 02:55:35PM -0500, Daniel Jordan wrote:
> On Thu, Feb 20, 2020 at 01:45:45PM -0500, Tejun Heo wrote:
> > The setup cost can be lazy optimized but it'd still have to bounce the
> > tiny pieces of work to different threads instead of processing them in
> > one fell swoop from the same context, which most likely is gonna be
> > untenably expensive.
> 
> I see, your last mail is clearer now.  If it's easy to do, a pointer to where
> this happens would help so we're on the same page.

Network packet rx is the clearest example I think, but you already
mentioned it. Reclaim is less so but when kswapd reclaims, it walks
everybody, and there can be a lot of small cgroups.

Thanks.

-- 
tejun
