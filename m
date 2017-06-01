From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH v2 11/17] cgroup: Implement new thread mode semantics
Date: Thu, 1 Jun 2017 10:50:42 -0400
Message-ID: <20170601145042.GA3494@htj.duckdns.org>
References: <1494855256-12558-1-git-send-email-longman@redhat.com>
 <1494855256-12558-12-git-send-email-longman@redhat.com>
 <20170519202624.GA15279@wtj.duckdns.org>
 <b1d02881-f522-8baa-5ebe-9b1ad74a03e4@redhat.com>
 <20170524203616.GO24798@htj.duckdns.org>
 <9b147a7e-fec3-3b78-7587-3890efcd42f2@redhat.com>
 <20170524212745.GP24798@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GL+JTsInNA/mbuK4/4hRahCalWAGsB2+Mr12cLAe/9A=;
        b=butnXgvysll1mjBQbE2OMs3nUrEkq0djNLV9gCxdTB+QBsR4aDzXOHDe1kUUVrN7Zc
         a4gFMW3kC8bVUY+it5bhoNX9KJPLyQSh/slzZ0rQy0lhBB37Ude7mxfXNjlCOtzR6eIw
         8rVBgEtw94+VKftSgZlqd/YW1w/LXGh2TvX209L++GpmuR5Yjgm/JWh6A5pQVvRHpevL
         ckdDSHAJ4OyAvGzZTclebqCSL43I1OS2ZZuj/BHdDtF8LxnjBdmu1LGLAEosJBVWRBXp
         7cJKZ9X/CPYtDzykmqKB6qiFlZEeWty8C9s4j1KkUOIe62w8V/bTfA1R0bB30bmBNdy7
         S8EQ==
Content-Disposition: inline
In-Reply-To: <20170524212745.GP24798@htj.duckdns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de

Hello, Waiman.

A short update.  I tried making root special while keeping the
existing threaded semantics but I didn't really like it because we
have to couple controller enables/disables with threaded
enables/disables.  I'm now trying a simpler, albeit a bit more
tedious, approach which should leave things mostly symmetrical.  I'm
hoping to be able to post mostly working patches this week.

Also, do you mind posting the debug patches as a separate series?
Let's get the bits which make sense indepdently in the tree.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
