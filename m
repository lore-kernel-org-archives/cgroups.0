From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH v2 08/17] cgroup: Move debug cgroup to its own file
Date: Fri, 19 May 2017 15:21:46 -0400
Message-ID: <20170519192146.GA9741@wtj.duckdns.org>
References: <1494855256-12558-1-git-send-email-longman@redhat.com>
 <1494855256-12558-9-git-send-email-longman@redhat.com>
 <20170517213603.GE942@htj.duckdns.org>
 <ee36d4f8-9e9d-a5c7-2174-56c21aaf75af@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OfxMhYVHOgK0YiGB8iPSATNSY8R3yKPDwoBh0VVtptw=;
        b=YEe2qX/4tV30xucEKiNrNKNnBY9Z2vJ2qs3piNu8bX+y5Qu+iluWCPK+TgICoV6Mwr
         ULnWu/MFg03EH9Yqgjkz/ONCo0ZxyDD7b4p9jnT2Oi15S8nxApSKbaMVU4k8ZV9Qctvo
         07hAvDc3/tX8nSq1n6t1fJ0ATllhFkE/waLyBUd9XF9wyqixu13rBjd7DkeWINczoCxc
         v+N36/IDstIfQwJLA2aUuYHeOYWqDKZyZkZr5CTxXo9WCAq4ruAVyouSKOI3g9z5mk0p
         NEsd63KU7A+yuOmC1n+I6ZmswOzyvlgtP+X2WlDWwP0gUwS0FIlPxNoDUuiLD0Qc+Pe8
         oAKQ==
Content-Disposition: inline
In-Reply-To: <ee36d4f8-9e9d-a5c7-2174-56c21aaf75af-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org

Hello, Waiman.

On Thu, May 18, 2017 at 11:52:18AM -0400, Waiman Long wrote:
> The controller name is "debug" and so it is obvious what this controller
> is for. However, the config prompt "Example controller" is indeed vague

Yeah but it also shows up as an integral part of stable interface
rather than e.g. /sys/kernel/debug.  This isn't of any interest to
people who aren't developing cgroup core code.  There is no reason to
risk growing dependencies on it.

> in meaning. So we can make the prompt more descriptive here. As for the
> boot param, are you saying something like "cgroup_debug" has to be
> specified in the command line even if CGROUP_DEBUG config is there for
> the debug controller to be enabled? I am fine with that if you think it
> is necessary.

Yeah, I think that'd be a good idea.  cgroup_debug should do.  While
at it, can you also please make CGROUP_DEBUG depend on DEBUG_KERNEL?

Thanks.

-- 
tejun
