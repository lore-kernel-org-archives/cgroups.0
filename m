From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] cgroups: Resource controller for open files.
Date: Wed, 2 Jul 2014 10:49:01 -0400
Message-ID: <20140702144901.GC23275@htj.dyndns.org>
References: <1404311407-4851-1-git-send-email-merimus@google.com>
 <20140702143300.GB23275@htj.dyndns.org>
 <CAANmLtwwbKBi+zZ01ywbeMnzu5a0UvqEz-_zHJLNtBVso2=ibg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=6aiqAGscFUYhCCcE3fXPWVB4Mm7Czm3dDqWg1o6ek/w=;
        b=SUX9Dkl9maKxhqhF+OvsLdq7qBK6VjF0FAmXhDszijUCSVQxd9ej77n0f0wJY0Wjut
         ejAy9HNOh5nMIWtP4T0jXnXTGCWm8BZ1l6eufThCPv7zQ5wSmD9vAbtaQkxbn9xl3/7k
         qeE2dDPNqHNEWN4tyPDOzyauMlQsuRZmPi4MO66AktLRlqXZ3klsnhANYMja3UDH3Axr
         yrSez0ekyn50j8dLvGYVonK3PIioWbC7CsiHZZI9CqRWeerwhBwu4q/lK6hLWuXVAM7u
         ePFt+Mew8mN3o+YTme7pXUbXvl7dN9i98ZQ3IgmWXfv4OJRbln89Is2+liNI88W4MsqE
         UA+w==
Content-Disposition: inline
In-Reply-To: <CAANmLtwwbKBi+zZ01ywbeMnzu5a0UvqEz-_zHJLNtBVso2=ibg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Binder Makin <merimus@google.com>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, Daniel Jacobowitz <dmj@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org

Hello,

On Wed, Jul 02, 2014 at 10:46:59AM -0400, Binder Makin wrote:
> kmem keeps the cgroup from DOSing the machine but then you can get a ENOMEM
> out of some call which is trying to allocate kernel memory.
> People are used to limiting file handles from rlimits and the EMFILE is
> easier for them to debug/fix.

EMFILE instead of ENOMEM seems really thin as the sole rationale for a
whole new controller, doesn't it?

Thanks.

-- 
tejun
