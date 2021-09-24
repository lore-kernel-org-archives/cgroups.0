From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3] vmpressure: wake up work only when there is
 registration event
Date: Fri, 24 Sep 2021 16:11:21 +0200
Message-ID: <YU3ciRm7L2p9lJo6@dhcp22.suse.cz>
References: <1632491065-10785-1-git-send-email-wang.yong12@zte.com.cn>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1632492681; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xptrUF64qS+6u7xLV3tWOmzw4bsvaWDSNFYfVdST24M=;
        b=picfxz/elp6W9f7CrwEaQtXFpVHkQ2uj6HVogFSG1fbe3TZ6Rp4MRjWYdS5gaBAaz8eySa
        xry+lDDpqV1kUX56tSodaps3toJJXLjQ2T01KVkKlU2muVl907c/RGZT8ulP0oAIHJ8nlA
        IKuWE5zGXaNvMWoQnX0qayxiW3eIzFU=
Content-Disposition: inline
In-Reply-To: <1632491065-10785-1-git-send-email-wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: yongw.pur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org

On Fri 24-09-21 06:44:25, yongw.pur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> From: wangyong <wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> 
> Use the global variable num_events to record the number of vmpressure
> events registered by the system, and wake up work only when there
> is registration event.
> Usually, the vmpressure event is not registered in the system, this patch
> can avoid waking up work and doing nothing.
> 
> Test with 5.14.0-rc5-next-20210813 on x86_64 4G ram.
> Consume cgroup memory until it is about to be reclaimed, then execute
> "perf stat -I 2000 malloc.out" command to trigger memory reclamation
> and get performance results.
> The context-switches is reduced by about 20 times.
> 
> unpatched:
> Average of 10 test results
> 582.4674048     task-clock(msec)
> 19910.8         context-switches
> 0               cpu-migrations
> 1292.9          page-faults
> 414784733.1     cycles
> 580070698.4     instructions
> 125572244.7     branches
> 2073541.2       branch-misses
> 
> patched:
> Average of 10 test results
> 973.6174796     task-clock(msec)
> 988.6           context-switches
> 0               cpu-migrations
> 1785.2          page-faults
> 772883602.4     cycles
> 1360280911      instructions
> 290519434.9     branches
> 3378378.2       branch-misses

Your data still doesn't make any sense. I have asked about that in the
previous submission and you haven't really clarified anything. How come
your task-clock has almost doubled. You are likely not not comparing
apples to apples or something weird is going on.

This patch is not going to fly without a sensible data and analysis of
that data.

Thanks!
-- 
Michal Hocko
SUSE Labs
