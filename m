From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/4] cpusets,isolcpus: add file to show isolated cpus in
 cpuset
Date: Wed, 18 Mar 2015 12:47:45 -0400
Message-ID: <20150318164745.GA21564@htj.duckdns.org>
References: <1425917530-1771-1-git-send-email-riel@redhat.com>
 <1425917530-1771-4-git-send-email-riel@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=omuV6HgpmLK0Wlh0zeZrUD8/WRU6vxcEezQaLFKCFn0=;
        b=JI2EOnd2qVSyUxdLRlqMJeZtizeTb9MW8L73/KERi3T/QEyM06CtLqzloqAZkFFVDl
         7/mUscmNS/caBeN9ydmvmtkgnCRh3gvtZWIKd0auYdvkiBhEATjmRIIT5sB6R8xLG9n5
         dHjGgwKkPfA+UYRI6w4EVAw6R6lVNebIuymiDUNGpph9XBR2SMVzDRTUSJS4ubAotch2
         gB4XTEonuUarncRaHn0Msg0WuqMHrXF9YtGt4r+++M9HZEp77zcwUDKV5ftc75PHDjrv
         UFEWcNxgbXy6AivFhZhEi3zu8mRaudq+dVc4xMhn8AN/RKMaEeFAd70gNhjodQjK/f2l
         0gQw==
Content-Disposition: inline
In-Reply-To: <1425917530-1771-4-git-send-email-riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Mon, Mar 09, 2015 at 12:12:09PM -0400, riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> From: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> The previous patch makes it so the code skips over isolcpus when
> building scheduler load balancing domains. This makes it hard to
> see for a user which of the CPUs in a cpuset are participating in
> load balancing, and which ones are isolated cpus.
> 
> Add a cpuset.isolcpus file with info on which cpus in a cpuset are
> isolated CPUs.
> 
> This file is read-only for now. In the future we could extend things
> so isolcpus can be changed at run time, for the root (system wide)
> cpuset only.

Didn't Li say that this is trivially computable from userland?  I'm
not sure this knob actually belongs to cpuset.

Thanks.

-- 
tejun
