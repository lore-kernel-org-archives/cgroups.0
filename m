From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Is not locking task_lock in cgroup_fork() safe?
Date: Mon, 8 Oct 2012 11:00:00 +0900
Message-ID: <20121008020000.GB2575@localhost>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=mxh+R3MQJ6tllBjc0TqT0LWkc77rfYHIPDjqSQ9lgA0=;
        b=qERgUCro7GRfmeIH0P2lIdHuvCecQIR5WxRG5aVuIUCdmabnMMHJ8K2h7xoEdQnOEv
         qOiHCfoJ1PGkPwtX4eF+ezSR7BG9IJCeAfcd8HFiRTq+6INc/IzQunm2Osx31ZRT5ICd
         zhMLi/LFaGguMYMVQfifTg9aQHwsakNilrQ28S3iKX/IOQlPjPyaFAKeIPhy/7TJjHPH
         kTx+W2iQUgx4Jm4Ey/7L1KgRXccOjP9NYiJ0yf07SV7Wh1t2sUxQOPcZuga9CI2l05ND
         rGTBNeiy+PunSMSU8rAcTTLi/fN84aTjWKnzD10Z46ReYvzWGLPBNraux9i9IPSLUsGv
         jOkg==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Frederic.

7e381b0eb1 ("cgroup: Drop task_lock(parent) on cgroup_fork()") removed
task_lock from cgroup_fork citing that current->cgroups can't change
due to threadgroup_change locking; however, threadgroup_change locking
is used only during CLONE_THREAD forking.  If @current is forking a
new process, there's nothing preventing someone else to migrate the
parent while forking is in progress and delete the css_set it
currently is using.  Am I confused somewhere?

Thanks.

-- 
tejun
