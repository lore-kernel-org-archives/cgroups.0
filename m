From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/6] add res_counter_uncharge_until()
Date: Mon, 14 May 2012 11:17:25 -0700
Message-ID: <20120514181725.GF2366@google.com>
References: <4FACDED0.3020400@jp.fujitsu.com>
 <4FACE01A.4040405@jp.fujitsu.com>
 <20120511141945.c487e94c.akpm@linux-foundation.org>
 <4FB05B8F.8020408@jp.fujitsu.com>
 <CAFTL4hwGEhyxZO0sXx5gVyK_xjhMQEbHojJbHzQmVKafNyVWtw@mail.gmail.com>
 <4FB0DF4A.5010506@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=GK6jHJfsQs6Z7IOYzDGF33psCG+fq0NS+gdLb9MMAhQ=;
        b=gcaH19Q4LP0X1t0QqMpVXX3ocygvZi/ussRRmwPj2nkkXMPojCQtJD1T3eASnUWWvI
         chl+8scL1fjz4N+JFpuE2X+cryUbmUGCmip284jmTIgdG+hkJ7GGYmV0oQaAF/TuU1Gd
         unDKIEKM2uiVS+26xNOMehvMWwcnSB5BLITXDlGtssQ5Azqsn8xfuzQZibKIQB5O5PMP
         /etXgz9BJ+adi7MaBf+w3w7jp1pjofwMn19CFQGrMTlpH1Tk5sEqhpmvoZRMuB/k2mo8
         b0UObHYWvmhwRfY6dL6SEIjSz3RdUnBCuW8A23T8U98XMvPNNk74+nhomG5NDmnKmjYR
         34lA==
Content-Disposition: inline
In-Reply-To: <4FB0DF4A.5010506-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Hiroyuki Kamezawa <kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, May 14, 2012 at 07:32:42PM +0900, KAMEZAWA Hiroyuki wrote:
> [PATCH 2/6] memcg: add res_counter_uncharge_until()
> 
> From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> At killing res_counter which is a child of other counter,
> we need to do
> 	res_counter_uncharge(child, xxx)
> 	res_counter_charge(parent, xxx)
> 
> This is not atomic and wasting cpu. This patch adds
> res_counter_uncharge_until(). This function's uncharge propagates
> to ancestors until specified res_counter.
> 
> 	res_counter_uncharge_until(child, parent, xxx)
> 
> Now, ops is atomic and efficient.
> 
> Changelog since v2
>  - removed unnecessary lines.
>  - added 'From' , this patch comes from his one.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
