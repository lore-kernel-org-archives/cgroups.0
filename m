From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Devel] Re: containers and cgroups mini-summit @ Linux Plumbers
Date: Thu, 26 Jul 2012 11:15:28 -0700
Message-ID: <20120726181528.GA25660@google.com>
References: <4FFDF321.4030103@openvz.org>
 <500FD022.6000608@parallels.com>
 <877gtr6uo5.fsf@xmission.com>
 <50110AE6.2080701@parallels.com>
 <50110D53.2090407@parallels.com>
 <874nou6bx1.fsf@xmission.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=+MUZBgv+VdjBozbZscVh02UGb4UU8KsLgWfn+rzE2Ww=;
        b=G5ZZAfwNpMmcGCdVR5ZXpdm2Ued/7FuPAbiOkRLvfrQPvBbl0ULYljNzkDA2E98NO5
         P81j8sIDNDOpNkUgmYI9NJwJPo2j+olgr34p85eReVMTT+i8hOZsX0pRAPVb86MkpTUl
         HTaN38YB/wnPt7nv59CjoKKmiaEtHNisVpTsMmvgOS7rCR0KAdT3Zu9ZL3exDKqTPtla
         bsX9LvQONm611p5M30AJXjzWS0I71JyxBMVEpw/0Ld6+C3f5nXAhKgdPAFq+Mz90jBsH
         SoNTkgsrx+o9666aqKFeFPADnsM0nbE/BsOe8FZmWkOl1QxpLagGubnK7ct564cvBvKR
         f1Sg==
Content-Disposition: inline
In-Reply-To: <874nou6bx1.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Suleiman-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Souhlal <ssouhlal-HZy0K5TPuP5AfugRpC6u6w@public.gmane.org>, Dave Kleikamp <dave.kleikamp-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Dhaval Giani <dhaval.giani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Maxim-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Rohit Seth <rohitseth-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Patlasov <MPatlasov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

Hello, Eric.

On Thu, Jul 26, 2012 at 03:42:50AM -0700, Eric W. Biederman wrote:
> - Create a new mount namespace.
> - Create fresh mounts of all of the control groups like I would do at
>   boot, with no consideration to any other control group state.
> - Start forking processes.
> 
> The expected semantics would be something like chroot for control
> groups, where all of the control groups that are created by fresh mounts
> are relative to whatever state the process of being in a control group
> that the process that mounted them was in.

No, any attempt to build namespace support into cgroup core code will
be nacked with strong prejudice.  I still think it was a mistake to
add that to sysfs.  Thankfully, procfs is going the FUSE way and I
hope in time we could convert sysfs to a similar mechanism and
deprecate the in-kernel support.

So, no, no, no, no, no, no, no, no, no, no, no, no. :P

-- 
tejun
