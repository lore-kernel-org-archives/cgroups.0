From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCHSET for-4.11] cgroup: implement cgroup v2 thread mode
Date: Wed, 22 Mar 2017 15:52:25 +0100
Message-ID: <20170322145225.nsmnvknla752e6yx@hirez.programming.kicks-ass.net>
References: <20170203205955.GA9886@mtj.duckdns.org>
 <20170206124943.GJ6515@twins.programming.kicks-ass.net>
 <20170208230819.GD25826@htj.duckdns.org>
 <20170209102909.GC6515@twins.programming.kicks-ass.net>
 <20170210154508.GA16097@mtj.duckdns.org>
 <20170210175145.GJ6515@twins.programming.kicks-ass.net>
 <20170212050544.GJ29323@mtj.duckdns.org>
 <20170214103541.GS6515@twins.programming.kicks-ass.net>
 <20170313200544.GE15709@htj.duckdns.org>
 <20170321123958.af7mcvcovexxzahu@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZCBcZdVVTJ/A2/XULMPCAu2Tje/JWuS2oUSEMNMtwr0=; b=kgZr9qr5NHZB6bzGkZEOcmJhW
        Pu1nwljOSd9MC5dgcroDAkuYEBW9ckmRgQqQiM50WmDGKin5pJQbWMlKhjsf+tSzBjYe85D0VseJY
        z7qTnd7TADRUgnM8UdIUdfM1ncfd7mNb77HACRT41aMgZhL4UliYSd9M8ihdr9al8bKoq4G28dlQA
        NOplAwpS7Mom8enUcJbKPmyBGGiAUORuysAluMxGkVB4+6+x2X6PkWOA/bFgswQ5A8+R8d+hDYSi+
        p3s09eFfDE8LJ9rKr2p0yAhs8maBrdB0ryiSswzDu7Ql8j6Ily+httIbWqaUiCUkOQ6ZAejaTw+2m
    
Content-Disposition: inline
In-Reply-To: <20170321123958.af7mcvcovexxzahu-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, lvenanci-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Tue, Mar 21, 2017 at 01:39:58PM +0100, Peter Zijlstra wrote:
> 
> And yes, having to consider views is new and a direct consequence of
> this new optional feature. But I don't see how its a problem.
> 

So aside from having (RO) links in thread groups for system controllers,
we could also have a ${controller}_parent link back to whatever group is
the actual parent for that specific controller's view.

So then your B's memcg_parent would point to A, not T.

But I feel this is all superfluous window dressing; but if you want to
clarify the filesystem interface, this could be something to consider.
