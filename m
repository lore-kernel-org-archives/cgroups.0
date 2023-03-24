From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cpuset: Clean up cpuset_node_allowed
Date: Thu, 23 Mar 2023 16:03:36 -1000
Message-ID: <ZB0E+C2nao2mKlbJ@slm.duckdns.org>
References: <9953284e-05da-56b0-047d-ecf18aa53892@redhat.com>
 <20230228083537.102665-1-haifeng.xu@shopee.com>
 <299c9c34-0c07-ae52-61d7-6332f35c6245@redhat.com>
 <2e71c2bf-9ee3-4ada-e9d9-acb6e422e9af@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679623419;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PY/nCrDiW8SdcBN3F88jY3M7fLY4heof/m4P0yCEwhw=;
        b=HL6A8izR0CkeHjxLTeXacguhkCInW7j8vtFgwkEVI+52gmedURua9uXjCQYd1au7M4
         J3wKLc5Aaxr4n8OrTW1aboOPukXGln1bEfbkxmfXkRn6g27aVMLkRw5UTMCDUUiMzrLu
         gA2qhSRF0DeHSKKS0Lfj2/OFgFLPQj+/W3uFZOJ8HKZ7Ef709sX3NmbybV0tVgYjcqo9
         LNtgR9a6IG8ul2Ht2ssRrjooLeqB4noIZg0Q/C4ZOaho+LB9gK7sfrhgZK+tSwqccjaS
         rxmjuwkEYAujP00mwv527Ch8lZwee8c/QiAm7yaggQs3brArDtQ01NmWgzttubBCX+Rj
         nd7A==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2e71c2bf-9ee3-4ada-e9d9-acb6e422e9af-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Mar 18, 2023 at 05:30:46PM -0400, Waiman Long wrote:
> On 3/17/23 21:35, Waiman Long wrote:
> > On 2/28/23 03:35, Haifeng Xu wrote:
> > > Commit 002f290627c2 ("cpuset: use static key better and convert to
> > > new API")
> > > has used __cpuset_node_allowed() instead of cpuset_node_allowed() to
> > > check
> > > whether we can allocate on a memory node. Now this function isn't
> > > used by
> > > anyone, so we can do the follow things to clean up it.
> > > 
> > > 1. remove unused codes
> > > 2. rename __cpuset_node_allowed() to cpuset_node_allowed()
> > > 3. update comments in mm/page_alloc.c
> > > 
> > > Suggested-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > Signed-off-by: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
...
> It turns out that cpuset_node_allowed() isn't used anywhere except in
> cpuset.h. So it should be OK to remove the alternate cpuset_node_allowed()
> function.
> 
> Acked-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.4.

Thanks.

-- 
tejun
