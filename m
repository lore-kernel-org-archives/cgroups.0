From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: oomd with 6.0-rc1 has ridiculously high memory pressure stats wit
Date: Tue, 23 Aug 2022 08:27:38 -1000
Message-ID: <YwUcGvE/rhHEZ+KO@slm.duckdns.org>
References: <d0df567c-1f6a-418d-8db7-3f777bd109c8@www.fastmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=+WvRv1MoYZ7sQiK7t+GyZ70lGFaAzp9tw2tlccfkvmk=;
        b=pCNYuN0qV52Vx7RAFA8Tjg3Hz2xw7hy2GFRZk03BroITwWpspQ7kVFl8GnZiNZYwj0
         6C+RyprsHjGX+lB/VB448WO6TPXxcTCz8IQpmcewZ+5X7hrEH/mw/4vqw4BWqkDc6FwA
         OnedAe+4BAqfBX66VcLX4VQ3mk0DDHXK62gsv2WXu76Rh1Vxd5BUkHkWob8uVYX3ss+s
         2KrYSA6S9db5oVTTEotHhuRx3PgK4/XNXr5Jg90SB8QO5BDvINKA1Y6A+8/993IWlez2
         qeWGAT7VZiCib09D/F47cQay89J7W8T/fmqFCYwj6jSnRGLYHKswyNcMxRfYb/lHcFJu
         Pqlw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <d0df567c-1f6a-418d-8db7-3f777bd109c8-jFIJ+Wc5/Vo7lZ9V/NTDHw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Murphy <lists-zXQU9YWDTqjmlV4oE/1sFAC/G2K4zDHf@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

(cc'ing Johannes for visibility)

On Fri, Aug 19, 2022 at 10:51:27PM -0400, Chris Murphy wrote:
> Hi,
> 
> Tracking a downstream bug in Fedora Rawhide testing, where 6.0-rc1 has landed, and we're seeing various GNOME components getting kllled off by systemd-oomd, with the stats showing suspiciously high values:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=2119518
> 
> e.g.
> 
> Killed /user.slice/user-1000.slice/user-HmGangybm7RTDjBF/Jpztg@public.gmane.org/session.slice/org.gnome.Shell-r28gBBs99rhXz5zEmyOJwQ@public.gmane.org due to memory pressure for /user.slice/user-1000.slice/user-HmGangybm7RTDjBF/Jpztg@public.gmane.org being 27925460729.27% > 50.00% for > 20s with reclaim activity
> 
> I'm not seeing evidence of high memory pressure in /proc/pressure though, whereas oomd is reporting really high memory pressure and absolute time for it that makes no sense at all:
> 
> >>Sep 09 03:01:05 fedora systemd-oomd[604]:                 Pressure: Avg10: 1255260529528.42 Avg60: 325612.68 Avg300: 757127258245.62 Total: 2month 4w 2d 8h 15min 12s
> 
> It's been up for about 2 minutes at this point, not 3 months.
> 
> Thanks,
> 
> 
> --
> Chris Murphy Murphy

-- 
tejun
