From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/3] cgroup: Implement cgroup2 basic CPU usage accounting
Date: Tue, 29 Aug 2017 08:42:36 -0700
Message-ID: <20170829154236.GQ491396@devbig577.frc2.facebook.com>
References: <20170811163754.3939102-1-tj@kernel.org>
 <20170811163754.3939102-4-tj@kernel.org>
 <20170829143252.6zoes63bwfflukjy@hirez.programming.kicks-ass.net>
 <20170829152426.GL491396@devbig577.frc2.facebook.com>
 <02e84780-1ad7-95e3-345e-baec3dc6db84@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ra4d+1HKzQhVzmZ/G1DMsfjkcn7nsLQSZCMJ/NZPEDA=;
        b=iNLjGIH2TRF6zV9h2xgRFJyFOJxQ/PpGDJZnb7nOU7QBwAo0JdiOfvewb3HUlkmwY9
         3Zy2OfzsebW+TDTmMiR8BW2tJqmSB0Cr3+GNhxFvGeYEwP96Fd+CeQCTaHR2onhIPvAJ
         ZP4tFFMf3I0BWHGUjW2b3U48g6fB1QLjQFC+Zpm886OHTz1sKIZZu3uofAjz+c6Sucr/
         5ImZPHyxywCmTy7uuGvvPvDYPX2I9P84G9YWSfQXWaV5F6xcSLeDyZObah3UFj9S+85k
         s0yCDV84pjwL2ExBhqizYhbYB/hsnSKBgcFpuZksct4rGKxCM4Vip47N3Ef/7zDUfI6s
         gS8g==
Content-Disposition: inline
In-Reply-To: <02e84780-1ad7-95e3-345e-baec3dc6db84@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, lizefan@huawei.com, hannes@cmpxchg.org, mingo@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

Hello, Waiman.

On Tue, Aug 29, 2017 at 11:32:35AM -0400, Waiman Long wrote:
> > Also, please note that a system may end up with a lot of cgroups
> > without the user intending to.  memcg drains removed cgroups lazily
> > and the number of draining cgroups can reach very high numbers if the
> > system isn't under memory pressure.  The plan is to add basic stats
> > for other resources too and keeping it scalable w.r.t. idle cgroups
> > allows using the same mechanism for all resources.
> 
> I think it will be good to put the rationale behind this function as a
> comment in the code.

Ah, good point.  I'll beef up the overall comment in the header file
and point to that from the function comment.

Thanks.

-- 
tejun
