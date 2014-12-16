From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: Provide knob for force OOM into the memcg
Date: Tue, 16 Dec 2014 14:33:58 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1412161430040.5142@chino.kir.corp.google.com>
References: <1418736335-30915-1-git-send-email-cpandya@codeaurora.org> <20141216133935.GK22914@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=xNoXhqLXIBihEPoGNE6vvAKJKVXNceYhMJLEYDgKphc=;
        b=Rn0+CNe1xVtNROSENJHEsveH7Tp9muM7FGyYvRCVnLrtaH12OlffWhnA4thUgkRVGj
         RHyxAVEnh1hnMuUZyixJFspiLzuhm8KfmpRv9z3038fLR3/MCGiW7cQrLwsQOMIZ4r5Y
         eq9UNaBk7Bf+CF6AC3m5RxqZtQBUj+gEUoM36GKIzRZ+93ELNar8MuWYAS04HZjDDe9f
         cIk1LSInhOLcu1aHwdDU7Dg3a4bhhxKByf/xJx51mxGC24+hepWIk+RBKah+uuaaFNSY
         ZcnBD9fSYVq3Mo/n28cwGWFqTkExb5J6c+Wn0zMRh3vM2gZawEeHad8oDhX2dGUKt5Yu
         iITw==
In-Reply-To: <20141216133935.GK22914-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Chintan Pandya <cpandya-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 16 Dec 2014, Michal Hocko wrote:

> > We may want to use memcg to limit the total memory
> > footprint of all the processes within the one group.
> > This may lead to a situation where any arbitrary
> > process cannot get migrated to that one  memcg
> > because its limits will be breached. Or, process can
> > get migrated but even being most recently used
> > process, it can get killed by in-cgroup OOM. To
> > avoid such scenarios, provide a convenient knob
> > by which we can forcefully trigger OOM and make
> > a room for upcoming process.
> > 
> > To trigger force OOM,
> > $ echo 1 > /<memcg_path>/memory.force_oom
> 
> What would prevent another task deplete that memory shortly after you
> triggered OOM and end up in the same situation? E.g. while the moving
> task is migrating its charges to the new group...
> 
> Why cannot you simply disable OOM killer in that memcg and handle it
> from userspace properly?
> 

The patch is introducing a mechanism to induce a kernel oom kill for a 
memcg hierarchy to make room for it in the new memcg, not disable the oom 
killer so the migration fails due to the lower limits.

It doesn't have any basis since a SIGKILL coming from userspace should be 
considered the same as a kernel oom kill from the memcg perspective, i.e. 
the fatal_signal_pending() checks that allow charge bypass instead of a 
strict reliance on TIF_MEMDIE being set.

It seems to be proposed as a shortcut so that the kernel will determine 
the best process to kill.  That information is available to userspace so 
it should be able to just SIGKILL the desired process (either in the 
destination memcg or in the source memcg to allow deletion), so this 
functionality isn't needed in the kernel.
