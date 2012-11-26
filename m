From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Why is cpuset_cpus_allowed_fallback() necessary?
Date: Mon, 26 Nov 2012 14:32:49 -0800
Message-ID: <20121126223249.GB15930@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=zVS4cKZLz9INXH46ey8L49LEm7SJnsJ5p9+c35zMkYE=;
        b=p2gD1LQTq5ZG8RYzLdonffcQ9v8w6sDtCHgJb37iC/C3ffeplzN4T/rOF9tVoUC5L6
         CinA0dDyS05wTNjHW+1QtB3qeNvqj2hThEprH3Kz3GK3/SVpUoFiiw1mhNVIRVoCztUg
         mFms2//qG2qhFpQ9IB0pJCf1PzoeOqJweLNUkppvlQo2d4Tlc+1qndDi5QsjrYH+fylC
         Een7PqvK3sXQmN8NeCW0VY+TvypBWL8aTHTFV/8n7ETalpwuLnRnXCkrHRZTqSK19ctZ
         /1A7Yp9iffgethFcACqjiIvxZAEVTsgi0MD74Ge6SKX1fwAcDsJX0vthOr6rO/RAM6fO
         bhrw==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, guys.

I'm wondering why cpuset_cpus_allowed_fallback() is necessary.  This
is called from, e.g., try_to_wake_up()->select_task_rq() when none of
the cpus in ->cpus_allowed is useable.  The cpuset callback invokes
do_set_cpus_allowed() w/ the cpuset's cpus_allowed.  This was added by
the following commit,

  commit 9084bb8246ea935b98320554229e2f371f7f52fa
  Author: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
  Date:   Mon Mar 15 10:10:27 2010 +0100


  sched: Make select_fallback_rq() cpuset friendly

  Introduce cpuset_cpus_allowed_fallback() helper to fix the cpuset problems
  with select_fallback_rq(). It can be called from any context and can't use
  any cpuset locks including task_lock(). It is called when the task doesn't
  have online cpus in ->cpus_allowed but ttwu/etc must be able to find a
  suitable cpu.
  ....			  

The problem is, nothing's explaining what "the cpuset problems with
select_fallback_rq()" are.  Oleg, do you remember?  Why do we need
this?

Thanks.

-- 
tejun
