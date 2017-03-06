From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.10-fixes] cgroup/pids: remove spurious
 suspicious RCU usage warning
Date: Mon, 6 Mar 2017 15:12:00 -0500
Message-ID: <20170306201200.GI19696@htj.duckdns.org>
References: <1487585723.8499.5.camel@gmx.de>
 <20170301174452.GE3662@htj.duckdns.org>
 <1488391071.4812.2.camel@gmx.de>
 <20170301203907.GF3662@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=h3IwCvIcOLxM9ICKEpGcnI6w0nNg71KSIsufjb0M1B8=;
        b=jTzVTimYYhz1It/XKracg0b/fT0Iql1WxITwhRx3RnXhw1fiWn1PewUZzm9hvetcRj
         mqGYQ8GUrRQAFDCnK+FnkHjyW7vkZ4EoOGfI3f+LZW9364EK89nxJQ875kbnBaPDJajN
         lGAggnzURZ2il/kfjc/J64Osa1hCnlzeLCfSOKzwK72poRyHBgtCCvCcjaip0JMmATQe
         RZBmcAm9p4cHcWPQvcNF0MkhtrF2srcpp/eAAlybJuYdHdrM4n2BNx0Sbmj7bPmJE9dr
         WqeT7SqjmS89L4heBT33MRRehFQi3xFHE+QPffi0xyJnI58Mw7XgPRuVaHfa8ITu5CHC
         y2uQ==
Content-Disposition: inline
In-Reply-To: <20170301203907.GF3662-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Galbraith <efault-Mmb7MZpHnFY@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, Mar 01, 2017 at 03:39:07PM -0500, Tejun Heo wrote:
> pids_can_fork() is special in that the css association is guaranteed
> to be stable throughout the function and thus doesn't need RCU
> protection around task_css access.  When determining the css to charge
> the pid, task_css_check() is used to override the RCU sanity check.
> 
> While adding a warning message on fork rejection from pids limit,
> 135b8b37bd91 ("cgroup: Add pids controller event when fork fails
> because of pid limit") incorrectly added a task_css access which is
> neither RCU protected or explicitly annotated.  This triggers the
> following suspicious RCU usage warning when RCU debugging is enabled.

Applied to cgroup/for-4.11-fixes.

-- 
tejun
