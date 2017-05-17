From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH v2 08/17] cgroup: Move debug cgroup to its own file
Date: Wed, 17 May 2017 17:36:03 -0400
Message-ID: <20170517213603.GE942@htj.duckdns.org>
References: <1494855256-12558-1-git-send-email-longman@redhat.com>
 <1494855256-12558-9-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SQcRzWhVAGIwgyFATs6nSC8bNCvW3e7zCBWlfEsD5ss=;
        b=BrqlHW7nhavfF3DLorMYI2nd2dLIY1v1XiPLvY+z/UvM5ft9ss/dEchVppozU42+on
         KXHh8uqK8iuLaRyt//qi8jkM8GF+UjUib2dkkA4c+fJBUL/IpvqRUaGCzQz86wiR0TZy
         tkFCiSUFFcTJM4moof5bvP/bdbEunFdLNFXB8zFNyoP6lLaZNwrQarUATbvyfEXBdl2d
         El3T7GKXQTemVvjGJkrXhg49ufWUmC5+e5N182mykIfMTDpx8QzNCEvSS/U4hKlfCRKy
         gWMXGwHapvdItPTYklkIH9ANIXg+XyDkX3SrKVKLjnlk2aIA6HDD4ZFM0le0r2h1ZB9c
         9Prg==
Content-Disposition: inline
In-Reply-To: <1494855256-12558-9-git-send-email-longman@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de

Hello, Waiman.

On Mon, May 15, 2017 at 09:34:07AM -0400, Waiman Long wrote:
> The debug cgroup currently resides within cgroup-v1.c and is enabled
> only for v1 cgroup. To enable the debug cgroup also for v2, it
> makes sense to put the code into its own file as it will no longer
> be v1 specific. The only change in this patch is the expansion of
> cgroup_task_count() within the debug_taskcount_read() function.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>

I don't mind enabling the debug controller for v2 but let's please
hide it behind an unwieldy boot param / controller name so that it's
clear that its interface isn't expected to be stable.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
