From: Greg Thelen <gthelen@google.com>
Subject: Re: [patch 2/2] mm: memcontrol: default hierarchy interface for memory
Date: Tue, 13 Jan 2015 15:20:08 -0800
Message-ID: <xr93a91mz2s7.fsf@gthelen.mtv.corp.google.com>
References: <1420776904-8559-1-git-send-email-hannes@cmpxchg.org> <1420776904-8559-2-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=references:from:to:cc:subject:in-reply-to:date:message-id
         :mime-version:content-type;
        bh=Sspa4accIAij8cXDKtIkrfeymcPlT0nk7TmG/NktILU=;
        b=NdTSrABf9yicwFyno4T5cLpm0GrkruM4vr6JlssVPHsRvCJp7ZnjoqyZf0bXMmimEf
         c7yIXfRcLGB9NB2pEdTSFUd/A/TLIQ5beONuMMP3LRYJgS1U2L0LH0ckGDLOlul+kqkw
         eWokjBSgHmklwmZPMKT08DnmNkRTaCyH1b2EwTxaeTJ7ug/IR2QPYsjyW6q06CP5laBx
         emiWAAic0jpAMcY8X1EW9jj3kd/cUhR5CNjBPwNe7WSELXvKfOvUHkk8wCkHefGJFMMM
         4hRrNn0lBqRVHYV7yIg/h1y/IjAQ1PxSmF6ulpGZtcKJwv8Non0FkznkslUmPr8boEsn
         7uNQ==
In-reply-to: <1420776904-8559-2-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org


On Thu, Jan 08 2015, Johannes Weiner wrote:

> Introduce the basic control files to account, partition, and limit
> memory using cgroups in default hierarchy mode.
>
> This interface versioning allows us to address fundamental design
> issues in the existing memory cgroup interface, further explained
> below.  The old interface will be maintained indefinitely, but a
> clearer model and improved workload performance should encourage
> existing users to switch over to the new one eventually.
>
> The control files are thus:
>
>   - memory.current shows the current consumption of the cgroup and its
>     descendants, in bytes.
>
>   - memory.low configures the lower end of the cgroup's expected
>     memory consumption range.  The kernel considers memory below that
>     boundary to be a reserve - the minimum that the workload needs in
>     order to make forward progress - and generally avoids reclaiming
>     it, unless there is an imminent risk of entering an OOM situation.

So this is try-hard, but no-promises interface.  No complaints.  But I
assume that an eventual extension is a more rigid memory.min which
specifies a minimum working set under which an container would prefer an
oom kill to thrashing.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
