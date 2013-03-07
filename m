From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: lockdep trace from prepare_bprm_creds
Date: Thu, 7 Mar 2013 11:33:42 -0800
Message-ID: <20130307193342.GA3209@htj.dyndns.org>
References: <20130306223657.GA7392@redhat.com>
 <20130307172545.GA10353@redhat.com>
 <20130307180139.GD29601@htj.dyndns.org>
 <20130307182140.GF29601@htj.dyndns.org>
 <20130307183213.GA18022@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=mK7JHDirIDfatq/FcFJbR4MLG2MC8deuudq886FvfEk=;
        b=V9Ev3DnibJMhJEzDIHDGfut9FBofsA55NFCdtEoVCh/aKWKQIgfqjSW/dT2px8u0sK
         W8DXLmZ0DOZ4IfqQr4kbsR5lyx6vxZUaWVkw7kWKmlPcd3xqTOYmscZ/bRwEjbZ1IZRp
         dpXwPFQ7TLurhOgg59i1HsZfGYuDKSlZW1H+rnDwOYBhmYLuHKpEXi0VfzCuq69+C6m0
         vCvawUYZe1x07cedDyxyRPS0htKtDp/3VhYbNUvT1qXkgEjO69FNFcCJygWNSdPGAiJa
         20ODyxt0AZ6q/ZbGpG+VqO9aEq9uII2nuRbl+t9+SEmiwRGJmH2XwNSeWaPA8kT57Yu7
         E8SA==
Content-Disposition: inline
In-Reply-To: <20130307183213.GA18022-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Mar 07, 2013 at 07:32:14PM +0100, Oleg Nesterov wrote:
> On 03/07, Tejun Heo wrote:
> >
> > On Thu, Mar 07, 2013 at 10:01:39AM -0800, Tejun Heo wrote:
> > >
> > > Another possibility is moving cgroup_lock outside threadgroup_lock(),
> > > which was impossible before because of cgroup_lock abuses in specific
> > > controller implementations but most of that have been updated and we
> > > should now be pretty close to being able to make cgroup_lock outer to
> > > most other locks.  Appending a completely untested patch below.
> >
> > This probably doesn't help as the dependency involves i_mutex.
> 
> Confused... why?

Maybe I'm confused.  We still have i_mutex -> cgroup_lock from the
mount path.  The original deadlock was cred_mutex -> i_mutex
vs. i_mutex -> cgroup_mutex -> cred_mutex.  The patch changes the
latter to i_mutex -> cgroup_mutex and cred_mutex -> cgroup_mutex.
Gosh, it's confusing, yeah, we might be okay.

-- 
tejun
