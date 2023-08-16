From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2][next] cgroup: Avoid -Wstringop-overflow warnings
Date: Wed, 16 Aug 2023 11:01:21 -1000
Message-ID: <ZN05IZBfaKkPKJfH@slm.duckdns.org>
References: <ZN02iLcZYgxHFrEN@work>
 <ZN02wFqzvwP2JI-K@slm.duckdns.org>
 <202308161356.4AED47263E@keescook>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692219683; x=1692824483;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FuKq3/l4OyQ+0bhsP63oq+yhF5v+FLjFlawMMB3oE90=;
        b=MAh9iyXCBy3uqvElWQriYDbdgKgL+HrzzmoeT8qdzq+naxquZKPbT/q0tywqRJLP/R
         xC3i88CpffAvT4J8QwBM7kPi6qMYTPnc96qL7r+EbRY6IBW0sNMYxpWXfVsno6+sAUsI
         lLymeXyS08FEio/NjL5JfwFpy1hDbuqmZ9UBPMiDmokDvyoTgvE32X/QjGbV5/QE1pBy
         CrKWHxVmhs49ORnTdd7rKKMZohHwV3sxSgDHbgBLh+dZ1An7cRQqAtCmgsKRBT7sHyRN
         NdQbbDSBRevBrJSYPBNsfE2n0kNF1giWo5DGf7Et2o4n0cH+pmLED7zTf5MbTp1Hp93l
         0xJg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <202308161356.4AED47263E@keescook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: "Gustavo A. R. Silva" <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-hardening-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Aug 16, 2023 at 01:57:16PM -0700, Kees Cook wrote:
> On Wed, Aug 16, 2023 at 10:51:12AM -1000, Tejun Heo wrote:
> > Hello,
> > 
> > On Wed, Aug 16, 2023 at 02:50:16PM -0600, Gustavo A. R. Silva wrote:
> > > Change the notation from pointer-to-array to pointer-to-pointer.
> > > With this, we avoid the compiler complaining about trying
> > > to access a region of size zero as an argument during function
> > > calls.
> > 
> > Haha, I thought the functions were actually accessing the memory. This can't
> > be an intended behavior on the compiler's side, right?
> 
> I think it's a result of inlining -- the compiler ends up with a case
> where it looks like it might be possible to index a zero-sized array,
> but it is "accidentally safe".

Ah I see. It's not that the compiler knows that ** access is safe. It's more
that it only applies the check on arrays. Is that right? Gustavo, I don't
mind the patch but can you update the patch description a bit explaining a
bit more on what's going on with the complier? It doesn't have to be the
full explanation but it'd be useful to explicitly point out that we're just
working around the compiler being a bit silly.

Thanks.

-- 
tejun
