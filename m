From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 18/18] ioasid: Add /dev/ioasid for userspace
Date: Fri, 12 Mar 2021 10:54:39 -0400
Message-ID: <20210312145439.GD2356281@nvidia.com>
References: <1614463286-97618-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1614463286-97618-19-git-send-email-jacob.jun.pan@linux.intel.com>
 <20210310192301.GC2356281@nvidia.com>
 <20210311145534.6fe9bb9a@jacob-builder>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QrKz109+QtTaiqMToTFOgc22uC4OAicGA0DKsvjRXMY=;
 b=MI8se11LehMz4nD8CW+Fe1EtXtt4c2b4iNfnNwP0vEKXlEtBv5JuMqiLBd+S5nq1fx4CKudRZzUBzu1F5v2syyushNA7k6rQd+4QDqZIHJd4wAi9u3vbVJMRq4hsNPoagXSMUs32rpns/1o1b3Kow++aJMRMxrQQQS34S84atRstbgPpA58S1vv3QCqujaZ0Uo8vUi++CTf+yIiJie4wCu8X05adN5vDnfz0N7HvFYWD+AtXzZDjCZAnBWJVCurO0QeG13mYO6o/1R9okVqHzOwS0+txC5JoNCZ1igDxsN9uTrFkV8Tk7DCp2rLCWq5Zzcw/95WhAK6gotNX+wbEaw==
Content-Disposition: inline
In-Reply-To: <20210311145534.6fe9bb9a@jacob-builder>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Raj Ashok <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yi Liu <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Thu, Mar 11, 2021 at 02:55:34PM -0800, Jacob Pan wrote:
> Hi Jason,
> 
> Thanks for the review.
> 
> On Wed, 10 Mar 2021 15:23:01 -0400, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > On Sat, Feb 27, 2021 at 02:01:26PM -0800, Jacob Pan wrote:
> > 
> > > +/* -------- IOCTLs for IOASID file descriptor (/dev/ioasid) -------- */
> > > +
> > > +/**
> > > + * IOASID_GET_API_VERSION - _IO(IOASID_TYPE, IOASID_BASE + 0)
> > > + *
> > > + * Report the version of the IOASID API.  This allows us to bump the
> > > entire
> > > + * API version should we later need to add or change features in
> > > incompatible
> > > + * ways.
> > > + * Return: IOASID_API_VERSION
> > > + * Availability: Always
> > > + */
> > > +#define IOASID_GET_API_VERSION		_IO(IOASID_TYPE,
> > > IOASID_BASE + 0)  
> > 
> > I think this is generally a bad idea, if you change the API later then
> > also change the ioctl numbers and everything should work out
> > 
> > eg use the 4th argument to IOC to specify something about the ABI
> > 
> Let me try to understand the idea, do you mean something like this?
> #define IOASID_GET_INFO _IOC(_IOC_NONE, IOASID_TYPE, IOASID_BASE + 1,
> sizeof(struct ioasid_info))
> 
> If we later change the size of struct ioasid_info, IOASID_GET_INFO would be
> a different ioctl number. Then we will break the existing user space that
> uses the old number. So I am guessing you meant we need to have a different
> name also. i.e.

Something like that is more appropriate. Generally we should not be
planning to 'remove' IOCTLs. The kernel must always have backwards
compat, so any new format you introduce down the road has to have new
IOCTL number so the old format can continue to be supported.

Negotiation of support can usually by done by probing for ENOIOCTLCMD
or similar on the new ioctls, not an API version

Jason
