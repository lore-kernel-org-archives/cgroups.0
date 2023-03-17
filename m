From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: bpf: use cgroup_lock()/cgroup_unlock() wrappers
Date: Fri, 17 Mar 2023 12:08:23 -1000
Message-ID: <ZBTk15bE2CH8L8bD@slm.duckdns.org>
References: <20230303095310.238553-1-kamalesh.babulal@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679090905;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fktUgeNKHeEQ2v/T0Wiw60L+0FDNv0kxizcb8obLG8Y=;
        b=IDX20rndKJ/Uot2engpvKciEKywc2wk8AMwLKStBF/6eWM6GHrrs8U6/QnbXnzelbx
         wZLaNbY5SoxasFx5NbRja1hPTBWBhoXXKwYOdvApjN7QFhIMRAdgz3Z3/W3rn82qckTu
         pyxnBRSi9sF/dagYAgxiBbhdafEVBXTcHbxp50Jr5rAe2y+zug697tFeposkyQjLVenZ
         EJxK16UryRJELe/QqPprPtZHW81+52OmQbKHjmdik6h0ZLaJzk+kqK39k7y6R36pue3Z
         JGcryL4Zu8A9yh0mEv1um1VL29cD+wcoIJdeNQteIVhjAiFj4HaMOC3aNKhv18Qc2V81
         Rc2A==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230303095310.238553-1-kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Tom Hromatka <tom.hromatka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Mar 03, 2023 at 03:23:10PM +0530, Kamalesh Babulal wrote:
> Replace mutex_[un]lock() with cgroup_[un]lock() wrappers to stay
> consistent across cgroup core and other subsystem code, while
> operating on the cgroup_mutex.
> 
> Signed-off-by: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.4.

Thanks.

-- 
tejun
