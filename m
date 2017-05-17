From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH v2 09/17] cgroup: Keep accurate count of tasks in
 each css_set
Date: Wed, 17 May 2017 17:40:34 -0400
Message-ID: <20170517214034.GF942@htj.duckdns.org>
References: <1494855256-12558-1-git-send-email-longman@redhat.com>
 <1494855256-12558-10-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kZDHNHgqKecmWuyrz07MDcFlnvpYLZnfApGZRSexdeA=;
        b=H7ZcTjeXcu+OVkB4eYMA4yR3wlrAhXRVEoqjSaaQZLwnxYOf8asqX32vnLuXwMsPQc
         E4IjUm5xoZnzH2bmNrfKGM97qBepipCPIXudSfP2h+tub8wS9ATCVY+ThY4x0lk6OP+j
         lw8wUGJ5YxPK4HkWFEZSgKnjt/X7cDZrsZnzEIIiobrn6F04EX/lSJyAs3tylpSI2am+
         Ya+Qd/Mq3SeP+6nV2c0th5tMTxwNnKYvnTogpqAvvZVU+pTZ6fBtIAGKD4jgjFQ1As8h
         E6SGqGx7T7ZOz9Jy2mBtWzUvC1HE9FKRQWKJGjzLtt/81OUMRGTMhYduEWJTKhwzKzxp
         iUOQ==
Content-Disposition: inline
In-Reply-To: <1494855256-12558-10-git-send-email-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org

Hello,

On Mon, May 15, 2017 at 09:34:08AM -0400, Waiman Long wrote:
> The reference count in the css_set data structure was used as a
> proxy of the number of tasks attached to that css_set. However, that
> count is actually not an accurate measure especially with thread mode
> support. So a new variable task_count is added to the css_set to keep
> track of the actual task count. This new variable is protected by
> the css_set_lock. Functions that require the actual task count are
> updated to use the new variable.
> 
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Looks good.  We probably should replace css_set_populated() to use
this too.

Thanks.

-- 
tejun
