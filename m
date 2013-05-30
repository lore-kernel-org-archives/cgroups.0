From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch] mm, memcg: add oom killer delay
Date: Thu, 30 May 2013 17:07:42 +0200
Message-ID: <20130530150539.GA18155@dhcp22.suse.cz>
References: <alpine.DEB.2.02.1305291817280.520@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=zPYzXxutv+narSaBy+3OQloAw9P7C175v/Vi2ijIEsY=;
        b=fxrgvOg5hv97Ov78T4313FFN9cVHk/mbLvGU+CvgZW3K1GYWlMRZL8pkoKo/Cu5wyz
         k04Hlo6PGwYupixMewTQoLIdHic7nRrqjOoGeUX/V82Q8MA4ixobXZDLzHrpiPzmUnsj
         24TBbG7noQEqaTuf4b56hOsXcrLGXc/M0r2dDwSpGg3UFM1CLFBvONNajdvsiZphPgZS
         KsxkK33+6bKWwOLyKwffhtt4TAsivl1pQbX3emPvdXWtzfJxajpolQo4WlyQCpZGEEKe
         CIWtduKasDLa8utXodgorcGRCMFebe+59q0adyVV2+OJPBWArtLZhvH58oGXZ2cW5di4
         zyWA==
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305291817280.520@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Wed 29-05-13 18:18:10, David Rientjes wrote:
> Completely disabling the oom killer for a memcg is problematic if
> userspace is unable to address the condition itself, usually because it
> is unresponsive. 

Isn't this a bug in the userspace oom handler? Why is it unresponsive? It
shouldn't allocated any memory so nothing should prevent it from running (if
other tasks are preempting it permanently then the priority of the handler
should be increased).

> This scenario creates a memcg deadlock: tasks are
> sitting in TASK_KILLABLE waiting for the limit to be increased, a task to
> exit or move, or the oom killer reenabled and userspace is unable to do
> so.
>
> An additional possible use case is to defer oom killing within a memcg
> for a set period of time, probably to prevent unnecessary kills due to
> temporary memory spikes, before allowing the kernel to handle the
> condition.

I am not sure I like the idea. How does an admin decide what is the right value
of the timeout? And why he cannot use userspace oom handler to do the same
thing?

[...]
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
