From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] cgroupns: Only allow creation of hierarchies in the
 initial cgroup namespace
Date: Fri, 15 Jul 2016 08:05:01 -0400
Message-ID: <20160715120501.GF3078@mtj.duckdns.org>
References: <87h9br4h80.fsf@x220.int.ebiederm.org>
 <87r3av32g1.fsf@x220.int.ebiederm.org>
 <20160715111659.GB3078@mtj.duckdns.org>
 <8760s72lu5.fsf@x220.int.ebiederm.org>
 <87h9br16b7.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3SKHsGdIRFBDFHhm41idio7iqtYlMC+/wxiLLKPQCIk=;
        b=S5WBoHxihdhmeW0Dkvn/rb272IU0dn3YiO5Pt6SkDyqYDFxj/s4i8cJ1rsrwZpDtAq
         ss7UVLkgFjaLfxAD6ynHWcoIpH3AA+aJBkYCrh0VungjtBabDoOoO8QaU2IQrcFXSQA3
         XuGo2HM0fwuFkqjBaGWN7h2DbyIk/88q0XBLl0/eyFCENOKbLBxxSz/vCu8S2f9xDoav
         K1N0ymty7u/7rC/RAC+8W1MaHjztHCKh+R+BH0yzLtogoo7bWXknjPW2xSmTguKNdTnJ
         w3dFmXiB83wq3susSC/UpmNN/Y1hnhsdmev6kh+10tZ3yFttkjyolnlHrDk9CHVOKqMl
         cdaw==
Content-Disposition: inline
In-Reply-To: <87h9br16b7.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jul 15, 2016 at 06:36:44AM -0500, Eric W. Biederman wrote:
> 
> Unprivileged users can't use hierarchies if they create them as they do not
> have privilieges to the root directory.
> 
> Which means the only thing a hiearchy created by an unprivileged user
> is good for is expanding the number of cgroup links in every css_set,
> which is a DOS attack.
> 
> We could allow hierarchies to be created in namespaces in the initial
> user namespace.  Unfortunately there is only a single namespace for
> the names of heirarchies, so that is likely to create more confusion
> than not.
> 
> So do the simple thing and restrict hiearchy creation to the initial
> cgroup namespace.
> 
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Fixes: a79a908fd2b0 ("cgroup: introduce cgroup namespaces")
> Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>

Applied to cgroup/for-4.7-fixes.

Thanks.

-- 
tejun
