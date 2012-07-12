From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch 2/5] mm, oom: introduce helper function to process threads
 during scan
Date: Thu, 12 Jul 2012 15:18:21 +0800
Message-ID: <4FFE7A3D.3010908@gmail.com>
References: <alpine.DEB.2.00.1206251846020.24838@chino.kir.corp.google.com> <alpine.DEB.2.00.1206291404530.6040@chino.kir.corp.google.com> <alpine.DEB.2.00.1206291405360.6040@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=Ja5xe0rHWVRq28Qbhm9WrwHNFYBgqSrRW81LV3JD2ig=;
        b=i9gzSDhFcjSa0BqnqDu/TINe/J+a9Wnppt8gQg69AC481x0AsSTf5fBh51eFqzb0/8
         /WY0ceGtYwIyBGtswkcE0g/pIihMsem5Un0EdWe8RonEfzdeBE6++3yBDadHQ5PG6f66
         uX1inONrWNTDy7fUkCMzve42wMvpwO7OB8Jtp0mgFYHn+3LKYZ2q0UnGWu5AjdAg8MH2
         iRSLEiZSLNNNWfZUw5gVK+7+6hSCHuOeT8v2auBC9HHFAhGNbegfVRLaRk9duIjfzN4M
         t9fcGWaxlSMgVXEKWtn+8rs1BSXT3FWGxr+9LnQAxzIkynelG2JLbteN7CWuiNTnNFBM
         OIig==
In-Reply-To: <alpine.DEB.2.00.1206291405360.6040-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 06/30/2012 05:06 AM, David Rientjes wrote:
> This patch introduces a helper function to process each thread during the
> iteration over the tasklist.  A new return type, enum oom_scan_t, is
> defined to determine the future behavior of the iteration:
>
>   - OOM_SCAN_OK: continue scanning the thread and find its badness,
>
>   - OOM_SCAN_CONTINUE: do not consider this thread for oom kill, it's
>     ineligible,
>
>   - OOM_SCAN_ABORT: abort the iteration and return, or
>
>   - OOM_SCAN_SELECT: always select this thread with the highest badness
>     possible.
>
> There is no functional change with this patch.  This new helper function
> will be used in the next patch in the memory controller.
>

Looks good to me.
You can add  Reviewed-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org> :-)


Thanks,
Sha
