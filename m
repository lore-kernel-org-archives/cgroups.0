From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.4-fixes 2/3] cgroup: fix handling of
 multi-destination migration from subtree_control enabling
Date: Thu, 3 Dec 2015 10:16:32 -0500
Message-ID: <20151203151632.GE27463@mtj.duckdns.org>
References: <20151123195541.GA19072@mtj.duckdns.org>
 <56543C76.2050008@bmw-carit.de>
 <20151124144418.GB17033@mtj.duckdns.org>
 <56547B22.2020802@bmw-carit.de>
 <20151124145945.GF17033@mtj.duckdns.org>
 <20151130224205.GA9039@mtj.duckdns.org>
 <20151130224431.GB9039@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=pxrF4j+5VDs1AaBsS1M5KdwuP7JC7CH7ZPMOABHd2qw=;
        b=ygUSbPelMmscUjsoIqR8bcCCw6m+VqwxKynG4s87H03elAFIAUMHVYSOc3XqyVfpF7
         B/DdZZuN/YvbOPFM1eOHYNnGKJS9aA3cUZVfXRtmaWDBQ+QItBDSTr6eQo32QkGccOK7
         0SkGyxj5Cp0RkmhhmfOcIm9ofRB60hWfAVoxnfROKGxpjhWsDoLyOOHzYIeIGO8e2sKz
         z3l/+Xmudb63smhaiY/Q8b5sBcifXXltfgWb/RIWD0tj2igcGhweEJNkj6ERt9CxZdIm
         deL2wGM44lfG1dqnZeIwuSkq4sm/QQYZaLymSwV6QAFsL2KgzcGNI/r88XCXi7e7h/AI
         h7jQ==
Content-Disposition: inline
In-Reply-To: <20151130224431.GB9039-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>

On Mon, Nov 30, 2015 at 05:44:31PM -0500, Tejun Heo wrote:
> From 0d7d444e260493252e30c70813c7657e9ede2f12 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Date: Mon, 30 Nov 2015 17:24:34 -0500
> 
> Consider the following v2 hierarchy.
> 
>   P0 (+memory) --- P1 (-memory) --- A
>                                  \- B
> 
> P0 has memory enabled in its subtree_control while P1 doesn't.  If
> both A and B contain processes, they would belong to the memory css of
> P1.  Now if memory is enabled on P1's subtree_control, memory csses
> should be created on both A and B and A's processes should be moved to
> the former and B's processes the latter.  IOW, enabling controllers
> can cause atomic migrations into different csses.
> 
> The core cgroup migration logic has been updated accordingly but the
> controller migration methods haven't and still assume that all tasks
> migrate to a single target css; furthermore, the methods were fed the
> css in which subtree_control was updated which is the parent of the
> target csses.  pids controller depends on the migration methods to
> move charges and this made the controller attribute charges to the
> wrong csses often triggering the following warning by driving a
> counter negative.

Applying 1-2 to libata/for-4.4-fixes.

Thanks.

-- 
tejun
