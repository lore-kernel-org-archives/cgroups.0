From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: iterate cgroup_subsys_states
 directly
Date: Tue, 13 May 2014 12:59:01 -0400
Message-ID: <20140513165901.GF1866@htj.dyndns.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ayk9XK57zknF+H0CmL3C0+4bustl4vjiMk4lccTTN5c=;
        b=YN27onOfTN2JeznXBio9M56INGJbs/12ZAhOB7JHWAs69thSZZIcVPaaNKvsfr463c
         1sja1BDMrlPgBEJCj/JbCWg3jjDHrtcq0VfhTPyWFHOTMM2Cj4s+xrhx2CXHAHWP4f9h
         L5RDUnS8SAeft6Ogkk/WdmoN6VZaG80QtnkgFOhpOJnrrRm98DeofL0b9A8jQBcoFndr
         4iudlUezN9odIhGCgDO9YXeYlf1uyuWSjo2PZrgIwRaJIrDP3JD7sRGzvnk1ojN44Dvs
         Uj4FMOyUzQdM8R5kW1gXKrGgUzxcLuilKxaPJUpMEF1uV5/OoTB6PS7UKsH028FKqRzr
         o+bQ==
Content-Disposition: inline
In-Reply-To: <1399671091-23867-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org

On Fri, May 09, 2014 at 05:31:17PM -0400, Tejun Heo wrote:
> and available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-direct-css-iteration

Refreshed on top of cgroup/for-3.16 with the updated patches.

Thanks.

-- 
tejun
