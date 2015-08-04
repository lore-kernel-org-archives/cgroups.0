From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/3] cgroup: define controller file conventions
Date: Tue, 4 Aug 2015 10:51:07 -0400
Message-ID: <20150804145107.GB17598@mtj.duckdns.org>
References: <1438641689-14655-1-git-send-email-tj@kernel.org>
 <1438641689-14655-2-git-send-email-tj@kernel.org>
 <20150804084257.GJ25159@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=NqadBvqWiMw5HiVKm4SZeMvgBqB+OUk7gy2OQCR82EM=;
        b=Q1CnOfkoI5RO5c5eDlSRWDWEhipJLqqRyxlgOQ1Y2jH3ZXpHqc2yynJliaaiDZBWyw
         AwlnsPIaRbVqaeFQkyDk2qjNLgzqy+sAkxCCKWJanWMx1P0lwgcEuhaFGnmH5WkwQ3gY
         kQK5uxlLo+mQuASx+dzw58KhYxWubXMUPH+T/bKBYKynQWoOtDAGdqi1JkRYAqWTgKUX
         XsUuTuAJzU9L/BtJ2w586wOD4BJ/hh2veIVCF183IwKX3HJ57CnAj7Nd65wnxLR7JKPw
         K6xkAqahsuttpS5mWfKzB13dKdJ8n0Fq/MFlFdJ0s2nWiCFpQOSD+JANDC1FAWIusl0h
         4MQw==
Content-Disposition: inline
In-Reply-To: <20150804084257.GJ25159-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

On Tue, Aug 04, 2015 at 10:42:57AM +0200, Peter Zijlstra wrote:
> On Mon, Aug 03, 2015 at 06:41:27PM -0400, Tejun Heo wrote:
> > +- If a controller implements an absolute resource limit, the control
> > +  knob should be named "max".  The special token "max" should be used
> > +  to represent no limit for both reading and writing.
> 
> So what do you do with minimal resource guarantees? That's still an
> absolute resource limit and 'max' is obviously the wrong name.

The whole spectrum is min, low, high, max where min, max are absolute
guarantee, upper limit and low, high are best effort ones.  Will
update the doc.

Thanks.

-- 
tejun
