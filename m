From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/4] device_cgroup: keep track of local group settings
Date: Thu, 24 Jan 2013 14:05:53 -0800
Message-ID: <20130124220553.GW2373@mtj.dyndns.org>
References: <20130124194957.198022148@napanee.usersys.redhat.com>
 <20130124194957.519573358@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=BKOOLbpQuIbuc6xh6pe91WwlF9ekSYRE4/KC3abMhOA=;
        b=ScgFei9EEABzuvoljxtze5MgB7dqV+gM2jl4bA8bjJrgtbyro/hRTz2OsYxHqCOnJU
         rz5DjzbIFI2gC1gLBp/fyJi612NgaZlD9gFBjkL5jeYcxi3TEBG2ipsxISvAAAb9rWbb
         Luz2JPjp0qS9li00lJfpt7SwCV9PIQtKqc5SuDYxaV8IRosXmRZbuyWsFJizgzw0KWyn
         CDFgnRmoobPNWRRozyA0ANr7jpZqlDr2isi9KOZhflGUTc3oDKRwy7MxAEitnWSfswDO
         5XUDlUk4dBGVg5R4SxuTcTqBhVDFWKQx/ggeNWwP8+0+G0b5rbPgl7M4i+pB9lKZwiFx
         PKlg==
Content-Disposition: inline
In-Reply-To: <20130124194957.519573358-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On Thu, Jan 24, 2013 at 02:49:59PM -0500, aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> In preparation for better hierarchy support, it's needed to retain the local
> settings in order to try to reapply them after a propagated change if they're
> still valid.
> 
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Looks okay to me but it would be better if you separate out moving
dev_exception_rm() above dev_exception_add() into a separate patch.
It currently mixes functional and non-functional changes which isn't
very nice.

Thanks.

-- 
tejun
