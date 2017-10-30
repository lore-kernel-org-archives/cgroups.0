From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cfq-iosched: add "leaf_weight" setting for the root
 cgroup in cgroups v2
Date: Mon, 30 Oct 2017 07:55:26 -0700
Message-ID: <20171030145526.GB3252168@devbig577.frc2.facebook.com>
References: <a1828795-3f51-9455-9d0b-93f9dcfb6fd4@maciej.szmigiero.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7ej+az9hSCNkOn4ixWniSHgo6DWWhOitraJwJG5KV4w=;
        b=swrJGuHoEReXX0q+2b1r+1OaP8mFp8tJt1P09B61nBELWLyPmFv9O4diNGqrdSGCO1
         g3Z94yaeukCjiyldC8+eR4v84E9AuN4kqX+NtiIRGVumnuDwKlsQUb8D8jopt0xuP4da
         O48AfeoJu8196EnYKv1hpENIyQ4b2VRcIgIzoKnxIJuNFstm0A2W0YdU4oWtcX71zpYw
         8Qc7y2BHwPj6FlBcysOC9mEv4jNbc582RCfmEXfcQ9nvENnr+aeREbLz3hPodznReY2N
         496IWIiPlK5hc37d/DvzMZ16IUPAAnzKIjMN0b4E2gMLalV5STs//sEeXHG8ZuW/BGHp
         5lGg==
Content-Disposition: inline
In-Reply-To: <a1828795-3f51-9455-9d0b-93f9dcfb6fd4-APzI5cXaD1zVlRWJc41N0YvC60bnQu0Y@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Maciej S. Szmigiero" <mail-APzI5cXaD1zVlRWJc41N0YvC60bnQu0Y@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, Oct 29, 2017 at 05:36:53PM +0100, Maciej S. Szmigiero wrote:
> CFQ scheduler has a property that processes (or tasks in cgroups v1) that
> aren't assigned to any particular cgroup - that is, which stay in the root
> cgroup - effectively form an implicit leaf child node attached to the root
> cgroup.
> 
> This behavior is documented in blkio-controller.txt for cgroups v1, however
> as far as I know it isn't documented anywhere for cgroups v2 besides a
> generic remark that "How resource consumption in the root cgroup is
> governed is up to each controller" in cgroup-v2.txt.
> 
> By default, this implicit leaf child node has a (CFQ) weight which is two
> times higher that the default weight of a child cgroup.
> 
> cgroups v1 provide a "leaf_weight" setting which allow changing this value.
> However, this setting is missing from cgroups v2 and so the only way to
> tweak how much IO time processes in the root cgroup get is to adapt
> weight settings of all child cgroups accordingly.
> Let's add a "leaf_weight" setting to the root cgroup in cgroups v2, too.
> 
> Note that new kernel threads appear in the root cgroup and there seems to
> be no way to change this since kthreadd cannot be moved to another cgroup
> (for a good reason).
> 
> Signed-off-by: Maciej S. Szmigiero <mail-APzI5cXaD1zVlRWJc41N0YvC60bnQu0Y@public.gmane.org>

I don't think we wanna do this.  It's inconsistent with what other
controllers do and we want to charge the IOs in the root cgroup to the
right cgroup.

Thanks.

-- 
tejun
