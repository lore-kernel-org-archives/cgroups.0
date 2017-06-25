From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [1/3] cgroup: "cgroup.subtree_control" should be writeable by
 delegatee
Date: Sun, 25 Jun 2017 00:31:55 -0400
Message-ID: <20170625043155.GC9644@htj.duckdns.org>
References: <20170625042717.GA14158@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vzSmHEWVCLsi6CWIccXofyUGaXr0R/IERdqERGEwO4s=;
        b=vTqJho2qIu247A3si+eYSmWBtdepBe0G5oDNjOYWkigeJlKLGMAbtvUH2NgRw8Lx2g
         dFYqV4/k+PofkxvaRfMLyN0h/SIEn07h1/dfUVsg7eoOrUWHzum84lMB4SwpopVuS9Jl
         w4LPCiVxxBo4zVgIeZQwygd0oL7zHcSS3M0f9hFSLahTuZ331ERHUCOHeIsTPmRMDCyi
         UOkz77VNFJo+R9Z4B0Qv2ato2CbILTNH3UGR0lWRdKS6lefWrqKp59XbGauoYgfzJ+Su
         b8Ng122gqhlJ+pkkR887NBOQSJOBOE7tTda7jYf9iLg+CRnqnGS6AwNeXsXtXWzmdpAU
         ELiw==
Content-Disposition: inline
In-Reply-To: <20170625042717.GA14158-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aravind Anbudurai <aru7-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Sun, Jun 25, 2017 at 12:27:17AM -0400, Tejun Heo wrote:
> "cgroup.subtree_control" determines which resource types a cgroup
> wants to control.  Unlike actual resource knobs, this is an attribute
> which belongs to the cgroup itself instead of its parent and thus
> should be writeable by the delegatee in a delegated cgroup.
> 
> Update delegation documentation accordingly.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Applying to cgroup/for-4.13.  I've been thinking that the doc listed
both files all along.  Oh well, better late than never.

Thanks.

-- 
tejun
