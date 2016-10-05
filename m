From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC][PATCH] cgroup: Add new capability to allow a process to
 migrate other tasks between cgroups
Date: Wed, 5 Oct 2016 11:27:11 -0400
Message-ID: <20161005152711.GB26977@htj.duckdns.org>
References: <1475626874-22949-1-git-send-email-john.stultz@linaro.org>
 <20161005003833.GA29239@mail.hallyn.com>
 <CALAqxLU7qqKBVKO-bq_zKCUJqqvprNi8z5RpOb=Cec-VP=P4Yw@mail.gmail.com>
 <20161005042529.GA30929@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fGahAjq7DpFo8qZdx8MNtqxgGgjlOsI8zcPRLXSdVEI=;
        b=bzSF9iPFiGY56BH3ccI4QLQnjMQBcOr841lQZAJcxKsCyqKJgWbaHkl9Qo4DaR+2vM
         L3OLhLzk62gqBZYaooj9fM/YVnkyh4iX++okc/c741jdzClPd73ltH/bkBJ9Gmm371C9
         mehqRf9uvE2a5mw7dBKy7n0yJE6IcpbdcG68z98CrnkIjg9q5igw7sB+KnoEnRcfptuR
         yXln+h9KvoWqRQmJDlqqZleMHqzUR8ZBgHnYP93UsPCaEKM13d/JEEYMjNtmq0Zqe6SY
         TheaGGvnNVi84ruwWMDZqk+3C1J57kRmNU8GP2wdPUdDnXqj+e42fOWvZUmssN27cLHM
         ktqg==
Content-Disposition: inline
In-Reply-To: <20161005042529.GA30929-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Rom Lemarchand <romlem-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Todd Kjos <tkjos-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christian Poetzsch <christian.potzsch-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Hello,

On Tue, Oct 04, 2016 at 11:25:29PM -0500, Serge E. Hallyn wrote:
> > > If anything I'd say the GLOBAL_ROOT_UID check could be taken out since
> > > otherwise a host-root task effectively cannot drop this capability.
> > 
> > Is this ok to leave for a separate patch?
> 
> Yeah.  And I'm not sure whether Tejun would object to that idea.

With the capability, I think it'd be better to get rid of the explicit
UID check, but can we please rename the cap to CAP_CGROUP_MIGRATE and
loop in linux-api mailing list and ppl who are more familiar with
CAPs?

Thanks!

-- 
tejun
