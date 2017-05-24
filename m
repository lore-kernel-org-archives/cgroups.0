From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH v2 11/17] cgroup: Implement new thread mode semantics
Date: Wed, 24 May 2017 17:27:45 -0400
Message-ID: <20170524212745.GP24798@htj.duckdns.org>
References: <1494855256-12558-1-git-send-email-longman@redhat.com>
 <1494855256-12558-12-git-send-email-longman@redhat.com>
 <20170519202624.GA15279@wtj.duckdns.org>
 <b1d02881-f522-8baa-5ebe-9b1ad74a03e4@redhat.com>
 <20170524203616.GO24798@htj.duckdns.org>
 <9b147a7e-fec3-3b78-7587-3890efcd42f2@redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=g+C/ghRTrVmcfHtZtzAO7gIbLRj16weq1xUGjASvBWA=;
        b=uBmTj2vWF3YTLSVwn9cTGSHbczr/CnFpoMUaGf0clFrS4ZPKEYW6uv7833+SAchD34
         ExOSUS5tMrK6Nc5vlzPlEbapTLuzSLjQfz5ZRKfjgWgU+zk2Zvj0mSu3GMvS7XJu3E7d
         eBqsVl+I4FNkbdHhgtTPsuBPH4f91kqtEHDhbcYzekD+Nicj3YMTv9fVg9sbUUfGptlr
         uailKnaYIAQ8nmvymTc3tXC0CCFzbtLfQABPsodlGQSgxwEZJCQgjD4dCYopDixbJ3OT
         dAZRXPs0RrP6vUScy/Dl79ZtzNW2BcYEKLdPr1lWjj+AKXY1r0Ds1g3zlBe3fCBxKo2z
         ynWA==
Content-Disposition: inline
In-Reply-To: <9b147a7e-fec3-3b78-7587-3890efcd42f2@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de

Hello,

On Wed, May 24, 2017 at 05:17:13PM -0400, Waiman Long wrote:
> An alternative is to have separate enabling for thread root. For example,
> 
> # echo root > cgroup.threads
> # echo enable > child/cgroup.threads
> 
> The first statement make the current cgroup the thread root. However,
> setting it to a thread root doesn't make its child to be threaded. This
> have to be explicitly done on each of the children. Once a child cgroup
> is made to be threaded, all its descendants will be threaded. That will
> have the same effect as the current patch.

Yeah, I'm toying with different ideas.  I'll get back to you once
things get more concrete.

> With delegation, do you mean the relationship between a container and
> its host?

It can be but doesn't have to be.  For example, it can be delegations
to users without namespace / container being involved.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
