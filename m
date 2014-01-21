From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Date: Mon, 20 Jan 2014 21:58:28 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1401202155410.21729@chino.kir.corp.google.com>
References: <20140107162503.f751e880410f61a109cdcc2b@linux-foundation.org> <alpine.DEB.2.02.1401091324120.31538@chino.kir.corp.google.com> <20140109144757.e95616b4280c049b22743a15@linux-foundation.org> <alpine.DEB.2.02.1401091551390.20263@chino.kir.corp.google.com>
 <20140109161246.57ea590f00ea5b61fdbf5f11@linux-foundation.org> <alpine.DEB.2.02.1401091613560.22649@chino.kir.corp.google.com> <20140110221432.GD6963@cmpxchg.org> <alpine.DEB.2.02.1401121404530.20999@chino.kir.corp.google.com> <20140115143449.GN8782@dhcp22.suse.cz>
 <alpine.DEB.2.02.1401151319580.10727@chino.kir.corp.google.com> <20140116093220.GC28157@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=MtzGmgU4WiBkoFA0cZBIEVNR9YUuC7tCJWBbGrlMCKg=;
        b=CyAEPM5JjMPRUlkFVx1rN9e6Bou1ND99aZXad5EawPjBlh8el8cXeBWTF0UUeQhYnE
         bLib7lUIqQAjmXh24H3h3d2c4U/tqy1WkSEF/I8HECVaYKW7nX+vxalDDxbhy5lGFaK6
         ejl7NWPPwA0IpWnCcP6Qt0mXCK8xAw3thCwE1iisXnCdsxTU09gZvWrLDRvRocrwVJfK
         BArFmwHqXFQdms7V1OOMQL+2r/w0OQf17tQMrc3OvyF9x2pj/1YzZZ48WLHFz73Di5Bi
         wEJN90ZWE0kmGN9tO70LsVxGxzh9pmpcK5/2zM6j4HS5VinS8a+vUrJvC94KVYy8g/p5
         7OKw==
In-Reply-To: <20140116093220.GC28157@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, Greg Kroah-Hartmann <gregkh@linuxfoundation.org>

On Thu, 16 Jan 2014, Michal Hocko wrote:

> > This is concerning because it's merged in -mm without being tested by Eric 
> > and is marked for stable while violating the stable kernel rules criteria.
> 
> Are you questioning the patch fixes the described issue?
> 
> Please note that the exit_robust_list and PF_EXITING as a culprit has
> been identified by Eric. Of course I would prefer if it was tested by
> anybody who can reproduce it.

You're saying the patch hasn't been tested by anybody and that clearly 
violates the first rule in Documentation/stable_kernel_rules.txt:

 - It must be obviously correct and tested.

Adding Greg to the cc if this should be clarified further.  The patches 
getting proposed through -mm for stable boggles my mind sometimes.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
