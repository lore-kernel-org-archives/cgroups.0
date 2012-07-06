From: Wanpeng Li <liwp.linux@gmail.com>
Subject: Re: [PATCH] mm/memcg: add BUG() to mem_cgroup_reset
Date: Fri, 6 Jul 2012 16:44:15 +0800
Message-ID: <20120706084415.GB9319@kernel>
References: <1341546297-6223-1-git-send-email-liwp.linux@gmail.com>
 <20120706082242.GA1230@cmpxchg.org>
Reply-To: Wanpeng Li <liwp.linux@gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=oLDndfmynmxOXFiG56AiMBYKaob9VgxKZMstDTE5tI8=;
        b=PW2L221psA/vuy7Fu0ICdZlEtrmyvO5UMK7qpIpP3FzsUYLoEb+Ki8DFNv3Wv+38ch
         P0MjybXMMmDntSXzS1eVembM/cagrIp5KTM9lzpz/AK/XwutEb2OABxz3SSHbE3evyZT
         UjjlOAy6ZDK5FNFXKbPF3LlzbfBzCVfLvIzeB4ukSgk7eX/enbnA9RL6AM67AnQc0HC3
         IqXwILuVwQXjG4Bc1lJezGw6aiwb4lkINudHBCJiN31KyKZdBGpNXVWjqkRl5fl8tR1y
         9AcIpPnB33+XIQSEmeoh9yovkXkj2WBnoLiSMwjMd4bpJa0CAFi9bOo64T3yPY9WGFoh
         bNKQ==
Content-Disposition: inline
In-Reply-To: <20120706082242.GA1230@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Wanpeng Li <liwp.linux@gmail.com>

On Fri, Jul 06, 2012 at 10:22:42AM +0200, Johannes Weiner wrote:
>On Fri, Jul 06, 2012 at 11:44:57AM +0800, Wanpeng Li wrote:
>> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>> 
>> Branch in mem_cgroup_reset only can be RES_MAX_USAGE, RES_FAILCNT.
>
>And nobody is passing anything else.  Which is easy to prove as this
>is a private function.  And there wouldn't even be any harm passing
>something else.  Please don't add stuff like this.

Ok, thank you for your comment.

I also have another two patches, title:

clarify type in memory cgroups
return -EBUSY when oom-kill-disable modified and memcg use_hierarchy, has children

Hopefully, you can review. Thank you Johannes! :-)

Regards,
Wanpeng Li 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
