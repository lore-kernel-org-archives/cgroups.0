From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch 03/12] mm: huge_memory: use GFP_TRANSHUGE when charging
 huge pages
Date: Tue, 17 Jun 2014 18:20:57 +0200
Message-ID: <20140617162057.GA9572@dhcp22.suse.cz>
References: <1402948472-8175-1-git-send-email-hannes@cmpxchg.org>
 <1402948472-8175-4-git-send-email-hannes@cmpxchg.org>
 <20140617134745.GB19886@dhcp22.suse.cz>
 <20140617153018.GA7331@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=rUENU/nXfrHkQzHASFljlNch+tYMd7xQZpXv0FQyNfc=;
        b=Wa0xla15DJoivbWWOh4aeb9GaDDPwwNM/EjCyMXy30VELAOCIJRGNYDa2f+cc/7K+W
         Yv8FjWWBk/bFBzsmIO1abAYXg05faI5smBI1y1XBOF9vUgCB9Y/LSDdAN0CJQZyFpf/0
         pJDH6/eqWr4q78EewdoXG8bL1IqE+SlcOj5ITRaJYsoEedYRRQhKc0Z1tBY4v653EjJT
         B6oXWFouSEABo3q/ZVzUZFw5F5VeeolNvmq4evnnzVf3I4qUG9hm8+090xFdJECOTFk0
         dMlVbcdcsoEOFVTqyr7NYfrSffEQ1ywd8MZ4bC2WULPb0hkWdIW9pIY1jlyJ516zkrDY
         jKww==
Content-Disposition: inline
In-Reply-To: <20140617153018.GA7331@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Tue 17-06-14 11:30:18, Johannes Weiner wrote:
[...]
> This first changes __GFP_NORETRY to provide THP-required semantics,
> then switches THP over to it, then fixes oom-disabled/NOFAIL charges.
> 
> Does that make more sense?

Yes. Thanks!

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
