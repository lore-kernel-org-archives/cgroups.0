From: Tejun Heo <tj@kernel.org>
Subject: Re: cgroups(7): documenting cgroups v2 delegation
Date: Wed, 10 Jan 2018 11:39:07 -0800
Message-ID: <20180110193907.GC3460072@devbig577.frc2.facebook.com>
References: <1ce0a885-94fb-7480-7180-7b873c95b1bb@gmail.com>
 <20180108141450.GP3668920@devbig577.frc2.facebook.com>
 <6c9fdaee-739f-164d-d04e-fb3a7319db90@gmail.com>
 <20180109210722.GS3668920@devbig577.frc2.facebook.com>
 <672cd179-31be-e03a-f9ff-ce59b76e23e2@gmail.com>
 <20180110142640.GB3668920@devbig577.frc2.facebook.com>
 <655118da-6d58-8f02-7367-77c10a3c16ea@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/PWS82rECmwqKmmfUWiGTzmLXCTb1Cv2IPSGbgrLQWE=;
        b=VZVxou9rumdRUyXtY7MrD6dfboqIGPMOSifeBgDo79ZIZo77M4/MPXP9g4dAa8n8bM
         YiMiMsFY9tMARacMT7jDaYKvf6p7UALW1Czhv8Md7CcF+WryobpEiFx2TAvfNRa8eHqP
         wEmUYkrNk5IMp0B1lr/byfonuMxtB3HphRj4EoWkVgVoW7K5qp1L7hAE1JAg36X/YDwq
         ToaTxvZnc/W0wiZPfeM4q8dfljyLRbCuVEqK+zgNE1fQG5sC6pr7lzyH4kXBJRvJfufE
         RYB3CRVIqdMO0btJp009s0NX3aCf7/3fiH/8v2YZ0z+KGffdYLZ/nlL6d6eQQi8k9n7D
         Mj3w==
Content-Disposition: inline
In-Reply-To: <655118da-6d58-8f02-7367-77c10a3c16ea@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-man <linux-man@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, Roman Gushchin <guro@fb.com>

Hello,

On Wed, Jan 10, 2018 at 08:20:53PM +0100, Michael Kerrisk (man-pages) wrote:
> On 01/10/2018 03:26 PM, Tejun Heo wrote:
> > Hello, Michael.
> > 
> > On Tue, Jan 09, 2018 at 11:48:11PM +0100, Michael Kerrisk (man-pages) wrote:
> >>> That said, not necessarily an objection.  I'm just not sure about it.
> >>
> >> Okay. For the moment, I'll leave that text as is.
> >>
> >> I realized that there was also one more file that needs to be included
> >> in the list of files that must be delegated:
> >>
> >>        /dlgt_grp/cgroup.threads
> >>               Changing the ownership of  this  file  is  necessary  if  a
> >>               threaded subtree is being delegated (see the description of
> >>               "thread mode", below).
> >>
> >> Can you please confirm that it's only necessary to delegate this file
> >> if we are delegating a threaded subtree?
> > 
> > Replied on the other thread.  The file isn't delegatable as far as I
> > can tell.
> 
> So, following on from the discussion in the other thread, my
> question above still stands.

Oh, I frankly haven't thought about delegating a threaded subtree.

Thanks.

-- 
tejun
