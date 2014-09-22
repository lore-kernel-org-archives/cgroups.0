From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/3] sched: fix confusing PFA_NO_NEW_PRIVS constant
Date: Mon, 22 Sep 2014 00:45:38 -0400
Message-ID: <20140922044538.GH23583@htj.dyndns.org>
References: <541FA8F4.90703@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=f+lwM3z7ccIk/oR5d9dIC+1ocGz6mYajIAjq9teCKjY=;
        b=F1qJYIa2UK2VH3nl3Btb16BKBHK01MOA4MRv1G2kroyqpTq2bNdQC7QshN9uo7elSm
         +ipV1op1ijvxP1x4I7S456xCb73O6/sFR3LD7u+/5LVS1Dmqa2y7VUwKfjPoEz49Sr8A
         H5QIz/Si7c5COjAZgZUPoBH5S2T37CfMWVDjF/C1wludWgdGq+rzNi8nlinpBi8cUI2x
         JMlrjrZWp/mt3Av5gYBLpLKVQH94DR2n1SPOFvuGhokxr5SBRLfD7Ipi+WzUGViF4zyZ
         dHa8X4ezw6KEB66OyMB9HyNsXBEM64yOy3T9jxKHNY3ScpG0fNj00gWfdGuO/euq+Lj3
         Ajiw==
Content-Disposition: inline
In-Reply-To: <541FA8F4.90703-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org

On Mon, Sep 22, 2014 at 12:43:32PM +0800, Zefan Li wrote:
> Commit 1d4457f99928 ("sched: move no_new_privs into new atomic flags")
> defined PFA_NO_NEW_PRIVS as hexadecimal value, but it is confusing
> because it is used as bit number. Redefine it as decimal bit number.
> 
> Note this changes the bit position of PFA_NOW_NEW_PRIVS from 1 to 0.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
> Acked-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> [ lizf: slightly modified subject and changelog ]
> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

All the patches look good to me.  I can't say I'm a big fan of
function defining macros but I don't have prettier alternatives
either.  Once Peter/Ingo acks the patches, I'll route them through
cgroup/for-3.17-fixes.

Thanks.

-- 
tejun
