From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix a comment typo
Date: Tue, 27 Dec 2016 14:53:16 -0500
Message-ID: <20161227195316.GA31771@htj.duckdns.org>
References: <33bee1ec2bea0a063ad6f6cf003e91ccfa6daab1.1482300478.git.geliangtang@gmail.com>
 <be849a0bff86e529baa95bf0d896cb5a28d43ab3.1482300177.git.geliangtang@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1DdhDFqQBokMCZEk9cbmpRm4AJgbhBszA819EeSxM5I=;
        b=V/U5xQda5rg3x1j16SeTl1qcIo15LziZv5zePvUBtmHs7mGRJHMD6OVbyQ+n9Rqzd6
         aRKrOhS2DVcTtQbwF5yohOizBYHL1xMrVUqPRc9VsvFEL8zx1QPlSo/X4v5omqaMR+cq
         1VrWavSa78L3G0K636Q5pK360NXtjhg4fPKr+/Uq9FvGw0O0hHH7DBK7Z3+npbHiSkCm
         SfxFmZ/xjuqSnTRRo3qAKWRHLGuiMpoykoScnREWvPvebDm3lgvEEvp7Cma3903FimT3
         rxDGWYigv+fCQh5yFHx34mfegjBM4npcGym4sihDtJIgQT42LyXBq05OZI6Yy7IEBqnC
         +l8w==
Content-Disposition: inline
In-Reply-To: <be849a0bff86e529baa95bf0d896cb5a28d43ab3.1482300177.git.geliangtang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Geliang Tang <geliangtang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jiri Kosina <trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Dec 24, 2016 at 11:28:35PM +0800, Geliang Tang wrote:
> Fix a comment typo in cgroup.h.
> 
> Signed-off-by: Geliang Tang <geliangtang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Applied to cgroup/for-4.11.

Thanks.

-- 
tejun
