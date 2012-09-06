From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 05/10] cgroup: Remove CGROUP_BUILTIN_SUBSYS_COUNT
Date: Thu, 6 Sep 2012 15:23:54 -0700
Message-ID: <20120906222354.GQ29092@google.com>
References: <1345816904-21745-1-git-send-email-wagi@monom.org>
 <1345816904-21745-6-git-send-email-wagi@monom.org>
 <20120824232840.GS21325@google.com>
 <5039046D.1040402@monom.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Wj1QD+QoT7J4hGvJFkzZ0Sa1Rdzwl7TWIxcXg84Mhok=;
        b=tOUtniwTkf5BkromT2CRPwGvV9ltN/nzDrw6FEnLUG0jJsRzTc9pgAffbuObCLKcJA
         WHsxnHFZsGhPNZWy8Zc8nEHzbItmsdq4fr/FHUlr6xC7K3gck67X7v5l8Uypi1sAyZyA
         d3Y9fl5HlzephaEtr5a2teZzDPa9Cogjk3/7js/VNcucUTJGSHhU37S8QSk0OT2nGgvQ
         9GVnxq96a6b0uFPh9JPvR81C4ovmlOo9kVPqK0vofiY5P1H+WwkukBBuHoHKIATkUoQC
         pTwv2J+timHSH7yHy49JVPmVQ3z+4XM5LZDDvvsE6nc06/JJPMG4ZplkiFh7MU8S42t1
         En9Q==
Content-Disposition: inline
In-Reply-To: <5039046D.1040402-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>

Hello, Daniel.

On Sat, Aug 25, 2012 at 06:59:25PM +0200, Daniel Wagner wrote:
> >Wouldn't it be better to explicitly state that a following patch would
> >reduce the SUBSYS_COUNT and stop putting builtin and module ones into
> >different sections?
> 
> Sure, can do that. I just to make sure I understand you correctly,
> What do you mean with different section? Do you refer to the enum sorting?

I meant that there's no reason to have all builtin ones contiguosly
and then the module ones using two cgroup_subsys.h inclusions.

Thanks!

-- 
tejun
