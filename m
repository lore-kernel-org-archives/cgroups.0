From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Trivial correction to reflect controller.
Date: Sat, 5 Mar 2016 07:49:42 -0500
Message-ID: <20160305124942.GB3567@htj.duckdns.org>
References: <1457157656-5605-1-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3T3U9DC0orV6IlhsrIa1qVa4Lv+TjhmBaTIRgh8eNOg=;
        b=ZX5PPBZHa29AYxZPjsP2KRpB3F9aqccY96OQdFiOOvsQaqG4Wg+7FgSAyu/0L9z0s+
         axquSh+n6fXdgAiXl41/YgGkNWkS2snoJkz/El/cJnUTHx6B6d4s8Wmq4UVjwzZSQgv6
         Uymx+S2RaPofXGz4Oe5dMvh58zu45zYjYTh0UYluGuMCJGgf/385+ULXJD4Cr+RJx0bf
         p4e2WwTy8PXoqNoqWlE1nGdOpGlVBeFGk//ApXEl/83ZUE5nCKDUiFd5J5EzdctxGnYM
         ZSK6Yg33T3jZ5O5RC68FqLkdA6OeEo5q80oaXvbPSUwxpiGqfWQEuMpy/6Q/K4uVkYBZ
         47BA==
Content-Disposition: inline
In-Reply-To: <1457157656-5605-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Mar 05, 2016 at 11:30:56AM +0530, Parav Pandit wrote:
> Trivial correction in menuconfig help to reflect PIDs as
> controller instead of subsystem to align to rest of the text
> and documentation.
> 
> Signed-off-by: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Applied to cgroup/for-4.6.

Thanks.

-- 
tejun
