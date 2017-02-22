From: Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH] mm: memcontrol: provide shmem statistics
Date: Wed, 22 Feb 2017 15:12:50 +1100
Message-ID: <20170222041250.GA9967@balbir.ozlabs.ibm.com>
References: <20170221164343.32252-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ckRRsoqKageNMPKGPDyu1EK6RIUhhYrRb5088iahpZQ=;
        b=HUE7uRx8IOIhiY+lNZOa/Iw0HlEi8l6ohrFr+PMBP0NZonD3yIOgBiv5Rp0YcE2lXW
         /GncipKQO7JC4u4A4FYM0uwzSMPW01XgXEBKJD3uEbs9xymDaIrIaudJkzVKLqdSqbvx
         P8VQO3O4MpGTtWLeLXohBPhhLvCBxxxxfgN1gvqqudGBmhJHekzerFi5B7wFZhva+sYq
         tphLZ6N8/gLtJcCzbfK/aYrB1+X7xhMVKup8V/T/uAkTMJD6tCgZkfPIy/Gz63BuK2LF
         HOavnUWlzYomosUEwa9UjbI2UHYLdFSZpRNkIUKAMuofBhYBQsBKC75awOYh/SRIp2wq
         ps/A==
Content-Disposition: inline
In-Reply-To: <20170221164343.32252-1-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov.dev@gmail.com>, Chris Down <cdown@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Feb 21, 2017 at 11:43:43AM -0500, Johannes Weiner wrote:
> Cgroups currently don't report how much shmem they use, which can be
> useful data to have, in particular since shmem is included in the
> cache/file item while being reclaimed like anonymous memory.
> 
> Add a counter to track shmem pages during charging and uncharging.
> 
> Reported-by: Chris Down <cdown@fb.com>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---

Makes sense

Acked-by: Balbir Singh <bsingharora@gmail.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
