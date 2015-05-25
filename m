From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: add explicit cast and comment for return type
 conversion
Date: Mon, 25 May 2015 07:40:45 -0400
Message-ID: <20150525114045.GA526@htj.duckdns.org>
References: <1432472872-3578-1-git-send-email-hofrat@osadl.org>
 <20150524203528.GB7099@htj.duckdns.org>
 <20150525055742.GE1397@opentech.at>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=I2L+Sfiu/PH2qS1jcVVh3tAnYnVt623hi9pwtGK0w1k=;
        b=ZJ1sEUNaIRp4n0b1pu9R6pR/m9sYN0FpPkeeeFkf0DskvNSc1klLFMzUWi95VNS5VB
         /KdOSMJoDDcuftSGkOtLqqUcHMOdL6aATMvHVRrTTXZSmtvS4AqQaQmTkws9XgXLoE3F
         iI9sqa/xH6W+MpoTml3XQDG1ATPEiBOFQf+RmwU1et946xabMB0nUG/52GVbypcUEIu6
         BRw4EMifzongYFMuPAUtCDbOY+Jb7t1xo8+pNyNWECJUFq3fpO02QEvgs2y9LnoKyksg
         45dwrmZzj2u5IUsZvtr3ngQ4yV/BS9VQa3VLZF3+KjQeY01VHoSEUwEf6J6V4xT9E050
         FCXA==
Content-Disposition: inline
In-Reply-To: <20150525055742.GE1397-AxMHDufBahDk7+2FdBfRIA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nicholas Mc Guire <der.herr-kA1LtwSENNE@public.gmane.org>
Cc: Nicholas Mc Guire <hofrat-Q945KHDl0DbYtjvyW6yDsg@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Nicholas.

On Mon, May 25, 2015 at 07:57:42AM +0200, Nicholas Mc Guire wrote:
> nop not downward but signed/unsigned  if it were down it would not be
> a problem but signed/unsigned can be - for those cases where it can't
> be fixed up by changing the declarations or return variable types 
> explicit cast might make sense - as noted in the patch Im not sure either
> if this form of cleanups is helpful. 
> 
> In the kernel core there are about 400 signed/unsigned implicit 
> conversions (about 3k in the entire kernel) which is what Im trying to 
> remove or if that is not possible in a resonable way mark as false positive.

I still don't get it.  What does this buy us actually?  If we continue
to do this, people would just learn to add explicit cast when doing
sign conversions.  We just converge to a different behavior without
actually gaining any protection.  What's the benefit of doing this?

Thanks.

-- 
tejun
