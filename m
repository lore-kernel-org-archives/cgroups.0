From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] device_cgroup: lock assert fails in dev_exception_clean()
Date: Wed, 23 Jan 2013 11:38:50 -0500
Message-ID: <20130123163849.GH17632@redhat.com>
References: <1358460018-14717-1-git-send-email-jerry.snitselaar@oracle.com>
 <1358460018-14717-2-git-send-email-jerry.snitselaar@oracle.com>
 <20130117220642.GE16568@mtj.dyndns.org>
 <20130117231341.GA14588@cantor.us.oracle.com>
 <20130123043140.GA5913@cantor.us.oracle.com>
 <20130123142939.GC17632@redhat.com>
 <20130123163640.GB2373@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130123163640.GB2373-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Tejun,
On Wed, Jan 23, 2013 at 08:36:40AM -0800, Tejun Heo wrote:
> On Wed, Jan 23, 2013 at 09:29:39AM -0500, Aristeu Rozanski wrote:
> > Hi Jerry,
> > On Tue, Jan 22, 2013 at 09:31:41PM -0700, Jerry Snitselaar wrote:
> > > The original patch I sent to James and lkml got pulled in to linus. Is
> > > the correct thing to do here put the list cleanup code back in
> > > devcgroup_css_free and drop the call to dev_exception_clean along with
> > > change my patch made like this?
> > 
> > I think this is what was suggested (not tested):
> 
> Yeap.

on a slightly subject, hierarchy support is still desired for device
cgroups? I got the patchset ready by the time ebiederman submitted
userns patches and like it was discussed before device_cgroup would be
made obsolete once userns was out.

-- 
Aristeu
