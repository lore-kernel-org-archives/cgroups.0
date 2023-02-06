From: pr-tracker-bot-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Subject: Re: [GIT PULL] cgroup fixes for v6.2-rc7
Date: Mon, 06 Feb 2023 22:22:57 +0000
Message-ID: <167572217713.7822.15849062504890125362.pr-tracker-bot@kernel.org>
References: <Y+F149pNVNcMJQIn@slm.duckdns.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675722177;
        bh=77eH0dObGsmGIQ6H5Q/e/w+lwpEpf0OEqQVQWCaEWuw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=dicnAoPT6MkxCXv2eo5ewyQnaR8dWQZJNxmeFWE6zSCEbeUX2FVIixj7K579AK9DH
         qP80IcHi9lY8D3Yhcax0qEMh1JmvOPHTkLi6Zx2tdYHU4RTuxEK55aijc+IocnXJP9
         0ROkmSrZK7oUTZNbbTIMqvc5USR6knwPE+XZIvX5ojUHxMjbKZ7R9Nr4eGtkTeTmUD
         mWt5rwxMgN+0Ht0CNYkjXgP/7ki2zyR9BSuUoAslncCMy51JAKksiZhRLU5eNnLGxG
         wBopdj4GRfOGwX9o4aZQnoVFmnai11D0EKF4nCKk42IZnSiernvMZIAARLhkDQk6Ro
         Nz6KsbVZ+d9dA==
In-Reply-To: <Y+F149pNVNcMJQIn-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

The pull request you sent on Mon, 6 Feb 2023 11:49:23 -1000:

> git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git/ tags/cgroup-for-6.2-rc7-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/05ecb680708a1dbe6554d6fc17e5d9a8a7cb5e6a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
