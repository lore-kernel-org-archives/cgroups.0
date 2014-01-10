From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Date: Thu, 9 Jan 2014 16:35:05 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1401091634390.24832@chino.kir.corp.google.com>
References: <20131210103827.GB20242@dhcp22.suse.cz> <alpine.DEB.2.02.1312101655430.22701@chino.kir.corp.google.com> <20131211095549.GA18741@dhcp22.suse.cz> <alpine.DEB.2.02.1312111434200.7354@chino.kir.corp.google.com> <20131212103159.GB2630@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312131551220.28704@chino.kir.corp.google.com> <20131217162342.GG28991@dhcp22.suse.cz> <alpine.DEB.2.02.1312171240541.21640@chino.kir.corp.google.com> <20131218200434.GA4161@dhcp22.suse.cz> <alpine.DEB.2.02.1312182157510.1247@chino.kir.corp.google.com>
 <20131219144134.GH10855@dhcp22.suse.cz> <20140107162503.f751e880410f61a109cdcc2b@linux-foundation.org> <alpine.DEB.2.02.1401091324120.31538@chino.kir.corp.google.com> <20140109144757.e95616b4280c049b22743a15@linux-foundation.org>
 <alpine.DEB.2.02.1401091551390.20263@chino.kir.corp.google.com> <20140109161246.57ea590f00ea5b61fdbf5f11@linux-foundation.org> <alpine.DEB.2.02.1401091613560.22649@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=V2RQQRvsJK0VNC4cGR0+gRD4I36fPZd8I7VQn7aFFxQ=;
        b=E/7FX01ASAKyBN731KkE10cLF5EN56zlAM8XndgeOpRw2yT4YwCovnzdYHpLYzs4p1
         xj3InL+Tvzh+xcEuRN9lu/vX6Kxak0CwPUMrxAKiufezcj+fLhNiosrlueljns003Zc2
         8qpLtoSI8h6HkBc2ZLZB1Pb+3mbFR7WhKAQr0z/1omCQVU9YubbfsBJMihN6gEboMMcC
         1Z9DoKsJKC3C0BfSENTXlfr+2UjNsjqWQdEmd8S4ATv5I9mliUhOyj+bLHjafWmOLRLs
         WV5qzuNHNxGpjaAwCCSF9a7nTwbHBiYVj9PIZkgH91UqAo6gFYUf0hWsJevLS2ZENKnN
         4LLA==
In-Reply-To: <alpine.DEB.2.02.1401091613560.22649@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>

On Thu, 9 Jan 2014, David Rientjes wrote:

> > Johannes' final email in this thread has yet to be replied to, btw.
> > 
> 
> Will do.
> 

I've responded to this email, but nothing in Johannes' email actually 
talks about this specific patch at all, so I'm not sure it's very useful.

Thanks.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
