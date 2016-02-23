From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/6] cgroup: use ->subtree_control when testing no
 internal process rule
Date: Tue, 23 Feb 2016 09:59:51 -0500
Message-ID: <20160223145951.GU3965@htj.duckdns.org>
References: <1452205790-21331-1-git-send-email-tj@kernel.org>
 <1452205790-21331-5-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=R37xNWQLoiqsocPcyTWobr6m0xNqRZvWbwQHpsW2bpk=;
        b=QUXZG/bDaeMxyaw/BkhqYObTFnXjY4cVOqzifRGtpUiRghn/7jr722/8PkokVVudBo
         ZLQEhosOafd2cN0l0HtFAC1Zl0mLYax9irGD3fjvOTXZ5/7hkPRFjCSyjloddLCf/WGu
         rY6+OOTzMSUX87bvrHTRx4jFXuIlcSI4CoU3hZxEARWvcNMM6UmperDYEbWBrhm6fggW
         bBCDVm4mEhmUI9r26d7yGZ2CfE3i752cU6mM0v0nYD4wuKWhAhrsyp5S34+1fsfcm8R2
         H/gG1NwFD8hLe5psoxs64QOE+l2OeG1VaJ4+VI+fHaEcoCkv0B2OgerzutcSZyeZzTam
         PmGw==
Content-Disposition: inline
In-Reply-To: <1452205790-21331-5-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, Jan 07, 2016 at 05:29:48PM -0500, Tejun Heo wrote:
> No internal process rule is enforced by cgroup_migrate_prepare_dst()
> during process migration.  It tests whether the target cgroup's
> ->child_subsys_mask is zero which is different from "subtree_control"
> write path which tests ->subtree_control.  This hasn't mattered
> because up until now, both ->child_subsys_mask and ->subtree_control
> are zero or non-zero at the same time.  However, with the planned
> addition of implicit controllers, this will no longer be true.
> 
> This patch prepares for the change by making
> cgorup_migrate_prepare_dst() test ->subtree_control instead.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Applying 1-4 to cgroup/for-4.6.  Will post refreshed version of
perf_event update soon.

Thanks.

-- 
tejun
