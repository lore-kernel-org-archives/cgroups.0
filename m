From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: fix circular locking dependency
Date: Mon, 11 Dec 2017 07:20:59 -0800
Message-ID: <20171211152059.GH2421075@devbig577.frc2.facebook.com>
References: <CANaxB-zT+sz=z1FFk5npnwMySdfKCBZDkM+P+=JXDkCXbh=rCw@mail.gmail.com>
 <1511868946-23959-1-git-send-email-prsood@codeaurora.org>
 <623f214b-8b9a-f967-7a3d-ca9c06151267@codeaurora.org>
 <20171204202219.GF2421075@devbig577.frc2.facebook.com>
 <20171204225825.GP2421075@devbig577.frc2.facebook.com>
 <20171204230117.GF20227@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=khQrf6k8pmJPKHE8MSb0299s7kNzzoGj7xY5aJ9DKFw=;
        b=NHhQPZZ7MJRWQMGZzaf7l+KEBh4Qz3UAtN+ILF0p1LRI8yQ6ja8VOEnjtJn3dknYr3
         kzLx+YLMbQllMn1JsBg25JNiNmyrgFG93S2okyZcb4KmzGmEPIP7t4KvtEissZyMT0UT
         YH/2oNvkMZJCqVvUMTPB0aclC4pjHazoAcrsZ2oMAIB/g6s/apZYlBHV5crMpm7zMI33
         jdZjowDTOpA7d09ufEq6Z4/O7JgXtzySJNKMRl4+5w/PpyK02BIS3IMxImqiitrcxSxK
         UzKt/+OGxgabebUrerUqbHQfS68t+iW47y+wqGDjZKlwY50aC9Eekg+Eo8j5Th0/aCYk
         htJA==
Content-Disposition: inline
In-Reply-To: <20171204230117.GF20227-IIpfhp3q70z/8w/KjCw3T+5/BudmfyzbbVWyRVo5IupeoWH0uzbU5w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org

Hello, Peter.

On Tue, Dec 05, 2017 at 12:01:17AM +0100, Peter Zijlstra wrote:
> > AFAICS, this should remove the circular dependency you originally
> > reported.  I'll revert the two cpuset commits for now.
> 
> So I liked his patches in that we would be able to go back to
> synchronous sched_domain building.

Ah, yeah, that's a separate issue but didn't we intentionally make
that asynchronous?  IIRC, cpuset migration can take a really long time
when the memory migration is turned on and doing that synchronously
could mess up the system.

Thanks.

-- 
tejun
