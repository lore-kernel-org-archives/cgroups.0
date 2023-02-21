From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] mm: change memcg->oom_group access with atomic operations
Date: Tue, 21 Feb 2023 18:18:03 +0000
Message-ID: <Y/UK2zRi+WNGrWEs@casper.infradead.org>
References: <20230220230624.lkobqeagycx7bi7p@google.com>
 <6563189C-7765-4FFA-A8F2-A5CC4860A1EF@linux.dev>
 <CALvZod55K5zbbVYptq8ud=nKVyU1xceGVf6UcambBZ3BA2TZqA@mail.gmail.com>
 <Y/TMYa8DrocppXRu@casper.infradead.org>
 <Y/UDmc3+uIErpanS@P9FQF9L96D.corp.robot.car>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tTqyemmz1pSv74LR4HajXP0tRM9VnFXvQ4hZwbauJIY=; b=aTHEWPY/BN+r5noMxZCmo9iSA1
        Z9IeoyW/C1dX8qm5tPsU2u5j+AQ/AEhI+yMzMaNWzFE1cwZXzPuTpDM2a3cpTh+rJ9tg53kLukUWa
        1Raq91MM6pgzQ18B3/7w2dnnQ/4vw7VRe3x3ALCx09tzgnM7YKGmSNjPqvYGrmmRZDG+B2EfthaKX
        fNj/RnFy+ub0fsZpl6t42kQ5htBwnbD8RQiyCn5tLpfTkOa9cTy6ZTVDCx8QIeUx/6Xdl6chkrflk
        F0Ixpvhu+kwgmwoFV6hu+MTaFi1VQjGIUecpBZdG5kpmzPyzvWpcSpPfnK9smVbeMgkCEVcxswtPw
        zEfhVeDw==;
Content-Disposition: inline
In-Reply-To: <Y/UDmc3+uIErpanS-+xijCwNIfdoLQcUKs7qKB+WAnPUfkyWGUBSOeVevoDU@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Feb 21, 2023 at 09:47:05AM -0800, Roman Gushchin wrote:
> > Wouldn't a compiler be within its rights to implement a one byte store as:
> > 
> > 	load-word
> > 	modify-byte-in-word
> > 	store-word
> > 
> > and if this is a lockless store to a word which has an adjacent byte also
> > being modified by another CPU, one of those CPUs can lose its store?
> > And WRITE_ONCE would prevent the compiler from implementing the store
> > in that way.
> 
> Even then it's not an issue in this case, as we end up with either 0 or 1,
> I don't see how we can screw things up here.

Thread 1:
	load word containing oom_group and oom_lock

Thread 2:
	store to oom_lock

Thread 1:
	store word containing oom_group and oom_lock

Thread 2's store has been lost.
