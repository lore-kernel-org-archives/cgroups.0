From: Vipin Sharma <vipinsh@google.com>
Subject: Re: [RFC 2/2] cgroup: sev: Miscellaneous cgroup documentation.
Date: Wed, 24 Feb 2021 15:13:23 -0800
Message-ID: <YDbdk/aY88t/khY2@google.com>
References: <20210218195549.1696769-1-vipinsh@google.com>
 <20210218195549.1696769-3-vipinsh@google.com>
 <71092e0e-5c72-924b-c848-8ae9a589f6b0@infradead.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=muWCsWrQoBXyu4MckQ9XwIgh71Pik8fohBKy8+YwG04=;
        b=eALgcZew2EajyVeA/DiBEfM4a24dApZHnvUSzXm8kKOfeR1mXWz+bNzjmsq3m/8hka
         aYPKhw/8/x67hSwUlOdFPiH6qFX9rkoBkdESplPOCsj+JbhWaEasMiAEJ8AgzYIAqm4p
         yp67ujCmh5HofiMxCbHagDi6aOpZ+DYHw/28E0B6cYsGbwJ2RKhYBUtvsLz9dMsfm8gl
         1hwODTkdUw1wXyhfduiO3n9tXE81lWrCqXiRDudm/cd+QUo6Vx0uktrikPYHPySKbZ3v
         Y+quj12JNP7Ur3mxgMxUor82l251R8I8o3h1oJHehxxHbxjaCpy83dNl1o9exjZC+ZeX
         x6KA==
Content-Disposition: inline
In-Reply-To: <71092e0e-5c72-924b-c848-8ae9a589f6b0@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Randy Dunlap <rdunlap@infradead.org>
Cc: tj@kernel.org, thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Feb 19, 2021 at 11:02:41AM -0800, Randy Dunlap wrote:
> > +++ b/Documentation/admin-guide/cgroup-v1/misc.rst
> > @@ -0,0 +1 @@
> > +/Documentation/admin-guide/cgroup-v2.rst
> What is the purpose of this (above) file?

This new controller has both cgroup v1 and v2 support. Tejun suggested
if we can point to v2 doc from v1. If this is not recommended approach I
can add all of the v2 documention of misc controller here, let me know.

I missed a heading and adding this file in cgroup-v1/index.rst.
Fixed it now.

> > +        Limits can be set more than the capacity value in the misc.capacity
> 
>                              higher than
> 

Done

> > +a process to a different cgroup do not move the charge to the destination
> 
>                                    does

Done

> > +Others
> >  ----
> 
> That underline is too short for "Others".
> 

Fixed.

> Try building this doc file, please.
> 
> next-20210219/Documentation/admin-guide/cgroup-v2.rst:2196: WARNING: Unexpected indentation.
> next-20210219/Documentation/admin-guide/cgroup-v2.rst:2203: WARNING: Unexpected indentation.
> next-20210219/Documentation/admin-guide/cgroup-v2.rst:2210: WARNING: Unexpected indentation.
> next-20210219/Documentation/admin-guide/cgroup-v2.rst:2232: WARNING: Title underline too short.
> 
> Others
> ----
> next-20210219/Documentation/admin-guide/cgroup-v2.rst:2232: WARNING: Title underline too short.
> 
> 
> I think that the first 3 warnings are due to missing a blank line after ::
> or they could have something to do with mixed tabs and spaces in the misc.*
> properties descriptions.
> 

Sorry, I was not familiar with Sphinx build and didn't build using that.
I have fixed all of the above warnings. My next patch will reflect
fixes.

Thanks

