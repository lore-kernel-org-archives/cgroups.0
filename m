From: Liqueur Librazy <im-WO6o3BnTAZpAfugRpC6u6w@public.gmane.org>
Subject: Re: [BUG] blk-throttle panic on 32bit machine after startup
Date: Mon, 18 Oct 2021 23:22:27 +0800
Message-ID: <e726813b-4f6d-3a5d-6adb-8407a9b4c7f7@librazy.org>
References: <CAEKhA2x1Qi3Ywaj9fzdsaChabqDSMe2m2441wReg_V=39_Cuhg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1634570567;
        s=mx; d=librazy.org; i=im-WO6o3BnTAZpAfugRpC6u6w@public.gmane.org;
        h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=kZhtruoVwNb47EYcsxuzHngcaBNhwqEKuTTcZhdi/HE=;
        b=e7gJw8grFe/k7pDLAMOlujFTGoN08nc2CVJ0B/nMAud9K5h962WRHocctzMz8bYP
        oTQsTq5HURE01HdTv9jGiA/yyr3VmDKTpa3cninBpo9msJugpIzgT6/XPkpz+jq0Uzr
        pDOV9nbkncx0MNUNPbKGdFrVnGkpzvamFM2Ma52s=
Content-Language: en-US
In-Reply-To: <CAEKhA2x1Qi3Ywaj9fzdsaChabqDSMe2m2441wReg_V=39_Cuhg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: zhangyoufu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

Hi,

Yet another colleague of the reporter here. I found that some 
precondition maybe not sound when tg->slice_end[rw] is initialized with 
0, which time_before(INITIAL_JIFFIES, 0) holds true in 32-bit Linux.

As in v5.15-rc6/block/blk-throttle.c

1. L833

	/* Determine if previously allocated or extended slice is complete or 
not */
	static bool throtl_slice_used(struct throtl_grp *tg, bool rw)
	{
		if (time_in_range(jiffies, tg->slice_start[rw], tg->slice_end[rw]))
			return false;

		return true;
	}

throtl_slice_used will always return true for a newly initialized slice.
This may be intentional behavior but not mentioned in comment.
(except when jiffies == 0, which is another topic: will 
time_in_range_open do better here?)

2. L791, in throtl_start_new_slice_with_credit

	/*
	 * Previous slice has expired. We must have trimmed it after last
	 * bio dispatch. That means since start of last slice, we never used
	 * that bandwidth. Do try to make use of that bandwidth while giving
	 * credit.
	 */
	if (time_after_eq(start, tg->slice_start[rw]))
		tg->slice_start[rw] = start;

As mentioned in my colleague Haoran Luo's reply, time_after_eq(start, 
tg->slice_start[rw]) is falsy when the jiffies had not wrapped around.
A easy solution is to add a check for tg->slice_start[rw] == 0, or we 
should initialize tg->slice_start[rw] and tg->slice_end[rw] with 
INITIAL_JIFFIES.
