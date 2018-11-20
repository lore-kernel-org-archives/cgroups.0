From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH cgroup/for-4.21 1/2] cpuset: Minor cgroup2 interface
 updates
Date: Tue, 20 Nov 2018 18:19:20 +0100
Message-ID: <20181120171920.GA2131@hirez.programming.kicks-ass.net>
References: <20181113201339.GN2509588@devbig004.ftw2.facebook.com>
 <20181120124624.GL2131@hirez.programming.kicks-ass.net>
 <20181120154410.GQ2509588@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=I+8Ok8d3U7ODhT6w9ubsS4qTzg7vYuk5vhO0Db4ECIs=; b=X/JhevL5RIpdVTkxKR652x/Bv
        JCu18806N+sEXYqj7D8zNEIM/ZD2VNlb2UQq57PoBEzCmKjYCarQI27OjG8a2kG1mBYoSteoi3QOT
        JBFQDou1md9Ap9t6x7VjAmxUF1OF4jtEIZ2R/KRRrx0niyNOGZ8JQdE15cLnL+D/hz5/EJ4JmMOx7
        Kx0suzHHwMxDUhgxT0K5vOc4G22VHMNW/XCzAxpbUCwqjhYupxbWbbub3NuXqudLyQaTo7tUVV/lX
        j4EhMGnj5k4a0wi51xxMNFl3S6NRaQ1uLu+SnaMRw2e+9dYmqq8/urZbH8t/hzv+y6VWXi+WaWZKb
    
Content-Disposition: inline
In-Reply-To: <20181120154410.GQ2509588@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Nov 20, 2018 at 07:44:10AM -0800, Tejun Heo wrote:
> Hello, Peter.
> 
> On Tue, Nov 20, 2018 at 01:46:24PM +0100, Peter Zijlstra wrote:
> > Why though? The Changelog doesn't give rationale for the actual changes.
> 
> Ah yeah, sorry about that.
> 
> > And I'm not sure I agree with either one of them.
> > 
> > The partition is a scheduling feature;
> 
> So is everything with cpuset.cpus prefix.  They're all modifying how
> scheduler handles the cpus.

Fair enough I suppose.

> > and I like 0/1 much better to type, so why not allow that?
> 
> Mostly for consistency and it's generally better to keep interfaces
> minimal - e.g. what if we need to add support for more key words to
> the file?  Would we assign incrementing integers to them?

Or just not give them a numeric alias at all.

But numbers are more minimal than words, so lets just get rid of them
pesky word things ;-)

Alternatively; we could use kstrtobool(). That accepts a metric ton of
input ;-)
