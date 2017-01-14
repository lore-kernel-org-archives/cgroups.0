From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 6/9] slab: don't put memcg caches on slab_caches list
Date: Sat, 14 Jan 2017 10:39:08 -0500
Message-ID: <20170114153908.GC32693@mtj.duckdns.org>
References: <20170114055449.11044-1-tj@kernel.org>
 <20170114055449.11044-7-tj@kernel.org>
 <20170114133918.GE2668@esperanza>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=q+59NOHP6huQZGE8cP3PpHeV7TuAyfip7D9BMkL33HY=;
        b=K13cMgZHVadJX//riDjnSOxz99YtaQ6VBX7NJsRNrn/JeBoUZeFjfUfPSGuRJ5UFTi
         iL6bAdjYS2PclnzFUahgNXpaAO39u3bnwM69VeHYNZmYNryJZuOrHuZSdoIyDQeac9en
         68R0nIKWTh5hqTB0wdpakbUbrNU3LMr57qBGxdgqtpDRHyWCGz5MRCOP1TI5gxPc82rn
         Xt+b9nN9oTvp8FNxgfMHJRriOWrCd3jsFF0xnoQjslM88TSXTC6Iys9n+cQ67GRu0qGu
         mvJlEUoz+S8Hsv9wt0N7D4lNRSVZojjrJ3VPtNNzgrtodC//0EFAVMtFGEDBiVMz7H+h
         b47Q==
Content-Disposition: inline
In-Reply-To: <20170114133918.GE2668@esperanza>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-mJ5StSI9eqKXDw4h08c5KA@public.gmane.org>
Cc: cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, jsvana-b10kYP2dOMg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Sat, Jan 14, 2017 at 04:39:18PM +0300, Vladimir Davydov wrote:
> IIRC the slab_caches list is also used on cpu/mem online/offline, so you
> have to patch those places to ensure that memcg caches get updated too.
> Other than that the patch looks good to me.

Right, will update.  Thanks!

-- 
tejun
