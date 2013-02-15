From: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/7] memcg targeted shrinking
Date: Thu, 14 Feb 2013 17:28:57 -0800
Message-ID: <xr93ip5unz52.fsf@gthelen.mtv.corp.google.com>
References: <1360328857-28070-1-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=x-received:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version:content-type;
        bh=VhXaCrJIkr+Xe4dpaFLCTbhdFQnL70fFwaVt6fkx+Fc=;
        b=nV052eWWMTx7BIp2ywletBoXaKLF0+P4zvCsN4LU/mm9koWqPar2NfwGJN0B+BMGSE
         +2OnJuNHxPy47Ia/wP+EWVU9nUNNAeLifxQ1VZLE5az08ZS2J4tTNvo7GVFqlPBhu4TI
         WgeSl+1bExis7vr0ItE4scnOok5aGIwYSn9FhVxjy7SbRhHJx2c2vl1JW3wJ3fNjyHJJ
         ZNQMzLRp8DhmQOAggQ42C1duA4yDHqtN22RCEjXB22D+DnjzAFVHj40dUO2wKVrPz3bZ
         dzTOGq5H9MegipavMMJNmae6fIUfhGFT5oSj4FbGlOJTrzFNLfr+H6UEws9xHaxDKul+
         ytPQ==
In-Reply-To: <1360328857-28070-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
	(Glauber Costa's message of "Fri, 8 Feb 2013 17:07:30 +0400")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Dave Shrinnker <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Feb 08 2013, Glauber Costa wrote:

> This patchset implements targeted shrinking for memcg when kmem limits are
> present. So far, we've been accounting kernel objects but failing allocations
> when short of memory. This is because our only option would be to call the
> global shrinker, depleting objects from all caches and breaking isolation.
>
> This patchset builds upon the recent work from David Chinner
> (http://oss.sgi.com/archives/xfs/2012-11/msg00643.html) to implement NUMA
> aware per-node LRUs. I build heavily on its API, and its presence is implied.
>
> The main idea is to associate per-memcg lists with each of the LRUs. The main
> LRU still provides a single entry point and when adding or removing an element
> from the LRU, we use the page information to figure out which memcg it belongs
> to and relay it to the right list.
>
> This patchset is still not perfect, and some uses cases still need to be
> dealt with. But I wanted to get this out in the open sooner rather than
> later. In particular, I have the following (noncomprehensive) todo list:
>
> TODO:
> * shrink dead memcgs when global pressure kicks in.
> * balance global reclaim among memcgs.
> * improve testing and reliability (I am still seeing some stalls in some cases)

Do you have a git tree with these changes so I can see Dave's numa LRUs
plus these changes?
