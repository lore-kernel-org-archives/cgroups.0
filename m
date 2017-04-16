From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroup: avoid attaching a cgroup root to two different
 superblocks
Date: Mon, 17 Apr 2017 00:24:41 +0900
Message-ID: <20170416152441.GA27278@wtj.duckdns.org>
References: <58E7532B.4030505@huawei.com>
 <20170414232737.GC20350@outlook.office365.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qsYP7pW1xad5ezMHYYsCrKKlEo+hERiL5RizK7kPP0M=;
        b=ru5ZHEGBMr3tHNxK3q84wy+Ci6Kqw0nHt4GuZ8ouxKhOlCX+cfU8I9S/f2uuMDiQ5m
         jIGazIQ2ZbihL7b1lk2FapR2EwG4deBR8CyxIYGfM6hEK5P4nkl3uTynC9GbUzZtdXfs
         Z3gCRAD/2p4RWJADBaFFJS8sasXRs0/MFKZeG8vrxE71l3kA3sfcITdHULQUr4C0aRYf
         EAyd64G3MDhx18beoFRLrjZEc+27bRyKwAYCS+ZJGDZ0TVsD7xP3T6Cier9pi87Zg9yA
         olbvLtoVK8sAPGDRsAiuB/jgeAcmVX/mH3kNLsX/p9od1boetG/dz0OTBGk/IWNrS3hM
         R5WA==
Content-Disposition: inline
In-Reply-To: <20170414232737.GC20350-1ViLX0X+lBJGNQ1M2rI3KwRV3xvJKrda@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Apr 14, 2017 at 04:27:38PM -0700, Andrei Vagin wrote:
> Hello,
> 
> One of our CRIU tests hangs with this patch.
> 
> Steps to reproduce:
> curl -o cgroupns.c https://gist.githubusercontent.com/avagin/f87c8a8bd2a0de9afcc74976327786bc/raw/5843701ef3679f50dd2427cf57a80871082eb28c/gistfile1.txt
> gcc cgroupns.c -o cgroupns
> ./cgroupns
> ./cgroupns

Reverted the patch for now.  Let's try again later.

Thanks.

-- 
tejun
