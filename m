From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v2][next] cgroup: Avoid -Wstringop-overflow warnings
Date: Wed, 16 Aug 2023 13:57:16 -0700
Message-ID: <202308161356.4AED47263E@keescook>
References: <ZN02iLcZYgxHFrEN@work>
 <ZN02wFqzvwP2JI-K@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1692219437; x=1692824237;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PTnRjDgF03Eifi7sf3kpv96X0kZ1CgBBnY922J5YppA=;
        b=YrnJuLkKAUI9GOoFGUyMxaW0N4JvwWCdrMEG+WXxw28UwGdvMagNkGayO+D+VNRv7W
         tdSXtKKS34K9MQ4zDTHtW6q2rQmnBOa1Cm/YWl1qMYvmdTxQHD3MejqhxJNse7BFpFZ4
         taJO9DBM9v9B7HzFifZ/3iQ27MxXyE1MvyhG4=
Content-Disposition: inline
In-Reply-To: <ZN02wFqzvwP2JI-K-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Gustavo A. R. Silva" <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-hardening-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Aug 16, 2023 at 10:51:12AM -1000, Tejun Heo wrote:
> Hello,
> 
> On Wed, Aug 16, 2023 at 02:50:16PM -0600, Gustavo A. R. Silva wrote:
> > Change the notation from pointer-to-array to pointer-to-pointer.
> > With this, we avoid the compiler complaining about trying
> > to access a region of size zero as an argument during function
> > calls.
> 
> Haha, I thought the functions were actually accessing the memory. This can't
> be an intended behavior on the compiler's side, right?

I think it's a result of inlining -- the compiler ends up with a case
where it looks like it might be possible to index a zero-sized array,
but it is "accidentally safe".

-- 
Kees Cook
