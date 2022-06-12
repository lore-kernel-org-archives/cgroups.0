From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v11 3/8] cgroup/cpuset: Allow no-task partition to have
 empty cpuset.cpus.effective
Date: Sun, 12 Jun 2022 07:41:13 -1000
Message-ID: <YqYlOQjKtQCBsQuT@slm.duckdns.org>
References: <20220510153413.400020-1-longman@redhat.com>
 <20220510153413.400020-4-longman@redhat.com>
 <YqYlCRywdgSYtwKk@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X6BJIvmW0nAM/rdDTrxImV1gJDMQBIx+HHhMyoZbXj0=;
        b=VePaCp4WTk52eQPlsdGdj1sEDkrzFDEkktTLgnzTAUURmN5dzumLqNzKwcRyno9pe5
         R6uBdesg/HyOjALj1N4q5Swbx8MCK6m4oNXcrgj5Roy9AJ0JLzYbxXz2FImMdHTI6LMj
         YEaSj4RW/x41CQcePmC7BDegynpKSQdHW4hIiSgJlRQ1A6uhMTh/989NOlO24IW9Q4T3
         uGDDPJdrVezaC8CcdStqLRbb9sjYIJtvpFpLdqCBj3XGkfloa212yArOs52hvS/4ULw2
         wCjeFFj5FlGFBu4IlEOBnXS2gTjd4BrYn3CVNY8i9vTl3yIhcVBSyqJ6Whas/i608wIv
         WnAQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <YqYlCRywdgSYtwKk@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>

On Sun, Jun 12, 2022 at 07:40:25AM -1000, Tejun Heo wrote:
> Hello,
> 
> Sorry about the long delay.
> 
> On Tue, May 10, 2022 at 11:34:08AM -0400, Waiman Long wrote:
> > Once a partition with empty "cpuset.cpus.effective" is formed, no
> > new task can be moved into it until "cpuset.cpus.effective" becomes
> > non-empty.
> 
> This is always true due to no-tasks-in-intermediate-cgroups requirement,
> right?

or rather, I should have asked, why does this need an explicit check?

Thanks.

-- 
tejun
