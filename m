From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Subject: Re: [patch for-3.12] mm, memcg: protect mem_cgroup_read_events for
 cpu hotplug
Date: Tue, 01 Oct 2013 20:47:01 -0400
Message-ID: <524B6D05.5030609@gmail.com>
References: <alpine.DEB.2.02.1310011629350.27758@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=CbAQTSrAhW5QQkzMQtxomg7CVBRJbuBl1mgNaNlAgIo=;
        b=t2WaO3gVxs9j6D9SeHv4HdANcyjGMdBWqHvHgb0s88/Fbgn1srkJq/7fwmF8RSSgtS
         WM5tQ+t63lGa53jnB3JhTfNtXFzlk+zjbNRO9aVswd12OI15EY9/spuEIbe366qJSdK9
         uK2uLvafgtvfk0o0lqW5mtXc0DN7q7DVpXn739EDVi4e8GyeBTlHqyQW9kU3OfweTwxQ
         maafb1CvN7S6HzxIcMrMytqJXjoYUbniRhzlnl7KzycGO0gkRMZYeKKRLEnJAmxM0sYY
         xc5vPgMkSNr/Vk+oaQ/yhl3Ol0vJTsN8jMGXmmOeiVIMeFrvyIy2ydvuD79tKS96NhUd
         2/Rw==
In-Reply-To: <alpine.DEB.2.02.1310011629350.27758@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kosaki.motohiro@gmail.com

(10/1/13 7:31 PM), David Rientjes wrote:
> for_each_online_cpu() needs the protection of {get,put}_online_cpus() so
> cpu_online_mask doesn't change during the iteration.
>
> Signed-off-by: David Rientjes <rientjes@google.com>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
