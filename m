From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] cgroup: use an ordered workqueue for cgroup
 destruction
Date: Fri, 7 Feb 2014 13:06:00 -0800 (PST)
Message-ID: <alpine.LSU.2.11.1402071300300.926@eggly.anvils>
References: <alpine.LSU.2.11.1402061541560.31342@eggly.anvils> <20140207140402.GA3304@htj.dyndns.org> <alpine.LSU.2.11.1402071130250.333@eggly.anvils> <20140207203508.GC8833@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=YQpIxzpp1uVNs8bsMXnF9qCMvYtnPmO2XMBOQhs8K24=;
        b=RwFSX4hyoTkc8rZICtA9H6Yk91XsSS421tky4iSz8DP8jjJP4pW6dvSSAEbbKrZqxJ
         o6zCyNp3KeVrpmRFBHCKggkEXTzleDweseaffWmLVO3vHPPtnFk9sJndqlTKh2NUWZu5
         lgTQeDDeKlRXAO4OlcZmTcsVyiyS0PQNVK7eHNYc5mRssJUfen6fpogxdX8blZBg9aXp
         GJcccyHIXrWYT6NmTt5YZDZzoyMrcf/d7s9qgk85enIE7NRYDc3m0t1jX+tXZQdJkQq/
         //Qp6enV43vFMqY/Olt9kznIpsgvekwf7VT9IMIBegEdu68lN8XQ7lq/5qgTfHeeExn3
         6vBQ==
In-Reply-To: <20140207203508.GC8833@htj.dyndns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, Filipe Brandenburger <filbranden@google.com>, Li Zefan <lizefan@huawei.com>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Greg Thelen <gthelen@google.com>, Michel Lespinasse <walken@google.com>, Markus Blank-Burian <burian@muenster.de>, Shawn Bohrer <shawn.bohrer@gmail.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Fri, 7 Feb 2014, Tejun Heo wrote:
> On Fri, Feb 07, 2014 at 12:20:44PM -0800, Hugh Dickins wrote:
> 
> > You don't return to this concern in the following mails of the thread:
> > did you later decide that it actually won't be a problem?  I'll assume
> > so for the moment, since you took the patch, but please reassure me.
> 
> I was just worrying about a different solution where we take
> css_offline invocation outside of cgroup_mutex and bumping up
> max_active.  There's nothing to worry about your patch.  Sorry about
> not being clear.  :)

Thanks a lot for your detailed and admirably responsive explanations.
You were looking ahead, I see that now, and I'm gratefully reassured :)

Hugh

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
