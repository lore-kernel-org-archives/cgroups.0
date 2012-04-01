From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: make css->refcnt clearing on cgroup
 removal optional
Date: Sun, 1 Apr 2012 11:54:30 -0700
Message-ID: <20120401185430.GA9230@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120330223423.GJ28934@google.com>
 <20120330223606.GK28934@google.com>
 <4F77B6BA.4070207@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=HOm/dKBXRbak/+F0MUeyXFypc/eVHCRHT/nDCCxAQxQ=;
        b=y31Sow0Ydlig+ATCUmYppS8mrUHq5MDeUz2QSfVOOFOVq9nSRZBxFvatRjeASDfQ+G
         MPkwblTVIexb+6SAVVPpAprSawtVzoevrm+kceuo7ISj+yKAVRYRj1nr0g1DWw1plu36
         DN6S2AIXfc3pSA2mQDg9I35/F+j3Eu0yFGVFVfQXr2gJWymeeIShZE/shLTgyBSWpRFB
         DoPHBe1003GFdggO9264YBMraRUnuAIdXr01OUTynXk88gRDNu1RmKalux9BdpzcB+np
         u3+o4dU5/Jp+5QfEofA2gcYw6kCOLfX69Fwp0MGCpN+jRrSxIsPrOoVQRlx1WkSq1suJ
         STbw==
Content-Disposition: inline
In-Reply-To: <4F77B6BA.4070207-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

Hello, Li.

On Sun, Apr 01, 2012 at 10:00:26AM +0800, Li Zefan wrote:
> > Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> 
> Both patches look good.
> 
> Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Alright, adding the patches to cgroup/for-3.5.

> and I'd like to see code shrink with memcg updates ASAP.

Amen. :)

-- 
tejun
