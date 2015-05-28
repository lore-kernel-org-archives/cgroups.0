From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v12 8/8] cgroup: implement the PIDs subsystem
Date: Thu, 28 May 2015 16:40:51 -0400
Message-ID: <20150528204051.GB27479@htj.duckdns.org>
References: <1431960667-26593-1-git-send-email-cyphar@cyphar.com>
 <1431960667-26593-9-git-send-email-cyphar@cyphar.com>
 <20150519080055.GA3644@twins.programming.kicks-ass.net>
 <CAOviyaij2bays4aYQ_5HcopcBOfj4M_gKE7oQ_FsV38skK6vWA@mail.gmail.com>
 <alpine.DEB.2.11.1505191508530.4225@nanos>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=sdtOi9nP1XIA0BJ6Eqw4qe6cT/MIcuXcoS02XUkWuGc=;
        b=r6W7WHUpU7qM5rT9HaNLpgBEAUA1+TDxeHQytoytrsoV/V6tXcVkKCTiwaFRUzpA/S
         3otsyNR/GYFp7JShdwEdrNEWjh3JnyyvZgygHEGs68ffuEr7aV7zNytHM1vr/E1JLPfG
         RUtWd8SF7zaLBo9GFTWJWmLJeFLrHMD53P5PsOwzArE1dy5xHv52qsk1907zWvY2E8HS
         g9l5Q7tocxNONri+RqqNdmFMr6YgW58Nq9JVwblrjTzfrD9oWJV/IgXxQs7nPFBTBygb
         kfHoYM3T3h6ixMH3fXBniznIPqC3VLaU5czL1TlMZX66ycPDZ+FRjujsVrjdbxqAQ87x
         9f/w==
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1505191508530.4225@nanos>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Thomas.

On Tue, May 19, 2015 at 03:11:34PM +0200, Thomas Gleixner wrote:
> That's complete and utter nonsense. What has the parent limit to do
> with the overflow of the child limit?
> 
> parent:	 limit 100   usecnt 80
> child:	 limit 10    usecnt 10
> 
> So moving anything into child is violating the constraints and has to
> be refused. Anything else is just dirty hackery.

And the one who's moving the process there might as well raise the
limit in the child all the same.  It doesn't make any difference
without delegation and with delegation we need to restrict migration
at the exactly same junctions.  We can't delegate otherwise.  And the
resource limit for the delegated subtree is enforced from its parent
which delegatee can't escape how it changes the configuration or moves
processes around.

Thanks.

-- 
tejun
