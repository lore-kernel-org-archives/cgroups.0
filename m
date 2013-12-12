From: Tejun Heo <tj@kernel.org>
Subject: Re: [patch 7/8] mm, memcg: allow processes handling oom
 notifications to access reserves
Date: Thu, 12 Dec 2013 11:37:06 -0500
Message-ID: <20131212163706.GJ32683@htj.dyndns.org>
References: <20131205025026.GA26777@htj.dyndns.org>
 <alpine.DEB.2.02.1312051537550.7717@chino.kir.corp.google.com>
 <20131206190105.GE13373@htj.dyndns.org>
 <alpine.DEB.2.02.1312061441390.8949@chino.kir.corp.google.com>
 <20131210215037.GB9143@htj.dyndns.org>
 <alpine.DEB.2.02.1312101522400.22701@chino.kir.corp.google.com>
 <20131211124240.GA24557@htj.dyndns.org>
 <CAAAKZwsmM-C=kLGV=RW=Y4Mq=BWpQzuPruW6zvEr9p0Xs4GD5g@mail.gmail.com>
 <20131212142156.GB32683@htj.dyndns.org>
 <20131212163222.GK2630@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=k84oq5guEyOe9z4KGIBjVgy9efFcSE9AJxN8Eht9MqU=;
        b=pR5DkjdqWLpUlz0Y7rJsU+MekPQU9Qc6L+/cYdAf9ZegkCfv//oZ93JKSPtu+zqXjD
         Q5W6t5DcsA92VKZMfEdDVKMKTalG5avyc0uIhKSUL1q61M+4ZqcQfUnGZrKf6GnKnhDf
         WZH/npj6FgWdWhn5TWzNs96cr5zFDcxptBk5q4gTVhOYpeoZDqwFFV5eTYR1+pdbO+eJ
         4HHdpLZEVsOSf+ygYgWejBW/+fp9QOTZi4esT5isvyoB532o4mUDDCpMgfyCkbHzaMdX
         PDgOMHYVct6X6rtrb0DvSspMCHtsDWLv4weWLcKuwfDWrCgaYbAjw8PieqOtq0k6fpeJ
         ogtg==
Content-Disposition: inline
In-Reply-To: <20131212163222.GK2630@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Tim Hockin <thockin@hockin.org>, David Rientjes <rientjes@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux-foundation.org>, Li Zefan <lizefan@huawei.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, Cgroups <cgroups@vger.kernel.org>

Hello, Michal.

On Thu, Dec 12, 2013 at 05:32:22PM +0100, Michal Hocko wrote:
> You weren't on the CC of the original thread which has started here
> https://lkml.org/lkml/2013/11/19/191. And the original request for
> discussion was more about user defined _policies_ for the global
> OOM rather than user space global OOM handler. I feel that there
> are usacases where the current "kill a single task based on some
> calculations" is far from optimal which leads to hacks which try to cope
> with after oom condition somehow gracefully.
> 
> I do agree with you that pulling oom handling sounds too dangerous
> even with all the code that it would need and I feel we should go a
> different path than (ab)using memcg.oom_control interface for that.
> I still think we need to have a way to tell the global OOM killer what
> to do.

Oh yeah, sure, I have no fundamental objections against improving the
in-kernel system OOM handler, including making it cgroup-aware which
seems like a natural extension to me.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
