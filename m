From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Mon, 17 Aug 2015 16:35:21 -0400
Message-ID: <20150817203521.GL21075@mtj.duckdns.org>
References: <1438641689-14655-1-git-send-email-tj@kernel.org>
 <1438641689-14655-4-git-send-email-tj@kernel.org>
 <20150804090711.GL25159@twins.programming.kicks-ass.net>
 <20150804151017.GD17598@mtj.duckdns.org>
 <20150805091036.GT25159@twins.programming.kicks-ass.net>
 <20150805143132.GK17598@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=mwDGiB/Xl3WqcDjarHMhAgguFCPQMaTze1lXpoTiwak=;
        b=yNh/51OJUMR0dqPbCxmiBOWDYzI6OWI51P9Q3UN86eTiK529I7WL7Tpc15d3HgBWdM
         yNaZAkBmwS/XLNNPvlUtGju6PeS/6T4TifIA6ir6CghUoRD4a8kgU5fEpwcqzTq4GjaC
         n+ZwegM5bxaHkMdfU0pCkcYN8mXS/qiwC2jBijogY0hZCw3aseLFTzKGzg/9Z8fJgu2f
         BQo7D6l2fGJVwPORweQkIbV0rRyA/94HHJ6/ldx/llj79JEBFSZavMyUGb/5BAfjJuCl
         OiX+xtZahYQCCvW0j9FH/JK6+TNcFQfyYAWJNycMW93v4COAAu8ys4Qw61GlsW+1EcmT
         zW8g==
Content-Disposition: inline
In-Reply-To: <20150805143132.GK17598-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello, Peter.

Do we have an agreement on the sched changes?

Thanks a lot.

-- 
tejun
