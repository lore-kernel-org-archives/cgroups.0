From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Wed, 31 Aug 2016 09:56:52 -0400
Message-ID: <20160831135652.GD12660@htj.duckdns.org>
References: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LJgDzmer7eaOtsVcmfWRsmlx6eA8P3JbkEOcHru52eI=;
        b=Mhxo761/8nefdQZUTGBkIJxxJpvfmN9OcmgmlUxxhXsFvxNYgHJNrMR2EgqKPe0x39
         D8l6myQ3j5Y1DEcMj/6ALgmIKwXuH9oF78Md/iuyyyJmg3z9R8JDUpQuI1clt6uBnv74
         KC+7qnwTdigCWwvQlMHYi6zVr9vf/+IWPtvU5nbV1AIqW3rIHU7NBJaX81aQuBL+1lYO
         wnv9vpt8IgcIF0lex7kehXpUck3KLpWgLjer7BvbibRLsCAqY1uMmSKDBRXanqmqX/gL
         kfaO97prlpvkzn3x9YKbKP68o2AKsnlU5wPgSlEZh10tpQPbXxKQVnxD0BamdK5WprB2
         oUXw==
Content-Disposition: inline
In-Reply-To: <1472632647-1525-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Wed, Aug 31, 2016 at 02:07:24PM +0530, Parav Pandit wrote:
> rdmacg: IB/core: rdma controller support
> 
> Patch is generated and tested against below Doug's linux-rdma
> git tree.
> 
> URL: git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
> Branch: master
> 
> Patchset is also compiled and tested against below Tejun's cgroup tree
> using cgroup v2 mode.
> URL: git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
> Branch: master
> 
> Overview:
> Currently user space applications can easily take away all the rdma
> device specific resources such as AH, CQ, QP, MR etc. Due to which other
> applications in other cgroup or kernel space ULPs may not even get chance
> to allocate any rdma resources. This results into service unavailibility.

Generally looks good to me.  Please feel free to add

 Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

for the whole series.  Also, once reviews from rdma side are done,
please let me know what's the preferable way to route the patchset.  I
can route it through the cgroup tree or it can go through rdma one.

Thanks a lot for the persisence!

-- 
tejun
