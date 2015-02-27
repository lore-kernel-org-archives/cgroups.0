From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC 0/2] add nproc cgroup subsystem
Date: Fri, 27 Feb 2015 12:06:40 -0500
Message-ID: <20150227170640.GK3964@htj.duckdns.org>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
 <20150227114940.GB3964@htj.duckdns.org>
 <54F09E62.8000007@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ObgeOa+V41E02ZJZV7LdZm+9j7S5Io83d+SK/XbEJBY=;
        b=SaAk9I5qa9qu651e7amcgOgGBl91H6AKzmWX7xQZL/a35NEvn0jmLcsnBhWB4rg2Fm
         KVjFJSaHg3Af++zPQ6BN2Du5KNffpxbo7TAaLUkEZSb5mJf4ZwLYAlhKPuHU5bVD9GLU
         X16DkY+51TprP7A5IZackfTOZ2xHFFIb60+dGqqbYGDNEIK+Xezo/+P+GQxZhOPAwVMF
         pBSW9gDLmwhstKliYvJjqLJrJ4OHRi5fzL5kEDRTa9MX9VefoYgt24qgBA0uveI9uXVu
         VNn9oxy9YRykB4M97XvoitLBpfRBmH0Cd1l8M3E719WnSwZproDgq8OUcaE1VPHQk4dT
         HdxQ==
Content-Disposition: inline
In-Reply-To: <54F09E62.8000007-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Fri, Feb 27, 2015 at 11:42:10AM -0500, Austin S Hemmelgarn wrote:
> Kernel memory consumption isn't the only valid reason to want to limit the
> number of processes in a cgroup.  Limiting the number of processes is very
> useful to ensure that a program is working correctly (for example, the NTP
> daemon should (usually) have an _exact_ number of children if it is
> functioning correctly, and rpcbind shouldn't (AFAIK) ever have _any_
> children), to prevent PID number exhaustion, to head off DoS attacks against
> forking network servers before they get to the point of causing kmem
> exhaustion, and to limit the number of processes in a cgroup that uses lots
> of kernel memory very infrequently.

All the use cases you're listing are extremely niche and can be
trivially achieved without introducing another cgroup controller.  Not
only that, they're actually pretty silly.  Let's say NTP daemon is
misbehaving (or its code changed w/o you knowing or there are corner
cases which trigger extremely infrequently).  What do you exactly
achieve by rejecting its fork call?  It's just adding another
variation to the misbehavior.  It was misbehaving before and would now
be continuing to misbehave after a failed fork.

In general, I'm pretty strongly against adding controllers for things
which aren't fundamental resources in the system.  What's next?  Open
files?  Pipe buffer?  Number of flocks?  Number of session leaders or
program groups?

If you want to prevent a certain class of jobs from exhausting a given
resource, protecting that resource is the obvious thing to do.

Thanks.

-- 
tejun
