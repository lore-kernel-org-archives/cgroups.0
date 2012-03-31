From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] cgroup: cftype based file interface, take #2
Date: Sat, 31 Mar 2012 09:30:56 -0700
Message-ID: <20120331163056.GA2557@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1332368265-21586-1-git-send-email-tj@kernel.org>
 <4F75AA1F.9020007@huawei.com>
 <20120330154246.GE28934@google.com>
 <4F76FF04.40007@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=5/aW/UTzlZxQvxa0yToC8vIlnTSHgtaT1nmwTUxodUY=;
        b=xJTRnOi+PMFppwXao0lNXoitp33dY7aPSVHf9Ys/0KecAr8OycizachHO3VigPrTzt
         K7vMq/4APin9hXsp8oHPwUVHjibrcf2W16RwqvoVtX7k5hixah9Uf51vjaaQwh5MtJSw
         901fH9KMRNOJfG2o4q7GzYZ822Z5E8L3TxXxb3CnuMmShYu00YvMbxVfB3h1+w6pXW42
         RqESaiTh5u2PUE7alHrxh2+fB/VayLYtKdmof4bN6Yl4d9tMfqWFEc4HkhXfXCfGYnfX
         QF3gYPlKXMY/1I6CLHEOTfisWk4KogdJ3l6AEERAQrOPYPzo28w2fEUnOiWGK3CedVUB
         +scg==
Content-Disposition: inline
In-Reply-To: <4F76FF04.40007-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

Hello,

On Sat, Mar 31, 2012 at 08:56:36PM +0800, Li Zefan wrote:
> > Subsys can't be changed if any non-root cgroup exists.
> 
> Ah, this is a long-standing defect, which is documented in Doc/../cgroups.txt.
> It's not trivial to fix it, and I never heard someone request it to be fixed.

Yeah, it was a bit of head scratcher.  If it can be done only when
there's no cgroup configured, one might as well unmount and mount w/
new subsys instead of remounting.  There's the minute difference that
existing root cgroup state is preserved but that hardly justifies the
crippled feature.  IMHO, lack of fix request indicates the feature not
being used rather than anything else, so the deprecation proposal.

Thanks.

-- 
tejun
