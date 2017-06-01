From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH v2 11/17] cgroup: Implement new thread mode semantics
Date: Thu, 1 Jun 2017 16:52:03 -0400
Message-ID: <20170601205203.GB13390@htj.duckdns.org>
References: <20170524203616.GO24798@htj.duckdns.org>
 <9b147a7e-fec3-3b78-7587-3890efcd42f2@redhat.com>
 <20170524212745.GP24798@htj.duckdns.org>
 <20170601145042.GA3494@htj.duckdns.org>
 <20170601151045.xhsv7jauejjis3mi@hirez.programming.kicks-ass.net>
 <ffa991a3-074d-ffd5-7a6a-556d6cdd08fe@redhat.com>
 <20170601184740.GC3494@htj.duckdns.org>
 <ca834386-c41c-2797-702f-91516b06779f@redhat.com>
 <20170601203815.GA13390@htj.duckdns.org>
 <e65745c2-3b07-eb8b-b638-04e9bb1ed1e6@redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=as5LD+N+/ls1BVOkyutrUy/VN2J3Yh33PUNF/2pVL4Q=;
        b=GYbwjWdu+gLHZT5X4bVBwqjSgZ9KOFizPQwj5DwuRj27bhfOd6ZtYRAV8YgmWu5E1l
         jV13/jkyfGv/K7j1YkkXHesxKP6UqETqSA/NfvVAVsyHeV/aPiOG2DMUsy2JNvKffjd3
         kZqE/oUpVT6FayMX0MlhaJ94Itmhih0jjJCKRt1VpncENv+9v+2daz0JBuUA++OUJBtM
         BFIJDBoQMQhxTVsgGNmjnyYsYoBR6E3MNkp6du/fpVYBXNCmGWZhy8UEDvOzz7hnKtpd
         J2H8+Fm9JFDL+h2ot8OiSWGHuG+NLInXlxjqlj02oN1bYypjyDYXSLvV+BkJ/YqTg82R
         og9Q==
Content-Disposition: inline
In-Reply-To: <e65745c2-3b07-eb8b-b638-04e9bb1ed1e6@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de

Hello,

On Thu, Jun 01, 2017 at 04:48:48PM -0400, Waiman Long wrote:
> I think we are on agreement here. I should we should just document how
> userland can work around the internal process competition issue by
> setting up the cgroup hierarchy properly. Then we can remove the no
> internal process constraint.

Heh, we agree on the immediate solution but not the final direction.
This requirement affects how controllers implement resource control in
significant ways.  It is a restriction which can be worked around in
userland relatively easily.  I'd much prefer to keep the invariant
intact.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
