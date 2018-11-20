From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH cgroup/for-4.21 1/2] cpuset: Minor cgroup2 interface
 updates
Date: Tue, 20 Nov 2018 07:44:10 -0800
Message-ID: <20181120154410.GQ2509588@devbig004.ftw2.facebook.com>
References: <20181113201339.GN2509588@devbig004.ftw2.facebook.com>
 <20181120124624.GL2131@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SM4C77HJsk3VZeoo7j2DXFW5SgWyxknbONhZKcDfceQ=;
        b=NP8JUw246bZpGQJ/j4aJD6AVvEi/6N6xyn4YStgKbtJP1B9pxU4T6lCDvjX/U7vge8
         8UPsXdHhOcAp/sE+P5wl7HHytNW9CRmuNngsjBLPPro27x+YIEFP3JGyjeuvmLXM9L/W
         CbN8OAnB0iJ0Z0ORhPfRQKhiwnbIqHME/XtUDOhLUQ1qID7EplQYxk9A3udALGUfhIEh
         4zYBZz12NRTyhpu5MlvrZwVZlpE+LsS25Yfj1b/hGKumfO0gadeiX3JcFlhW6BfMeOwh
         JS5hSmCkM5JVIudZl+aQ1srGDv5bi/QPSwtq0blvmod5unhoXMwX9A3e5FbUNNi87jXI
         PTvg==
Content-Disposition: inline
In-Reply-To: <20181120124624.GL2131@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <longman@redhat.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello, Peter.

On Tue, Nov 20, 2018 at 01:46:24PM +0100, Peter Zijlstra wrote:
> Why though? The Changelog doesn't give rationale for the actual changes.

Ah yeah, sorry about that.

> And I'm not sure I agree with either one of them.
> 
> The partition is a scheduling feature;

So is everything with cpuset.cpus prefix.  They're all modifying how
scheduler handles the cpus.

> and I like 0/1 much better to type, so why not allow that?

Mostly for consistency and it's generally better to keep interfaces
minimal - e.g. what if we need to add support for more key words to
the file?  Would we assign incrementing integers to them?

Thanks.

-- 
tejun
