From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFD] Merge task counter into memcg
Date: Tue, 17 Apr 2012 08:23:50 -0700
Message-ID: <20120417152350.GC32402@google.com>
References: <20120411185715.GA4317@somewhere.redhat.com>
 <4F86527C.2080507@samsung.com>
 <20120417010902.GA14646@somewhere.redhat.com>
 <4F8D1171.1090504@samsung.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Hp7gn8bBcq61+HZAXc2q2HV/bMcM+Q5OUYGl0nC2LUA=;
        b=0kg8Ev1PtynOqCBR3a/M5o8P+Al4Lb7VdTJPwxQ9VE27uqhM2Km91TJBuzvhIRywEA
         itKK833pfLZGeIt6bZUOh+1xyDVf555lkkG3W9KFWvvaKxthVeaYi6PCs3XAO6SvNSCF
         vWmU2OOUn5tvN3kBpKLkhtzT3cy46r78AOUXaOVZXAaaTyaAvtbckqBvgq4sPRgi/Wk9
         QDB2nfdLHcSnMcwbtBgDo0Rd3uZMWFStz5g6vAZzjYQ5+sdX7bFxIEAJCaCNcZJnTmrJ
         o1GwH8iw8/DivzhSntkssoXEhS5CpmriePvbUjFN4R8coF46VRdTVzbB+speYue8vzRd
         k0QA==
Content-Disposition: inline
In-Reply-To: <4F8D1171.1090504-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexander Nikiforov <a.nikiforov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Daniel Walsh <dwalsh-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>

Hello,

On Tue, Apr 17, 2012 at 10:45:05AM +0400, Alexander Nikiforov wrote:
> between them. Now we have only 1 way to get notification about tasks
> file - inotify(), but this approach works only if you work from
> userspace with file (e.g. create struct file, for example with echo
> $$ /sys/abc/tasks), but when something happens from kernel side
> (do_fork()/do_exit) we cannot get any event about group of the
> process (we can scan tasks file and count number of PID, or work
> with
> waitpid(), but IMHO this is ugly solutions)

Wouldn't simply generating FS_MODIFY event on the tasks file do the
trick?

Thanks.

-- 
tejun
