From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 1/3] sched: fix confusing PFA_NO_NEW_PRIVS constant
Date: Wed, 24 Sep 2014 09:35:13 -0400
Message-ID: <20140924133513.GD16555@htj.dyndns.org>
References: <542124D3.9000007@huawei.com>
 <20140924132218.GC16555@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=jaVKcV0ufvAgfggF0/GktbZ4tyMyOZHFcZs2U2ORGbw=;
        b=U3kzYO7QtF9BWtclwaShDZDDmPgwsuV8ScP/X6Tpx3ce0qJAVxr9wYl8OljbNg54U9
         i/4wg1lTXwUd67oPeBq/Zav6fkHcfnpBNYWLEXFjbCDHePlNzKfshQChJa1vAanIyiW9
         ht3Gv6EKIfAGQ+V+TguOAvt0FuUX/uxvVMX9vzbkhpIViqJWW+wghe4cvY17wZasn+dr
         oCDT875F6FhncL7wnUxe+JVYHSa1BtQcUIKuWS6M7je2K/tDcq/HufOg/Wc+EGRR3RtM
         xGrN2g66fScarBRbmzBKPNMtALWp0jwzytZGlLs/V+5uEgw+mse9UAyGBCEC4Uqr8qll
         GVoA==
Content-Disposition: inline
In-Reply-To: <20140924132218.GC16555-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Miao Xie <miaox-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed, Sep 24, 2014 at 09:22:18AM -0400, Tejun Heo wrote:
> On Tue, Sep 23, 2014 at 03:44:19PM +0800, Zefan Li wrote:
> > From: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
> > 
> > Commit 1d4457f99928 ("sched: move no_new_privs into new atomic flags")
> > defined PFA_NO_NEW_PRIVS as hexadecimal value, but it is confusing
> > because it is used as bit number. Redefine it as decimal bit number.
> > 
> > Note this changes the bit position of PFA_NOW_NEW_PRIVS from 1 to 0.
> > 
> > Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> > Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Cc: Miao Xie <miaox-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
> > Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> > Signed-off-by: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
> > Acked-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> > [ lizf: slightly modified subject and changelog ]
> > Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> Applied 1-3 to cgroup/for-3.17-fixes w/ the typo spotted by davidr
> fixed.

Reverted due to build failure.  Will wait for a refreshed version. :(

Thanks.

-- 
tejun
