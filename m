From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET v2 cgroup/for-3.16] cgroup: post unified hierarchy
 fixes and updates
Date: Tue, 13 May 2014 12:12:39 -0400
Message-ID: <20140513161227.GI23710@htj.dyndns.org>
References: <1399663975-315-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=mRRbhwRb9zShZMogtHIDMiHQbA98CT/nbKtWXMW2q0o=;
        b=b0BfBzMgcMCPntZeKipSuRFa8Xr9ju+3k6nTMO4uqm7NVFWwKkbIN1BRWCizzImF+o
         TE89Fomy1kJDQipoy8Bys4X5k72LAS2u56qsroH0w2eBL/WtbKil75kN/bwBpIuiociL
         87aPMYCXQUxG4kemHC39vBV+nZG7WUmllQWgWOvJYQirhqAcmQax4ntLl0Yv//kQSVQf
         ir/DCUkT31cR0/CsEggXiPdPS4Dcjtx5trbloVPufjWF0eXpib/QbQ71HFeiljRVj/ua
         n8qr0y+WWhFL1kSqbKxxaCzDAY1iUQh/yMR65J++6zYns/VIZkaoafpuofEuhCxx7lqV
         8IRg==
Content-Disposition: inline
In-Reply-To: <1399663975-315-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, May 09, 2014 at 03:32:48PM -0400, Tejun Heo wrote:
> Hello,
> 
> Changes from the last take[L] are,
> 
> * 0002, 0003 and 0007 added.
> 
> * Other patches are refreshed without content change.
> 
> This patchset contains the following seven patches.
> 
>  0001-cgroup-fix-offlining-child-waiting-in-cgroup_subtree.patch
>  0002-cgroup-cgroup_idr_lock-should-be-bh.patch
>  0003-cgroup-css_release-shouldn-t-clear-cgroup-subsys.patch
>  0004-cgroup-update-and-fix-parsing-of-cgroup.subtree_cont.patch
>  0005-cgroup-use-restart_syscall-for-retries-after-offline.patch
>  0006-cgroup-use-release_agent_path_lock-in-cgroup_release.patch
>  0007-cgroup-rename-css_tryget-to-css_tryget_online.patch

Applied to cgroup/for-3.16.

Thanks.

-- 
tejun
