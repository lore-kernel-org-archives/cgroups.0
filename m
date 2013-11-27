From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup-for-3.14] cgroup: restructure pidlist handling
Date: Wed, 27 Nov 2013 18:23:41 -0500
Message-ID: <20131127232341.GF13098@mtj.dyndns.org>
References: <1385331096-7918-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=KIK2V6G0cQa23Atu4F2ss8jrePMN6a5NbPdcqlbFzyc=;
        b=e5VUjtGIScSerXbg8CsYbPFMlaO/bZIRDqdmNP14i9/YE12CfHtePyqEqj5/+ie5vR
         7WAbAjE0ki4UlN3/SoL7FkCetSJHsPVcOq3sKmdih9oTeoXRT+Wqf7MHZHg+xH505iAN
         6aPqye+AjC1NNfuifBg/zDeyhL3RsTPlOI7pgaIzV+NNGKbvy3WeJUCpMSibAfzVHl+u
         jmLziCQ7j1sd/gu6eC3Ubv04BihwTOzezkVCqZP6SlFP2+fNGJRokUUh1AAVYWN8MxAQ
         yl4BLQHQTAK6vli3Ao8CD5xWGBVHpcTfPuV4i+vK3Ej/xWXcjEFGSQM/oqO15CIyC16+
         fnNw==
Content-Disposition: inline
In-Reply-To: <1385331096-7918-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, Nov 24, 2013 at 05:11:27PM -0500, Tejun Heo wrote:
> This patchset is on top of cgroup/for-3.14 edab95103d3a ("cgroup:
> Merge branch 'memcg_event' into for-3.14") and available in the
> following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-pidlist

Patchset rebased on cgroup/for-3.14 c729b11edf74 ("cgroup: Merge
branch 'for-3.13-fixes' into for-3.14 ").  git branch updated
accordingly.

Thanks.

-- 
tejun
