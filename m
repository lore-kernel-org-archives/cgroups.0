From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.5-fixes] cpuset: make mm migration
 asynchronous
Date: Fri, 22 Jan 2016 10:23:09 -0500
Message-ID: <20160122152309.GC32380@htj.duckdns.org>
References: <56978452.6010606@de.ibm.com>
 <20160114195630.GA3520@mtj.duckdns.org>
 <5698A023.9070703@de.ibm.com>
 <20160115164023.GH3520@mtj.duckdns.org>
 <20160119171841.GP3520@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=eT+I16Ay445KOuS/laSHW6TZ6T7doSPRvZEFRc7TShA=;
        b=KRmwW2wJF5WEen4O7NmeiE411NqH/S8UiAf/ItHP8wfDOXE5MnzQcme5l06NRLzpRi
         5arDqmmPsFf4R+Q4lPtyXMtL5pOdFLIuM+4NWxdkOOBSwuzgcir5NnMVrIshMqs/Giny
         CoQGocUHCinQO8721MGJfMtJIAl7GK/YCDxZUMcPJm+9oJDCIHQtPnwC1EaeKTHTwUDZ
         2CL8wk9EF77bP+fysbNVM15kJNUhXGbtI+wl1Tj1RurkIa/5xRBjX2WUNJCIoYZwB33w
         XWxOyFvzcnhhQfcF2Cr2rSVZWD/DZb1r6iAtTprUq+uR6/tvbOiRghyUnmtt4NobvmoC
         NQZg==
Content-Disposition: inline
In-Reply-To: <20160119171841.GP3520-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux-s390 <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KVM list <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Jan 19, 2016 at 12:18:41PM -0500, Tejun Heo wrote:
> If "cpuset.memory_migrate" is set, when a process is moved from one
> cpuset to another with a different memory node mask, pages in used by
> the process are migrated to the new set of nodes.  This was performed
> synchronously in the ->attach() callback, which is synchronized
> against process management.  Recently, the synchronization was changed
> from per-process rwsem to global percpu rwsem for simplicity and
> optimization.
> 
> Combined with the synchronous mm migration, this led to deadlocks
> because mm migration could schedule a work item which may in turn try
> to create a new worker blocking on the process management lock held
> from cgroup process migration path.
> 
> This heavy an operation shouldn't be performed synchronously from that
> deep inside cgroup migration in the first place.  This patch punts the
> actual migration to an ordered workqueue and updates cgroup process
> migration and cpuset config update paths to flush the workqueue after
> all locks are released.  This way, the operations still seem
> synchronous to userland without entangling mm migration with process
> management synchronization.  CPU hotplug can also invoke mm migration
> but there's no reason for it to wait for mm migrations and thus
> doesn't synchronize against their completions.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reported-and-tested-by: Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # v4.4+

Applied to cgroup/for-4.5-fixes.

Thanks.

-- 
tejun
