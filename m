From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: implement cgroup_subsys->implicit_on_dfl
Date: Tue, 8 Mar 2016 10:59:13 -0500
Message-ID: <20160308155913.GA3447@mtj.duckdns.org>
References: <1456351975-1899-1-git-send-email-tj@kernel.org>
 <1456351975-1899-2-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Q2HJXdULmpiOJS8BAYkq56hTkmG9oLdlmVGHTWzyOZQ=;
        b=Jqj/I/98kr4hcJY/1mzl37Nd+pE+GA5h48GYr+xPmBMQCkrnm5kukerEQZfJTldkPu
         sak8qTxw5aTlmNPZq7UeV3CYIX95tPcQXS6QEHJpCZjr+xL0Es8IPofuebQIlgderSLf
         QUT/8X768wnrZ1bgTdq62ynCYRRq9BuhHAak7ZfUoKBjmvvxCWyhSg408LVQP/gMtWat
         DIo0GYaOmBP2JSSQANS41CJ/WGEH+7soJF8DsQFRcfuAKZUZEO5bXDkcZiCs8sTQCfKG
         981bKSGM1Y3YMRJ3qZBJY8WM+HUa4SXH6JmYJUo1r5//BWpt0ewIDCY+pUZROc62R+5X
         6LZg==
Content-Disposition: inline
In-Reply-To: <1456351975-1899-2-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, Feb 24, 2016 at 05:12:54PM -0500, Tejun Heo wrote:
> Some controllers, perf_event for now and possibly freezer in the
> future, don't really make sense to control explicitly through
> "cgroup.subtree_control".  For example, the primary role of perf_event
> is identifying the cgroups of tasks; however, because the controller
> also keeps a small amount of state per cgroup, it can't be replaced
> with simple cgroup membership tests.
> 
> This patch implements cgroup_subsys->implicit_on_dfl flag.  When set,
> the controller is implicitly enabled on all cgroups on the v2
> hierarchy so that utility type controllers such as perf_event can be
> enabled and function transparently.
> 
> An implicit controller doesn't show up in "cgroup.controllers" or
> "cgroup.subtree_control", is exempt from no internal process rule and
> can be stolen from the default hierarchy even if there are non-root
> csses.
> 
> v2: Reimplemented on top of the recent updates to css handling and
>     subsystem rebinding.  Rebinding implicit subsystems is now a
>     simple matter of exempting it from the busy subsystem check.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Applying this one to cgroup/for-4.6.  Waiting for the review of
userland part on the second patch.

Thanks.

-- 
tejun
