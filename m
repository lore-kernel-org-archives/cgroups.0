From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: asynchronous reclaim for memory.high
Date: Thu, 20 Feb 2020 13:45:45 -0500
Message-ID: <20200220184545.GH698990@mtj.thefacebook.com>
References: <20200219181219.54356-1-hannes@cmpxchg.org>
 <20200219183731.GC11847@dhcp22.suse.cz>
 <20200219191618.GB54486@cmpxchg.org>
 <20200219195332.GE11847@dhcp22.suse.cz>
 <20200219214112.4kt573kyzbvmbvn3@ca-dmjordan1.us.oracle.com>
 <20200219220859.GF54486@cmpxchg.org>
 <20200220154524.dql3i5brnjjwecft@ca-dmjordan1.us.oracle.com>
 <20200220155651.GG698990@mtj.thefacebook.com>
 <20200220182326.ubcjycaubgykiy6e@ca-dmjordan1.us.oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ajjnncCD8dG0G18fVGbEVN7FP1csi2qzGtdLhYXXJTU=;
        b=k/vpOSde9bMUoOkP1G2/1I25Nn9Pkv0cytj97/bjAuSIclk+m4KQ9S0ziULuviFMs9
         c6vb59sXLtBdSul8JNMDN9b22s/HaXZqEDqZVUUgXxNzpc7+RQuul8Lh87CBQrY8TG3b
         yeVKaW3Bcp9oIDJS2uYK6b0btASzCNPTQaNt4mwNERLhrW2G+KqIsbMBhMm9SXREycvV
         j/K7EMs16439ppT5r1FvGQRPftTQKxEEa69Oq9TofNUu2SJGZM7OqXVNPpPTYwvgce4v
         wW8oxpMW8jTdFf8kowzQY6+ON6pmqStIvwfyWeN0NhVNmwZhaMHrCqR6Xy/TfGZu19ch
         YULQ==
Content-Disposition: inline
In-Reply-To: <20200220182326.ubcjycaubgykiy6e-S51bK0XF4qpuJJETbFA3a0B3C2bhBk7L0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Hello,

On Thu, Feb 20, 2020 at 01:23:26PM -0500, Daniel Jordan wrote:
> The amount of work wouldn't seem to matter as long as the kernel thread stays
> in the cgroup and lives long enough.  There's only the one-time cost of
> attaching it when it's forked.  That seems doable for unbound workqueues (the
> async reclaim), but may not be for the network packets.

The setup cost can be lazy optimized but it'd still have to bounce the
tiny pieces of work to different threads instead of processing them in
one fell swoop from the same context, which most likely is gonna be
untenably expensive.

Thanks.

-- 
tejun
