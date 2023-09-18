From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: Avoid extra dereference in css_populate_dir()
Date: Mon, 18 Sep 2023 08:58:15 -1000
Message-ID: <ZQidx8_nMRsQVtwx@slm.duckdns.org>
References: <96694dfc5f4caf4d84a740c3b18b0a456c9ff522.1694501024.git.kamalesh.babulal@oracle.com>
 <5870fc2459d97b2e47c5a8dc47f1a2a3837c5e03.1694501024.git.kamalesh.babulal@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695063497; x=1695668297; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HIq/dcnUlfz9c9ZMg9REc9/bKulrunuVIS2q81WpsmA=;
        b=FRRbTfPlWZTj5JCf6cVkzU6C/btoGlKTDH7qt519WzjunsWS8crRO4CGourmoCqM5O
         ts75zeEZ9f7qzcgOGpV2OnMNTK/GEjBj5iBUOhxjRLosOP7147EOjWu62h4Q0jJuc4Fu
         /da2rLEPR9VetBkML9Y3Bo+Lvy3AiDIPN/pXTNHZMTps81DSYEiyGlY58mNObieXYKw5
         8pcu9wliAhCi5vonpL71cqdmEYAEVeD7BtP87e+gBg69cOlWpqU4tOT0737bbPmPdHYp
         oaKAK4VPRQsGVycskKMFVw6g5kjNnuThcbpYJX+28qTsZl5NuS7BtIj/RqxHt5rdM/5N
         xJIQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5870fc2459d97b2e47c5a8dc47f1a2a3837c5e03.1694501024.git.kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tom Hromatka <tom.hromatka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Sep 12, 2023 at 12:34:35PM +0530, Kamalesh Babulal wrote:
> Use css directly instead of dereferencing it from &cgroup->self, while
> adding the cgroup v2 cft base and psi files in css_populate_dir(). Both
> points to the same css, when css->ss is NULL, this avoids extra deferences
> and makes code consistent in usage across the function.
> 
> Signed-off-by: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.7.

Thanks.

-- 
tejun
