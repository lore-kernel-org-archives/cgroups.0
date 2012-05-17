From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [patch 6/6] mm: memcg: print statistics from live counters
Date: Thu, 17 May 2012 14:56:05 +0400
Message-ID: <4FB4D945.7060108@parallels.com>
References: <1337018451-27359-1-git-send-email-hannes@cmpxchg.org> <1337018451-27359-7-git-send-email-hannes@cmpxchg.org> <20120516160131.fecb5ddf.akpm@linux-foundation.org> <4FB43FDB.6050300@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FB43FDB.6050300-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 05/17/2012 04:01 AM, KAMEZAWA Hiroyuki wrote:
> Hm...sorry. I(fujitsu) am now considering to add meminfo for memcg...,
>
> add an option to override /proc/meminfo if a task is in container or
> meminfo file somewhere.
> (Now, we cannot trust /usr/bin/free, /usr/bin/top etc...in a container.)

Yes, and all the previous times I tried to touch those, I think the 
general agreement was to come up with some kind of fuse overlay that 
would read information available from the kernel, and present it 
correctly formatted through bind-mounts on the files of interest.

But that's mainly because we never reached agreement on how to make that 
appear automatically from such tasks
