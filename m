From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 02/18] cgroup_pids: track maximum pids
Date: Mon, 13 Jun 2016 18:09:25 -0400
Message-ID: <20160613220925.GI31708@htj.duckdns.org>
References: <1465847065-3577-1-git-send-email-toiwoton@gmail.com>
 <1465847065-3577-3-git-send-email-toiwoton@gmail.com>
 <20160613211227.GG31708@htj.duckdns.org>
 <17cb1a37-47b1-dbd4-6835-efad3cf6c12f@gmail.com>
 <20160613213354.GH31708@htj.duckdns.org>
 <15ef1041-35b6-cb31-ff98-8b0be7780bc3@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=r8F7ZuhGYmnp/OE7LooknIX72zXnQPFkv4ZGMwUhrNA=;
        b=WC0y8UbLg1iEulcpOS0Mpe/iOoAvqahScZzLa3X3W+KF6CDtqRo+xwAYBOgTiNCZM1
         K5s6gtJh2bEdf3B2hGVVV+FsMF67BMdyH9hVenc42W9AEwoLIKJtOyARR9JEmL6Jw1l0
         Vd/NPur6iACmdxClMJZHXDFSvkZolIj8NPrd+j4ZmRW5jqKGjt933sgG+/4Pb5gtbOL+
         fokBeE/R/RLa+TUzsZPIw1RFmBtHGsiC4FbbQ2tm+eUnPpedIOB86v/pFROxQlEZZSt2
         N7i04bsIYNy+4fL4BLzgGhb5rFHy/v1ACM26EIHOZoz3QS10PFsBWEBDq2ZX9WubvyBZ
         Jelg==
Content-Disposition: inline
In-Reply-To: <15ef1041-35b6-cb31-ff98-8b0be7780bc3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Jun 13, 2016 at 09:59:32PM +0000, Topi Miettinen wrote:
> On 06/13/16 21:33, Tejun Heo wrote:
> > Hello,
> > 
> > On Mon, Jun 13, 2016 at 09:29:32PM +0000, Topi Miettinen wrote:
> >> I used fork callback as I don't want to lower the watermark in all cases
> >> where the charge can be lowered, so I'd update the watermark only when
> >> the fork really happens.
> > 
> > I don't think that would make a noticeable difference.  That's where
> > we decide whether to grant fork or not after all and thus where the
> > actual usage is.
> > 
> 
> You mean, increment count on cgroup_can_fork()? But what if the fork()
> fails after that (signal_pending case)?

That number isn't gonna deviate by any significant amount and the
counter is to estimate what the limit should be set to to begin with.
It's logical to collect how close the usage got to can_attach failure
due to limit breach.

> >> Is there a better way to compare and set? I don't think atomic_cmpxchg()
> >> does what's needed,
> > 
> > cmpxchg loop should do what's necessary although I'm not sure how much
> > being strictly correct matters here.
> 
> These are not used for any decisions taken by kernel, but by the user. I
> have to say I don't know where's the line between strict correctness and
> less strict.

Provided that cmpxchg is done only when the counter needs to be
actually updated, it's not gonna be noticeably expensive.  Might as
well make it correct.

Thanks.

-- 
tejun
