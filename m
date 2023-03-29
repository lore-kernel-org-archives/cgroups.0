From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 4/4] cgroup/cpuset: Minor updates to test_cpuset_prs.sh
Date: Wed, 29 Mar 2023 08:43:11 -1000
Message-ID: <ZCSGv6PIfpvvWmxd@slm.duckdns.org>
References: <20230317151508.1225282-1-longman@redhat.com>
 <20230317151508.1225282-5-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680115393;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cm0O3mZAnzYDE3YblEoiVSRTHdbnazflMNNUfEvhAAA=;
        b=PDF80dUbKgdMlNmNe/WmOHssgAIRXS/Sj0NJnb29a8Noce+C0wRj7eGsS2P7i9cgR9
         6BmursKNdQyAYfDPu6uWeimwZ3q23ydPk7Yrv/d72j7MGtAFYci5mDSSkoOFXua6EsE8
         LXk9i1M5jTtOTGyuo/zhyvRknUOOkid5S37+zU5yCcRJhZfNNMpDNjkRaRIa/wtr7gfk
         t/q2tOdR2CHCVdIuTw6w6uNUQ+eSYiUqbuNAwNUvQ4x+iBhsT9yNcgLc/DjZe/fj2+g7
         b2EohJSjU6/FOQXMXLIM+nUpybsfQhohYFT34yLJIWuNlEo5xcnm2DXLIn89P6ttkACW
         UfYQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230317151508.1225282-5-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Juri Lelli <juri.lelli@redhat.com>

On Fri, Mar 17, 2023 at 11:15:08AM -0400, Waiman Long wrote:
> This patch makes the following minor updates to the cpuset partition
> testing script test_cpuset_prs.sh.
> 
>  - Remove online_cpus function call as it will be called anyway on exit
>    in cleanup.
>  - Make the enabling of sched/verbose debugfs flag conditional on the
>    "-v" verbose option and set DELAY_FACTOR to 2 in this case as cpuset
>    partition operations are likely to be slowed down by enabling that.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>

Applied 2-4 to cgroup/for-6.4.

Thanks.

-- 
tejun
