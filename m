From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch 2/2] mm, memcg: add memory.oom_control notification for
 system oom
Date: Mon, 18 Nov 2013 19:52:13 +0100
Message-ID: <20131118185213.GA12923@dhcp22.suse.cz>
References: <alpine.DEB.2.02.1310301838300.13556@chino.kir.corp.google.com>
 <20131031054942.GA26301@cmpxchg.org>
 <alpine.DEB.2.02.1311131416460.23211@chino.kir.corp.google.com>
 <20131113233419.GJ707@cmpxchg.org>
 <alpine.DEB.2.02.1311131649110.6735@chino.kir.corp.google.com>
 <20131114032508.GL707@cmpxchg.org>
 <alpine.DEB.2.02.1311141447160.21413@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1311141525440.30112@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1311141526300.30112@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=hERelkN0vMXtNJkfpoKGKaQotrzes/cHJpVUZIdmqWU=;
        b=WALYDj34Jay9jKnahLbAJjzVk023bM1mVuxr/mTF7iN5eoLMu8N5hhmMv0kXCCSLxS
         aMZIOEZ4DfDh0KNr9iTw9X3kEWPvydqVS+XJelzAtd9U4OT3XDCjoDxVTg1NjE2QnXxC
         gni8gtkXWKMh0Bigqcus8CA2i8Nl7kIIiBz8luo4Dpg/U+02vWt4mVxYOxZUvYb1T1Jw
         IZ8um/ZUpvaecUS9pd2TQSmmACDqT13Mwt9K2EEP/hhpV/24uUwLKacHxiG3uJ+nWRXK
         X24cFMEHmnTTynZyGrzWp5r7PHibcN0dhjXDusRZRmVLvYR8m3GQekD0rws2gf8+DRQE
         FPhg==
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311141526300.30112@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Thu 14-11-13 15:26:55, David Rientjes wrote:
> A subset of applications that wait on memory.oom_control don't disable
> the oom killer for that memcg and simply log or cleanup after the kernel
> oom killer kills a process to free memory.
> 
> We need the ability to do this for system oom conditions as well, i.e.
> when the system is depleted of all memory and must kill a process.  For
> convenience, this can use memcg since oom notifiers are already present.

Using the memcg interface for "read-only" interface without any plan for
the "write" is only halfway solution. We want to handle global OOM in a
more user defined ways but we have to agree on the proper interface
first. I do not want to end up with something half baked with memcg and
a different interface to do the real thing just because memcg turns out
to be unsuitable.

And to be honest, the more I am thinking about memcg based interface the
stronger is my feeling that it is unsuitable for the user defined OOM
policies. But that should be discussed properly (I will send a RFD in
the follow up days).

[...]
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
