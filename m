From: James Bottomley <jejb@linux.ibm.com>
Subject: Re: [dm-devel] [PATCH 0/9] Documentation: correct lots of spelling
 errors (series 2)
Date: Thu, 02 Feb 2023 13:54:33 -0500
Message-ID: <ac6270fe1dba1b3398dc2b830cf9bda5c89a7a3d.camel@linux.ibm.com>
References: <20230129231053.20863-1-rdunlap@infradead.org>
         <875yckvt1b.fsf@meer.lwn.net>
         <a2c560bb-3b5c-ca56-c5c2-93081999281d@infradead.org>
         <8540c721-6bb9-3542-d9bd-940b59d3a7a4@acm.org>
         <87o7qbvra9.fsf@meer.lwn.net>
Reply-To: jejb@linux.ibm.com
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=YS8OxqX6Xa4ReQhYwflKc5aSv/9TMKB2gRMMZTEJZEM=;
 b=CFDCGulP3P9Xe+2FAp6xgIgRdBQw74UWN3jgGISv3dFzGsARHrCHm0mKBX/ELGDgttez
 O2meJewgXXM7+teNdX1OhLZrAIM2aVkDVTHAidhbq037PYHO8U582Sv4uDmN9nO7C+H0
 Ct6DdO3veQD6OKh6pBbNXbO7fmZB2GLhEks2HUnbj9M40HZLiGUM/0/PZYRpNZFTZABc
 KUw69DyK4MX540GbhWsmE2ikKCZ2qfXEtoCa6lzKc4HwYnA/+A4P1qpvOVXru7Rg7Eu5
 s6n0B3YDRpfXh9P9tepOpIUV6KxgO+ZDzTxLDiaQq2Q5zExlYDSpXCevnb+PR2ZAq65+ Hg== 
In-Reply-To: <87o7qbvra9.fsf@meer.lwn.net>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Jonathan Corbet <corbet@lwn.net>, Bart Van Assche <bvanassche@acm.org>, Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, linux-doc@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com, netdev@vger.kernel.org, Zefan Li <lizefan.x@bytedance.com>, sparclinux@vger.kernel.org, Neeraj Upadhyay <quic_neeraju@quicinc.com>, Alasdair Kergon <agk@redhat.com>, Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Guenter Roeck <linux@roeck-us.net>, linux-media@vger.kernel.org, Jean Delvare <jdelvare@suse.com>, "Paul E. McKenney" <paulmck@kernel.org>, Frederic Weisbecker <frederic@kernel.org>, Mike Snitzer <snitzer@kernel.org>, Josh Triplett <josh@joshtriplett.org>, linux-raid@vger.kernel.org, Tejun Heo <tj@kernel.org>, Jiri

On Thu, 2023-02-02 at 11:46 -0700, Jonathan Corbet wrote:
> Bart Van Assche <bvanassche@acm.org> writes:
> 
> > On 2/2/23 10:33, Randy Dunlap wrote:
> > > On 2/2/23 10:09, Jonathan Corbet wrote:
> > > > Randy Dunlap <rdunlap@infradead.org> writes:
> > > > >   [PATCH 6/9] Documentation: scsi/ChangeLog*: correct
> > > > > spelling
> > > > >   [PATCH 7/9] Documentation: scsi: correct spelling
> > > > 
> > > > I've left these for the SCSI folks for now.  Do we *really*
> > > > want to be
> > > > fixing spelling in ChangeLog files from almost 20 years ago?
> > > 
> > > That's why I made it a separate patch -- so the SCSI folks can
> > > decide that...
> > 
> > How about removing the Documentation/scsi/ChangeLog.* files? I'm
> > not sure these changelogs are still useful since these duplicate
> > information that is already available in the output of git log
> > ${driver_directory}.
> 
> Actually, the information in those files mostly predates the git era,
> so you won't find it that way.  I *still* question their value,
> though...

In the pre-source control days they were the answer to the GPLv2
Section 2 requirement to " carry prominent notices stating that you
changed the files and the date of any change." 

If you remove the files you may run afoul of the GPLv2 Section 1
requirement to "keep intact all the notices that refer to this
License".  Of course, nowadays we assume the source control does this
for us, so people rarely think of these requirements, but for files
that predate source control I think you need to consider the licence
implications.

James


