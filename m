From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Date: Wed, 27 Nov 2013 18:52:10 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1311271839290.5120@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1311141447160.21413@chino.kir.corp.google.com> <alpine.DEB.2.02.1311141525440.30112@chino.kir.corp.google.com> <20131118154115.GA3556@cmpxchg.org> <20131118165110.GE32623@dhcp22.suse.cz> <20131122165100.GN3556@cmpxchg.org>
 <alpine.DEB.2.02.1311261648570.21003@chino.kir.corp.google.com> <20131127163435.GA3556@cmpxchg.org> <alpine.DEB.2.02.1311271343250.9222@chino.kir.corp.google.com> <20131127231931.GG3556@cmpxchg.org> <alpine.DEB.2.02.1311271613340.10617@chino.kir.corp.google.com>
 <20131128022804.GJ3556@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=16QdJ054bz2s0SC2YTGww4JbVuwe9kk5Fw3pq2UHYfE=;
        b=L34S7NllvSY6VQIh7F+U9VTgQ4xJoxOyt/Tw/2ffGBnG4d9db7xVomYCg7TDSKkEi8
         NAAn4dk8hC4N9TGiE4p3h+dQZpf6VBTIW1Lyy/8r8zGIhCmSJL2Y+wEDpkXfyiI5lrw8
         ZxvRzNg4tV+pEVmLLci2H1qWak8KG5awvNSNLwBPV2xVgq9y4GcLtog9ewFMpjlg+rvt
         lAA4D2+b0v3JYFaleDwmi4vzWFEUyA3Av9OwtVF87d9G71fhZGmlc756+l/ehhHQL3HX
         r0niJ1qUExwn/d6p8yic7i2NI9pnJNjN33sTepGjKwVDONRW4CR7baAA902J7xEv/WAE
         kP4g==
In-Reply-To: <20131128022804.GJ3556-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 27 Nov 2013, Johannes Weiner wrote:

> The long-standing, user-visible definition of the current line agrees
> with me.  You can't just redefine this, period.
> 
> I tried to explain to you how insane the motivation for this patch is,
> but it does not look like you are reading what I write.  But you don't
> get to change user-visible behavior just like that anyway, much less
> so without a sane reason, so this was a complete waste of time :-(
> 

If you would like to leave this to Andrew's decision, that's fine.  
Michal has already agreed with my patch and has acked it in -mm.

If userspace is going to handle oom conditions, which is possible today 
and will be extended in the future, then it should only wakeup as a last 
resort when there is no possibility of future memory freeing.  It would be 
stupid to have userspace wakeup to handle the oom condition and then 
require it determine if the kernel simply needed to give it access to 
memory reserves for the allocating task to exit and free memory so it 
doesn't actually need to do anything.

Section 10 of Documentation/cgroups/memory.txt defines the necessary 
actions for processes waiting on this notification to make forward 
progress, it doesn't expect a process is already going to exit and free 
memory on its own.  Waking up in such a condition would be absolutely 
ludicrous.

Furthermore, if you're looking for notification simply when the memcg oom 
limit has been reached, you can use memory thresholds.  If you're looking 
for notification simply when reclaim is suffering severe pressure, you can 
use VMPRESSURE_CRITICAL.

I've been patient in this thread, but at this point I think everything has 
been said and it's pointless to continue going in circles.  Thanks for 
your time.
