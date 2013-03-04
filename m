From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: per-cpu statistics
Date: Sun, 3 Mar 2013 17:01:42 -0800
Message-ID: <20130304010142.GE3678@htj.dyndns.org>
References: <512F0E76.2020707@parallels.com>
 <5133F0FD.3040501@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=aXTfmsU2jKmZWhmTOE7hOA2IeI4v1wgQ+Zk4FDXXRWU=;
        b=zk1qOKpB13ZoMR7hBPAjKA3m0sPYD0eWRMPu63nLsaSVgexOHmii+hdc3HB7LBbyNm
         0Bz41pVlesjH5wcFsv35pRY9GfplqE2iJL/4lDzvhNC+Fj8KkhV9ca4DkZmbhMTDDv9O
         JvyFltIeX8yJm9r3stgAt5gFdhu804b/K56nx2NCy75riRPSQfkl6U+XTw45EpUa0LTZ
         pH1rS0+JS4L3oQx8q+BdSwy0mOyWgqSGqrzf3cIxzdgzM4MUbKPtE3ZhnVe5UnGCaI6k
         +/Xvbz6sQCf0zYNbBaIeKWnOUqM1ZHy0PegUcB6GnXD496dA+1jvgT9/qEfFclIfFkdB
         VvDA==
Content-Disposition: inline
In-Reply-To: <5133F0FD.3040501-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>

Hello,

On Mon, Mar 04, 2013 at 09:55:25AM +0900, Kamezawa Hiroyuki wrote:
> An reason I didn't like percpu_counter *was* its memory layout.
> 
> ==
> struct percpu_counter {
>         raw_spinlock_t lock;
>         s64 count;
> #ifdef CONFIG_HOTPLUG_CPU
>         struct list_head list;  /* All percpu_counters are on a list */
> #endif
>         s32 __percpu *counters;
> };
> ==
> 
> Assume we have counters in an array, then, we'll have
> 
>    lock
>    count
>    list
>    pointer
>    lock
>    count
>    list
>    pointer
>    ....
> 
> An counter's lock ops will invalidate pointers in the array.
> We tend to update several counters at once.

I agree that percpu_counter leaves quite a bit to be desired.  It
would be great if we can implement generic percpu stats facility which
takes care of aggregating the values periodically preferably with
provisions to limit the amount of deviation global counter may reach.

Thansk.

-- 
tejun
