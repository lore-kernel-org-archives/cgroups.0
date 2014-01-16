From: David Rientjes <rientjes@google.com>
Subject: Re: [patch v2 -mm] mm, oom: prefer thread group leaders for display
 purposes
Date: Thu, 16 Jan 2014 14:49:25 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1401161447510.31228@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1401151837560.1835@chino.kir.corp.google.com> <20140116070549.GL6963@cmpxchg.org> <alpine.DEB.2.02.1401152344560.14407@chino.kir.corp.google.com> <alpine.DEB.2.02.1401152345330.14407@chino.kir.corp.google.com>
 <20140116142141.GF28157@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=641iJawDEwcGPSJUqqG8VdN3eI5LPAAcU4dlcjTV1Eg=;
        b=Z2Jdgiv+lZycEHRtvgpg2+8G0On1n5dZUN+/PJZ+p0bE8ZsIeFnt2aTE3b9DliMvo1
         3heAndtRGi8Tp3bK9v552Mf3mT3FYQQjiursjncW3YgZo3uVSHHD7YlOnypGuaJWAmqE
         odXLdzezRcinvf1XoxKtJHMdrDRYWToB0ACe800RdT+QY0rSCBYjbfBl4GcmfOmtuCze
         6eufY49HYhE+m2q9gAnEJ9TR9tDjLOUnPXwSh2/ctCRyNGU9YqgZGousUN8UtMDj6+If
         101XapcMxfN7RhSWzpLi1v+GtFEhJED3XkZPgvzzLfc9rp1ZXtm6Dzp2+HN9BP+HYjW8
         12Vw==
In-Reply-To: <20140116142141.GF28157@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Thu, 16 Jan 2014, Michal Hocko wrote:

> > When two threads have the same badness score, it's preferable to kill the 
> > thread group leader so that the actual process name is printed to the 
> > kernel log rather than the thread group name which may be shared amongst 
> > several processes.
> 
> I am not sure I understand this. Is this about ->comm? If yes then why
> couldn't the group leader do PR_SET_NAME?
> 

Both comm and pid, we only display thread group leaders in the tasklist 
dump of eligible processes, we want the killed message to specify from 
which process.

You're suggesting a thread group leader do PR_SET_NAME of all its threads 
for readable oom killer output?  Lol.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
