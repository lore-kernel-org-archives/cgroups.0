From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 05/11] cpuset: inherite ancestor's masks if
 real_{cpus,mems}_allowed become empty
Date: Wed, 21 Aug 2013 09:44:02 -0400
Message-ID: <20130821134402.GE19286@mtj.dyndns.org>
References: <52148F52.0@huawei.com>
 <52148F90.7070809@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=LMdT4dSFNubUR3cq/kMadQU1ux9TxwzbF2T5LoxHhlI=;
        b=dix0pV38OvpA5SR1VSRwBn2Dc+ovvytlH8dtNbzDVaf+bZCHTsfwcFR3VOsDv8QhDk
         BwWAB1Bih7bXZx1XVi3PBBRCNMhMljLAXZTb0cQ2Djr9g74rs9vqiqD+mON8sjK+0efr
         NqGYxpo+HFNOhED3DYaETpJz2p9NHQLMU5NicSGy8boQPdQxR561m0F6iZMkgve/OX76
         aS5xyhxsc3WPNuEXsHES7F4ClzxHPWXgUNB2ZwwOvJ9aTm8KblSrQEchBp4v5lrAgpOD
         SNcmUL52k9KsVtwR0XNp2xv3JCdAhJ0zCWppQRXtELo5/8JkYqcXmvMacPnyD7j0ZFSV
         POVg==
Content-Disposition: inline
In-Reply-To: <52148F90.7070809-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>

Hello,

s/inherite/inherit/ in the subject.

On Wed, Aug 21, 2013 at 05:59:44PM +0800, Li Zefan wrote:
> We're going to have separate user-configured masks and effective ones.
> 
> At last configured masks can only be changed by writing cpuset.cpus
> and cpuset.mems, and they won't be restricted by parent cpuset. While
> effective masks reflect cpu/memory hotplug and hierachical restriction.
> 
> This is a preparation to make real_{cpus,mems}_allowed to be effective
> masks of the cpuset:
> 
> - change the effective masks at hotplug: done
> - change the effective masks at config change: done
> - take on ancestor's mask when the effective mask is empty: done

The above description doesn't really work well.  It looks like this
patch does all three changes.  Can you please update the patch
descriptions so that it's clear what each patch does?

>  		/*
> +		 * If it becomes empty, inherite the effective mask of the
                                        ^
					inherit

> +		 * parent, which is guarantted to have some CPUs.
>  		 */
> -		if (cpumask_equal(new_cpus, cp->real_cpus_allowed) &&
> -		    ((cp == cs) || !cpumask_empty(new_cpus))) {
> +		if (cpumask_empty(new_cpus))
> +			cpumask_copy(new_cpus, parent->real_cpus_allowed);
> +
> +		/* Skip the whole subtree if the cpumask is not changed. */
> +		if (cpumask_equal(new_cpus, cp->real_cpus_allowed)) {
>  			pos_css = css_rightmost_descendant(pos_css);
>  			continue;
>  		}

Ooh, I like how this looks now.  Makes a lot more sense than the logic
before.

Thanks.

-- 
tejun
