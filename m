From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH REPOST 2/2] cgroup, perf_event: make perf_event
 controller work on cgroup2 hierarchy
Date: Thu, 2 Feb 2017 13:47:32 -0500
Message-ID: <20170202184732.GA7917@htj.duckdns.org>
References: <1456351975-1899-1-git-send-email-tj@kernel.org>
 <1456351975-1899-3-git-send-email-tj@kernel.org>
 <20170129193520.GA18336@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WxMLIxH2ylRQFeh4M4N+AsJydc7YVEhMFPZTeQzDrlc=;
        b=a5Kz6syujUO1Pa7rscgQ6m/finlJpkKa1EBBgt2cS0KkZJ+/A0TF4dOvYUwWo9Skkp
         9bzkzxO924pmV2vEe2xCxtONd9UNsOtsTBWLtUarmcGuq/AD/KN7T1LlZefy+al95Zjh
         txBHpnfIlNoQUt3KYLYKT21GtKjvduBN1Eh5IDk2dhCduICzRzTVajV+MZsWg0DZWuZf
         s5WRYny4ACKhapYW3/B45LV6631LRrnrfyKnIf9+0o4WCgfvxiifu9W7Buz8n0dJMRG3
         wR0wnd3J98r/lxn0avplN/6SVoI4travWYXPeSkBJZyso0+mhECXnpAdpaW1AopIE2Iu
         2MxA==
Content-Disposition: inline
In-Reply-To: <20170129193520.GA18336-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Sun, Jan 29, 2017 at 02:35:20PM -0500, Tejun Heo wrote:
> perf_event is a utility controller whose primary role is identifying
> cgroup membership to filter perf events; however, because it also
> tracks some per-css state, it can't be replaced by pure cgroup
> membership test.  Mark the controller as implicitly enabled on the
> default hierarchy so that perf events can always be filtered based on
> cgroup v2 path as long as the controller is not mounted on a legacy
> hierarchy.
> 
> "perf record" is updated accordingly so that it searches for both v1
> and v2 hierarchies.  A v1 hierarchy is used if perf_event is mounted
> on it; otherwise, it uses the v2 hierarchy.
> 
> v2: Doc updated to reflect more flexible rebinding behavior.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Acked-by: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
> Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Applied to cgroup/for-4.11.

Thanks.

-- 
tejun
